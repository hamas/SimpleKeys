import 'package:flutter/material.dart';
import '../../models/key_note.dart';
import '../../state/keyboard_controller.dart';

/// Tactile isomorphic grid pad with 3D scale compression, zero-latency multi-touch,
/// and radiant warm glow lighting.
class IsomorphicPad extends StatelessWidget {
  final KeyNote note;
  final KeyboardController controller;

  const IsomorphicPad({
    super.key,
    required this.note,
    required this.controller,
  });

  bool get isRoot => note.name == 'C';

  @override
  Widget build(BuildContext context) {
    final isPressed = controller.pressedMidiNotes.contains(note.midiNumber);
    final isPlayable = controller.isNotePlayable(note);
    final bool dimmed = !isPlayable;

    // Palette tokens matching design spec
    const Color bgIdle = Color(0xFF1C1D22);
    const Color borderIdle = Color(0xFF2D2F38);
    const Color glowOrange = Color(0xFFFF8C42);
    const Color rootBorder = Color(0xAAFF8C42);

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        if (!dimmed) {
          controller.handlePointerDown(event.pointer, note, velocity: 1.0);
        }
      },
      onPointerUp: (event) {
        controller.handlePointerUp(event.pointer);
      },
      onPointerCancel: (event) {
        controller.handlePointerUp(event.pointer);
      },
      child: AnimatedScale(
        scale: isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeOutQuad,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 70),
          curve: Curves.easeOutQuad,
          decoration: BoxDecoration(
            color: dimmed
                ? const Color(0xFF131418)
                : isPressed
                    ? glowOrange
                    : isRoot
                        ? const Color(0xFF242226)
                        : bgIdle,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: dimmed
                  ? const Color(0xFF1E2026)
                  : isPressed
                      ? Colors.white
                      : isRoot
                          ? rootBorder
                          : borderIdle,
              width: (isPressed || isRoot) ? 1.5 : 1.0,
            ),
            boxShadow: [
              if (isPressed && !dimmed) ...[
                BoxShadow(
                  color: glowOrange.withValues(alpha: 0.65),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: glowOrange.withValues(alpha: 0.35),
                  blurRadius: 6,
                ),
              ] else if (isRoot && !dimmed) ...[
                BoxShadow(
                  color: glowOrange.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] else if (!dimmed) ...[
                const BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Root note anchor tag (for all 'C's)
              if (isRoot && !dimmed)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPressed ? Colors.white : glowOrange,
                      boxShadow: [
                        BoxShadow(
                          color: glowOrange.withValues(alpha: 0.6),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),

              // Centered Note Name with bold high-contrast typography
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      note.label,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: dimmed
                            ? const Color(0xFF4A4E5C)
                            : isPressed
                                ? const Color(0xFF141518)
                                : isRoot
                                    ? const Color(0xFFFFDDB8)
                                    : const Color(0xFFF8FAFC),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${note.frequency.toStringAsFixed(0)} Hz',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: dimmed
                            ? const Color(0xFF353842)
                            : isPressed
                                ? const Color(0xFF322010)
                                : const Color(0xFF717888),
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

