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
  final stage = level.clamp(1, 100);

  // Every 10th stage is a major Boss stage.
  if (stage % 10 == 0) {
    return StageConfig(
      theme: stage <= 30
          ? StageTheme.cyber
          : stage <= 60
              ? StageTheme.reactor
              : stage <= 80
                  ? StageTheme.voidZone
                  : StageTheme.galaxy,
      challenge: StageChallenge.score,
      target: 700 + stage * 20,
      bonusMultiplier: 3 + (stage ~/ 40),
    );
  }

  // Levels 1-10: learning curve.
  if (stage <= 10) {
    return StageConfig(
      theme: stage <= 5 ? StageTheme.classic : StageTheme.neon,
      challenge: stage <= 3
          ? StageChallenge.none
          : StageChallenge.combo,
      target: stage <= 3 ? 0 : 5 + stage,
      bonusMultiplier: 1,
    );
  }

  // Levels 11-30: first serious difficulty increase.
  if (stage <= 30) {
    return StageConfig(
      theme: StageTheme.cyber,
      challenge: stage.isEven
          ? StageChallenge.lives
          : StageChallenge.combo,
      target: stage.isEven ? 2 : 10 + stage ~/ 3,
      bonusMultiplier: 2,
    );
  }

  // Levels 31-50: faster and more demanding.
  if (stage <= 50) {
    return StageConfig(
      theme: StageTheme.reactor,
      challenge: stage.isEven
          ? StageChallenge.score
          : StageChallenge.combo,
      target: stage.isEven
          ? 900 + (stage - 30) * 25
          : 14 + stage ~/ 4,
      bonusMultiplier: 3,
    );
  }

  // Levels 51-70: advanced gameplay.
  if (stage <= 70) {
    return StageConfig(
      theme: StageTheme.voidZone,
      challenge: stage % 3 == 0
          ? StageChallenge.lives
          : StageChallenge.score,
      target: stage % 3 == 0
          ? 2
          : 1400 + (stage - 50) * 30,
      bonusMultiplier: 3,
    );
  }

  // Levels 71-90: expert zone.
  if (stage <= 90) {
    return StageConfig(
      theme: StageTheme.galaxy,
      challenge: stage.isEven
          ? StageChallenge.combo
          : StageChallenge.score,
      target: stage.isEven
          ? 22 + stage ~/ 5
          : 2000 + (stage - 70) * 35,
      bonusMultiplier: 4,
    );
  }

  // Levels 91-100: final/endgame difficulty.
  return StageConfig(
    theme: StageTheme.galaxy,
    challenge: StageChallenge.combo,
    target: 28 + stage ~/ 5,
    bonusMultiplier: 5,
  );
}
