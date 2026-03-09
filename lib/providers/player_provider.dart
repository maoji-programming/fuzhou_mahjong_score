import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import 'game_rules_provider.dart';
import 'game_state_provider.dart';

class PlayersNotifier extends Notifier<List<Player>> {
  @override
  List<Player> build() {
    return [
      Player(id: '1', name: 'Player 1', icon: '👤', isBanker: true),
      Player(id: '2', name: 'Player 2', icon: '👤'),
      Player(id: '3', name: 'Player 3', icon: '👤'),
      Player(id: '4', name: 'Player 4', icon: '👤'),
    ];
  }

  void updatePlayer(String id, {String? name, String? icon, bool? isBanker}) {
    state = [
      for (final player in state)
        if (player.id == id)
          player.copyWith(name: name, icon: icon, isBanker: isBanker)
        else
          // If a new player is set as banker, others should not be banker
          player.copyWith(isBanker: isBanker == true ? false : player.isBanker),
    ];
  }

  void setBanker(String id) {
    state = [
      for (final player in state) player.copyWith(isBanker: player.id == id),
    ];
  }

  void settleRound({
    required String endMethod, // '流局', '胡牌'
    required String? winnerId,
    String? discarderId,
    int flowerCount = 0,
    int goldCount = 0,
    int kongCount = 0,
    int bankerCount = 0,
    String? specialWin, // '平胡', '自摸', '金雀', etc.
    int basePoint = 5,
    Map<String, int>? customScores, // Provide a map of player id to score loss
  }) {
    if (endMethod == '流局') {
      return;
    }

    final int winnerIndex = state.indexWhere((p) => p.id == winnerId);
    if (winnerIndex == -1) return;

    final winner = state[winnerIndex];
    final gameStateNotifier = ref.read(gameStateProvider.notifier);
    final gameState = ref.read(gameStateProvider);

    // Calculate the score per player
    int scorePerPlayer = 0;
    int currentBankerCount = winner.isBanker ? gameState.bankerCount + 1 : 0;
    if (customScores != null) {
      // Scores are directly provided per player
    } else {
      //score of special hand set in game rule page
      final rules = ref.read(gameRulesProvider);
      int handscore = rules.getSpecialHandPoint(specialWin);

      scorePerPlayer =
          (basePoint +
                  flowerCount +
                  goldCount +
                  kongCount +
                  currentBankerCount) *
              2 +
          handscore;
    }
    // Sum up the score of each player
    List<Player> newState = List.from(state);
    int totalWon = 0;

    for (int i = 0; i < newState.length; i++) {
      if (i == winnerIndex) continue;

      int payment = 0;

      if (customScores != null) {
        payment = customScores[newState[i].id] ?? 0;
      } else {
        payment = scorePerPlayer;
        if (newState[i].isBanker) {
          payment *= 2;
        }
      }

      newState[i] = newState[i].copyWith(score: newState[i].score - payment);
      totalWon += payment;
    }

    newState[winnerIndex] = newState[winnerIndex].copyWith(
      score: newState[winnerIndex].score + totalWon,
    );

    // Apply game state updates
    if (winner.isBanker) {
      gameStateNotifier.updateBankerCount(currentBankerCount);
      gameStateNotifier.nextWind();
    } else {
      gameStateNotifier.updateBankerCount(0);
      // Fuzhou mahjong typical rule: banker passes to next
    }

    state = newState;
  }
}

final playersProvider = NotifierProvider<PlayersNotifier, List<Player>>(
  PlayersNotifier.new,
);
