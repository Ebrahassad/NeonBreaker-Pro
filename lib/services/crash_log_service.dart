import 'dart:io';

/// Reads back the crash logs written by `NeonBreakerApplication.kt`
/// (see android/app/src/main/kotlin/.../NeonBreakerApplication.kt).
///
/// No adb, no Play Console, no root required: this is this app's own
/// external files directory, which every app can read/write without any
/// runtime permission.
class CrashLogService {
  static const String _packageName = 'hassadi.neonbreaker.pro';

  static Directory _crashLogDir() {
    return Directory(
      '/storage/emulated/0/Android/data/$_packageName/files/crash_logs',
    );
  }

  /// Returns the most recent crash log's contents, or null if there
  /// isn't one (either no crash happened, or storage isn't accessible
  /// on this device — both are treated the same: just skip silently).
  static Future<String?> latestCrashLog() async {
    try {
      final dir = _crashLogDir();

      if (!await dir.exists()) return null;

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
      final dir = _crashLogDir();
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (_) {
      // Nothing to do — worst case an old log stays around.
    }
  }
}
