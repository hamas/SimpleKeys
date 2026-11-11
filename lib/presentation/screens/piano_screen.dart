import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../state/keyboard_controller.dart';
import '../widgets/piano_keyboard.dart';
import '../widgets/top_bar.dart';

/// Single-screen minimal piano experience.
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
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TopBar(controller: _controller),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: PianoKeyboard(controller: _controller),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

