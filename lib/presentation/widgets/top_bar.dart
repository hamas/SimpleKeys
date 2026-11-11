import 'package:flutter/material.dart';
import '../../core/audio/sound_presets.dart';
import '../../state/keyboard_controller.dart';

/// Clean, comfortable Material 3 control deck with properly sized buttons and readable typography.
class TopBar extends StatelessWidget {
  final KeyboardController controller;
  final bool isPortrait;

  const TopBar({
    super.key,
    required this.controller,
    this.isPortrait = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isPortrait) {
      return _buildPortraitDeck(context);
    }
    return _buildLandscapeBar(context);
  }

  // --- PORTRAIT CONTROL DECK (Comfortable, Prominent Buttons) ---
  Widget _buildPortraitDeck(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasPressedNotes = controller.pressedMidiNotes.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header: Brand + Large Octave Stepper
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.piano, size: 24, color: colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SimpleKeys',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Minimal Piano',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Layout Mode Toggle Button (4x4 Pads vs Piano)
              IconButton.filledTonal(
                tooltip: controller.keyboardMode == KeyboardMode.isomorphicGrid
                    ? 'Switch to Piano Keys'
                    : 'Switch to 4x4 Pads',
                icon: Icon(
                  controller.keyboardMode == KeyboardMode.isomorphicGrid
                      ? Icons.grid_view_rounded
                      : Icons.piano,
                  size: 20,
                ),
                onPressed: controller.toggleKeyboardMode,
              ),

              const SizedBox(width: 8),

              // Prominent Octave Stepper Pill (Height 46dp, generous tap area)
              Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(23),
                  border: Border.all(color: colorScheme.outlineVariant, width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 22),
                      tooltip: 'Octave Down',
                      onPressed: controller.baseOctave > 2 ? controller.shiftOctaveDown : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        controller.octaveRangeLabel,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 22),
                      tooltip: 'Octave Up',
                      onPressed: controller.baseOctave < 5 ? controller.shiftOctaveUp : null,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 2. Prominent Harmony & Active Chord Display
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: hasPressedNotes
                  ? colorScheme.primaryContainer.withValues(alpha: 0.4)
                  : colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: hasPressedNotes
                    ? colorScheme.primary.withValues(alpha: 0.6)
                    : colorScheme.outlineVariant,
                width: hasPressedNotes ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasPressedNotes ? colorScheme.primary : colorScheme.outline,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    controller.activeChord,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: hasPressedNotes ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (controller.isMagicScale)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'PENTATONIC',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 3. Full-Sized SegmentedButton for Sound Presets (Height 48dp)
          SizedBox(
            height: 48,
            child: SegmentedButton<SoundBankType>(
              segments: const [
                ButtonSegment(
                  value: SoundBankType.feltPiano,
                  label: Text('Felt Piano', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                  icon: Icon(Icons.piano, size: 20),
                ),
                ButtonSegment(
                  value: SoundBankType.musicBox,
                  label: Text('Music Box', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                  icon: Icon(Icons.notifications_active, size: 20),
                ),
                ButtonSegment(
                  value: SoundBankType.dreamPad,
                  label: Text('Dream Pad', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                  icon: Icon(Icons.cloud, size: 20),
                ),
              ],
              selected: {controller.soundPreset},
              onSelectionChanged: (newSelection) {
                controller.setSoundPreset(newSelection.first);
              },
            ),
          ),

          const SizedBox(height: 12),

          // 4. Large Filter Chips Row (Magic Scale & Sustain)
          Row(
            children: [
              Expanded(
                child: FilterChip(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  avatar: Icon(
                    Icons.auto_awesome,
                    size: 18,
                    color: controller.isMagicScale
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                  label: const Center(
                    child: Text('Magic Scale', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                  ),
                  selected: controller.isMagicScale,
                  selectedColor: colorScheme.secondaryContainer,
                  onSelected: (_) => controller.toggleMagicScale(),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: FilterChip(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  avatar: Icon(
                    controller.isSustainEnabled ? Icons.waves : Icons.graphic_eq,
                    size: 18,
                    color: controller.isSustainEnabled
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                  label: Center(
                    child: Text(
                      controller.isSustainEnabled ? 'Sustain On' : 'Damper (Staccato)',
                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                  selected: controller.isSustainEnabled,
                  selectedColor: colorScheme.primaryContainer,
                  onSelected: (_) => controller.toggleSustain(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- LANDSCAPE BAR ---
  Widget _buildLandscapeBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasPressedNotes = controller.pressedMidiNotes.isNotEmpty;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.piano, size: 22, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'SimpleKeys',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Layout Mode Toggle Button (4x4 Pads vs Piano)
          IconButton.filledTonal(
            tooltip: controller.keyboardMode == KeyboardMode.isomorphicGrid
                ? 'Switch to Piano Keys'
                : 'Switch to 4x4 Pads',
            icon: Icon(
              controller.keyboardMode == KeyboardMode.isomorphicGrid
                  ? Icons.grid_view_rounded
                  : Icons.piano,
              size: 18,
            ),
            onPressed: controller.toggleKeyboardMode,
          ),

          const SizedBox(width: 12),

          // Octave Stepper
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(21),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 18),
                  onPressed: controller.baseOctave > 2 ? controller.shiftOctaveDown : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    controller.octaveRangeLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: controller.baseOctave < 5 ? controller.shiftOctaveUp : null,
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          // Chord Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: hasPressedNotes
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasPressedNotes
                    ? colorScheme.primary.withValues(alpha: 0.5)
                    : colorScheme.outlineVariant,
              ),
            ),
            child: Text(
              controller.activeChord,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: hasPressedNotes
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const Spacer(),

          // Sound Presets
          SizedBox(
            height: 42,
            child: SegmentedButton<SoundBankType>(
              segments: const [
                ButtonSegment(
                  value: SoundBankType.feltPiano,
                  label: Text('Felt'),
                  icon: Icon(Icons.piano, size: 16),
                ),
                ButtonSegment(
                  value: SoundBankType.musicBox,
                  label: Text('Music Box'),
                  icon: Icon(Icons.notifications_active, size: 16),
                ),
                ButtonSegment(
                  value: SoundBankType.dreamPad,
                  label: Text('Pad'),
                  icon: Icon(Icons.cloud, size: 16),
                ),
              ],
              selected: {controller.soundPreset},
              onSelectionChanged: (newSelection) {
                controller.setSoundPreset(newSelection.first);
              },
            ),
          ),

          const SizedBox(width: 12),

          // Sustain Chip
          FilterChip(
            avatar: Icon(
              controller.isSustainEnabled ? Icons.waves : Icons.graphic_eq,
              size: 16,
            ),
            label: Text(controller.isSustainEnabled ? 'Sustain' : 'Damper'),
            selected: controller.isSustainEnabled,
            onSelected: (_) => controller.toggleSustain(),
          ),

          const SizedBox(width: 8),

          // Magic Scale Chip
          FilterChip(
            avatar: const Icon(Icons.auto_awesome, size: 16),
            label: const Text('Magic Scale'),
            selected: controller.isMagicScale,
            selectedColor: colorScheme.secondaryContainer,
            onSelected: (_) => controller.toggleMagicScale(),
          ),
        ],
      ),
    );
  }
}
