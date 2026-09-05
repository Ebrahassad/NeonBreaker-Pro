import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/save_service.dart';
import '../widgets/ad_banner.dart';
import '../widgets/neon_app_icon.dart';
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
                          child: const NeonAppIcon(size: 120),
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
