import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../services/save_service.dart';
import '../widgets/ad_banner.dart';
import 'game_screen.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key, required this.save});

  final SaveService save;

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Refresh saved progress whenever the screen becomes active again.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _openLevel(int level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(save: widget.save, level: level),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Widget _stars(int stars) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) => Icon(
          index < stars ? Icons.star_rounded : Icons.star_border_rounded,
          size: 14,
          color: index < stars ? NeonColors.yellow : Colors.white24,
        ),
      ),
    );
  }

  Widget _levelCard({
    required int level,
    required bool unlocked,
    required int stars,
    required int bestScore,
  }) {
    return InkWell(
      onTap: unlocked ? () => _openLevel(level) : null,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: NeonColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: unlocked ? NeonColors.cyan : Colors.white12,
          ),
        ),
        child: unlocked
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$level',
                    style: const TextStyle(
                      color: NeonColors.cyan,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  _stars(stars),
                  if (bestScore > 0) ...[
                    const SizedBox(height: 3),
                    Text(
                      'BEST $bestScore',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .4,
                      ),
                    ),
                  ],
                ],
              )
            : const Icon(Icons.lock_rounded, color: Colors.white24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final save = widget.save;
    final bestLevel = save.bestLevel;

    return Scaffold(
      appBar: AppBar(title: const Text('LEVELS'), actions: []),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'TOTAL STARS: ${save.totalStars}',
                    style: const TextStyle(
                      color: NeonColors.yellow,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                Text(
                  'BEST LEVEL: ${save.bestLevel}',
                  style: const TextStyle(
                    color: NeonColors.cyan,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: 100,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final level = index + 1;
                final unlocked = level <= bestLevel;
                final stars = save.starsForLevel(level);
                final bestScore = save.bestScoreForLevel(level);

                return _levelCard(
                  level: level,
                  unlocked: unlocked,
                  stars: stars,
                  bestScore: bestScore,
                );
              },
            ),
          ),
          const AdBanner(),
        ],
      ),
    );
  }
}
