import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../state/keyboard_controller.dart';
import 'isomorphic_pad.dart';

/// 4x4 tactile isomorphic pad grid container encased in a glossy 3D "Candy Crush" game frame.
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

        const double outerMarginH = 14.0;
        const double outerMarginV = 6.0;

        // Tray inner dimensions
        final double trayWidth = totalWidth - (outerMarginH * 2);
        final double trayHeight = totalHeight - (outerMarginV * 2);

        const double trayPaddingH = 10.0;
        const double trayPaddingTop = 18.0;
        const double trayPaddingBottom = 10.0;
        const double spacing = 9.0;

        final double netWidth = trayWidth - (trayPaddingH * 2) - (spacing * 3);
        final double netHeight = trayHeight - trayPaddingTop - trayPaddingBottom - (spacing * 3);

        final double padWidth = netWidth / 4;
        final double padHeight = netHeight / 4;
        final double childAspectRatio = (padWidth / padHeight).clamp(0.4, 2.0);

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: outerMarginH,
            vertical: outerMarginV,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. 3D Pastel Lilac Candy Tray / Game Board Frame
              Container(
                width: trayWidth,
                height: trayHeight,
                padding: const EdgeInsets.fromLTRB(
                  trayPaddingH,
                  trayPaddingTop,
                  trayPaddingH,
                  trayPaddingBottom,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: const Color(0xFFD8B4FE),
                    width: 4.5,
                  ),
                  boxShadow: [
                    // Chunky 3D tray bottom shadow
                    BoxShadow(
                      color: const Color(0xFF9333EA).withValues(alpha: 0.25),
                      offset: const Offset(0, 7),
                      blurRadius: 14,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(0, -2),
                      blurRadius: 4,
                    ),
                  ],
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
                    final rowIndex = index ~/ 4; // 0 = Row 4 (Top Pink), 1 = Blue, 2 = Mint, 3 = Mango
                    return IsomorphicPad(
                      key: ValueKey('candy_pad_${note.midiNumber}_$index'),
                      note: note,
                      controller: controller,
                      rowIndex: rowIndex,
                    );
                  },
                ),
              ),

              // 2. Cute Header Pill Badge (Matching the "Level 1" banner)
              Positioned(
                top: -11,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFA855F7), Color(0xFF7E22CE)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7E22CE).withValues(alpha: 0.4),
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.music_note_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'CANDY PADS 4x4',
                          style: GoogleFonts.fredoka(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
