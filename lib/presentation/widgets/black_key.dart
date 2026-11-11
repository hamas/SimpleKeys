import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/key_note.dart';

/// Renders an elevated matte-black sharp/flat piano key with realistic beveling.
class BlackKey extends StatelessWidget {
  final KeyNote note;
  final bool isPressed;
  final bool isPlayable;

  const BlackKey({
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
            ? AppColors.blackKeyDimmed
            : isPressed
                ? AppColors.blackKeyPressed
                : AppColors.blackKeyFill,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
        border: Border(
          left: BorderSide(
            color: dimmed ? Colors.black : AppColors.blackKeyBorder,
            width: 1,
          ),
          right: BorderSide(
            color: dimmed ? Colors.black : AppColors.blackKeyBorder,
            width: 1,
          ),
          bottom: BorderSide(
            color: isPressed ? AppColors.accentCyan : const Color(0xFF0F1013),
            width: isPressed ? 2 : 4,
          ),
        ),
        boxShadow: [
          if (isPressed && !dimmed)
            BoxShadow(
              color: AppColors.accentCyan.withValues(alpha: 0.35),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            )
          else if (!dimmed)
            const BoxShadow(
              color: Color(0x66000000),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
        ],
      ),
      child: Stack(
        children: [
          // Elevated sheen along top edge
          Positioned(
            top: 0,
            left: 2,
            right: 2,
            height: 3,
            child: Container(
              color: dimmed ? Colors.transparent : const Color(0x1AFFFFFF),
            ),
          ),
          // Note label at bottom of black key
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Text(
              note.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: dimmed
                    ? AppColors.textMuted.withValues(alpha: 0.5)
                    : isPressed
                        ? AppColors.accentCyan
                        : AppColors.blackKeyText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
