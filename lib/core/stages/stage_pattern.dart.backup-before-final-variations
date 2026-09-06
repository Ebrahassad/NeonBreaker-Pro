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
  if (level % 10 == 0) return StagePattern.boss;

  switch (level % 8) {
    case 1:
      return StagePattern.classic;
    case 2:
      return StagePattern.diamond;
    case 3:
      return StagePattern.fortress;
    case 4:
      return StagePattern.checker;
    case 5:
      return StagePattern.pyramid;
    case 6:
      return StagePattern.cross;
    case 7:
      return StagePattern.tunnel;
    default:
      return StagePattern.classic;
  }
}
