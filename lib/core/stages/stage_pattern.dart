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
  // Every 10th level is a Boss stage.
  if (level % 10 == 0) {
    return StagePattern.boss;
  }

  // The 100 levels are divided into progression bands.
  // Early levels stay readable, while later levels use
  // more demanding formations and more visual variety.

  final band = (level - 1) ~/ 20;
  final position = (level - 1) % 20;

  const early = <StagePattern>[
    StagePattern.classic,
    StagePattern.diamond,
    StagePattern.checker,
    StagePattern.pyramid,
    StagePattern.cross,
    StagePattern.tunnel,
    StagePattern.fortress,
  ];

  const mid = <StagePattern>[
    StagePattern.diamond,
    StagePattern.fortress,
    StagePattern.checker,
    StagePattern.cross,
    StagePattern.tunnel,
    StagePattern.pyramid,
    StagePattern.fortress,
  ];

  const late = <StagePattern>[
    StagePattern.fortress,
    StagePattern.tunnel,
    StagePattern.cross,
    StagePattern.pyramid,
    StagePattern.checker,
    StagePattern.fortress,
    StagePattern.tunnel,
  ];

  const endgame = <StagePattern>[
    StagePattern.tunnel,
    StagePattern.fortress,
    StagePattern.cross,
    StagePattern.pyramid,
    StagePattern.tunnel,
    StagePattern.fortress,
    StagePattern.checker,
  ];

  final patterns = switch (band) {
    0 => early,
    1 => mid,
    2 => late,
    3 => late,
    _ => endgame,
  };

  return patterns[position % patterns.length];
}
