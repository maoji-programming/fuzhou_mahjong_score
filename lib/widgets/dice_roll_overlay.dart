import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiceRollOverlay extends StatefulWidget {
  final VoidCallback onDismiss;

  const DiceRollOverlay({super.key, required this.onDismiss});

  @override
  State<DiceRollOverlay> createState() => _DiceRollOverlayState();
}

class _DiceRollOverlayState extends State<DiceRollOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<int> _diceValues = [1, 1, 1];
  bool _isRolling = true;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1500),
        )..addListener(() {
          if (_isRolling) {
            setState(() {
              _diceValues[0] = _random.nextInt(6) + 1;
              _diceValues[1] = _random.nextInt(6) + 1;
              _diceValues[2] = _random.nextInt(6) + 1;
            });
          }
        });

    _controller.forward().then((_) {
      setState(() {
        _isRolling = false;
      });
      // Auto-dismiss after 2 seconds showing results
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) widget.onDismiss();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _diceValues.reduce((a, b) => a + b);

    return Material(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isRolling ? '骰子飞转中...' : '合计: $total',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDice(_diceValues[0]),
                const SizedBox(width: 20),
                _buildDice(_diceValues[1]),
                const SizedBox(width: 20),
                _buildDice(_diceValues[2]),
              ],
            ),
            const SizedBox(height: 60),
            if (!_isRolling)
              Text(
                '即将返回游戏...',
                style: GoogleFonts.outfit(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDice(int value) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _controller.value * 10 * pi;
        return Transform.rotate(
          angle: _isRolling ? angle : 0,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: _isRolling
                  ? const Icon(Icons.casino, size: 50, color: Color(0xFF2E7D32))
                  : Text(
                      _getDiceChar(value),
                      style: TextStyle(
                        fontSize: 50,
                        color: value == 1 || value == 4
                            ? Colors.red
                            : Colors.black87,
                        fontFamily: 'serif',
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  String _getDiceChar(int value) {
    switch (value) {
      case 1:
        return '⚀';
      case 2:
        return '⚁';
      case 3:
        return '⚂';
      case 4:
        return '⚃';
      case 5:
        return '⚄';
      case 6:
        return '⚅';
      default:
        return '⚀';
    }
  }
}
