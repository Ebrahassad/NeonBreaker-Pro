enum StageTheme { classic, neon, cyber, reactor, voidZone, galaxy }

enum StageChallenge { none, survive, combo, lives, score }

class StageConfig {
  const StageConfig({
    required this.theme,
    required this.challenge,
    required this.target,
    required this.bonusMultiplier,
  });

  final StageTheme theme;
  final StageChallenge challenge;
  final int target;
  final int bonusMultiplier;
}

StageConfig stageConfigFor(int level) {
  if (level <= 3) {
    return const StageConfig(
      theme: StageTheme.classic,
      challenge: StageChallenge.none,
      target: 0,
      bonusMultiplier: 1,
    );
  }

  if (level <= 6) {
    return const StageConfig(
      theme: StageTheme.neon,
      challenge: StageChallenge.combo,
      target: 5,
      bonusMultiplier: 2,
    );
  }

  if (level <= 10) {
    return const StageConfig(
      theme: StageTheme.cyber,
      challenge: StageChallenge.lives,
      target: 2,
      bonusMultiplier: 2,
    );
  }

  if (level <= 15) {
    return const StageConfig(
      theme: StageTheme.reactor,
      challenge: StageChallenge.score,
      target: 500,
      bonusMultiplier: 3,
    );
  }

  if (level <= 20) {
    return const StageConfig(
      theme: StageTheme.voidZone,
      challenge: StageChallenge.survive,
      target: 30,
      bonusMultiplier: 3,
    );
  }

  return const StageConfig(
    theme: StageTheme.galaxy,
    challenge: StageChallenge.combo,
    target: 10,
    bonusMultiplier: 4,
  );
}
