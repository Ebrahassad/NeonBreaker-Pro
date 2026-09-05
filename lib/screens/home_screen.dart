import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme.dart';
import '../services/crash_log_service.dart';
import '../services/save_service.dart';
import '../widgets/ad_banner.dart';
import 'game_screen.dart';
import 'levels_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.save});

  final SaveService save;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SaveService get save => widget.save;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForCrashLog());
  }

  Future<void> _checkForCrashLog() async {
    final log = await CrashLogService.latestCrashLog();
    if (log == null || !mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0E0620),
          title: const Text(
            'تم رصد كراش سابق',
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: SelectableText(
                log,
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: 'monospace',
                  fontSize: 11,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: log));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم نسخ السجل')),
                  );
                }
              },
              child: const Text('نسخ'),
            ),
            TextButton(
              onPressed: () async {
                await CrashLogService.clearAll();
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('إغلاق وحذف السجل'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF180522), Color(0xFF07030E), Color(0xFF020208)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x6639F4FF),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/icon/neonbreaker_icon.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          'NEONBREAKER',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                            color: Colors.white,
                          ),
                        ),

                        const Text(
                          'PRO',
                          style: TextStyle(
                            color: NeonColors.cyan,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 8,
                          ),
                        ),

                        const SizedBox(height: 35),

                        _button(
                          context,
                          'PLAY',
                          Icons.play_arrow_rounded,
                          () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GameScreen(
                                  save: save,
                                  level: save.bestLevel,
                                ),
                              ),
                            );

                            if (context.mounted) {
                              setState(() {});
                            }
                          },
                        ),

                        const SizedBox(height: 12),

                        _button(context, 'LEVELS', Icons.grid_view_rounded, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LevelsScreen(save: save),
                            ),
                          );
                        }),

                        const SizedBox(height: 12),

                        _button(
                          context,
                          'SETTINGS',
                          Icons.settings_rounded,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SettingsScreen(save: save),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 25),

                        Text(
                          'BEST ${save.highScore}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const AdBanner(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback action,
  ) {
    return SizedBox(
      width: 330,
      height: 55,
      child: OutlinedButton.icon(
        onPressed: action,
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: NeonColors.cyan.withValues(alpha: .55)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
