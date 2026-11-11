import 'package:flutter/material.dart';
import '../../models/key_note.dart';
import '../../state/keyboard_controller.dart';

/// 3D tactile color theme token set for Material 3 Expressive pads.
class PadColorTheme {
  final Color primary;
  final Color surfaceTop;
  final Color surfaceBottom;
  final Color bevelBorder;
  final Color bottomEdgeShadow;
  final Color glow;
  final Color textColor;
  final Color subtextColor;

  const PadColorTheme({
    required this.primary,
    required this.surfaceTop,
    required this.surfaceBottom,
    required this.bevelBorder,
    required this.bottomEdgeShadow,
    required this.glow,
    required this.textColor,
    required this.subtextColor,
  });

  /// Vibrant Cyber Violet / Purple (Row 4: High register A4 - D5)
  static const violet = PadColorTheme(
    primary: Color(0xFF8B5CF6),
    surfaceTop: Color(0xFF8B5CF6),
    surfaceBottom: Color(0xFF6D28D9),
    bevelBorder: Color(0xFFC4B5FD),
    bottomEdgeShadow: Color(0xFF4C1D95),
    glow: Color(0xFFC084FC),
    textColor: Colors.white,
    subtextColor: Color(0xFFDDD6FE),
  );

  /// Electric Azure / Cobalt Blue (Row 3: Upper-mid D4 - G4)
  static const blue = PadColorTheme(
    primary: Color(0xFF3B82F6),
    surfaceTop: Color(0xFF3B82F6),
    surfaceBottom: Color(0xFF1D4ED8),
    bevelBorder: Color(0xFF93C5FD),
    bottomEdgeShadow: Color(0xFF1E3A8A),
    glow: Color(0xFF60A5FA),
    textColor: Colors.white,
    subtextColor: Color(0xFFDBEAFE),
  );

  /// Luminous Neon Mint / Emerald (Row 2: Lower-mid G3 - C4)
  static const mint = PadColorTheme(
    primary: Color(0xFF10B981),
    surfaceTop: Color(0xFF10B981),
    surfaceBottom: Color(0xFF047857),
    bevelBorder: Color(0xFF6EE7B7),
    bottomEdgeShadow: Color(0xFF064E3B),
    glow: Color(0xFF34D399),
    textColor: Colors.white,
    subtextColor: Color(0xFFD1FAE5),
  );

  /// Radiant Sunset Coral / Flame Orange (Row 1: Bass C3 - F3)
  static const coral = PadColorTheme(
    primary: Color(0xFFF97316),
    surfaceTop: Color(0xFFF97316),
    surfaceBottom: Color(0xFFC2410C),
    bevelBorder: Color(0xFFFDBA74),
    bottomEdgeShadow: Color(0xFF7C2D12),
    glow: Color(0xFFFB923C),
    textColor: Colors.white,
    subtextColor: Color(0xFFFFEDD5),
  );

  /// Royal Golden Amber Anchor (Root Notes: C3, C4, C5)
  static const goldenAnchor = PadColorTheme(
    primary: Color(0xFFF59E0B),
    surfaceTop: Color(0xFFFBBF24),
    surfaceBottom: Color(0xFFD97706),
    bevelBorder: Color(0xFFFEF08A),
    bottomEdgeShadow: Color(0xFF78350F),
    glow: Color(0xFFFDE047),
    textColor: Colors.white,
    subtextColor: Color(0xFFFEF3C7),
  );

  /// Dimmed Inactive State (Magic Scale non-pentatonic filter)
  static const dimmed = PadColorTheme(
    primary: Color(0xFF262A36),
    surfaceTop: Color(0xFF232733),
    surfaceBottom: Color(0xFF181B24),
    bevelBorder: Color(0xFF2F3444),
    bottomEdgeShadow: Color(0xFF101218),
    glow: Colors.transparent,
    textColor: Color(0xFF5A6175),
    subtextColor: Color(0xFF424757),
  );
}

/// Ultra-tactile 3D Isomorphic Pad with Material 3 Expressive vibrant colors,
/// mechanical key travel displacement, specular gloss bevels, and glowing neon LED aura.
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

  PadColorTheme _resolveTheme(bool isPlayable) {
    if (!isPlayable) return PadColorTheme.dimmed;
    if (isRoot) return PadColorTheme.goldenAnchor;

    switch (rowIndex) {
      case 0:
        return PadColorTheme.violet;
      case 1:
        return PadColorTheme.blue;
      case 2:
        return PadColorTheme.mint;
      case 3:
      default:
        return PadColorTheme.coral;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPressed = controller.pressedMidiNotes.contains(note.midiNumber);
    final isPlayable = controller.isNotePlayable(note);
    final theme = _resolveTheme(isPlayable);
    final bool isDimmed = !isPlayable;

    const double bevelDepth = 4.5; // 3D mechanical travel depth

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
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Bottom 3D Chassis / Bevel Extrusion Layer (the extruded base of the button)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: theme.bottomEdgeShadow,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  // Ambient floor drop shadow
                  BoxShadow(
                    color: isPressed || isDimmed
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.55),
                    blurRadius: isPressed ? 3 : 8,
                    offset: Offset(0, isPressed ? 1.5 : 5.5),
                  ),
                  // Radiant neon LED underside glow
                  if (isPressed && !isDimmed) ...[
                    BoxShadow(
                      color: theme.glow.withValues(alpha: 0.9),
                      blurRadius: 22,
                      spreadRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.45),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // 2. Floating Top Cap (Physically shifts down by bevelDepth on press)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 40),
            curve: Curves.easeOutQuad,
            top: isPressed ? bevelDepth : 0.0,
            left: 0.0,
            right: 0.0,
            bottom: isPressed ? 0.0 : bevelDepth,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isPressed
                      ? [
                          Color.lerp(theme.surfaceTop, Colors.white, 0.45)!,
                          theme.surfaceTop,
                        ]
                      : [
                          theme.surfaceTop,
                          theme.surfaceBottom,
                        ],
                ),
                border: Border.all(
                  color: isPressed
                      ? Colors.white.withValues(alpha: 0.95)
                      : isDimmed
                          ? theme.bevelBorder
                          : isRoot
                              ? Colors.white.withValues(alpha: 0.9)
                              : theme.bevelBorder.withValues(alpha: 0.8),
                  width: (isPressed || isRoot) ? 2.0 : 1.4,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Top specular gloss reflection sheen
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 24,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: isPressed ? 0.5 : (isDimmed ? 0.08 : 0.3)),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Root Note Anchor Badge (Top right)
                  if (isRoot && !isDimmed)
                    Positioned(
                      top: 7,
                      right: 7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: isPressed ? Colors.white : Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isPressed ? Colors.black26 : Colors.white.withValues(alpha: 0.6),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 11,
                              color: isPressed ? const Color(0xFFD97706) : const Color(0xFFFDE047),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'ROOT',
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.4,
                                color: isPressed ? const Color(0xFF92400E) : const Color(0xFFFEF3C7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Centered Note Name & Frequency pill
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          note.label,
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: isDimmed
                                ? theme.textColor
                                : isPressed
                                    ? Colors.black87
                                    : theme.textColor,
                            shadows: [
                              if (!isDimmed && !isPressed)
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  offset: const Offset(0, 1.5),
                                  blurRadius: 3,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: isPressed
                                ? Colors.black.withValues(alpha: 0.15)
                                : Colors.black.withValues(alpha: 0.28),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${note.frequency.toStringAsFixed(0)} Hz',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: isDimmed
                                  ? theme.subtextColor
                                  : isPressed
                                      ? Colors.black54
                                      : theme.subtextColor,
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
        ],
      ),
    );
  }
}
