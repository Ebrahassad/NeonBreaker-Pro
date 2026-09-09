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
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('تم نسخ السجل')));
                }
              },
              child: const Text('نسخ'),
            ),
            TextButton(
              onPressed: () async {
                await CrashLogService.clearAll();

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
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
      backgroundColor: const Color(0xFF03020A),
      body: Stack(
        children: [
SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(22, 28, 22, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLogo(),

                          const SizedBox(height: 18),

                          _buildTitle(),

                          const SizedBox(height: 30),

                          _buildBestScore(),

                          const SizedBox(height: 28),

                          _mainButton(
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

                          const SizedBox(height: 14),

                          Row(
                            children: [
                              Expanded(
                                child: _secondaryButton(
                                  context,
                                  'LEVELS',
                                  Icons.grid_view_rounded,
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            LevelsScreen(save: save),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _secondaryButton(
                                  context,
                                  'SETTINGS',
                                  Icons.settings_rounded,
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            SettingsScreen(save: save),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            'BREAK • BOUNCE • DESTROY',
                            style: TextStyle(
                              color: Colors.white30,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.5,
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
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        width: 142,
        height: 142,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(
              color: NeonColors.cyan.withValues(alpha: .42),
              blurRadius: 30,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: NeonColors.cyan.withValues(alpha: .28),
              blurRadius: 58,
              spreadRadius: 12,
            ),
            BoxShadow(
              color: NeonColors.pink.withValues(alpha: .22),
              blurRadius: 75,
              spreadRadius: 10,
            ),
            BoxShadow(
              color: NeonColors.cyan.withValues(alpha: .16),
              blurRadius: 100,
              spreadRadius: 18,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: Image.asset(
            'assets/icon/neonbreaker_icon.png',
            width: 142,
            height: 142,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [Colors.white, Color(0xFFB8F9FF), NeonColors.cyan],
            ).createShader(bounds);
          },
          child: const Text(
            'NEONBREAKER',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 31,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.8,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 3),

        const Text(
          'PRO',
          style: TextStyle(
            color: NeonColors.pink,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 9,
            shadows: [Shadow(color: NeonColors.pink, blurRadius: 12)],
          ),
        ),
      ],
    );
  }

  Widget _buildBestScore() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: .035),
        border: Border.all(color: NeonColors.cyan.withValues(alpha: .18)),
        boxShadow: [
          BoxShadow(
            color: NeonColors.cyan.withValues(alpha: .06),
            blurRadius: 18,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            size: 20,
            color: Color(0xFFFFD166),
          ),
          const SizedBox(width: 9),
          const Text(
            'BEST',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${save.highScore}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback action,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF39ECFF), Color(0xFF14D9F5), Color(0xFF087FBE)],
            stops: [0.0, 0.42, 1.0],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: .55),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: NeonColors.cyan.withValues(alpha: .55),
              blurRadius: 28,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: NeonColors.cyan.withValues(alpha: .22),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 12,
              right: 12,
              top: 5,
              height: 18,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: .28),
                        Colors.white.withValues(alpha: .0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // PLAY stays exactly in the center of the button.
            Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  shadows: [
                    Shadow(
                      color: Color(0xAA003B55),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),

            // Play icon is independent from the centered text.
            Positioned(
              left: 18,
              child: IgnorePointer(
                child: Icon(
                  icon,
                  size: 32,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Color(0xAA003B55),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),

            // Invisible touch layer preserves the whole button action.
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: action,
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.white.withValues(alpha: .16),
                  highlightColor: Colors.white.withValues(alpha: .08),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secondaryButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback action,
  ) {
    return SizedBox(
      height: 55,
      child: OutlinedButton.icon(
        onPressed: action,
        icon: Icon(icon, size: 20),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: NeonColors.cyan.withValues(alpha: .40)),
          backgroundColor: Colors.white.withValues(alpha: .025),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
    );
  }
}


