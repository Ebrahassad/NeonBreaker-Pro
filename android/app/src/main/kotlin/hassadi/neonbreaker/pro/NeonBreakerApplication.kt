package hassadi.neonbreaker.pro

import android.app.Application
import java.io.File
import java.io.PrintWriter
import java.io.StringWriter
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Catches ANY uncaught exception (including ones from third-party SDKs
 * like Unity Ads, and ones that happen before the Flutter engine even
 * starts) and writes the full stack trace to a plain text file under
 * this app's own external files directory.
 *
 * The Flutter side (see main.dart) reads this file back on next launch
 * and shows it in a copyable dialog — no adb, no Play Console, no root
 * needed to retrieve it.
 */
class NeonBreakerApplication : Application() {

    override fun onCreate() {
        super.onCreate()

        val defaultHandler = Thread.getDefaultUncaughtExceptionHandler()

        Thread.setDefaultUncaughtExceptionHandler { thread, throwable ->
            try {
                val stringWriter = StringWriter()
                throwable.printStackTrace(PrintWriter(stringWriter))

                val timestamp = SimpleDateFormat(
                    "yyyy-MM-dd_HH-mm-ss",
                    Locale.US,
                ).format(Date())

                val logDir = File(getExternalFilesDir(null), "crash_logs")
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
