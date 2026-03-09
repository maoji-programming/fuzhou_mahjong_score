import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_rules_provider.dart';

class GameRulesPage extends ConsumerWidget {
  const GameRulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(gameRulesProvider);
    final notifier = ref.read(gameRulesProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '游戏规则',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('基础设置'),
            const SizedBox(height: 16),
            _buildSettingRow(
              '底分',
              '每局的基础分',
              TextFormField(
                initialValue: rules.basePoint.toString(),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '5',
                ),
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (val) {
                  final int? value = int.tryParse(val);
                  if (value != null) notifier.setBasePoint(value);
                },
              ),
            ),
            const Divider(height: 32),
            _buildSectionHeader('特殊胡牌设置'),
            const SizedBox(height: 8),
            Text(
              '不填写即代表不计该类胡牌',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            _buildPointInput(
              '平胡',
              rules.normalHandPoint,
              (val) => notifier.setNormalHandPoint(val),
            ),
            _buildPointInput(
              '自摸',
              rules.selfDrawnPoint,
              (val) => notifier.setSelfDrawnPoint(val),
            ),
            _buildPointInput(
              '金雀',
              rules.goldenBirdPoint,
              (val) => notifier.setGoldenBirdPoint(val),
            ),
            _buildPointInput(
              '三金倒',
              rules.threeGoldenFallPoint,
              (val) => notifier.setThreeGoldenFallPoint(val),
            ),
            _buildPointInput(
              '抢金',
              rules.robGoldPoint,
              (val) => notifier.setRobGoldPoint(val),
            ),
            _buildPointInput(
              '金龙',
              rules.goldenDragonPoint,
              (val) => notifier.setGoldenDragonPoint(val),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                '确认保存',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1A1C1E),
      ),
    );
  }

  Widget _buildSettingRow(String title, String subtitle, Widget trailing) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 100, child: trailing),
      ],
    );
  }

  Widget _buildPointInput(
    String label,
    int? value,
    Function(int?) onChanged, {
    bool enabled = true,
    String? subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: enabled ? const Color(0xFFF8F9FA) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: enabled ? Colors.transparent : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: enabled ? Colors.black : Colors.grey[500],
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Colors.red[300],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            child: TextFormField(
              initialValue: value?.toString() ?? '',
              enabled: enabled,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '未启用',
                hintStyle: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: enabled ? const Color(0xFF2E7D32) : Colors.grey[400],
              ),
              onChanged: (val) {
                final int? parsed = int.tryParse(val);
                onChanged(val.isEmpty ? null : parsed);
              },
            ),
          ),
        ],
      ),
    );
  }
}
