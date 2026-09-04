class StageReward {
  const StageReward({required this.stars, required this.bonusScore});

  final int stars;
  final int bonusScore;
}

StageReward calculateStageReward({
  required int score,
  required int lives,
  required int bestCombo,
  required int level,
  required int bonusMultiplier,
  bool challengeCompleted = false,
}) {
  var stars = 1;

  if (lives >= 3) {
    stars++;
  }

  if (bestCombo >= 5) {
    stars++;
  }

  if (challengeCompleted) {
    stars++;
  }

  if (level >= 10 && score >= level * 100) {
    stars = 3;
  }

  stars = stars.clamp(1, 3);

  final baseBonus = level * 25 + bestCombo * 5 + lives * 10;

  final challengeBonus = challengeCompleted ? level * 25 : 0;

  final bonusScore = (baseBonus + challengeBonus) * bonusMultiplier;

  return StageReward(stars: stars, bonusScore: bonusScore);
}
