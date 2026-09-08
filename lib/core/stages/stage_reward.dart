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
  // Stars are directly tied to remaining lives.
  // 3 lives = 3 stars
  // 2 lives = 2 stars
  // 1 life  = 1 star
  final stars = lives.clamp(0, 3);

  final baseBonus = level * 25 + bestCombo * 5 + lives * 10;

  final challengeBonus = challengeCompleted ? level * 25 : 0;

  final bonusScore = (baseBonus + challengeBonus) * bonusMultiplier;

  return StageReward(stars: stars, bonusScore: bonusScore);
}
