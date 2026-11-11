import 'package:flutter/material.dart';
import '../../models/key_note.dart';
import '../../state/keyboard_controller.dart';
import 'black_key.dart';
import 'white_key.dart';

/// Container that renders piano keys and handles low-latency multi-touch pointer events.
class PianoKeyboard extends StatelessWidget {
  final KeyboardController controller;

  const PianoKeyboard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final allNotes = controller.notes;
    final whiteNotes = allNotes.where((n) => !n.isAccidental).toList();
    final blackNotes = allNotes.where((n) => n.isAccidental).toList();

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

        // Map each black key to its preceding white key index
        final Map<KeyNote, double> blackKeyLeftPositions = {};
        for (final black in blackNotes) {
          final indexInAll = allNotes.indexOf(black);
          if (indexInAll > 0) {
            final prevNote = allNotes[indexInAll - 1];
            if (!prevNote.isAccidental && prevNote.whiteKeyIndex != null) {
              final centerBoundary = (prevNote.whiteKeyIndex! + 1) * whiteKeyWidth;
              blackKeyLeftPositions[black] = centerBoundary - (blackKeyWidth / 2);
            }
          }
        }

        // Resolves coordinate (x, y) to a specific KeyNote with black-key-first precedence
        KeyNote? hitTestKey(Offset pos) {
          final x = pos.dx;
          final y = pos.dy;

          if (x < 0 || x > totalWidth || y < 0 || y > totalHeight) {
            return null;
          }

          // 1. Black key hit test (top portion of keyboard)
          if (y <= blackKeyHeight) {
            for (final entry in blackKeyLeftPositions.entries) {
              final blackLeft = entry.value;
              if (x >= blackLeft && x <= blackLeft + blackKeyWidth) {
                return entry.key;
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
              controller.handlePointerDown(event.pointer, hitKey);
            }
          },
          onPointerMove: (event) {
            final hitKey = hitTestKey(event.localPosition);
            controller.handlePointerMove(event.pointer, hitKey);
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
                final left = blackKeyLeftPositions[note];
                if (left == null) return const SizedBox.shrink();

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
