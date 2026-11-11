import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/key_note.dart';

/// Tactile Material 3 Expressive ivory felt piano key with 3D front-lip depth and key-travel physics.
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Transform.translate(
        offset: Offset(0, (isPressed && !dimmed) ? 3.5 : 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 60),
          curve: Curves.easeOutQuad,
          decoration: BoxDecoration(
            gradient: dimmed
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF383634), AppColors.whiteKeyDimmed],
                  )
                : isPressed
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFE4DDD0), AppColors.whiteKeyPressed],
                      )
                    : const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.whiteKeyTopGrad, AppColors.whiteKeyFill],
                      ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            border: Border(
              left: BorderSide(
                color: dimmed ? Colors.black54 : AppColors.whiteKeyBorder,
                width: 0.75,
              ),
              right: BorderSide(
                color: dimmed ? Colors.black54 : AppColors.whiteKeyBorder,
                width: 0.75,
              ),
              // Front-lip 3D depth bevel
              bottom: BorderSide(
                color: (isPressed && !dimmed)
                    ? AppColors.accentAmber
                    : dimmed
                        ? const Color(0xFF282725)
                        : AppColors.whiteKeyFrontLip,
                width: (isPressed && !dimmed) ? 3.0 : 6.0,
              ),
            ),
            boxShadow: [
              if (isPressed && !dimmed) ...[
                BoxShadow(
                  color: AppColors.accentAmber.withValues(alpha: 0.35),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: AppColors.accentAmber.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ] else if (!dimmed)
                const BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Subtle top felt guide strip
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 4,
                child: Container(
                  color: dimmed
                      ? Colors.transparent
                      : const Color(0x40FFFFFF),
                ),
              ),

              // Bottom note badge & label
              Positioned(
                bottom: (isPressed && !dimmed) ? 10 : 13,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      note.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        color: dimmed
                            ? AppColors.textMuted.withValues(alpha: 0.6)
                            : (isPressed
                                ? AppColors.accentAmber
                                : const Color(0xFF4B5563)),
                      ),
                    ),
                    Text(
                      '${note.octave}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: dimmed
                            ? AppColors.textMuted.withValues(alpha: 0.4)
                            : (isPressed
                                ? AppColors.accentAmber.withValues(alpha: 0.8)
                                : AppColors.textMuted),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
