import 'piano_notes.dart';

/// Lightweight real-time chord & harmony analyzer for couch improvisation.
abstract final class ChordDetector {
  /// Analyzes a set of pressed MIDI note numbers and returns an expressive chord name.
  static String detectChord(Set<int> midiNotes) {
    if (midiNotes.isEmpty) return 'Tap or slide keys';

    final sorted = midiNotes.toList()..sort();
    if (sorted.length == 1) {
      final midi = sorted.first;
      final name = PianoNotes.noteNames[midi % 12];
      final octave = (midi ~/ 12) - 1;
      return '$name$octave';
    }

    if (sorted.length == 2) {
      final n1 = PianoNotes.noteNames[sorted[0] % 12];
      final n2 = PianoNotes.noteNames[sorted[1] % 12];
      final semitones = sorted[1] - sorted[0];
      final interval = switch (semitones % 12) {
        0 => 'Octave',
        1 => 'Minor 2nd',
        2 => 'Major 2nd',
        3 => 'Minor 3rd',
        4 => 'Major 3rd',
        5 => 'Perfect 4th',
        6 => 'Tritone',
        7 => 'Perfect 5th',
        8 => 'Minor 6th',
        9 => 'Major 6th',
        10 => 'Minor 7th',
        11 => 'Major 7th',
        _ => 'Dyad',
      };
      return '$n1 + $n2 • $interval';
    }

    // 3 or more notes: check chords relative to each possible root
    final pitchClasses = sorted.map((m) => m % 12).toSet();

    for (final root in pitchClasses) {
      final intervals = pitchClasses.map((p) => (p - root + 12) % 12).toSet();
      final rootName = PianoNotes.noteNames[root];

      // Triads
      if (intervals.containsAll({0, 4, 7})) {
        if (intervals.contains(11)) return '$rootName Maj7';
        if (intervals.contains(10)) return '$rootName Dominant 7';
        if (intervals.contains(9)) return '$rootName Major 6';
        if (intervals.contains(2)) return '$rootName add9';
        return '$rootName Major';
      }

      if (intervals.containsAll({0, 3, 7})) {
        if (intervals.contains(10)) return '$rootName Minor 7';
        if (intervals.contains(11)) return '$rootName Min/Maj7';
        if (intervals.contains(9)) return '$rootName Minor 6';
        return '$rootName Minor';
      }

      if (intervals.containsAll({0, 3, 6})) {
        if (intervals.contains(9)) return '$rootName Diminished 7';
        return '$rootName Diminished';
      }

      if (intervals.containsAll({0, 4, 8})) {
        return '$rootName Augmented';
      }

      if (intervals.containsAll({0, 5, 7})) {
        return '$rootName Sus4';
      }

      if (intervals.containsAll({0, 2, 7})) {
        return '$rootName Sus2';
      }
    }

    // Fallback: list active note names
    final names = pitchClasses.map((p) => PianoNotes.noteNames[p]).join(' • ');
    return names;
  }
}
