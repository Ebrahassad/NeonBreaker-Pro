import 'package:flutter/material.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../services/ad_service.dart';

class AdBanner extends StatelessWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (!AdService.instance.isInitialized) {
      return const SizedBox(
        height: 52,
        width: double.infinity,
      );
    }

    return const SizedBox(
      height: 52,
      width: double.infinity,
      child: UnityBannerAd(
        placementId: AdService.bannerPlacementId,
      ),
    );
  }
}
