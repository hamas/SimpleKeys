import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/key_note.dart';
import '../../state/keyboard_controller.dart';

/// Candy Crush 3D glossy color theme tokens.
class CandyColorTheme {
  final Color primary;
  final Color highlight;
  final Color deepShadow;
  final Color specular;
  final Color textShadow;

  const CandyColorTheme({
    required this.primary,
    required this.highlight,
    required this.deepShadow,
    required this.specular,
    required this.textShadow,
  });

  /// Row 4 (Top): Bubblegum Pink (#FF3385)
  static const bubblegumPink = CandyColorTheme(
    primary: Color(0xFFFF3385),
    highlight: Color(0xFFFF80B5),
    deepShadow: Color(0xFFC2185B),
    specular: Color(0xFFFFE4EF),
    textShadow: Color(0xFF880E4F),
  );

  /// Row 3: Jelly Blue (#00B0FF)
  static const jellyBlue = CandyColorTheme(
    primary: Color(0xFF00B0FF),
    highlight: Color(0xFF80D8FF),
    deepShadow: Color(0xFF0077C2),
    specular: Color(0xFFE1F5FE),
    textShadow: Color(0xFF01579B),
  );

  /// Row 2: Bright Mint (#00E676)
  static const brightMint = CandyColorTheme(
    primary: Color(0xFF00E676),
    highlight: Color(0xFF69F0AE),
    deepShadow: Color(0xFF009624),
    specular: Color(0xFFE8F5E9),
    textShadow: Color(0xFF1B5E20),
  );

  /// Row 1 (Bottom): Mango Yellow (#FFC700)
  static const mangoYellow = CandyColorTheme(
    primary: Color(0xFFFFC700),
    highlight: Color(0xFFFFE082),
    deepShadow: Color(0xFFD98E00),
    specular: Color(0xFFFFF9C4),
    textShadow: Color(0xFFB45309),
  );

  /// Royal Golden Sugar Anchor (All 'C' Root notes: C3, C4, C5)
  static const goldenAnchor = CandyColorTheme(
    primary: Color(0xFFFFB300),
    highlight: Color(0xFFFFE57F),
    deepShadow: Color(0xFFB27B00),
    specular: Color(0xFFFFFDE7),
    textShadow: Color(0xFF92400E),
  );

  /// Dimmed Inactive State (Magic Scale non-pentatonic filter)
  static const dimmed = CandyColorTheme(
    primary: Color(0xFFD1D5DB),
    highlight: Color(0xFFE5E7EB),
    deepShadow: Color(0xFF9CA3AF),
    specular: Color(0xFFF3F4F6),
    textShadow: Color(0xFF6B7280),
  );
}

/// 3D, glossy, tactile "Candy Crush" isomorphic pad with squish physics,
/// radial pillowy gradient, curved specular highlights, and debossed musical engraving.
class IsomorphicPad extends StatelessWidget {
  final KeyNote note;
  final KeyboardController controller;
  final int rowIndex;

  const IsomorphicPad({
    super.key,
    required this.note,
    required this.controller,
    this.rowIndex = 0,
  });

  bool get isRoot => note.name == 'C';

  CandyColorTheme _resolveTheme(bool isPlayable) {
    if (!isPlayable) return CandyColorTheme.dimmed;
    if (isRoot) return CandyColorTheme.goldenAnchor;

    switch (rowIndex) {
      case 0:
        return CandyColorTheme.bubblegumPink;
      case 1:
        return CandyColorTheme.jellyBlue;
      case 2:
        return CandyColorTheme.brightMint;
      case 3:
      default:
        return CandyColorTheme.mangoYellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPressed = controller.pressedMidiNotes.contains(note.midiNumber);
    final isPlayable = controller.isNotePlayable(note);
    final theme = _resolveTheme(isPlayable);
    final bool isDimmed = !isPlayable;

    // Physical 3D squish offsets (5dp downward translation on press)
    final double topOffset = isPressed ? 5.0 : 0.0;
    final double bottomMargin = isPressed ? 2.0 : 7.0;

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        if (!isDimmed) {
          controller.handlePointerDown(event.pointer, note, velocity: 1.0);
        }
      },
      onPointerUp: (event) {
        controller.handlePointerUp(event.pointer);
      },
      onPointerCancel: (event) {
        controller.handlePointerUp(event.pointer);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeOutQuad,
        margin: EdgeInsets.only(top: topOffset, bottom: 7.0 - topOffset),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // Chunky, raised plastic/jelly 3D bottom shadow
          boxShadow: [
            // Solid candy base extrusion
            BoxShadow(
              color: isDimmed ? Colors.black26 : theme.deepShadow,
              offset: Offset(0, bottomMargin),
              blurRadius: isPressed ? 1.5 : 0.0,
            ),
            // Ambient soft table drop shadow
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              offset: Offset(0, bottomMargin + 3),
              blurRadius: isPressed ? 4.0 : 8.0,
            ),
            // Pressed radiant neon splash glow
            if (isPressed && !isDimmed)
              BoxShadow(
                color: theme.primary.withValues(alpha: 0.75),
                blurRadius: 18.0,
                spreadRadius: 2.0,
                offset: const Offset(0, 2),
              ),
          ],
          // Pillowy 3D radial gradient (lighter highlight in the upper center, richer tone toward edges)
          gradient: RadialGradient(
            center: const Alignment(-0.25, -0.45),
            radius: 0.95,
            colors: isPressed
                ? [
                    Color.lerp(theme.highlight, Colors.white, 0.45)!,
                    theme.primary,
                  ]
                : [
                    theme.highlight,
                    theme.primary,
                  ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: isPressed ? 0.85 : 0.45),
            width: 1.6,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Top glossy specular lens highlight (curved glassy reflection)
              Positioned(
                top: 4,
                left: 10,
                right: 10,
                height: 16,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: isPressed ? 0.8 : 0.65),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Secondary soft side sheen (creates 3D pillowy roundness)
              Positioned(
                top: 8,
                left: 6,
                width: 12,
                bottom: 14,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.28),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Debossed musical note watermark in background
              Positioned(
                bottom: 8,
                right: 8,
                child: Icon(
                  Icons.music_note_rounded,
                  size: 26,
                  color: isDimmed
                      ? Colors.transparent
                      : theme.textShadow.withValues(alpha: 0.25),
                ),
              ),

              // 4. Root Note Anchor Sparkle Star Badge
              if (isRoot && !isDimmed)
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 3,
                          offset: const Offset(0, 1.5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 11,
                          color: Color(0xFFD97706),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'ROOT',
                          style: GoogleFonts.fredoka(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFB45309),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // 5. Chunky, friendly rounded typography with soft 3D drop shadow
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      note.label,
                      style: GoogleFonts.fredoka(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: isDimmed
                            ? const Color(0xFF6B7280)
                            : Colors.white,
                        shadows: [
                          if (!isDimmed) ...[
                            Shadow(
                              color: theme.textShadow,
                              offset: const Offset(0, 2.5),
                              blurRadius: 1.0,
                            ),
                            Shadow(
                              color: theme.textShadow.withValues(alpha: 0.8),
                              offset: const Offset(0, 1.2),
                              blurRadius: 0.5,
                            ),
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.35),
                              offset: const Offset(0, 4.0),
                              blurRadius: 3.0,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Small candy frequency capsule
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: isDimmed
                            ? Colors.black.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${note.frequency.toStringAsFixed(0)} Hz',
                        style: GoogleFonts.fredoka(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: isDimmed
                              ? const Color(0xFF6B7280)
                              : Colors.white,
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
}
