import 'package:flutter/material.dart';

abstract final class AppColors {
  // App Canvas
  static const Color background = Color(0xFF0C0E11);
  static const Color surface = Color(0xFF14171D);
  static const Color surfaceBorder = Color(0xFF232833);
  static const Color surfaceHighlight = Color(0xFF2C3240);

  // Piano White Keys (Warm Ivory / Felt)
  static const Color whiteKeyFill = Color(0xFFEEEBE4);
  static const Color whiteKeyPressed = Color(0xFFD6CDBF);
  static const Color whiteKeyBorder = Color(0xFFD1CBC0);
  static const Color whiteKeyDimmed = Color(0xFF4C4A47);
  static const Color whiteKeyText = Color(0xFF6B7280);

  // Piano Black Keys (Matte Obsidian)
  static const Color blackKeyFill = Color(0xFF16171B);
  static const Color blackKeyPressed = Color(0xFF2E323D);
  static const Color blackKeyBorder = Color(0xFF262933);
  static const Color blackKeyDimmed = Color(0xFF101114);
  static const Color blackKeyText = Color(0xFF94A3B8);

  // Accents & Glow States
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentCyan = Color(0xFF38BDF8);
  static const Color activeGlow = Color(0x33F59E0B);
  static const Color magicScaleGlow = Color(0x2238BDF8);

  // Typography
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
}

