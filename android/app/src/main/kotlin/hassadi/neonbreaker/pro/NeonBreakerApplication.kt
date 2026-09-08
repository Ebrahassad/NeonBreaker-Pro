package hassadi.neonbreaker.pro

import android.app.Application
import java.io.File
import java.io.PrintWriter
import java.io.StringWriter
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Catches ANY uncaught exception — including ones thrown by a
 * third-party SDK's own auto-starting ContentProvider (e.g. Unity Ads),
 * which run BEFORE Application.onCreate(). The handler is installed in
 * this class's `init` block, which executes during object construction
 * — the earliest point our own code can run in the whole process.
 *
 * The Flutter side (see crash_log_service.dart / home_screen.dart) reads
 * this file back on next launch and shows it in a copyable dialog — no
 * adb, no Play Console, no root needed to retrieve it.
 */
class NeonBreakerApplication : Application() {

    init {
        installCrashHandler()
    }

    private fun installCrashHandler() {
        val defaultHandler = Thread.getDefaultUncaughtExceptionHandler()

        Thread.setDefaultUncaughtExceptionHandler { thread, throwable ->
            try {
                val stringWriter = StringWriter()
                throwable.printStackTrace(PrintWriter(stringWriter))

                val timestamp = SimpleDateFormat(
                    "yyyy-MM-dd_HH-mm-ss",
                    Locale.US,
                ).format(Date())

                // Internal storage (filesDir) is always available, needs
                // no permission, and needs no path guessing on the Dart
                // side — unlike external storage, which can differ by
                // device/user profile.
                val logDir = File(filesDir, "crash_logs")
                if (!logDir.exists()) {
                    logDir.mkdirs()
                }

                val logFile = File(logDir, "crash_$timestamp.txt")
                logFile.writeText(
                    "Thread: ${thread.name}\n\n${stringWriter}"
                )
            } catch (loggingFailure: Throwable) {
                // Never let the crash logger itself throw — that would
                // replace the original, useful stack trace with a new one.
            }

            // Always hand off to the default handler afterwards so normal
            // Android crash behavior (closing the app) still happens.
            defaultHandler?.uncaughtException(thread, throwable)
        }
    }
}
