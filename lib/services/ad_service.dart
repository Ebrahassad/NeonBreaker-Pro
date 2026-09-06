import 'package:flutter/foundation.dart';

class AdService {
  AdService._();
  static final AdService instance = AdService._();

  bool get isInitialized => false;
  bool get isRewardedReady => false;

  Future<void> init() async {}
  Future<void> maybeShowInterstitial() async {}
  Future<void> showInterstitial() async {}
  Future<void> showRewarded({required VoidCallback onReward}) async {}
}
