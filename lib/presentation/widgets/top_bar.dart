import 'package:flutter/material.dart';
import '../../core/audio/sound_presets.dart';
import '../../core/theme/app_colors.dart';
import '../../state/keyboard_controller.dart';

/// Material 3 Expressive top control bar housing octave stepper, fluid preset switcher,
/// sustain pedal toggle, and radiant magic-scale toggle.
class TopBar extends StatelessWidget {
  final KeyboardController controller;

  const TopBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 6, 10, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceBorder, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // App Logo / Title
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.piano, size: 20, color: AppColors.accentAmber),
              SizedBox(width: 8),
              Text(
                'SimpleKeys',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Expressive Octave Stepper Pill
          _buildOctaveStepper(),

          const Spacer(),

          // Fluid Segmented Sound Preset Switcher
          _buildPresetSwitcher(),

          const SizedBox(width: 10),

          // Sustain Pedal Toggle Pill
          _buildSustainToggle(),

          const SizedBox(width: 10),

          // Radiant Magic Scale Toggle Pill
          _buildMagicScaleToggle(),
        ],
      ),
    );
  }

  Widget _buildOctaveStepper() {
    final canShiftDown = controller.baseOctave > 2;
    final canShiftUp = controller.baseOctave < 5;

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.surfaceDim,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceBorder, width: 0.75),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStepperButton(
            icon: Icons.remove,
            enabled: canShiftDown,
            onTap: controller.shiftOctaveDown,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.unfold_more, size: 13, color: AppColors.accentAmber),
                const SizedBox(width: 4),
                Text(
                  'C${controller.baseOctave} – C${controller.baseOctave + 2}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          _buildStepperButton(
            icon: Icons.add,
            enabled: canShiftUp,
            onTap: controller.shiftOctaveUp,
          ),
        ],
      ),
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Icon(
            icon,
            size: 15,
            color: enabled ? AppColors.textPrimary : AppColors.textMuted.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }

  Widget _buildPresetSwitcher() {
    return Container(
      height: 36,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surfaceDim,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceBorder, width: 0.75),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: SoundBankType.values.map((preset) {
          final isSelected = controller.soundPreset == preset;
          final iconData = switch (preset) {
            SoundBankType.feltPiano => Icons.piano,
            SoundBankType.musicBox => Icons.notifications_active,
            SoundBankType.dreamPad => Icons.cloud,
          };

          return GestureDetector(
            onTap: () => controller.setSoundPreset(preset),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.surfaceHighlight
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: isSelected
                    ? Border.all(color: AppColors.accentAmber.withValues(alpha: 0.75), width: 1)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.accentAmber.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    iconData,
                    size: 14,
                    color: isSelected ? AppColors.accentAmber : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    preset.title,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSustainToggle() {
    final isSustain = controller.isSustainEnabled;

    return GestureDetector(
      onTap: controller.toggleSustain,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSustain
              ? AppColors.accentAmber.withValues(alpha: 0.15)
              : AppColors.surfaceDim,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSustain ? AppColors.accentAmber : AppColors.surfaceBorder,
            width: isSustain ? 1.25 : 0.75,
          ),
          boxShadow: isSustain
              ? [
                  BoxShadow(
                    color: AppColors.accentAmber.withValues(alpha: 0.2),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSustain ? Icons.waves : Icons.graphic_eq,
              size: 14,
              color: isSustain ? AppColors.accentAmber : AppColors.textSecondary,
            ),
            const SizedBox(width: 5),
            Text(
              isSustain ? 'Sustain' : 'Damper',
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSustain ? FontWeight.w700 : FontWeight.w500,
                color: isSustain ? AppColors.accentAmber : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMagicScaleToggle() {
    final isActive = controller.isMagicScale;

    return GestureDetector(
      onTap: controller.toggleMagicScale,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.accentCyan.withValues(alpha: 0.18)
              : AppColors.surfaceDim,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? AppColors.accentCyan : AppColors.surfaceBorder,
            width: isActive ? 1.5 : 0.75,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: 0.35),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 14,
              color: isActive ? AppColors.accentCyan : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              'Magic Scale',
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                color: isActive ? AppColors.accentCyan : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
