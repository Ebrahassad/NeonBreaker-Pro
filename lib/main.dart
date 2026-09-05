import 'dart:async';

import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/home_screen.dart';
import 'services/ad_service.dart';
import 'services/save_service.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final save = SaveService();
      await save.init();

      runApp(NeonBreakerApp(save: save));

      // Ads initialize only after the first frame is on screen, and any
      // failure here (missing native SDK, bad game id, no network, etc.)
      // is swallowed so it can never take the whole app down with it.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initAdsSafely();
      });
    },
    (error, stack) {
      // Never let a stray ad-SDK or platform-channel error crash the app.
      debugPrint('Unhandled error (ignored so the game keeps running): $error');
    },
  );
}

void _initAdsSafely() {
  Future(() async {
    try {
      await AdService.instance.init();
    } catch (_) {
      // Ads are optional — the game is fully playable without them.
    }
  });
}

class NeonBreakerApp extends StatelessWidget {
  const NeonBreakerApp({super.key, required this.save});

  final SaveService save;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NeonBreaker Pro',
      theme: neonTheme(),
      home: HomeScreen(save: save),
    );
  }
}
