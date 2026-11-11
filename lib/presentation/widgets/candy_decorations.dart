import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom painter rendering a joyful candy-land background with floating candies,
/// stars, and musical notes.
class CandyBackgroundPainter extends CustomPainter {
  const CandyBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Soft pastel mint/aqua gradient background
    final rect = Offset.zero & size;
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFCEF6EC),
          Color(0xFFB8F0E2),
          Color(0xFFA5EAD9),
          Color(0xFFBCEEE1),
        ],
        stops: [0.0, 0.35, 0.75, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // 2. Scattered pastel floating candy treats, stars & notes
    _drawFloatingTreats(canvas, size);
  }

  void _drawFloatingTreats(Canvas canvas, Size size) {
    // Top-left wrapped candy (pink)
    _drawWrappedCandy(
      canvas,
      Offset(size.width * 0.08, size.height * 0.09),
      22,
      -0.25,
      const Color(0xFFFF99C8).withValues(alpha: 0.45),
    );

    // Top-right musical note (pink/coral)
    _drawMusicNote(
      canvas,
      Offset(size.width * 0.88, size.height * 0.04),
      24,
      0.35,
      const Color(0xFFFF85BD).withValues(alpha: 0.4),
    );

    // Top-left star (yellow)
    _drawStar(
      canvas,
      Offset(size.width * 0.16, size.height * 0.02),
      12,
      const Color(0xFFFFE082).withValues(alpha: 0.6),
    );

    // Left candy drop (lime)
    _drawJellyDrop(
      canvas,
      Offset(size.width * 0.04, size.height * 0.24),
      18,
      const Color(0xFFC5E1A5).withValues(alpha: 0.45),
    );

    // Right star (lavender/mint)
    _drawStar(
      canvas,
      Offset(size.width * 0.94, size.height * 0.24),
      15,
      const Color(0xFFD1C4E9).withValues(alpha: 0.5),
    );

    // Right lollipop / wrapped sweet
    _drawWrappedCandy(
      canvas,
      Offset(size.width * 0.96, size.height * 0.40),
      20,
      0.45,
      const Color(0xFFFFCC80).withValues(alpha: 0.4),
    );

    // Left note (blue/lavender)
    _drawMusicNote(
      canvas,
      Offset(size.width * 0.03, size.height * 0.42),
      22,
      -0.3,
      const Color(0xFF90CAF9).withValues(alpha: 0.4),
    );

    // Right star (pink)
    _drawStar(
      canvas,
      Offset(size.width * 0.97, size.height * 0.55),
      14,
      const Color(0xFFF48FB1).withValues(alpha: 0.4),
    );

    // Left candy sweet (pink/magenta)
    _drawWrappedCandy(
      canvas,
      Offset(size.width * 0.03, size.height * 0.63),
      18,
      0.3,
      const Color(0xFFCE93D8).withValues(alpha: 0.4),
    );

    // Bottom left candy (peach/orange)
    _drawWrappedCandy(
      canvas,
      Offset(size.width * 0.05, size.height * 0.88),
      20,
      -0.4,
      const Color(0xFFFFAB91).withValues(alpha: 0.45),
    );

    // Bottom right star (yellow)
    _drawStar(
      canvas,
      Offset(size.width * 0.95, size.height * 0.72),
      16,
      const Color(0xFFFFF59D).withValues(alpha: 0.55),
    );
  }

  void _drawWrappedCandy(
    Canvas canvas,
    Offset center,
    double radius,
    double angle,
    Color color,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Candy central oval
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: radius * 1.6, height: radius),
      paint,
    );

    // Left wrapper twist
    final leftPath = Path()
      ..moveTo(-radius * 0.7, 0)
      ..lineTo(-radius * 1.3, -radius * 0.45)
      ..lineTo(-radius * 1.3, radius * 0.45)
      ..close();
    canvas.drawPath(leftPath, paint);

    // Right wrapper twist
    final rightPath = Path()
      ..moveTo(radius * 0.7, 0)
      ..lineTo(radius * 1.3, -radius * 0.45)
      ..lineTo(radius * 1.3, radius * 0.45)
      ..close();
    canvas.drawPath(rightPath, paint);

    canvas.restore();
  }

  void _drawJellyDrop(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: size * 1.3, height: size),
      Radius.circular(size * 0.4),
    );
    canvas.drawRRect(rrect, paint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    const points = 5;
    for (int i = 0; i < points * 2; i++) {
      final r = (i % 2 == 0) ? radius : radius * 0.48;
      final a = (i * math.pi / points) - (math.pi / 2);
      final x = center.dx + r * math.cos(a);
      final y = center.dy + r * math.sin(a);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawMusicNote(
    Canvas canvas,
    Offset center,
    double size,
    double angle,
    Color color,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Note head
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-size * 0.25, size * 0.3),
        width: size * 0.5,
        height: size * 0.38,
      ),
      paint,
    );

    // Stem
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-size * 0.05, -size * 0.45, size * 0.12, size * 0.8),
        const Radius.circular(2),
      ),
      paint,
    );

    // Flag
    final flagPath = Path()
      ..moveTo(size * 0.07, -size * 0.45)
      ..quadraticBezierTo(
        size * 0.45,
        -size * 0.2,
        size * 0.35,
        -size * 0.05,
      )
      ..quadraticBezierTo(
        size * 0.2,
        -size * 0.15,
        size * 0.07,
        -size * 0.25,
      )
      ..close();
    canvas.drawPath(flagPath, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Joyful 3D "SimpleKeys" bubble title with rainbow gradient lettering,
/// thick white 3D bubble outline, soft drop shadow, and floating sparkles.
class SimpleKeysTitle extends StatelessWidget {
  const SimpleKeysTitle({super.key});

  static const _letterColors = [
    Color(0xFFFF3399), // S - Vibrant Pink
    Color(0xFFFF6D00), // i - Orange
    Color(0xFFFFC400), // m - Golden Yellow
    Color(0xFF76DD00), // p - Lime
    Color(0xFF00C4FF), // l - Cyan
    Color(0xFFE040FB), // e - Violet
    Color(0xFFAB47BC), // K - Purple
    Color(0xFFFF4081), // e - Rose Pink
    Color(0xFF00B0FF), // y - Sky Blue
    Color(0xFF7C4DFF), // s - Violet
  ];

  @override
  Widget build(BuildContext context) {
    const titleText = 'SimpleKeys';

    return SizedBox(
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Floating notes and sparkles around the title matching the mockup
          Positioned(
            left: 28,
            top: 2,
            child: Transform.rotate(
              angle: -0.2,
              child: const Icon(Icons.music_note_rounded, size: 24, color: Color(0xFFFF94C2)),
            ),
          ),
          const Positioned(
            left: 54,
            top: -4,
            child: Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFE082)),
          ),
          Positioned(
            right: 28,
            top: 4,
            child: Transform.rotate(
              angle: 0.25,
              child: const Icon(Icons.queue_music_rounded, size: 26, color: Color(0xFF81D4FA)),
            ),
          ),
          const Positioned(
            right: 64,
            top: 2,
            child: Icon(Icons.auto_awesome, size: 15, color: Color(0xFFCE93D8)),
          ),

          // 1. Thick white 3D bubble outline layer
          Text(
            titleText,
            style: GoogleFonts.sniglet(
              fontSize: 44,
              fontWeight: FontWeight.w800,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10.0
                ..strokeCap = StrokeCap.round
                ..strokeJoin = StrokeJoin.round
                ..color = Colors.white,
              shadows: const [
                Shadow(
                  color: Color(0x3B6A1B9A),
                  offset: Offset(0, 5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),

          // 2. Inner rainbow gradient letters layer
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(titleText.length, (i) {
              final letter = titleText[i];
              final color = _letterColors[i % _letterColors.length];
              return Text(
                letter,
                style: GoogleFonts.sniglet(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color: color,
                  shadows: [
                    Shadow(
                      color: color.withValues(alpha: 0.35),
                      offset: const Offset(0, 2),
                      blurRadius: 1,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
