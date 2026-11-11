import 'package:flutter/material.dart';
import '../../state/keyboard_controller.dart';
import 'isomorphic_pad.dart';

/// 4x4 tactile isomorphic pad grid container.
/// Renders 16 square pads with generous 10dp spacing, centered layout, and zero-latency multi-touch.
class IsomorphicPadGrid extends StatelessWidget {
  final KeyboardController controller;

  const IsomorphicPadGrid({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final notes = controller.isomorphicNotes;

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Compute side length to keep pads perfectly square and centered
          final double side = constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth
              : constraints.maxHeight;

          const double padding = 12.0;
          const double spacing = 10.0;

          return SizedBox(
            width: side,
            height: side,
            child: Padding(
              padding: const EdgeInsets.all(padding),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                  childAspectRatio: 1.0,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return IsomorphicPad(
                    key: ValueKey('iso_pad_${note.midiNumber}_$index'),
                    note: note,
                    controller: controller,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

