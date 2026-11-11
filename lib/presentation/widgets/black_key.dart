import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/key_note.dart';

/// Tactile Material 3 Expressive matte obsidian sharp/flat piano key with 3D bevels and lighting.
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

    return Transform.translate(
      offset: Offset(0, (isPressed && !dimmed) ? 2.5 : 0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        curve: Curves.easeOutQuad,
        decoration: BoxDecoration(
          gradient: dimmed
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF141518), AppColors.blackKeyDimmed],
                )
              : isPressed
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF323746), AppColors.blackKeyPressed],
                    )
                  : const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.blackKeyTopGrad, AppColors.blackKeyFill],
                    ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
          border: Border(
            left: BorderSide(
              color: dimmed ? Colors.black : AppColors.blackKeyBorder,
              width: 1.0,
            ),
            right: BorderSide(
              color: dimmed ? Colors.black : AppColors.blackKeyBorder,
              width: 1.0,
            ),
            // Front-lip 3D depth bevel
            bottom: BorderSide(
              color: (isPressed && !dimmed)
                  ? AppColors.accentCyan
                  : dimmed
                      ? Colors.black
                      : AppColors.blackKeyFrontLip,
              width: (isPressed && !dimmed) ? 2.5 : 5.0,
            ),
          ),
          boxShadow: [
            if (isPressed && !dimmed) ...[
              BoxShadow(
                color: AppColors.accentCyan.withValues(alpha: 0.45),
                blurRadius: 14,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: AppColors.accentCyan.withValues(alpha: 0.20),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ] else if (!dimmed)
              const BoxShadow(
                color: Color(0x73000000),
                blurRadius: 8,
                offset: Offset(0, 5),
              ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Top specular satin sheen strip
            Positioned(
              top: 0,
              left: 2,
              right: 2,
              height: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  color: dimmed
                      ? Colors.transparent
                      : const Color(0x33FFFFFF),
                ),
              ),
            ),

            // Vertical edge reflection highlight
            Positioned(
              top: 6,
              left: 2,
              width: 1.5,
              bottom: 12,
              child: Container(
                color: dimmed
                    ? Colors.transparent
                    : const Color(0x1AFFFFFF),
              ),
            ),

            // Note label at bottom of black key
            Positioned(
              bottom: (isPressed && !dimmed) ? 7 : 9,
              left: 0,
              right: 0,
              child: Text(
                note.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: dimmed
                      ? AppColors.textMuted.withValues(alpha: 0.4)
                      : (isPressed
                          ? AppColors.accentCyan
                          : AppColors.blackKeyText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
