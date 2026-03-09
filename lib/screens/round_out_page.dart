import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/player_provider.dart';
import '../providers/game_rules_provider.dart';
import '../providers/game_state_provider.dart';
import '../models/player.dart';
import '../models/game_rules.dart';

class RoundOutPage extends ConsumerStatefulWidget {
  const RoundOutPage({super.key});

  @override
  ConsumerState<RoundOutPage> createState() => _RoundOutPageState();
}

class _RoundOutPageState extends ConsumerState<RoundOutPage> {
  String _endMethod = '食胡'; // '流局', '食胡'
  String? _winnerId;
  bool _isCustomScore = false;

  final TextEditingController _flowerController = TextEditingController(
    text: '0',
  );
  final TextEditingController _goldController = TextEditingController(
    text: '0',
  );
  final TextEditingController _kongController = TextEditingController(
    text: '0',
  );
  final Map<String, TextEditingController> _customScoreControllers = {};

  TextEditingController _getCustomScoreController(String playerId) {
    if (!_customScoreControllers.containsKey(playerId)) {
      _customScoreControllers[playerId] = TextEditingController(text: '0');
    }
    return _customScoreControllers[playerId]!;
  }

  final List<String> _specialWins = ['平胡', '自摸', '金雀', '三金倒', '抢金', '金龙'];
  String _selectedSpecialWin = '平胡';

  @override
  void dispose() {
    _flowerController.dispose();
    _goldController.dispose();
    _kongController.dispose();
    for (var controller in _customScoreControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playersProvider);
    // ignore: unused_local_variable
    final rules = ref.watch(gameRulesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '本局结算',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('结束方式'),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildOptionChip('流局'),
                const SizedBox(width: 8),
                _buildOptionChip('食胡'),
              ],
            ),
            const SizedBox(height: 32),
            if (_endMethod != '流局') ...[
              _buildSectionHeader('选择赢家'),
              const SizedBox(height: 16),
              _buildPlayerSelector(
                players,
                _winnerId,
                (id) => setState(() {
                  _winnerId = id;
                }),
              ),

              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('分数详情'),
                  Row(
                    children: [
                      Text(
                        '自定',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Checkbox(
                        value: _isCustomScore,
                        onChanged: (val) {
                          setState(() {
                            _isCustomScore = val ?? false;
                          });
                        },
                        activeColor: const Color(0xFF2E7D32),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildScoreInputs(players),
              const SizedBox(height: 32),
              if (!_isCustomScore) ...[
                _buildSectionHeader('特殊胡牌'),
                const SizedBox(height: 16),
                _buildSpecialWinChips(),
                const SizedBox(height: 32),
                _buildSectionHeader('当前得分预览'),
                const SizedBox(height: 16),
                _buildScorePreview(players, rules),
                const SizedBox(height: 40),
              ],
            ],
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _canConfirm() ? _confirmResult : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: Text(
                  '确认并结算',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1A1C1E),
      ),
    );
  }

  Widget _buildOptionChip(String method) {
    final isSelected = _endMethod == method;
    return ChoiceChip(
      label: Text(method),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _endMethod = method;
          });
        }
      },
      selectedColor: const Color(0xFFFFC107).withOpacity(0.2),
      labelStyle: GoogleFonts.outfit(
        color: isSelected ? const Color(0xFFE65100) : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? const Color(0xFFFFC107) : Colors.black12,
        ),
      ),
    );
  }

  Widget _buildPlayerSelector(
    List<Player> players,
    String? selectedId,
    Function(String) onSelect,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: players.map((player) {
          final isSelected = selectedId == player.id;
          return GestureDetector(
            onTap: () => onSelect(player.id),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2E7D32).withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? const Color(0xFF2E7D32) : Colors.black12,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Text(player.icon, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(
                    player.name,
                    style: GoogleFonts.outfit(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildScoreInputs(List<Player> players) {
    if (_isCustomScore) {
      if (_winnerId == null) {
        return Text(
          '请先选择赢家',
          style: GoogleFonts.outfit(color: Colors.grey[600]),
        );
      }

      final nonWinners = players.where((p) => p.id != _winnerId).toList();

      return Column(
        children: nonWinners.map((player) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildNumberInput(
              '${player.name} 应付分数',
              _getCustomScoreController(player.id),
              isFullWidth: true,
            ),
          );
        }).toList(),
      );
    }
    return Row(
      children: [
        Expanded(child: _buildNumberInput('花数', _flowerController)),
        const SizedBox(width: 12),
        Expanded(child: _buildNumberInput('金数', _goldController)),
        const SizedBox(width: 12),
        Expanded(child: _buildNumberInput('槓数', _kongController)),
      ],
    );
  }

  Widget _buildNumberInput(
    String label,
    TextEditingController controller, {
    bool isFullWidth = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black12),
              ),
            ),
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialWinChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _specialWins.map((win) {
        final isSelected = _selectedSpecialWin == win;
        return ChoiceChip(
          label: Text(win),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              if (win == '三金倒' || win == '金龙') {
                _goldController.text = '3';
              }
              if (win == '金雀') {
                _goldController.text = '2';
              }
              setState(() {
                _selectedSpecialWin = win;
              });
            }
          },
          selectedColor: const Color(0xFF2E7D32).withOpacity(0.1),
          labelStyle: GoogleFonts.outfit(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? const Color(0xFF2E7D32) : Colors.black12,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScorePreview(List<Player> players, GameRules rules) {
    if (_winnerId == null) {
      return Text('请先选择赢家', style: GoogleFonts.outfit(color: Colors.grey[600]));
    }

    // We need game state for bankerCount
    // using Consumer widget approach or reading from ref.watch
    // actually, let's just use ref.watch(gameStateProvider)
    return Consumer(
      builder: (context, ref, child) {
        final gameState = ref.watch(gameStateProvider);

        final int basePoint = rules.basePoint;
        final int flowerCount = int.tryParse(_flowerController.text) ?? 0;
        final int goldCount = int.tryParse(_goldController.text) ?? 0;
        final int kongCount = int.tryParse(_kongController.text) ?? 0;

        final winner = players.firstWhere(
          (p) => p.id == _winnerId,
          orElse: () => players.first,
        );
        int currentBankerCount = gameState.bankerCount;
        if (winner.isBanker) {
          currentBankerCount += 1;
        } else {
          currentBankerCount = 0;
        }

        final int handscore = rules.getSpecialHandPoint(_selectedSpecialWin);
        final int scorePerPlayer =
            (basePoint +
                    flowerCount +
                    goldCount +
                    kongCount +
                    currentBankerCount) *
                2 +
            handscore;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '计算公式:',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '($basePoint底分 + $flowerCount花 + $goldCount金 + $kongCount杠 + $currentBankerCount连庄) × 2 + $handscore (${_selectedSpecialWin}) = $scorePerPlayer 分/人',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: const Color(0xFF1A1C1E),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '总计赢取: ${scorePerPlayer * (players.length - 1)} 分',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  color: const Color(0xFFE65100),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _canConfirm() {
    if (_endMethod == '流局') return true;
    if (_winnerId == null) return false;
    return true;
  }

  void _confirmResult() {
    final playersNotifier = ref.read(playersProvider.notifier);
    final rules = ref.read(gameRulesProvider);

    Map<String, int>? customScores;
    if (_isCustomScore && _winnerId != null) {
      customScores = {};
      for (var player in ref.read(playersProvider)) {
        if (player.id != _winnerId) {
          customScores[player.id] =
              int.tryParse(_getCustomScoreController(player.id).text) ?? 0;
        }
      }
    }

    playersNotifier.settleRound(
      endMethod: _endMethod,
      winnerId: _winnerId,
      flowerCount: int.tryParse(_flowerController.text) ?? 0,
      goldCount: int.tryParse(_goldController.text) ?? 0,
      kongCount: int.tryParse(_kongController.text) ?? 0,
      specialWin: _selectedSpecialWin,
      basePoint: rules.basePoint,
      customScores: customScores,
    );

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_endMethod == '流局' ? '本局流局' : '结算成功'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
    );
  }
}
