class Player {
  final String id;
  final String name;
  final String icon;
  final bool isBanker;
  final int score;
  final int bankerCount;
  final String direction; // 东, 南, 西, 北

  Player({
    required this.id,
    required this.name,
    required this.icon,
    this.isBanker = false,
    this.direction = "",
    this.score = 0,
    this.bankerCount = 0,
  });

  Player copyWith({
    String? name,
    String? icon,
    bool? isBanker,
    int? score,
    int? bankerCount,
    String? direction,
  }) {
    return Player(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isBanker: isBanker ?? this.isBanker,
      score: score ?? this.score,
      bankerCount: bankerCount ?? this.bankerCount,
      direction: direction ?? this.direction,
    );
  }
}
