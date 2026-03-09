import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Wind {
  east("东风"),
  south("南风"),
  west("西风"),
  north("北风");

  final String name;
  const Wind(this.name);
}

class GameState {
  final int round; // 第1圈
  final Wind wind; // 东风, 南风, 西风, 北风
  final int bankerCount;

  GameState({this.round = 1, this.wind = Wind.east, this.bankerCount = 0});

  GameState copyWith({int? round, Wind? wind, int? bankerCount}) {
    return GameState(
      round: round ?? this.round,
      wind: wind ?? this.wind,
      bankerCount: bankerCount ?? this.bankerCount,
    );
  }
}

class GameStateNotifier extends Notifier<GameState> {
  @override
  GameState build() {
    return GameState();
  }

  void updateRound(int round) {
    state = state.copyWith(round: round);
  }

  void updateWind(Wind wind) {
    state = state.copyWith(wind: wind);
  }

  void nextRound() {
    state = state.copyWith(round: state.round + 1);
  }

  void nextWind() {
    state = state.copyWith(wind: Wind.values[(state.wind.index + 1) % 4]);
  }

  void updateBankerCount(int count) {
    state = state.copyWith(bankerCount: count);
  }
}

final gameStateProvider = NotifierProvider<GameStateNotifier, GameState>(
  GameStateNotifier.new,
);
