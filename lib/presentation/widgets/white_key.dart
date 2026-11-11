import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/key_note.dart';

/// Renders a single tactile off-white felt piano key.
class WhiteKey extends StatelessWidget {
  final KeyNote note;
  final bool isPressed;
  final bool isPlayable;

  const WhiteKey({
    super.key,
    required this.note,
    required this.isPressed,
    required this.isPlayable,
  });

  @override
  Widget build(BuildContext context) {
    final bool dimmed = !isPlayable;

    return Container(
      decoration: BoxDecoration(
        color: dimmed
            ? AppColors.whiteKeyDimmed
            : isPressed
                ? AppColors.whiteKeyPressed
                : AppColors.whiteKeyFill,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(7),
          bottomRight: Radius.circular(7),
        ),
        border: Border(
          left: BorderSide(
            color: dimmed ? Colors.black45 : AppColors.whiteKeyBorder,
            width: 0.5,
          ),
          right: BorderSide(
            color: dimmed ? Colors.black45 : AppColors.whiteKeyBorder,
            width: 0.5,
          ),
          bottom: BorderSide(
            color: isPressed ? AppColors.accentAmber : const Color(0xFFB8B1A5),
            width: isPressed ? 3 : 5,
          ),
        ),
        boxShadow: [
          if (isPressed && !dimmed)
            BoxShadow(
              color: AppColors.accentAmber.withValues(alpha: 0.25),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          else if (!dimmed)
            const BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle top felt highlight strip
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 4,
            child: Container(
              color: dimmed ? Colors.transparent : const Color(0x33FFFFFF),
            ),
          ),
          // Bottom label
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Text(
              note.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
                color: dimmed
                    ? AppColors.textMuted
                    : isPressed
                        ? AppColors.accentAmber
                        : AppColors.whiteKeyText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
