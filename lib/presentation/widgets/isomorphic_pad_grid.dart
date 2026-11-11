import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../state/keyboard_controller.dart';
import 'isomorphic_pad.dart';

/// 4x5 candy jelly tray with "Level 1" top badge and 3D rounded pastel frame.
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
        const double trayPadding = 10.0;
        const double gutter = 9.0;

        final double trayWidth = totalWidth - (outerMarginH * 2);
        final double availableWidthForPads = trayWidth - (trayPadding * 2) - (gutter * 3);
        final double padSide = availableWidthForPads / 4;

        // Height for 5 rows of pads
        final double trayContentHeight = (padSide * 5) + (gutter * 4) + (trayPadding * 2);

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: outerMarginH),
            child: SizedBox(
              width: trayWidth,
              height: trayContentHeight + 14, // extra clearance for top badge
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  // 1. The Main Candy Tray Frame
                  Positioned(
                    top: 12,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(trayPadding),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6CAF5),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0xFFB8A4EA),
                          width: 4.0,
                        ),
                        boxShadow: const [
                          // 3D bottom bevel rim
                          BoxShadow(
                            color: Color(0xFF8F76CD),
                            offset: Offset(0, 6),
                            blurRadius: 0,
                          ),
                          // Soft drop shadow
                          BoxShadow(
                            color: Color(0x33000000),
                            offset: Offset(0, 8),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: gutter,
                          crossAxisSpacing: gutter,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return IsomorphicPad(
                            key: ValueKey('candy_pad_${note.midiNumber}_$index'),
                            note: note,
                            controller: controller,
                            index: index,
                          );
                        },
                      ),
                    ),
                  ),

                  // 2. "Level 1" Top Center Tab Badge
                  Positioned(
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFBA68C8),
                            Color(0xFF8E24AA),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE1BEE7),
                          width: 2.2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF6A1B9A),
                            offset: Offset(0, 3),
                            blurRadius: 0,
                          ),
                          BoxShadow(
                            color: Color(0x33000000),
                            offset: Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Text(
                        'Level ${controller.level}',
                        style: GoogleFonts.sniglet(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          shadows: const [
                            Shadow(
                              color: Color(0x66000000),
                              offset: Offset(0, 1.5),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
