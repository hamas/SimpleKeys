import 'dart:math' as math;

/// Represents a single piano key note with its musical pitch, frequency, and geometry metadata.
class KeyNote {
  final String name;
  final int octave;
  final int midiNumber;
  final double frequency;
  final bool isAccidental;
  final int semitoneInOctave; // 0 (C) through 11 (B)
  final int? whiteKeyIndex;

  const KeyNote({
    required this.name,
    required this.octave,
    required this.midiNumber,
    required this.frequency,
    required this.isAccidental,
    required this.semitoneInOctave,
    this.whiteKeyIndex,
  });

  /// Full display label, e.g. "C4" or "F#3".
  String get label => '$name$octave';

  /// Base natural note letter without accidental symbol, e.g. "C", "F".
  String get naturalName => name.replaceAll('#', '');

  /// Factory to compute pitch frequency from MIDI number.
  /// Standard concert pitch A4 = MIDI 69 = 440 Hz.
  static double midiToFrequency(int midi) {
    return 440.0 * math.pow(2.0, (midi - 69) / 12.0);
  }

  KeyNote copyWith({
    String? name,
    int? octave,
    int? midiNumber,
    double? frequency,
    bool? isAccidental,
    int? semitoneInOctave,
    int? whiteKeyIndex,
  }) {
    return KeyNote(
      name: name ?? this.name,
      octave: octave ?? this.octave,
      midiNumber: midiNumber ?? this.midiNumber,
      frequency: frequency ?? this.frequency,
      isAccidental: isAccidental ?? this.isAccidental,
      semitoneInOctave: semitoneInOctave ?? this.semitoneInOctave,
      whiteKeyIndex: whiteKeyIndex ?? this.whiteKeyIndex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeyNote &&
          runtimeType == other.runtimeType &&
          midiNumber == other.midiNumber;

  @override
  int get hashCode => midiNumber.hashCode;

  @override
  String toString() => 'KeyNote($label, midi: $midiNumber, freq: ${frequency.toStringAsFixed(1)}Hz)';
}
