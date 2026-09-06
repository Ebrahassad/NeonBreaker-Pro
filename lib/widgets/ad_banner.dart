import 'package:flutter/material.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../services/ad_service.dart';

/// A thin banner ad strip. Fails silently — if the ad can't load, it just
/// collapses to nothing instead of leaving a broken placeholder on screen.
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  bool _failed = false;

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 52,
      child: UnityBannerAd(
        placementId: AdService.bannerPlacementId,
        onLoad: (placementId) {},
        onClick: (placementId) {},
        onFailed: (placementId, error, message) {
          if (mounted) {
            setState(() => _failed = true);
          }
        },
      ),
    );
  }
}
