class GameRules {
  final int basePoint;
  final int? normalHandPoint; // 平胡
  final int? selfDrawnPoint; // 自摸
  final int? goldenBirdPoint; // 金雀
  final int? threeGoldenFallPoint; // 三金倒
  final int? robGoldPoint; // 抢金
  final int? goldenDragonPoint; // 金龙

  GameRules({
    this.basePoint = 5,
    this.normalHandPoint = 10,
    this.selfDrawnPoint = 20,
    this.goldenBirdPoint = 30,
    this.threeGoldenFallPoint = 40,
    this.robGoldPoint = 60,
    this.goldenDragonPoint = 50,
  });

  GameRules copyWith({
    int? basePoint,
    int? Function()? normalHandPoint,
    int? Function()? selfDrawnPoint,
    int? Function()? goldenBirdPoint,
    int? Function()? threeGoldenFallPoint,
    int? Function()? robGoldPoint,
    int? Function()? goldenDragonPoint,
  }) {
    return GameRules(
      basePoint: basePoint ?? this.basePoint,
      normalHandPoint: normalHandPoint != null
          ? normalHandPoint()
          : this.normalHandPoint,
      selfDrawnPoint: selfDrawnPoint != null
          ? selfDrawnPoint()
          : this.selfDrawnPoint,
      goldenBirdPoint: goldenBirdPoint != null
          ? goldenBirdPoint()
          : this.goldenBirdPoint,
      threeGoldenFallPoint: threeGoldenFallPoint != null
          ? threeGoldenFallPoint()
          : this.threeGoldenFallPoint,
      robGoldPoint: robGoldPoint != null ? robGoldPoint() : this.robGoldPoint,
      goldenDragonPoint: goldenDragonPoint != null
          ? goldenDragonPoint()
          : this.goldenDragonPoint,
    );
  }

  int getSpecialHandPoint(String? specialWin) {
    if (specialWin == null) return 0;
    switch (specialWin) {
      case '平胡':
        return normalHandPoint ?? 0;
      case '自摸':
        return selfDrawnPoint ?? 0;
      case '金雀':
        return goldenBirdPoint ?? 0;
      case '三金倒':
        return threeGoldenFallPoint ?? 0;
      case '抢金':
        return robGoldPoint ?? 0;
      case '金龙':
        return goldenDragonPoint ?? 0;
      default:
        return 0;
    }
  }
}
