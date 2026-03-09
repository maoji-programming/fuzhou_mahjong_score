import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/player_provider.dart';
import '../models/player.dart';
import 'player_setting_page.dart';
import 'game_rules_page.dart';
import 'game_page.dart';

class PlayersPage extends ConsumerWidget {
  const PlayersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                '加入玩家',
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

                        // Player 1 (Top)
                        _buildPlayerAvatar(
                          context,
                          players[0],
                          Alignment.topCenter,
                        ),
                        // Player 2 (Left)
                        _buildPlayerAvatar(
                          context,
                          players[1],
                          Alignment.centerLeft,
                        ),
                        // Player 3 (Bottom)
                        _buildPlayerAvatar(
                          context,
                          players[2],
                          Alignment.bottomCenter,
                        ),
                        // Player 4 (Right)
                        _buildPlayerAvatar(
                          context,
                          players[3],
                          Alignment.centerRight,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Game Rule Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameRulesPage(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFFC107), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    '游戏规则',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Start Game Button
              Container(
                width: double.infinity,
                height: 56,
                margin: const EdgeInsets.only(bottom: 24),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GamePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    '开始游戏',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerAvatar(
    BuildContext context,
    Player player,
    Alignment alignment,
  ) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerSettingPage(playerId: player.id),
            ),
          );
        },
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
                  child: Text(
                    player.icon,
                    style: const TextStyle(fontSize: 30),
                  ),
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
              child: Text(
                player.name,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E1E1E),
                ),
              ),
            ),
            if (player.isBanker) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC107),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '庄家',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
