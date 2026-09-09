import 'package:flutter/material.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../services/ad_service.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: UnityBannerAd(
        placementId: AdService.bannerPlacementId,
        onLoad: (placementId) {},
        onClick: (placementId) {},
        onFailed: (placementId, error, message) {},
      ),
    );
  }
}
