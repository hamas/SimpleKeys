import 'package:flutter/material.dart';
import '../../core/audio/sound_presets.dart';
import '../../state/keyboard_controller.dart';

/// Authentic Material 3 Expressive control deck with responsive portrait and landscape layouts.
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

  // --- PORTRAIT MATERIAL 3 EXPRESSIVE DECK ---
  Widget _buildPortraitDeck(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasPressedNotes = controller.pressedMidiNotes.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Top Header Row: Brand + Octave Stepper
          Row(
            children: [
              // Logo
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.piano, size: 20, color: colorScheme.primary),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SimpleKeys',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Couch Piano',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Octave Stepper Pill
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      visualDensity: VisualDensity.compact,
                      onPressed: controller.baseOctave > 2 ? controller.shiftOctaveDown : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        'C${controller.baseOctave}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      visualDensity: VisualDensity.compact,
                      onPressed: controller.baseOctave < 5 ? controller.shiftOctaveUp : null,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 2. Expressive Active Chord / Harmony Card
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: hasPressedNotes
                  ? colorScheme.primaryContainer.withValues(alpha: 0.35)
                  : colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: hasPressedNotes
                    ? colorScheme.primary.withValues(alpha: 0.5)
                    : colorScheme.outlineVariant,
                width: hasPressedNotes ? 1.5 : 1,
              ),
              boxShadow: hasPressedNotes
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasPressedNotes ? colorScheme.primary : colorScheme.outlineVariant,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    controller.activeChord,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: hasPressedNotes
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (controller.isMagicScale)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, size: 12, color: colorScheme.secondary),
                        const SizedBox(width: 4),
                        Text(
                          'PENTATONIC',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 3. Official Material 3 SegmentedButton for Presets
          SegmentedButton<SoundBankType>(
            segments: const [
              ButtonSegment(
                value: SoundBankType.feltPiano,
                label: Text('Felt'),
                icon: Icon(Icons.piano),
              ),
              ButtonSegment(
                value: SoundBankType.musicBox,
                label: Text('Music Box'),
                icon: Icon(Icons.notifications_active),
              ),
              ButtonSegment(
                value: SoundBankType.dreamPad,
                label: Text('Pad'),
                icon: Icon(Icons.cloud),
              ),
            ],
            selected: {controller.soundPreset},
            onSelectionChanged: (newSelection) {
              controller.setSoundPreset(newSelection.first);
            },
          ),

          const SizedBox(height: 10),

          // 4. Expressive FilterChips & Key Span Stepper Row
          Row(
            children: [
              // Magic Scale Chip
              FilterChip(
                avatar: Icon(
                  Icons.auto_awesome,
                  size: 15,
                  color: controller.isMagicScale
                      ? colorScheme.onSecondaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
                label: const Text('Magic Scale'),
                selected: controller.isMagicScale,
                selectedColor: colorScheme.secondaryContainer,
                onSelected: (_) => controller.toggleMagicScale(),
              ),

              const SizedBox(width: 8),

              // Sustain Pedal Chip
              FilterChip(
                avatar: Icon(
                  controller.isSustainEnabled ? Icons.waves : Icons.graphic_eq,
                  size: 15,
                  color: controller.isSustainEnabled
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
                label: Text(controller.isSustainEnabled ? 'Sustain' : 'Damper'),
                selected: controller.isSustainEnabled,
                selectedColor: colorScheme.primaryContainer,
                onSelected: (_) => controller.toggleSustain(),
              ),

              const Spacer(),

              // Octave Span Toggle (1 Octave vs 2 Octaves)
              SegmentedButton<int>(
                showSelectedIcon: false,
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                segments: const [
                  ButtonSegment(value: 1, label: Text('1 Oct')),
                  ButtonSegment(value: 2, label: Text('2 Oct')),
                ],
                selected: {controller.octaveSpan},
                onSelectionChanged: (newVal) {
                  controller.setOctaveSpan(newVal.first);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- LANDSCAPE MATERIAL 3 EXPRESSIVE BAR ---
  Widget _buildLandscapeBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasPressedNotes = controller.pressedMidiNotes.isNotEmpty;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          // Brand
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.piano, size: 20, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'SimpleKeys',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Octave Stepper
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 16),
                  visualDensity: VisualDensity.compact,
                  onPressed: controller.baseOctave > 2 ? controller.shiftOctaveDown : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    'C${controller.baseOctave} – C${controller.baseOctave + controller.octaveSpan}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  visualDensity: VisualDensity.compact,
                  onPressed: controller.baseOctave < 5 ? controller.shiftOctaveUp : null,
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Active Chord Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: hasPressedNotes
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const Spacer(),

          // Preset Switcher
          SegmentedButton<SoundBankType>(
            style: const ButtonStyle(visualDensity: VisualDensity.compact),
            segments: const [
              ButtonSegment(
                value: SoundBankType.feltPiano,
                label: Text('Felt'),
                icon: Icon(Icons.piano, size: 14),
              ),
              ButtonSegment(
                value: SoundBankType.musicBox,
                label: Text('Music Box'),
                icon: Icon(Icons.notifications_active, size: 14),
              ),
              ButtonSegment(
                value: SoundBankType.dreamPad,
                label: Text('Pad'),
                icon: Icon(Icons.cloud, size: 14),
              ),
            ],
            selected: {controller.soundPreset},
            onSelectionChanged: (newSelection) {
              controller.setSoundPreset(newSelection.first);
            },
          ),

          const SizedBox(width: 12),

          // Sustain Chip
          FilterChip(
            visualDensity: VisualDensity.compact,
            avatar: Icon(
              controller.isSustainEnabled ? Icons.waves : Icons.graphic_eq,
              size: 14,
            ),
            label: Text(controller.isSustainEnabled ? 'Sustain' : 'Damper'),
            selected: controller.isSustainEnabled,
            onSelected: (_) => controller.toggleSustain(),
          ),

          const SizedBox(width: 8),

          // Magic Scale Chip
          FilterChip(
            visualDensity: VisualDensity.compact,
            avatar: const Icon(Icons.auto_awesome, size: 14),
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
