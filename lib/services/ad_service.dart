import 'package:flutter/foundation.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

/// Centralized Unity Ads (LevelPlay) integration for NeonBreaker Pro.
///
/// Every call is defensive: if the SDK fails to initialize (no network,
/// ad units not approved yet, region restrictions, etc.) the game keeps
/// working exactly as before — ads are a bonus layer, never a blocker.
class AdService {
  AdService._();

  static final AdService instance = AdService._();

  // Unity LevelPlay dashboard identifiers.
  static const String gameId = '800363462';
  static const String bannerPlacementId = 'Banner_Android';
  static const String interstitialPlacementId = 'Interstitial_Android';
  static const String rewardedPlacementId = 'Rewarded_Android';

  // Flip to false once the app is live on the Play Store.
  static const bool testMode = kDebugMode;

  bool _initialized = false;
  bool _initializing = false;

  bool _interstitialReady = false;
  bool _rewardedReady = false;

  int _actionCount = 0;
  static const int _interstitialEvery = 3;

  bool get isInitialized => _initialized;
  bool get isRewardedReady => _rewardedReady;

  Future<void> init() async {
    if (_initialized || _initializing) return;
    _initializing = true;

    try {
      await UnityAds.init(
        gameId: gameId,
        testMode: testMode,
        onComplete: () {
          _initialized = true;
          _loadInterstitial();
          _loadRewarded();
          _loadBanner();
        },
        onFailed: (error, message) {
          _initialized = false;
        },
      );
    } catch (_) {
      // Ads SDK unavailable on this device/build — game stays fully playable.
    } finally {
      _initializing = false;
    }
  }

  void _loadInterstitial() {
    if (!_initialized) return;

    try {
      UnityAds.load(
        placementId: interstitialPlacementId,
        onComplete: (placementId) => _interstitialReady = true,
        onFailed: (placementId, error, message) => _interstitialReady = false,
      );
    } catch (_) {
      _interstitialReady = false;
    }
  }

  void _loadBanner() {
    if (!_initialized) return;

    try {
      UnityAds.load(
        placementId: bannerPlacementId,
        onComplete: (placementId) {},
        onFailed: (placementId, error, message) {},
      );
    } catch (_) {}
  }

  void _loadRewarded() {
    if (!_initialized) return;

    try {
      UnityAds.load(
        placementId: rewardedPlacementId,
        onComplete: (placementId) => _rewardedReady = true,
        onFailed: (placementId, error, message) => _rewardedReady = false,
      );
    } catch (_) {
      _rewardedReady = false;
    }
  }

  Future<void> maybeShowInterstitial() async {
    _actionCount++;

    if (_actionCount % _interstitialEvery != 0) {
      return;
    }

    await showInterstitial();
  }

  Future<void> showInterstitial() async {
    if (!_initialized) return;

    if (!_interstitialReady) {
      _loadInterstitial();
      return;
    }

    _interstitialReady = false;

    try {
      await UnityAds.showVideoAd(
        placementId: interstitialPlacementId,
        onComplete: (placementId) => _loadInterstitial(),
        onFailed: (placementId, error, message) => _loadInterstitial(),
        onSkipped: (placementId) => _loadInterstitial(),
      );
    } catch (_) {
      _loadInterstitial();
    }
  }

  Future<void> showRewarded({required VoidCallback onReward}) async {
    if (!_initialized || !_rewardedReady) {
      _loadRewarded();
      return;
    }

    _rewardedReady = false;

    try {
      await UnityAds.showVideoAd(
        placementId: rewardedPlacementId,
        onComplete: (placementId) {
          onReward();
          _loadRewarded();
        },
        onFailed: (placementId, error, message) => _loadRewarded(),
        onSkipped: (placementId) => _loadRewarded(),
      );
    } catch (_) {
      _loadRewarded();
    }
  }
}
