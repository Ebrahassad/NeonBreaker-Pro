enum StagePattern {
  classic,
  diamond,
  fortress,
  checker,
  pyramid,
  cross,
  tunnel,
  boss,
}

StagePattern patternForLevel(int level) {
  final l = level.clamp(1, 100);

  // Boss stages
  if (l == 20 || l == 40 || l == 60 || l == 80 || l == 100) {
    return StagePattern.boss;
  }

  // 1-10: Classic / introduction
  if (l <= 10) {
    const sequence = [
      StagePattern.classic,
      StagePattern.pyramid,
      StagePattern.diamond,
      StagePattern.checker,
      StagePattern.cross,
      StagePattern.classic,
      StagePattern.tunnel,
      StagePattern.diamond,
      StagePattern.pyramid,
      StagePattern.fortress,
    ];
    return sequence[l - 1];
  }

  // 11-20: defensive structures
  if (l <= 20) {
    const sequence = [
      StagePattern.fortress,
      StagePattern.tunnel,
      StagePattern.cross,
      StagePattern.diamond,
      StagePattern.fortress,
      StagePattern.checker,
      StagePattern.pyramid,
      StagePattern.tunnel,
      StagePattern.fortress,
      StagePattern.boss,
    ];
    return sequence[l - 11];
  }

  // 21-30: geometric patterns
  if (l <= 30) {
    const sequence = [
      StagePattern.diamond,
      StagePattern.cross,
      StagePattern.pyramid,
      StagePattern.checker,
      StagePattern.tunnel,
      StagePattern.diamond,
      StagePattern.cross,
      StagePattern.pyramid,
      StagePattern.fortress,
      StagePattern.checker,
    ];
    return sequence[l - 21];
  }

  // 31-40: advanced defensive
  if (l <= 40) {
    const sequence = [
      StagePattern.fortress,
      StagePattern.tunnel,
      StagePattern.fortress,
      StagePattern.cross,
      StagePattern.tunnel,
      StagePattern.diamond,
      StagePattern.fortress,
      StagePattern.pyramid,
      StagePattern.tunnel,
      StagePattern.boss,
    ];
    return sequence[l - 31];
  }

  // 41-50: mixed formations
  if (l <= 50) {
    const sequence = [
      StagePattern.checker,
      StagePattern.diamond,
      StagePattern.cross,
      StagePattern.pyramid,
      StagePattern.tunnel,
      StagePattern.fortress,
      StagePattern.checker,
      StagePattern.cross,
      StagePattern.diamond,
      StagePattern.pyramid,
    ];
    return sequence[l - 41];
  }

  // 51-60: difficult formations
  if (l <= 60) {
    const sequence = [
      StagePattern.fortress,
      StagePattern.cross,
      StagePattern.tunnel,
      StagePattern.checker,
      StagePattern.diamond,
      StagePattern.fortress,
      StagePattern.pyramid,
      StagePattern.tunnel,
      StagePattern.cross,
      StagePattern.boss,
    ];
    return sequence[l - 51];
  }

  // 61-70: high-density formations
  if (l <= 70) {
    const sequence = [
      StagePattern.pyramid,
      StagePattern.fortress,
      StagePattern.diamond,
      StagePattern.tunnel,
      StagePattern.checker,
      StagePattern.cross,
      StagePattern.fortress,
      StagePattern.pyramid,
      StagePattern.tunnel,
      StagePattern.diamond,
    ];
    return sequence[l - 61];
  }

  // 71-80: advanced mixed
  if (l <= 80) {
    const sequence = [
      StagePattern.cross,
      StagePattern.tunnel,
      StagePattern.fortress,
      StagePattern.checker,
      StagePattern.pyramid,
      StagePattern.diamond,
      StagePattern.cross,
      StagePattern.fortress,
      StagePattern.tunnel,
      StagePattern.boss,
    ];
    return sequence[l - 71];
  }

  // 81-90: endgame formations
  if (l <= 90) {
    const sequence = [
      StagePattern.fortress,
      StagePattern.diamond,
      StagePattern.tunnel,
      StagePattern.cross,
      StagePattern.pyramid,
      StagePattern.checker,
      StagePattern.fortress,
      StagePattern.cross,
      StagePattern.diamond,
      StagePattern.tunnel,
    ];
    return sequence[l - 81];
  }

  // 91-100: final sequence
  const sequence = [
    StagePattern.pyramid,
    StagePattern.fortress,
    StagePattern.cross,
    StagePattern.tunnel,
    StagePattern.diamond,
    StagePattern.checker,
    StagePattern.fortress,
    StagePattern.cross,
    StagePattern.tunnel,
    StagePattern.boss,
  ];

  return sequence[l - 91];
}
