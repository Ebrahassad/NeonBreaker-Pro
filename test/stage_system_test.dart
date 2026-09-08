import 'package:flutter_test/flutter_test.dart';

import 'package:neonbreaker_pro/core/stages/stage_config.dart';
import 'package:neonbreaker_pro/core/stages/stage_reward.dart';

void main() {
  test('stage configuration changes with progression', () {
    expect(stageConfigFor(1).theme, StageTheme.classic);

    expect(stageConfigFor(7).theme, StageTheme.cyber);

    expect(stageConfigFor(20).theme, StageTheme.voidZone);

    expect(stageConfigFor(25).theme, StageTheme.galaxy);
  });

  test('stage reward can reach three stars', () {
    final reward = calculateStageReward(
      score: 1500,
      lives: 3,
      bestCombo: 10,
      level: 15,
        bonusMultiplier: 4,
    );

    expect(reward.stars, 3);
    expect(reward.bonusScore, greaterThan(0));
  });

  test('minimum completed stage gives one star', () {
    final reward = calculateStageReward(
      score: 10,
      lives: 1,
      bestCombo: 0,
      level: 1,
        bonusMultiplier: 1,
    );

    expect(reward.stars, 1);
  });
}
