import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../state/keyboard_controller.dart';
import '../widgets/isomorphic_pad_grid.dart';
import '../widgets/piano_keyboard.dart';
import '../widgets/top_bar.dart';

/// Candy Crush 3D responsive screen with soft pastel background and floating candy confetti.
class PianoScreen extends StatefulWidget {
  const PianoScreen({super.key});

  @override
  State<PianoScreen> createState() => _PianoScreenState();
}

class _PianoScreenState extends State<PianoScreen> {
  late final KeyboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = KeyboardController();
    _controller.initializeAudio();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Soft pastel gradient background: lavender/soft lilac to light sky blue/mint
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEDE9FE), // Soft Pastel Lilac / Lavender
              Color(0xFFF3E8FF), // Pastel Rose / Violet
              Color(0xFFE0F2FE), // Soft Sky Blue
              Color(0xFFD1FAE5), // Soft Pastel Mint
            ],
            stops: [0.0, 0.35, 0.75, 1.0],
          ),
        ),
        child: CustomPaint(
          painter: const CandyConfettiPainter(),
          child: SafeArea(
            top: true,
            bottom: true,
            child: OrientationBuilder(
              builder: (context, orientation) {
                final isPortrait = orientation == Orientation.portrait;

                return ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) {
                    final isIsoMode = _controller.keyboardMode == KeyboardMode.isomorphicGrid;

                    if (isPortrait) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 3D Candy Top Control Deck
                          TopBar(controller: _controller, isPortrait: true),

                          if (isIsoMode)
                            // 4x4 Candy Pad Grid encased in 3D frame
                            Expanded(
                              child: IsomorphicPadGrid(controller: _controller),
                            )
                          else ...[
                            const Spacer(),
                            Container(
                              height: 250,
                              margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: PianoKeyboard(controller: _controller),
                            ),
                          ],
                        ],
                      );
                    }

                    // Landscape Layout
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TopBar(controller: _controller, isPortrait: false),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: isIsoMode
                                ? IsomorphicPadGrid(controller: _controller)
                                : Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: PianoKeyboard(controller: _controller),
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter rendering subtle, dreamy pastel candies, stars, and musical notes in the background.
class CandyConfettiPainter extends CustomPainter {
  const CandyConfettiPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final candyPaintPink = Paint()
      ..color = const Color(0xFFF472B6).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;

    final candyPaintBlue = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.16)
      ..style = PaintingStyle.fill;

    final candyPaintYellow = Paint()
      ..color = const Color(0xFFFBBF24).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;

    final candyPaintPurple = Paint()
      ..color = const Color(0xFFA855F7).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;

    // Draw floating candy shapes
    // 1. Top left wrapped candy
    _drawCandy(canvas, Offset(size.width * 0.08, size.height * 0.08), 10, candyPaintPink);
    // 2. Top right musical sparkle
    _drawStar(canvas, Offset(size.width * 0.90, size.height * 0.06), 8, candyPaintYellow);
    // 3. Middle left floating jelly bean
    _drawJellyBean(canvas, Offset(size.width * 0.05, size.height * 0.45), 9, candyPaintPurple);
    // 4. Middle right gumdrop
    _drawCandy(canvas, Offset(size.width * 0.94, size.height * 0.42), 8, candyPaintBlue);
    // 5. Lower left star
    _drawStar(canvas, Offset(size.width * 0.06, size.height * 0.85), 10, candyPaintYellow);
    // 6. Lower right wrapped candy
    _drawCandy(canvas, Offset(size.width * 0.92, size.height * 0.88), 9, candyPaintPink);
  }

  void _drawCandy(Canvas canvas, Offset center, double radius, Paint paint) {
    // Circle center + small side triangles
    canvas.drawCircle(center, radius, paint);
    final path = Path();
    path.moveTo(center.dx - radius, center.dy);
    path.lineTo(center.dx - radius - 5, center.dy - 4);
    path.lineTo(center.dx - radius - 5, center.dy + 4);
    path.close();

    path.moveTo(center.dx + radius, center.dy);
    path.lineTo(center.dx + radius + 5, center.dy - 4);
    path.lineTo(center.dx + radius + 5, center.dy + 4);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawJellyBean(Canvas canvas, Offset center, double radius, Paint paint) {
    final rect = Rect.fromCenter(center: center, width: radius * 2.2, height: radius * 1.4);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)), paint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi) / 5 - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
