import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/player_provider.dart';

class PlayerSettingPage extends ConsumerStatefulWidget {
  final String playerId;
  const PlayerSettingPage({super.key, required this.playerId});

  @override
  ConsumerState<PlayerSettingPage> createState() => _PlayerSettingPageState();
}

class _PlayerSettingPageState extends ConsumerState<PlayerSettingPage> {
  late TextEditingController _nameController;
  late String _selectedIcon;
  late bool _isBanker;

  final List<String> _icons = [
    '👦🏻',
    '👧🏻',
    '👵🏻',
    '👴🏻',
    '🐱',
    '🐶',
    '🐯',
    '🐸',
    '🐵',
    '🐼',
    '🚗',
    '🐲',
  ];

  @override
  void initState() {
    super.initState();
    final player = ref
        .read(playersProvider)
        .firstWhere((p) => p.id == widget.playerId);
    _nameController = TextEditingController(text: player.name);
    _selectedIcon = player.icon;
    _isBanker = player.isBanker;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Player Setting',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Name Input
            Text(
              '昵称',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              onChanged: (value) {
                ref
                    .read(playersProvider.notifier)
                    .updatePlayer(widget.playerId, name: value);
              },
            ),

            const SizedBox(height: 40),

            // Banker Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '庄家',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Switch.adaptive(
                  value: _isBanker,
                  activeTrackColor: const Color(0xFFFFC107),
                  onChanged: (value) {
                    setState(() {
                      _isBanker = value;
                    });
                    if (value) {
                      ref
                          .read(playersProvider.notifier)
                          .setBanker(widget.playerId);
                    } else {
                      ref
                          .read(playersProvider.notifier)
                          .updatePlayer(widget.playerId, isBanker: false);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Icon Selection
            Text(
              'Icon',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
              itemCount: _icons.length,
              itemBuilder: (context, index) {
                final icon = _icons[index];
                final isSelected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                    ref
                        .read(playersProvider.notifier)
                        .updatePlayer(widget.playerId, icon: icon);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFF0F0F0)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: Colors.black, width: 2)
                          : Border.all(color: Colors.transparent),
                    ),
                    alignment: Alignment.center,
                    child: Text(icon, style: const TextStyle(fontSize: 24)),
                  ),
                );
              },
            ),
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
                'Save Changes',
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
}
