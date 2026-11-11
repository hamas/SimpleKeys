import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/audio/sound_presets.dart';
import '../../state/keyboard_controller.dart';

/// Top game header row: Lives badge, Score badge, and Settings button.
class CandyHeader extends StatelessWidget {
  final KeyboardController controller;

  const CandyHeader({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Lives 5 pill container
          _buildStatPill(
            icon: Icons.favorite,
            iconColor: const Color(0xFFFF2E63),
            badgeGradient: const [Color(0xFF26E6B8), Color(0xFF00BFA5)],
            label: 'Lives',
            value: '${controller.lives}',
            pillWidth: 105,
          ),

          const SizedBox(width: 14),

          // 2. Score 02,840 pill container
          _buildStatPill(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFFFD600),
            badgeGradient: const [Color(0xFF26E6B8), Color(0xFF00BFA5)],
            label: 'Score',
            value: controller.formattedScore,
            pillWidth: 155,
          ),

          const SizedBox(width: 14),

          // 3. Settings gear button
          _buildSettingsButton(context),
        ],
      ),
    );
  }

  Widget _buildStatPill({
    required IconData icon,
    required Color iconColor,
    required List<Color> badgeGradient,
    required String label,
    required String value,
    required double pillWidth,
  }) {
    return Container(
      width: pillWidth,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF81D4FA),
          width: 3.0,
        ),
        boxShadow: const [
          // 3D bottom bevel
          BoxShadow(
            color: Color(0xFF0288D1),
            offset: Offset(0, 4),
            blurRadius: 0,
          ),
          // Soft ambient drop shadow
          BoxShadow(
            color: Color(0x26000000),
            offset: Offset(0, 5),
            blurRadius: 6,
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE1F5FE),
            Color(0xFFB3E5FC),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left round 3D icon badge
          Positioned(
            left: 3,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: badgeGradient,
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.8),
                  width: 2.0,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF00897B),
                    offset: Offset(0, 2),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 24,
                color: iconColor,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    offset: const Offset(0, 1.5),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // Label and Value text
          Positioned(
            left: 44,
            right: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.fredoka(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF546E7A),
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF263238),
                    height: 1.0,
                    shadows: [
                      Shadow(
                        color: Colors.white.withValues(alpha: 0.7),
                        offset: const Offset(0, 1),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showSettingsDialog(context);
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFCE93D8),
              Color(0xFFAB47BC),
            ],
          ),
          border: Border.all(
            color: const Color(0xFFE1BEE7),
            width: 2.5,
          ),
          boxShadow: const [
            // 3D bottom rim
            BoxShadow(
              color: Color(0xFF7B1FA2),
              offset: Offset(0, 4),
              blurRadius: 0,
            ),
            // Soft drop shadow
            BoxShadow(
              color: Color(0x33000000),
              offset: Offset(0, 5),
              blurRadius: 5,
            ),
          ],
        ),
        child: const Icon(
          Icons.settings_rounded,
          size: 26,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Color(0x664A148C),
              offset: Offset(0, 2),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7FF),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFB39DDB), width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF5E35B1),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '⚙️ Settings',
                        style: GoogleFonts.fredoka(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4A148C),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded, color: Color(0xFF7B1FA2)),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFFD1C4E9)),
                  const SizedBox(height: 8),

                  // Sound Preset
                  Text(
                    'Sound Instrument',
                    style: GoogleFonts.fredoka(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6A1B9A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: SoundBankType.values.map((preset) {
                      final isSelected = controller.soundPreset == preset;
                      return ChoiceChip(
                        label: Text(preset.title),
                        selected: isSelected,
                        selectedColor: const Color(0xFFAB47BC),
                        backgroundColor: const Color(0xFFEDE7F6),
                        labelStyle: GoogleFonts.fredoka(
                          color: isSelected ? Colors.white : const Color(0xFF4A148C),
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            controller.setSoundPreset(preset);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Notation & Sustain
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => controller.toggleNotation(),
                          icon: const Icon(Icons.translate_rounded, size: 18),
                          label: Text(
                            controller.notation == NoteNotation.scientific
                                ? 'ABC Pitch'
                                : 'Do-Re-Mi',
                            style: GoogleFonts.fredoka(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF4A148C),
                            side: const BorderSide(color: Color(0xFFAB47BC)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => controller.toggleSustain(),
                          icon: Icon(
                            controller.isSustainEnabled ? Icons.all_inclusive : Icons.music_off,
                            size: 18,
                          ),
                          label: Text(
                            controller.isSustainEnabled ? 'Sustain: ON' : 'Sustain: OFF',
                            style: GoogleFonts.fredoka(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF4A148C),
                            side: const BorderSide(color: Color(0xFFAB47BC)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
