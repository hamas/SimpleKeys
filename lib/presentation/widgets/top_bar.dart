import 'package:flutter/material.dart';
import '../../core/audio/sound_presets.dart';
import '../../state/keyboard_controller.dart';

/// Clean, vibrant Material 3 Expressive control deck with 3D tactile buttons,
/// rich color roles, and tight, well-balanced spacing.
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

  // --- PORTRAIT CONTROL DECK (3D Tactile + M3 Expressive Colorful) ---
  Widget _buildPortraitDeck(BuildContext context) {
    final theme = Theme.of(context);
    final hasPressedNotes = controller.pressedMidiNotes.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header: Brand + 3D Mode Toggle + 3D Octave Stepper Pill
          Row(
            children: [
              // 3D Brand Emblem
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF97316), Color(0xFFC2410C)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFDBA74), width: 1.2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x66C2410C),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.piano, size: 22, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SimpleKeys',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    controller.keyboardMode == KeyboardMode.isomorphicGrid
                        ? '4x4 Isomorphic'
                        : 'Acoustic Piano',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // 3D Layout Mode Toggle Button
              GestureDetector(
                onTap: controller.toggleKeyboardMode,
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: controller.keyboardMode == KeyboardMode.isomorphicGrid
                          ? const [Color(0xFF8B5CF6), Color(0xFF6D28D9)]
                          : const [Color(0xFF334155), Color(0xFF1E293B)],
                    ),
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(
                      color: controller.keyboardMode == KeyboardMode.isomorphicGrid
                          ? const Color(0xFFC4B5FD)
                          : const Color(0xFF475569),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: controller.keyboardMode == KeyboardMode.isomorphicGrid
                            ? const Color(0x668B5CF6)
                            : Colors.black45,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        controller.keyboardMode == KeyboardMode.isomorphicGrid
                            ? Icons.grid_view_rounded
                            : Icons.piano,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        controller.keyboardMode == KeyboardMode.isomorphicGrid ? '4x4' : 'Piano',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // 3D Octave Stepper Pill
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  ),
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: const Color(0xFF38BDF8), width: 1.2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      tooltip: 'Octave Down',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 36),
                      color: const Color(0xFF38BDF8),
                      onPressed: controller.baseOctave > 2 ? controller.shiftOctaveDown : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        controller.octaveRangeLabel,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF38BDF8),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      tooltip: 'Octave Up',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 36),
                      color: const Color(0xFF38BDF8),
                      onPressed: controller.baseOctave < 5 ? controller.shiftOctaveUp : null,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 2. 3D Harmony & Active Chord Display Banner
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: hasPressedNotes
                    ? [
                        const Color(0xFF1E1B4B),
                        const Color(0xFF0F172A),
                      ]
                    : [
                        const Color(0xFF151722),
                        const Color(0xFF0D0F15),
                      ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasPressedNotes ? const Color(0xFF818CF8) : const Color(0xFF2E3444),
                width: hasPressedNotes ? 1.4 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: hasPressedNotes ? const Color(0x44818CF8) : Colors.black38,
                  blurRadius: hasPressedNotes ? 12 : 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasPressedNotes ? const Color(0xFF38BDF8) : const Color(0xFF475569),
                    boxShadow: hasPressedNotes
                        ? [
                            const BoxShadow(
                              color: Color(0xFF38BDF8),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    controller.activeChord,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: hasPressedNotes ? Colors.white : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                if (controller.isMagicScale)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x66F59E0B),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'PENTATONIC',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 3. 3D Colorful Sound Preset Selector (Felt Piano, Music Box, Dream Pad)
          Row(
            children: [
              _buildPresetCard(
                type: SoundBankType.feltPiano,
                title: 'Felt Piano',
                icon: Icons.piano,
                activeGradient: const [Color(0xFFF97316), Color(0xFFC2410C)],
                activeBorder: const Color(0xFFFDBA74),
                activeGlow: const Color(0x66F97316),
              ),
              const SizedBox(width: 8),
              _buildPresetCard(
                type: SoundBankType.musicBox,
                title: 'Music Box',
                icon: Icons.notifications_active,
                activeGradient: const [Color(0xFF06B6D4), Color(0xFF0E7490)],
                activeBorder: const Color(0xFF67E8F9),
                activeGlow: const Color(0x6606B6D4),
              ),
              const SizedBox(width: 8),
              _buildPresetCard(
                type: SoundBankType.dreamPad,
                title: 'Dream Pad',
                icon: Icons.cloud,
                activeGradient: const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                activeBorder: const Color(0xFFC4B5FD),
                activeGlow: const Color(0x668B5CF6),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 4. 3D Colorful Action Chips Row (Magic Scale & Sustain)
          Row(
            children: [
              // Magic Scale 3D Button
              Expanded(
                child: _buildActionPill(
                  title: 'Magic Scale',
                  icon: Icons.auto_awesome,
                  isActive: controller.isMagicScale,
                  onTap: controller.toggleMagicScale,
                  activeGradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
                  activeBorder: const Color(0xFFFDE68A),
                  glowColor: const Color(0x66F59E0B),
                ),
              ),
              const SizedBox(width: 10),
              // Sustain 3D Button
              Expanded(
                child: _buildActionPill(
                  title: controller.isSustainEnabled ? 'Sustain On' : 'Staccato',
                  icon: controller.isSustainEnabled ? Icons.waves : Icons.graphic_eq,
                  isActive: controller.isSustainEnabled,
                  onTap: controller.toggleSustain,
                  activeGradient: const [Color(0xFF10B981), Color(0xFF047857)],
                  activeBorder: const Color(0xFF6EE7B7),
                  glowColor: const Color(0x6610B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 3D Preset Button Widget ---
  Widget _buildPresetCard({
    required SoundBankType type,
    required String title,
    required IconData icon,
    required List<Color> activeGradient,
    required Color activeBorder,
    required Color activeGlow,
  }) {
    final isSelected = controller.soundPreset == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setSoundPreset(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isSelected
                  ? activeGradient
                  : const [Color(0xFF222634), Color(0xFF161922)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? activeBorder : const Color(0xFF2E3444),
              width: isSelected ? 1.6 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected ? activeGlow : Colors.black45,
                blurRadius: isSelected ? 8 : 4,
                offset: Offset(0, isSelected ? 2 : 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 3D Action Pill Widget ---
  Widget _buildActionPill({
    required String title,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    required List<Color> activeGradient,
    required Color activeBorder,
    required Color glowColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 38,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isActive
                ? activeGradient
                : const [Color(0xFF222634), Color(0xFF161922)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? activeBorder : const Color(0xFF2E3444),
            width: isActive ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isActive ? glowColor : Colors.black45,
              blurRadius: isActive ? 8 : 3,
              offset: Offset(0, isActive ? 2 : 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.white : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xFFCBD5E1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- LANDSCAPE BAR ---
  Widget _buildLandscapeBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasPressedNotes = controller.pressedMidiNotes.isNotEmpty;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF161822),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2E3D)),
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

          const SizedBox(width: 14),

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

          const SizedBox(width: 10),

          // Octave Stepper
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2230),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF38BDF8)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28),
                  onPressed: controller.baseOctave > 2 ? controller.shiftOctaveDown : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    controller.octaveRangeLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28),
                  onPressed: controller.baseOctave < 5 ? controller.shiftOctaveUp : null,
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          // Chord Display
          Expanded(
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: hasPressedNotes
                    ? colorScheme.primaryContainer.withValues(alpha: 0.35)
                    : const Color(0xFF1F2332),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: hasPressedNotes
                      ? colorScheme.primary.withValues(alpha: 0.6)
                      : const Color(0xFF2E3444),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                controller.activeChord,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: hasPressedNotes ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Preset Pill
          PopupMenuButton<SoundBankType>(
            initialValue: controller.soundPreset,
            tooltip: 'Sound Preset',
            onSelected: controller.setSoundPreset,
            itemBuilder: (context) => SoundBankType.values.map((preset) {
              return PopupMenuItem(
                value: preset,
                child: Row(
                  children: [
                    Icon(
                      preset == SoundBankType.feltPiano
                          ? Icons.piano
                          : preset == SoundBankType.musicBox
                              ? Icons.notifications_active
                              : Icons.cloud,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(preset.title),
                  ],
                ),
              );
            }).toList(),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2332),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF2E3444)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    controller.soundPreset == SoundBankType.feltPiano
                        ? Icons.piano
                        : controller.soundPreset == SoundBankType.musicBox
                            ? Icons.notifications_active
                            : Icons.cloud,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    controller.soundPreset.title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 18),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Magic Scale FilterChip
          FilterChip(
            label: const Text('Magic', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            avatar: const Icon(Icons.auto_awesome, size: 14),
            selected: controller.isMagicScale,
            onSelected: (_) => controller.toggleMagicScale(),
          ),

          const SizedBox(width: 8),

          // Sustain FilterChip
          FilterChip(
            label: Text(
              controller.isSustainEnabled ? 'Sustain' : 'Staccato',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            avatar: Icon(controller.isSustainEnabled ? Icons.waves : Icons.graphic_eq, size: 14),
            selected: controller.isSustainEnabled,
            onSelected: (_) => controller.toggleSustain(),
          ),
        ],
      ),
    );
  }
}
