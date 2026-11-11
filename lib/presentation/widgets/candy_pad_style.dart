import 'package:flutter/material.dart';

/// Available candy jelly pad colors.
enum CandyColor {
  pink,
  blue,
  green,
  yellow,
}

/// Type of debossed musical note on the candy pad.
enum NoteIconType {
  single, // ♪ single eighth note
  double, // ♫ beamed double eighth notes
}

/// Palette tokens for a specific candy hue.
class CandyPalette {
  final Color surfaceTop;
  final Color surfaceBottom;
  final Color highlight;
  final Color bottomRim;
  final Color debossShadow;
  final Color debossHighlight;

  const CandyPalette({
    required this.surfaceTop,
    required this.surfaceBottom,
    required this.highlight,
    required this.bottomRim,
    required this.debossShadow,
    required this.debossHighlight,
  });

  static const pink = CandyPalette(
    surfaceTop: Color(0xFFFF5AA8),
    surfaceBottom: Color(0xFFFF2584),
    highlight: Color(0xFFFFB3D9),
    bottomRim: Color(0xFFC70058),
    debossShadow: Color(0xFFA60045),
    debossHighlight: Color(0xFFFF99C8),
  );

  static const blue = CandyPalette(
    surfaceTop: Color(0xFF38C8FF),
    surfaceBottom: Color(0xFF0099F8),
    highlight: Color(0xFF94E3FF),
    bottomRim: Color(0xFF006CB7),
    debossShadow: Color(0xFF005896),
    debossHighlight: Color(0xFF6BD5FF),
  );

  static const green = CandyPalette(
    surfaceTop: Color(0xFF8CE81E),
    surfaceBottom: Color(0xFF64D200),
    highlight: Color(0xFFC8FA6A),
    bottomRim: Color(0xFF408A00),
    debossShadow: Color(0xFF357000),
    debossHighlight: Color(0xFFA8F33B),
  );

  static const yellow = CandyPalette(
    surfaceTop: Color(0xFFFFD533),
    surfaceBottom: Color(0xFFFFB300),
    highlight: Color(0xFFFFEC85),
    bottomRim: Color(0xFFC67700),
    debossShadow: Color(0xFFA45E00),
    debossHighlight: Color(0xFFFFE05C),
  );

  static CandyPalette fromColor(CandyColor color) {
    switch (color) {
      case CandyColor.pink:
        return pink;
      case CandyColor.blue:
        return blue;
      case CandyColor.green:
        return green;
      case CandyColor.yellow:
        return yellow;
    }
  }
}

/// Static pattern of 5 rows x 4 columns = 20 pads exactly matching the user's mockup.
abstract final class CandyPadLayout {
  static const List<(CandyColor, NoteIconType)> layout20 = [
    // Row 0 (Top): Pink(♫), Blue(♫), Green(♪), Yellow(♪)
    (CandyColor.pink, NoteIconType.double),
    (CandyColor.blue, NoteIconType.double),
    (CandyColor.green, NoteIconType.single),
    (CandyColor.yellow, NoteIconType.single),

    // Row 1: Blue(♪), Pink(♫), Blue(♪), Yellow(♫)
    (CandyColor.blue, NoteIconType.single),
    (CandyColor.pink, NoteIconType.double),
    (CandyColor.blue, NoteIconType.single),
    (CandyColor.yellow, NoteIconType.double),

    // Row 2: Green(♫), Yellow(♫), Pink(♫), Blue(♪)
    (CandyColor.green, NoteIconType.double),
    (CandyColor.yellow, NoteIconType.double),
    (CandyColor.pink, NoteIconType.double),
    (CandyColor.blue, NoteIconType.single),

    // Row 3: Yellow(♪), Green(♫), Blue(♪), Pink(♫)
    (CandyColor.yellow, NoteIconType.single),
    (CandyColor.green, NoteIconType.double),
    (CandyColor.blue, NoteIconType.single),
    (CandyColor.pink, NoteIconType.double),

    // Row 4 (Bottom): Blue(♪), Green(♫), Yellow(♪), Yellow(♪)
    (CandyColor.blue, NoteIconType.single),
    (CandyColor.green, NoteIconType.double),
    (CandyColor.yellow, NoteIconType.single),
    (CandyColor.yellow, NoteIconType.single),
  ];

  static (CandyColor, NoteIconType) getPadStyle(int index) {
    if (index >= 0 && index < layout20.length) {
      return layout20[index];
    }
    // Fallback cyclic pattern
    final color = CandyColor.values[index % CandyColor.values.length];
    final icon = (index % 2 == 0) ? NoteIconType.single : NoteIconType.double;
    return (color, icon);
  }
}

