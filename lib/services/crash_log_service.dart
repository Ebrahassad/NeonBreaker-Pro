import 'dart:io';

import 'package:flutter/services.dart';

/// Reads back the crash logs written by `NeonBreakerApplication.kt`
/// (see android/app/src/main/kotlin/.../NeonBreakerApplication.kt).
///
/// The exact storage path is fetched from native Android via a
/// MethodChannel instead of being guessed/hardcoded on the Dart side —
/// internal storage paths can vary slightly by device/user profile, so
/// asking Android directly is the only fully reliable way.
class CrashLogService {
  static const MethodChannel _channel = MethodChannel('neonbreaker/crash_logs');

  static Future<Directory?> _crashLogDir() async {
    try {
      final path = await _channel.invokeMethod<String>('getFilesDirPath');
      if (path == null) return null;
      return Directory('$path/crash_logs');
    } catch (_) {
      return null;
    }
  }

  /// Returns the most recent crash log's contents, or null if there
  /// isn't one (either no crash happened, or storage isn't accessible
  /// on this device — both are treated the same: just skip silently).
  static Future<String?> latestCrashLog() async {
    try {
      final dir = await _crashLogDir();
      if (dir == null || !await dir.exists()) return null;

      final files = await dir
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.txt'))
          .cast<File>()
          .toList();

      if (files.isEmpty) return null;

      files.sort((a, b) => b.path.compareTo(a.path));

      return await files.first.readAsString();
    } catch (_) {
      return null;
    }
  }

  /// Deletes every stored crash log (call this once the user has seen
  /// and copied the one they needed).
  static Future<void> clearAll() async {
    try {
      final dir = await _crashLogDir();
      if (dir != null && await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (_) {
      // Nothing to do — worst case an old log stays around.
    }
  }
}
