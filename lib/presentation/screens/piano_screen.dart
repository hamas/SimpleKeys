import 'package:flutter/material.dart';
import '../../state/keyboard_controller.dart';
import '../widgets/candy_bottom_bar.dart';
import '../widgets/candy_decorations.dart';
import '../widgets/candy_header.dart';
import '../widgets/isomorphic_pad_grid.dart';

/// Joyful 3D Candy Crush aesthetic piano & musical learning screen for SimpleKeys.
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
      backgroundColor: const Color(0xFFCEF6EC),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Candy background with floating sweets, stars, and musical notes
          const CustomPaint(
            painter: CandyBackgroundPainter(),
          ),

          // 2. Foreground content layout
          SafeArea(
            top: true,
            bottom: true,
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),

                    // 1. 3D "SimpleKeys" Rainbow Bubble Title
                    const SimpleKeysTitle(),

                    const SizedBox(height: 8),

                    // 2. Top Stats: Lives, Score, Settings
                    CandyHeader(controller: _controller),

                    const SizedBox(height: 10),

                    // 3. Central 4x5 3D Candy Jelly Pad Tray with "Level 1" badge
                    Expanded(
                      child: IsomorphicPadGrid(controller: _controller),
                    ),

                    const SizedBox(height: 6),

                    // 4. Bottom 3D Pill Navigation: PLAY, SONGS, STORE
                    CandyBottomBar(controller: _controller),

                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
