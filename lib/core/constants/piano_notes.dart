import '../../models/key_note.dart';

/// Musical pitch constants and isomorphic note matrix generators for SimpleKeys.
abstract final class PianoNotes {
  /// Chromatic scale pitch names in standard Scientific Pitch Notation.
  static const List<String> noteNames = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];

  /// Generates the notes for the isomorphic pad grid.
  /// Default: 5 rows x 4 columns = 20 pads (matching the candy game layout).
  /// Visual layout on screen from top to bottom:
  /// Row 5 (Top):    E5, F5, G5, A5 (for baseOctave=3)
  /// Row 4:          A4, B4, C5, D5
  /// Row 3:          D4, E4, F4, G4
  /// Row 2:          G3, A3, B3, C4
  /// Row 1 (Bottom): C3, D3, E3, F3
  static List<KeyNote> generateIsomorphicGridNotes({
    int baseOctave = 3,
    int rows = 5,
  }) {
    final List<List<(String, int)>> gridDefinitions = [
      if (rows >= 5)
        [
          ('E', baseOctave + 2),
          ('F', baseOctave + 2),
          ('G', baseOctave + 2),
          ('A', baseOctave + 2),
        ],
      [
        ('A', baseOctave + 1),
        ('B', baseOctave + 1),
        ('C', baseOctave + 2),
        ('D', baseOctave + 2),
      ],
      [
        ('D', baseOctave + 1),
        ('E', baseOctave + 1),
        ('F', baseOctave + 1),
        ('G', baseOctave + 1),
      ],
      [
        ('G', baseOctave),
        ('A', baseOctave),
        ('B', baseOctave),
        ('C', baseOctave + 1),
      ],
      [
        ('C', baseOctave),
        ('D', baseOctave),
        ('E', baseOctave),
        ('F', baseOctave),
      ],
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

  /// Solfège name mapping (Do, Re, Mi, Fa, Sol, La, Si).
  static const Map<String, String> solfegeNoteMap = {
    'C': 'Do',
    'C#': 'Do#',
    'D': 'Re',
    'D#': 'Re#',
    'E': 'Mi',
    'F': 'Fa',
    'F#': 'Fa#',
    'G': 'Sol',
    'G#': 'Sol#',
    'A': 'La',
    'A#': 'La#',
    'B': 'Si',
  };

  /// Returns note label formatted in Solfège (e.g., "Do3", "Fa#4").
  static String toSolfege(String noteName, int octave) {
    final base = solfegeNoteMap[noteName] ?? noteName;
    return '$base$octave';
  }
}
