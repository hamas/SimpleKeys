import 'package:flutter/material.dart';

/// Material 3 Expressive color tokens, tonal surface containers, and tactile key materials.
abstract final class AppColors {
  // M3 Expressive Tonal Surfaces
  static const Color background = Color(0xFF0A0C0F);
  static const Color surfaceDim = Color(0xFF0F1217);
  static const Color surface = Color(0xFF14171E);
  static const Color surfaceContainerLow = Color(0xFF181D26);
  static const Color surfaceContainer = Color(0xFF1E232E);
  static const Color surfaceContainerHigh = Color(0xFF262D3B);
  static const Color surfaceContainerHighest = Color(0xFF31394A);
  static const Color surfaceBorder = Color(0xFF2E3646);
  static const Color surfaceHighlight = Color(0xFF3B4457);

  // M3 Expressive Accents
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentCyan = Color(0xFF38BDF8);
  static const Color accentPurple = Color(0xFFC084FC);
  static const Color activeGlow = Color(0x3DF59E0B);
  static const Color magicScaleGlow = Color(0x3D38BDF8);

  // Tactile Piano White Keys (Warm Ivory / Felt)
  static const Color whiteKeyTopGrad = Color(0xFFFBF8F3);
  static const Color whiteKeyFill = Color(0xFFEDE9E1);
  static const Color whiteKeyPressed = Color(0xFFDDD5C7);
  static const Color whiteKeyBorder = Color(0xFFCCC5B8);
  static const Color whiteKeyFrontLip = Color(0xFFB5ADA0);
  static const Color whiteKeyDimmed = Color(0xFF42403E);
  static const Color whiteKeyText = Color(0xFF6B7280);

  // Tactile Piano Black Keys (Matte Obsidian)
  static const Color blackKeyTopGrad = Color(0xFF272A33);
  static const Color blackKeyFill = Color(0xFF16171B);
  static const Color blackKeyPressed = Color(0xFF2D323E);
  static const Color blackKeyBorder = Color(0xFF262B36);
  static const Color blackKeyFrontLip = Color(0xFF0D0E11);
  static const Color blackKeyDimmed = Color(0xFF101114);
  static const Color blackKeyText = Color(0xFF94A3B8);

  // Typography
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
}
