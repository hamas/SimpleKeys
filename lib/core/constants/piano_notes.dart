import '../../models/key_note.dart';

/// Musical constants, scale definitions, and keyboard layout generators.
abstract final class PianoNotes {
  static const List<String> noteNames = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B',
  ];

  static const List<bool> accidentalPattern = [
    false, // C
    true,  // C#
    false, // D
    true,  // D#
    false, // E
    false, // F
    true,  // F#
    false, // G
    true,  // G#
    false, // A
    true,  // A#
    false, // B
  ];

  /// Standard C-Major Pentatonic semitone offsets (0=C, 2=D, 4=E, 7=G, 9=A).
  /// Excludes half-step clashes (F=5, B=11) and accidentals for zero-dissonance improv.
  static const Set<int> pentatonicSemitones = {0, 2, 4, 7, 9};

  /// Generates a list of [KeyNote]s starting at [startOctave] spanning [octaveCount] octaves,
  /// plus an optional closing root note (e.g., C3 to C5).
  static List<KeyNote> generateNotes({
    int startOctave = 3,
    int octaveCount = 2,
    bool includeEndingRoot = true,
  }) {
    final List<KeyNote> notes = [];
    int whiteKeyIndex = 0;

    for (int o = 0; o < octaveCount; o++) {
      final currentOctave = startOctave + o;
      for (int s = 0; s < 12; s++) {
        final midi = (currentOctave + 1) * 12 + s;
        final isAccidental = accidentalPattern[s];
        final freq = KeyNote.midiToFrequency(midi);

        notes.add(
          KeyNote(
            name: noteNames[s],
            octave: currentOctave,
            midiNumber: midi,
            frequency: freq,
            isAccidental: isAccidental,
            semitoneInOctave: s,
            whiteKeyIndex: isAccidental ? null : whiteKeyIndex++,
          ),
        );
      }
    }

    if (includeEndingRoot) {
      final endingOctave = startOctave + octaveCount;
      final endingMidi = (endingOctave + 1) * 12;
      notes.add(
        KeyNote(
          name: noteNames[0], // 'C'
          octave: endingOctave,
          midiNumber: endingMidi,
          frequency: KeyNote.midiToFrequency(endingMidi),
          isAccidental: false,
          semitoneInOctave: 0,
          whiteKeyIndex: whiteKeyIndex,
        ),
      );
    }

    return notes;
  }

  /// Generates the 16 notes for the 4x4 isomorphic pad grid.
  /// Visual layout on screen from top to bottom:
  /// Row 4 (Top):    A4, B4, C5, D5 (for baseOctave=3)
  /// Row 3:          D4, E4, F4, G4
  /// Row 2:          G3, A3, B3, C4
  /// Row 1 (Bottom): C3, D3, E3, F3
  static List<KeyNote> generateIsomorphicGridNotes({int baseOctave = 3}) {
    final gridDefinitions = [
      // Row 4 (Top)
      [('A', baseOctave + 1), ('B', baseOctave + 1), ('C', baseOctave + 2), ('D', baseOctave + 2)],
      // Row 3
      [('D', baseOctave + 1), ('E', baseOctave + 1), ('F', baseOctave + 1), ('G', baseOctave + 1)],
      // Row 2
      [('G', baseOctave), ('A', baseOctave), ('B', baseOctave), ('C', baseOctave + 1)],
      // Row 1 (Bottom)
      [('C', baseOctave), ('D', baseOctave), ('E', baseOctave), ('F', baseOctave)],
    ];

    final List<KeyNote> notes = [];
    for (final row in gridDefinitions) {
      for (final entry in row) {
        final name = entry.$1;
        final octave = entry.$2;
        final semitone = noteNames.indexOf(name);
        final midi = (octave + 1) * 12 + semitone;
        notes.add(
          KeyNote(
            name: name,
            octave: octave,
            midiNumber: midi,
            frequency: KeyNote.midiToFrequency(midi),
            isAccidental: false,
            semitoneInOctave: semitone,
          ),
        );
      }
    }
    return notes;
  }

  /// Checks if a note fits within the active Magic Scale filter.
  static bool isInMagicScale(KeyNote note, {int rootSemitone = 0}) {
    final relativeSemitone = (note.semitoneInOctave - rootSemitone + 12) % 12;
    return pentatonicSemitones.contains(relativeSemitone);
  }
}

