import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_rules.dart';

class GameRulesNotifier extends Notifier<GameRules> {
  @override
  GameRules build() {
    return GameRules();
  }

  void updateRules(GameRules rules) {
    state = rules;
  }

  void setBasePoint(int value) {
    state = state.copyWith(basePoint: value);
  }

  void setNormalHandPoint(int? value) {
    state = state.copyWith(normalHandPoint: () => value);
  }

  void setSelfDrawnPoint(int? value) {
    state = state.copyWith(selfDrawnPoint: () => value);
  }

  void setGoldenBirdPoint(int? value) {
    state = state.copyWith(goldenBirdPoint: () => value);
  }

  void setThreeGoldenFallPoint(int? value) {
    state = state.copyWith(threeGoldenFallPoint: () => value);
  }

  void setRobGoldPoint(int? value) {
    state = state.copyWith(robGoldPoint: () => value);
  }

  void setGoldenDragonPoint(int? value) {
    state = state.copyWith(goldenDragonPoint: () => value);
  }
}

final gameRulesProvider = NotifierProvider<GameRulesNotifier, GameRules>(
  GameRulesNotifier.new,
);
