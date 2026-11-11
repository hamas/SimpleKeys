import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../state/keyboard_controller.dart';
import '../widgets/piano_keyboard.dart';
import '../widgets/top_bar.dart';

/// Responsive piano screen with visible system bars and balanced component sizing.
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: true,
        bottom: true,
        child: OrientationBuilder(
          builder: (context, orientation) {
            final isPortrait = orientation == Orientation.portrait;

            return ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                if (isPortrait) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Prominent, comfortable top control deck
                      TopBar(controller: _controller, isPortrait: true),

                      const Spacer(),

                      // Proportional, balanced piano keyboard height in portrait
                      Container(
                        height: 250,
                        margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: PianoKeyboard(controller: _controller),
                      ),
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
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        child: PianoKeyboard(controller: _controller),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
