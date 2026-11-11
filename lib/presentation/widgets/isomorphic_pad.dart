import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/key_note.dart';
import '../../state/keyboard_controller.dart';
import 'candy_pad_style.dart';

/// 3D tactile "Candy Jelly" pad matching the Candy Crush aesthetic.
/// Features a glossy pillowy shell, debossed musical notes (♪ and ♫),
/// physical 3D key travel, and low-latency audio FFI triggering.
class IsomorphicPad extends StatelessWidget {
  final KeyNote note;
  final KeyboardController controller;
  final int index;

  const IsomorphicPad({
    super.key,
    required this.note,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isPressed = controller.pressedMidiNotes.contains(note.midiNumber);
    final isPlayable = controller.isNotePlayable(note);
    final bool isDimmed = !isPlayable;
    final bool isTeachTarget = controller.isNoteTargetedInTeach(note);

    final padStyle = CandyPadLayout.getPadStyle(index);
    final palette = CandyPalette.fromColor(padStyle.$1);
    final iconType = padStyle.$2;

    // 3D physical compression
    final double rimDepth = isPressed ? 1.5 : 5.5;

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        if (!isDimmed) {
          HapticFeedback.lightImpact();
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
        duration: const Duration(milliseconds: 45),
        curve: Curves.easeOutQuad,
        transform: Matrix4.translationValues(0, isPressed ? 4.0 : 0.0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            // Solid 3D bottom bevel rim
            BoxShadow(
              color: isDimmed ? const Color(0xFF616161) : palette.bottomRim,
              offset: Offset(0, rimDepth),
              blurRadius: 0.0,
            ),
            // Soft ambient drop shadow under the block
            BoxShadow(
              color: Colors.black.withValues(alpha: isPressed ? 0.15 : 0.28),
              offset: Offset(0, rimDepth + 3),
              blurRadius: isPressed ? 2.0 : 6.0,
            ),
            // Teach mode golden sparkle focus glow
            if (isTeachTarget)
              const BoxShadow(
                color: Color(0xFFFFD54F),
                blurRadius: 14,
                spreadRadius: 3,
              ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDimmed
                ? [
                    const Color(0xFF9E9E9E),
                    const Color(0xFF616161),
                  ]
                : isPressed
                    ? [
                        palette.surfaceBottom,
                        palette.bottomRim,
                      ]
                    : [
                        palette.surfaceTop,
                        palette.surfaceBottom,
                      ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Glossy top curved reflection (Candy Pillow Highlight)
              Positioned(
                top: 2,
                left: 6,
                right: 6,
                height: 24,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: isPressed ? 0.2 : 0.55),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Debossed Musical Note (matching the mockup pure aesthetic)
              Center(
                child: CustomPaint(
                  size: const Size(44, 42),
                  painter: DebossedMusicNotePainter(
                    iconType: iconType,
                    shadowColor: palette.debossShadow,
                    highlightColor: palette.debossHighlight,
                    isPressed: isPressed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter rendering debossed musical notes (single ♪ or double ♫)
/// carved into the candy surface.
class DebossedMusicNotePainter extends CustomPainter {
  final NoteIconType iconType;
  final Color shadowColor;
  final Color highlightColor;
  final bool isPressed;

  DebossedMusicNotePainter({
    required this.iconType,
    required this.shadowColor,
    required this.highlightColor,
    required this.isPressed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final shadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.fill;

    final highlightPaint = Paint()
      ..color = highlightColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    if (iconType == NoteIconType.single) {
      _drawSingleNote(canvas, w, h, highlightPaint, const Offset(0, 1.2));
      _drawSingleNote(canvas, w, h, shadowPaint, Offset.zero);
    } else {
      _drawDoubleNote(canvas, w, h, highlightPaint, const Offset(0, 1.2));
      _drawDoubleNote(canvas, w, h, shadowPaint, Offset.zero);
    }
  }

  void _drawSingleNote(
    Canvas canvas,
    double w,
    double h,
    Paint paint,
    Offset offset,
  ) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    // Note head (oval angled at -25 degrees)
    final headCenter = Offset(w * 0.36, h * 0.72);
    canvas.save();
    canvas.translate(headCenter.dx, headCenter.dy);
    canvas.rotate(-22 * math.pi / 180);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: w * 0.42, height: h * 0.32),
      paint,
    );
    canvas.restore();

    // Stem
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.50, h * 0.16, w * 0.13, h * 0.60),
        const Radius.circular(2.5),
      ),
      paint,
    );

    // Flag
    final flagPath = Path()
      ..moveTo(w * 0.62, h * 0.16)
      ..cubicTo(
        w * 0.95,
        h * 0.28,
        w * 0.88,
        h * 0.52,
        w * 0.68,
        h * 0.60,
      )
      ..cubicTo(
        w * 0.76,
        h * 0.44,
        w * 0.78,
        h * 0.28,
        w * 0.62,
        h * 0.26,
      )
      ..close();
    canvas.drawPath(flagPath, paint);

    canvas.restore();
  }

  void _drawDoubleNote(
    Canvas canvas,
    double w,
    double h,
    Paint paint,
    Offset offset,
  ) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    // Left note head
    final leftCenter = Offset(w * 0.26, h * 0.74);
    canvas.save();
    canvas.translate(leftCenter.dx, leftCenter.dy);
    canvas.rotate(-22 * math.pi / 180);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: w * 0.36, height: h * 0.28),
      paint,
    );
    canvas.restore();

    // Right note head
    final rightCenter = Offset(w * 0.68, h * 0.64);
    canvas.save();
    canvas.translate(rightCenter.dx, rightCenter.dy);
    canvas.rotate(-22 * math.pi / 180);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: w * 0.36, height: h * 0.28),
      paint,
    );
    canvas.restore();

    // Left stem
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.37, h * 0.24, w * 0.11, h * 0.54),
        const Radius.circular(2),
      ),
      paint,
    );

    // Right stem
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.79, h * 0.14, w * 0.11, h * 0.54),
        const Radius.circular(2),
      ),
      paint,
    );

    // Top connecting beam
    final beamPath = Path()
      ..moveTo(w * 0.37, h * 0.32)
      ..lineTo(w * 0.90, h * 0.22)
      ..lineTo(w * 0.90, h * 0.12)
      ..lineTo(w * 0.37, h * 0.22)
      ..close();
    canvas.drawPath(beamPath, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DebossedMusicNotePainter oldDelegate) {
    return oldDelegate.iconType != iconType ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.highlightColor != highlightColor ||
        oldDelegate.isPressed != isPressed;
  }
}
