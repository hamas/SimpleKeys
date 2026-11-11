import 'package:flutter/material.dart';
import '../../models/key_note.dart';
import '../../state/keyboard_controller.dart';
import 'black_key.dart';
import 'white_key.dart';

/// Container that renders piano keys and handles low-latency multi-touch pointer events
/// with zero-allocation geometry caching and dynamic velocity estimation.
class PianoKeyboard extends StatelessWidget {
  final KeyboardController controller;

  const PianoKeyboard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final layout = controller.layout;
    final whiteNotes = layout.whiteNotes;
    final blackNotes = layout.blackNotes;
    final blackPrecedingMap = layout.blackToPrecedingWhiteIndex;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final totalHeight = constraints.maxHeight;

        if (totalWidth <= 0 || totalHeight <= 0 || whiteNotes.isEmpty) {
          return const SizedBox.shrink();
        }

        final whiteKeyWidth = totalWidth / whiteNotes.length;
        final blackKeyWidth = whiteKeyWidth * 0.62;
        final blackKeyHeight = totalHeight * 0.60;

        // Calculate dynamic velocity from touch coordinate and pressure
        double resolveVelocity(double localY, double pressure) {
          final normalizedY = (localY / totalHeight).clamp(0.0, 1.0);
          final positionFactor = 0.65 + (normalizedY * 0.35);
          final pressureFactor = (pressure > 0.0 && pressure <= 1.0) ? pressure : 1.0;
          return (positionFactor * pressureFactor).clamp(0.5, 1.0);
        }

        // Resolves coordinate (x, y) with zero allocations
        KeyNote? hitTestKey(Offset pos) {
          final x = pos.dx;
          final y = pos.dy;

          if (x < 0 || x > totalWidth || y < 0 || y > totalHeight) {
            return null;
          }

          // 1. Black key hit test (top 60% of keyboard)
          if (y <= blackKeyHeight) {
            for (int i = 0; i < blackNotes.length; i++) {
              final black = blackNotes[i];
              final prevWhiteIdx = blackPrecedingMap[black];
              if (prevWhiteIdx != null) {
                final center = (prevWhiteIdx + 1) * whiteKeyWidth;
                final left = center - (blackKeyWidth / 2);
                if (x >= left && x <= left + blackKeyWidth) {
                  return black;
                }
              }
            }
          }

          // 2. White key hit test
          final whiteIdx = (x / whiteKeyWidth).floor().clamp(0, whiteNotes.length - 1);
          return whiteNotes[whiteIdx];
        }

        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (event) {
            final hitKey = hitTestKey(event.localPosition);
            if (hitKey != null) {
              final velocity = resolveVelocity(event.localPosition.dy, event.pressure);
              controller.handlePointerDown(event.pointer, hitKey, velocity: velocity);
            }
          },
          onPointerMove: (event) {
            final hitKey = hitTestKey(event.localPosition);
            final velocity = resolveVelocity(event.localPosition.dy, event.pressure);
            controller.handlePointerMove(event.pointer, hitKey, velocity: velocity);
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
              // White Keys Layer
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: whiteNotes.map((note) {
                  final isPressed = controller.pressedMidiNotes.contains(note.midiNumber);
                  final isPlayable = controller.isNotePlayable(note);

                  return Expanded(
                    child: WhiteKey(
                      note: note,
                      isPressed: isPressed,
                      isPlayable: isPlayable,
                    ),
                  );
                }).toList(),
              ),

              // Black Keys Layer (Overlay with precise absolute bounds)
              ...blackNotes.map((note) {
                final prevWhiteIdx = blackPrecedingMap[note];
                if (prevWhiteIdx == null) return const SizedBox.shrink();

                final center = (prevWhiteIdx + 1) * whiteKeyWidth;
                final left = center - (blackKeyWidth / 2);
                final isPressed = controller.pressedMidiNotes.contains(note.midiNumber);
                final isPlayable = controller.isNotePlayable(note);

                return Positioned(
                  left: left,
                  top: 0,
                  width: blackKeyWidth,
                  height: blackKeyHeight,
                  child: IgnorePointer(
                    child: BlackKey(
                      note: note,
                      isPressed: isPressed,
                      isPlayable: isPlayable,
                    ),
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
