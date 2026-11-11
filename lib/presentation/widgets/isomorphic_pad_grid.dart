import 'package:flutter/material.dart';
import '../../state/keyboard_controller.dart';
import 'isomorphic_pad.dart';

/// 4x4 tactile isomorphic pad grid container.
/// Dynamically fills the available screen area with zero dead space,
/// perfectly proportioned 3D pads, and zero-latency multi-touch.
class IsomorphicPadGrid extends StatelessWidget {
  final KeyboardController controller;

  const IsomorphicPadGrid({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final notes = controller.isomorphicNotes;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;
        final double totalHeight = constraints.maxHeight;

        if (totalWidth <= 0 || totalHeight <= 0) {
          return const SizedBox.shrink();
        }

        const double horizontalPadding = 14.0;
        const double verticalPadding = 8.0;
        const double spacing = 10.0;

        // Compute available space for the 4x4 grid
        final double netWidth = totalWidth - (horizontalPadding * 2) - (spacing * 3);
        final double netHeight = totalHeight - (verticalPadding * 2) - (spacing * 3);

        final double padWidth = netWidth / 4;
        final double padHeight = netHeight / 4;

        // Dynamic aspect ratio ensuring pads fill the vertical space without overflow
        final double childAspectRatio = (padWidth / padHeight).clamp(0.4, 2.0);

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              final rowIndex = index ~/ 4; // 0 = Row 4 (Top), 1 = Row 3, 2 = Row 2, 3 = Row 1 (Bottom)
              return IsomorphicPad(
                key: ValueKey('iso_pad_${note.midiNumber}_$index'),
                note: note,
                controller: controller,
                rowIndex: rowIndex,
              );
            },
          ),
        );
      },
    );
  }
}
