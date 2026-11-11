import 'package:flutter/material.dart';
import '../../core/audio/sound_presets.dart';
import '../../core/theme/app_colors.dart';
import '../../state/keyboard_controller.dart';

/// Top control bar housing octave controls, sound bank preset pill switcher, and magic-scale toggle.
class TopBar extends StatelessWidget {
  final KeyboardController controller;

  const TopBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.surfaceBorder,
            width: 1,
          ),
        ),
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
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(width: 24),

          // Octave Selector
          _buildOctaveControls(),

          const Spacer(),

          // Sound Preset Switcher Pills
          _buildPresetSwitcher(),

          const SizedBox(width: 16),

          // Magic Scale Toggle Button
          _buildMagicScaleToggle(),
        ],
      ),
    );
  }

  Widget _buildOctaveControls() {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIconButton(
            icon: Icons.remove,
            enabled: controller.baseOctave > 2,
            onPressed: controller.shiftOctaveDown,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'C${controller.baseOctave} – C${controller.baseOctave + 2}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _buildIconButton(
            icon: Icons.add,
            enabled: controller.baseOctave < 5,
            onPressed: controller.shiftOctaveUp,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? AppColors.textPrimary : AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildPresetSwitcher() {
    return Container(
      height: 32,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: SoundBankType.values.map((preset) {
          final isSelected = controller.soundPreset == preset;
          return GestureDetector(
            onTap: () => controller.setSoundPreset(preset),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.surfaceHighlight : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: isSelected
                    ? Border.all(color: AppColors.accentAmber.withValues(alpha: 0.6))
                    : null,
              ),
              child: Text(
                preset.title,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMagicScaleToggle() {
    final isActive = controller.isMagicScale;

    return GestureDetector(
      onTap: controller.toggleMagicScale,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accentCyan.withValues(alpha: 0.15) : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppColors.accentCyan : AppColors.surfaceBorder,
            width: isActive ? 1.5 : 1,
          ),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: AppColors.accentCyan.withValues(alpha: 0.2),
                blurRadius: 8,
              ),
          ],
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
                fontSize: 11.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.accentCyan : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

