import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../state/keyboard_controller.dart';
import '../widgets/piano_keyboard.dart';
import '../widgets/top_bar.dart';

/// Material 3 Expressive responsive piano screen supporting portrait and landscape orientations.
class PianoScreen extends StatefulWidget {
  const PianoScreen({super.key});

  @override
  State<PianoScreen> createState() => _PianoScreenState();
}

class _PianoScreenState extends State<PianoScreen> {
  late final KeyboardController _controller;
  Orientation? _lastOrientation;

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
        child: OrientationBuilder(
          builder: (context, orientation) {
            final isPortrait = orientation == Orientation.portrait;

            // Auto-adjust default octave span when orientation changes
            if (_lastOrientation != orientation) {
              _lastOrientation = orientation;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _controller.setOctaveSpan(isPortrait ? 1 : 2);
              });
            }

            return ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                if (isPortrait) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TopBar(controller: _controller, isPortrait: true),
                      const SizedBox(height: 8),
                      // Generous keyboard touch area in portrait
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                          child: PianoKeyboard(controller: _controller),
                        ),
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
