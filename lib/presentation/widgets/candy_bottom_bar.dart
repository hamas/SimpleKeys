import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/audio/sound_presets.dart';
import '../../core/lessons/tutorial_lessons.dart';
import '../../state/keyboard_controller.dart';

/// 3D tactile pill buttons matching the mockup: "PLAY", "SONGS", "STORE".
class CandyBottomBar extends StatelessWidget {
  final KeyboardController controller;

  const CandyBottomBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. PLAY button (Coral Pink)
          Expanded(
            child: _CandyPillButton(
              label: 'PLAY',
              topColor: const Color(0xFFFF6987),
              bottomColor: const Color(0xFFFF3366),
              bevelColor: const Color(0xFFC2185B),
              isActive: controller.appMode == AppMode.play,
              onTap: () {
                controller.setAppMode(AppMode.play);
              },
            ),
          ),
          const SizedBox(width: 12),

          // 2. SONGS button (Cyan Blue)
          Expanded(
            child: _CandyPillButton(
              label: 'SONGS',
              topColor: const Color(0xFF38D3FF),
              bottomColor: const Color(0xFF00A2F3),
              bevelColor: const Color(0xFF006CB7),
              isActive: controller.appMode == AppMode.teach,
              onTap: () {
                _showSongsDialog(context);
              },
            ),
          ),
          const SizedBox(width: 12),

          // 3. STORE button (Purple Magenta)
          Expanded(
            child: _CandyPillButton(
              label: 'STORE',
              topColor: const Color(0xFFCE93D8),
              bottomColor: const Color(0xFFAB47BC),
              bevelColor: const Color(0xFF7B1FA2),
              isActive: false,
              onTap: () {
                _showStoreDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSongsDialog(BuildContext context) {
    controller.setAppMode(AppMode.teach);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF7FF),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFF81D4FA), width: 3),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF0288D1),
                offset: Offset(0, 6),
                blurRadius: 0,
              ),
              BoxShadow(
                color: Color(0x33000000),
                offset: Offset(0, 8),
                blurRadius: 16,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '🎵 Select Song to Learn',
                style: GoogleFonts.fredoka(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0277BD),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Follow the golden sparkling pads on the board!',
                style: GoogleFonts.fredoka(
                  fontSize: 13,
                  color: const Color(0xFF546E7A),
                ),
              ),
              const Divider(color: Color(0xFFB3E5FC), height: 24),
              ...TutorialSong.sampleSongs.map((song) {
                final isSelected = controller.currentLesson.title == song.title;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF0288D1) : const Color(0xFFE1F5FE),
                        width: 2,
                      ),
                    ),
                    tileColor: isSelected ? const Color(0xFFE1F5FE) : Colors.white,
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF4FC3F7),
                      child: Icon(Icons.music_note, color: Colors.white),
                    ),
                    title: Text(
                      song.title,
                      style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF01579B),
                      ),
                    ),
                    subtitle: Text(
                      '${song.subtitle} • ${song.steps.length} notes',
                      style: GoogleFonts.fredoka(fontSize: 12),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Color(0xFF0288D1))
                        : null,
                    onTap: () {
                      controller.setLesson(song);
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showStoreDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF7FF),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFBA68C8), width: 3),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF7B1FA2),
                offset: Offset(0, 6),
                blurRadius: 0,
              ),
              BoxShadow(
                color: Color(0x33000000),
                offset: Offset(0, 8),
                blurRadius: 16,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '✨ Sound Store & Instruments',
                style: GoogleFonts.fredoka(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6A1B9A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Unlock and play different sound banks in real-time!',
                style: GoogleFonts.fredoka(
                  fontSize: 13,
                  color: const Color(0xFF546E7A),
                ),
              ),
              const Divider(color: Color(0xFFE1BEE7), height: 24),
              ...SoundBankType.values.map((preset) {
                final isSelected = controller.soundPreset == preset;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF8E24AA) : const Color(0xFFF3E5F5),
                        width: 2,
                      ),
                    ),
                    tileColor: isSelected ? const Color(0xFFF3E5F5) : Colors.white,
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFAB47BC),
                      child: Text(
                        preset == SoundBankType.feltPiano
                            ? '🎹'
                            : preset == SoundBankType.musicBox
                                ? '🔔'
                                : '✨',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    title: Text(
                      preset.title,
                      style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4A148C),
                      ),
                    ),
                    subtitle: Text(
                      preset.description,
                      style: GoogleFonts.fredoka(fontSize: 12),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Color(0xFF8E24AA))
                        : null,
                    onTap: () {
                      controller.setSoundPreset(preset);
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _CandyPillButton extends StatefulWidget {
  final String label;
  final Color topColor;
  final Color bottomColor;
  final Color bevelColor;
  final bool isActive;
  final VoidCallback onTap;

  const _CandyPillButton({
    required this.label,
    required this.topColor,
    required this.bottomColor,
    required this.bevelColor,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_CandyPillButton> createState() => _CandyPillButtonState();
}

class _CandyPillButtonState extends State<_CandyPillButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double rimDepth = _isPressed ? 1.5 : 5.0;

    return Listener(
      onPointerDown: (_) {
        setState(() => _isPressed = true);
        HapticFeedback.lightImpact();
      },
      onPointerUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onPointerCancel: (_) {
        setState(() => _isPressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeOutQuad,
        height: 52,
        transform: Matrix4.translationValues(0, _isPressed ? 3.5 : 0.0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: Colors.white,
            width: 2.2,
          ),
          boxShadow: [
            // Solid 3D bottom bevel
            BoxShadow(
              color: widget.bevelColor,
              offset: Offset(0, rimDepth),
              blurRadius: 0,
            ),
            // Soft ambient drop shadow
            BoxShadow(
              color: Colors.black.withValues(alpha: _isPressed ? 0.12 : 0.25),
              offset: Offset(0, rimDepth + 3),
              blurRadius: _isPressed ? 2.0 : 6.0,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widget.topColor,
              widget.bottomColor,
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              // Top glossy curved highlight
              Positioned(
                top: 2,
                left: 10,
                right: 10,
                height: 18,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.55),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // Button Label Text
              Center(
                child: Text(
                  widget.label,
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: widget.bevelColor.withValues(alpha: 0.8),
                        offset: const Offset(0, 1.8),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
