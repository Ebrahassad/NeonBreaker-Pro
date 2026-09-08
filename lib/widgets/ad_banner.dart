import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../services/ad_service.dart';

/// Bottom banner ad.
///
/// The Unity banner widget only loads once, the moment it is created — it
/// does not retry on its own. Since Unity Ads finishes initializing a
/// moment *after* the first frame (see main.dart), a banner created right
/// at startup would try to load before the SDK is ready and then sit dead
/// forever. This widget waits for [AdService] to report ready, and only
/// then mounts a fresh [UnityBannerAd] so it actually has a live SDK to
/// load against. If loading still fails, it retries a few times.
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  Timer? _pollTimer;
  bool _sdkReady = false;
  bool _failed = false;
  int _bannerKey = 0;
  int _retries = 0;
  static const int _maxRetries = 5;

  @override
  void initState() {
    super.initState();
    _waitForSdk();
  }

  void _waitForSdk() {
    if (AdService.instance.isInitialized) {
      setState(() => _sdkReady = true);
      return;
    }

    _pollTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (AdService.instance.isInitialized) {
        timer.cancel();
        setState(() => _sdkReady = true);
      }
    });
  }

  void _retry() {
    if (!mounted || _retries >= _maxRetries) {
      if (mounted) setState(() => _failed = true);
      return;
    }

    _retries++;

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _bannerKey++);
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_sdkReady || _failed) {
      // Reserve the space so layout doesn't jump once the ad appears —
      // and stay invisible instead of showing a broken/empty ad slot.
      return const SizedBox(height: 52, width: double.infinity);
    }

    return SizedBox(
      height: 52,
      width: double.infinity,
      child: UnityBannerAd(
        key: ValueKey('banner_$_bannerKey'),
        placementId: AdService.bannerPlacementId,
        onLoad: (placementId) {},
        onClick: (placementId) {},
        onFailed: (placementId, error, message) => _retry(),
      ),
    );
  }
}
