import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/audio/sound_presets.dart';
import '../../state/keyboard_controller.dart';

/// 3D Glossy "Candy Crush" aesthetic top control deck.
class TopBar extends StatelessWidget {
  final KeyboardController controller;
  final bool isPortrait;

  const TopBar({
    super.key,
    required this.controller,
    this.isPortrait = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isPortrait) {
      return _buildPortraitDeck(context);
    }
    return _buildLandscapeBar(context);
  }

  // --- PORTRAIT CANDY CONTROL DECK ---
  Widget _buildPortraitDeck(BuildContext context) {
    final hasPressedNotes = controller.pressedMidiNotes.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Puffy Candy Title + Stats Capsules (Lives/Octave, Score/Chord, Settings/Mode)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Puffy Candy Brand Title
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        center: Alignment(-0.3, -0.4),
                        colors: [Color(0xFFFF80B5), Color(0xFFFF3385)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x66C2185B),
                          offset: Offset(0, 3.5),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.piano, size: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'SimpleKeys',
                    style: GoogleFonts.fredoka(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF6B21A8),
                      shadows: [
                        const Shadow(
                          color: Colors.white,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                        Shadow(
                          color: const Color(0xFFC084FC).withValues(alpha: 0.5),
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Mode Switcher (Puffy Candy Button)
              GestureDetector(
                onTap: controller.toggleKeyboardMode,
                child: Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: controller.keyboardMode == KeyboardMode.isomorphicGrid
                          ? const [Color(0xFFC084FC), Color(0xFF9333EA)]
                          : const [Color(0xFFE2E8F0), Color(0xFF94A3B8)],
                    ),
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: controller.keyboardMode == KeyboardMode.isomorphicGrid
                            ? const Color(0xFF6B21A8)
                            : const Color(0xFF64748B),
                        offset: const Offset(0, 3),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        controller.keyboardMode == KeyboardMode.isomorphicGrid
                            ? Icons.grid_view_rounded
                            : Icons.piano,
                        size: 15,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        controller.keyboardMode == KeyboardMode.isomorphicGrid ? '4x4' : 'Piano',
                        style: GoogleFonts.fredoka(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 2. Stats Row: "Octave" Capsule & "Chord/Score" Capsule (styled after Lives & Score)
          Row(
            children: [
              // Octave Stepper Capsule (Candy Blue)
              Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(21),
                  border: Border.all(color: const Color(0xFF93C5FD), width: 2.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x333B82F6),
                      offset: Offset(0, 3),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Minus button
                    GestureDetector(
                      onTap: controller.baseOctave > 2 ? controller.shiftOctaveDown : null,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
                          ),
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF1D4ED8),
                              offset: Offset(0, 2),
                              blurRadius: 0.5,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.remove, size: 16, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'OCTAVE',
                            style: GoogleFonts.fredoka(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF3B82F6),
                              letterSpacing: 0.4,
                            ),
                          ),
                          Text(
                            controller.octaveRangeLabel,
                            style: GoogleFonts.fredoka(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF1E3A8A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Plus button
                    GestureDetector(
                      onTap: controller.baseOctave < 5 ? controller.shiftOctaveUp : null,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
                          ),
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF1D4ED8),
                              offset: Offset(0, 2),
                              blurRadius: 0.5,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Active Chord Capsule (Candy Violet Score Box)
              Expanded(
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(21),
                    border: Border.all(
                      color: hasPressedNotes ? const Color(0xFFC084FC) : const Color(0xFFE2E8F0),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: hasPressedNotes
                            ? const Color(0x44A855F7)
                            : const Color(0x1F000000),
                        offset: const Offset(0, 3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Star Icon
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFDE047), Color(0xFFF59E0B)],
                          ),
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFFB45309),
                              offset: Offset(0, 2),
                              blurRadius: 0.5,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.star_rounded, size: 16, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hasPressedNotes ? 'PLAYING' : 'HARMONY',
                              style: GoogleFonts.fredoka(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF9333EA),
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              controller.activeChord,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.fredoka(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: hasPressedNotes
                                    ? const Color(0xFF581C87)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (controller.isMagicScale)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'MAGIC',
                            style: GoogleFonts.fredoka(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 3. 3D Candy Button Presets ("PLAY", "SONGS", "STORE" style buttons)
          Row(
            children: [
              _buildCandyPresetButton(
                type: SoundBankType.feltPiano,
                label: 'FELT PIANO',
                icon: Icons.piano,
                gradient: const [Color(0xFFFF9E7A), Color(0xFFFF5722)],
                shadowColor: const Color(0xFFBF360C),
              ),
              const SizedBox(width: 8),
              _buildCandyPresetButton(
                type: SoundBankType.musicBox,
                label: 'MUSIC BOX',
                icon: Icons.notifications_active,
                gradient: const [Color(0xFF80D8FF), Color(0xFF0091EA)],
                shadowColor: const Color(0xFF01579B),
              ),
              const SizedBox(width: 8),
              _buildCandyPresetButton(
                type: SoundBankType.dreamPad,
                label: 'DREAM PAD',
                icon: Icons.cloud,
                gradient: const [Color(0xFFE879F9), Color(0xFFA21CAF)],
                shadowColor: const Color(0xFF701A75),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 4. Action Chips (Magic Scale & Sustain in Puffy Candy Style)
          Row(
            children: [
              Expanded(
                child: _buildCandyActionPill(
                  title: 'MAGIC SCALE',
                  icon: Icons.auto_awesome,
                  isActive: controller.isMagicScale,
                  onTap: controller.toggleMagicScale,
                  gradient: const [Color(0xFFFFE082), Color(0xFFFFB300)],
                  shadowColor: const Color(0xFFB27B00),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCandyActionPill(
                  title: controller.isSustainEnabled ? 'SUSTAIN ON' : 'STACCATO',
                  icon: controller.isSustainEnabled ? Icons.waves : Icons.graphic_eq,
                  isActive: controller.isSustainEnabled,
                  onTap: controller.toggleSustain,
                  gradient: const [Color(0xFF69F0AE), Color(0xFF00C853)],
                  shadowColor: const Color(0xFF007E33),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 3D Glossy Candy Preset Button ---
  Widget _buildCandyPresetButton({
    required SoundBankType type,
    required String label,
    required IconData icon,
    required List<Color> gradient,
    required Color shadowColor,
  }) {
    final isSelected = controller.soundPreset == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setSoundPreset(type),
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isSelected
                  ? gradient
                  : [Colors.white, const Color(0xFFE2E8F0)],
            ),
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: Colors.white,
              width: 2.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected ? shadowColor : const Color(0xFF94A3B8),
                offset: const Offset(0, 3.5),
                blurRadius: 0.5,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                offset: const Offset(0, 5),
                blurRadius: 4,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Top gloss lens reflection
              Positioned(
                top: 2,
                left: 8,
                right: 8,
                height: 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: isSelected ? 0.7 : 0.4),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 15,
                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.fredoka(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          color: isSelected ? Colors.white : const Color(0xFF475569),
                          shadows: isSelected
                              ? [
                                  Shadow(
                                    color: shadowColor,
                                    offset: const Offset(0, 1.5),
                                    blurRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 3D Candy Action Pill ---
  Widget _buildCandyActionPill({
    required String title,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    required List<Color> gradient,
    required Color shadowColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isActive
                ? gradient
                : [Colors.white, const Color(0xFFF1F5F9)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white, width: 2.2),
          boxShadow: [
            BoxShadow(
              color: isActive ? shadowColor : const Color(0xFF94A3B8),
              offset: const Offset(0, 3.5),
              blurRadius: 0.5,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 5),
              blurRadius: 4,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Gloss sheen
            Positioned(
              top: 2,
              left: 10,
              right: 10,
              height: 10,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: isActive ? 0.7 : 0.4),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 15,
                    color: isActive ? Colors.white : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: GoogleFonts.fredoka(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w900,
                      color: isActive ? Colors.white : const Color(0xFF475569),
                      shadows: isActive
                          ? [
                              Shadow(
                                color: shadowColor,
                                offset: const Offset(0, 1.5),
                                blurRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- LANDSCAPE BAR ---
  Widget _buildLandscapeBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD8B4FE), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x338B5CF6),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'SimpleKeys',
            style: GoogleFonts.fredoka(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF6B21A8),
            ),
          ),
          const SizedBox(width: 12),
          // Mode switch
          IconButton.filledTonal(
            icon: Icon(
              controller.keyboardMode == KeyboardMode.isomorphicGrid
                  ? Icons.grid_view_rounded
                  : Icons.piano,
              size: 16,
            ),
            onPressed: controller.toggleKeyboardMode,
          ),
          const SizedBox(width: 8),
          // Octave
          Text(
            controller.octaveRangeLabel,
            style: GoogleFonts.fredoka(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF2563EB),
            ),
          ),
          const Spacer(),
          Text(
            controller.activeChord,
            style: GoogleFonts.fredoka(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF9333EA),
            ),
          ),
        ],
      ),
    );
  }
}
