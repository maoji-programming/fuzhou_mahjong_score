import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/player_provider.dart';
import '../providers/game_state_provider.dart';
import '../models/player.dart';
import '../widgets/dice_roll_overlay.dart';
import 'round_out_page.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  bool _showDiceOverlay = false;

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playersProvider);
    final gameState = ref.watch(gameStateProvider);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    '第${gameState.round}圈: ${gameState.wind.name}',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1C1E),
                    ),
                  ),

                  const SizedBox(height: 60),

                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // The Mahjong Table
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                                border: Border.all(
                                  color: const Color(0xFF1B5E20),
                                  width: 8,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.grid_4x4,
                                  color: Colors.white.withOpacity(0.2),
                                  size: 80,
                                ),
                              ),
                            ),

                            // Player Positions
                            _buildPlayerAvatar(players[0], Alignment.topCenter),
                            _buildPlayerAvatar(
                              players[1],
                              Alignment.centerLeft,
                            ),
                            _buildPlayerAvatar(
                              players[2],
                              Alignment.bottomCenter,
                            ),
                            _buildPlayerAvatar(
                              players[3],
                              Alignment.centerRight,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildActionButton(
                          label: '胡牌',
                          color: const Color(0xFF2E7D32),
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RoundOutPage(),
                              ),
                            );
                          },
                        ),
                        _buildActionButton(
                          label: '打骰',
                          color: const Color(0xFFFFC107),
                          textColor: Colors.black87,
                          onPressed: () {
                            setState(() {
                              _showDiceOverlay = true;
                            });
                          },
                        ),
                        _buildActionButton(
                          label: '统计',
                          color: const Color(0xFFFFC107),
                          textColor: Colors.black87,
                          onPressed: () {},
                        ),
                        _buildActionButton(
                          label: '结束',
                          color: Colors.white,
                          textColor: Colors.black87,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_showDiceOverlay)
          DiceRollOverlay(
            onDismiss: () {
              setState(() {
                _showDiceOverlay = false;
              });
            },
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 100,
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: color == Colors.white
                ? const BorderSide(color: Colors.black12)
                : BorderSide.none,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _buildPlayerAvatar(Player player, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: player.isBanker
                  ? Border.all(color: const Color(0xFFFFC107), width: 3)
                  : null,
            ),
            child: Material(
              elevation: 4,
              shape: const CircleBorder(),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: Text(player.icon, style: const TextStyle(fontSize: 30)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  player.name,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1E1E1E),
                  ),
                ),
                Text(
                  '${player.score}',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: player.score >= 0
                        ? const Color(0xFF2E7D32)
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
