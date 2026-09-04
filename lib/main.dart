import 'dart:async';

import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/home_screen.dart';
import 'services/ad_service.dart';
import 'services/save_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final save = SaveService();
  await save.init();

  // Fire-and-forget: ads initialize in the background so they never
  // delay the app from opening.
  unawaited(AdService.instance.init());

  runApp(NeonBreakerApp(save: save));
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
