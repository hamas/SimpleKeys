import 'package:flutter_test/flutter_test.dart';
import 'package:simplekeys/core/constants/chord_detector.dart';
import 'package:simplekeys/core/constants/piano_notes.dart';
import 'package:simplekeys/state/keyboard_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('4x4 Isomorphic Pad Grid Geometry & Note Mapping', () {
    test('generateIsomorphicGridNotes generates exactly 16 notes arranged in 4 rows', () {
      final notes = PianoNotes.generateIsomorphicGridNotes(baseOctave: 3);
      expect(notes.length, 16);

      // Row 4 (Top): A4, B4, C5, D5 (indices 0..3)
      expect(notes[0].label, 'A4');
      expect(notes[1].label, 'B4');
      expect(notes[2].label, 'C5');
      expect(notes[3].label, 'D5');

      // Row 3: D4, E4, F4, G4 (indices 4..7)
      expect(notes[4].label, 'D4');
      expect(notes[5].label, 'E4');
      expect(notes[6].label, 'F4');
      expect(notes[7].label, 'G4');

      // Row 2: G3, A3, B3, C4 (indices 8..11)
      expect(notes[8].label, 'G3');
      expect(notes[9].label, 'A3');
      expect(notes[10].label, 'B3');
      expect(notes[11].label, 'C4');

      // Row 1 (Bottom): C3, D3, E3, F3 (indices 12..15)
      expect(notes[12].label, 'C3');
      expect(notes[13].label, 'D3');
      expect(notes[14].label, 'E3');
      expect(notes[15].label, 'F3');
    });

    test('Root notes (all "C"s) are identified accurately as anchors', () {
      final notes = PianoNotes.generateIsomorphicGridNotes(baseOctave: 3);
      final cNotes = notes.where((n) => n.name == 'C').toList();

      expect(cNotes.length, 3);
      expect(cNotes.map((n) => n.label).toList(), containsAll(['C3', 'C4', 'C5']));
    });

    test('Base octave shift correctly updates isomorphic pad pitch frequencies', () {
      final notesOctave2 = PianoNotes.generateIsomorphicGridNotes(baseOctave: 2);
      final notesOctave4 = PianoNotes.generateIsomorphicGridNotes(baseOctave: 4);

      // Row 1 start note shifts from C2 to C4
      expect(notesOctave2[12].label, 'C2');
      expect(notesOctave4[12].label, 'C4');
      expect(notesOctave4[12].midiNumber - notesOctave2[12].midiNumber, 24); // 2 octaves = 24 semitones
    });
  });

  group('PianoNotes & Scales', () {
    test('generateNotes generates 2 octaves plus ending root C (25 keys total)', () {
      final notes = PianoNotes.generateNotes(startOctave: 3, octaveCount: 2);
      expect(notes.length, 25);

      final whiteNotes = notes.where((n) => !n.isAccidental).toList();
      final blackNotes = notes.where((n) => n.isAccidental).toList();

      expect(whiteNotes.length, 15); // 7 * 2 + 1 ending C
      expect(blackNotes.length, 10); // 5 * 2
      expect(notes.first.label, 'C3');
      expect(notes.last.label, 'C5');
    });

    test('generateNotes generates 1 octave plus ending root C (13 keys total for portrait)', () {
      final notes = PianoNotes.generateNotes(startOctave: 3, octaveCount: 1);
      expect(notes.length, 13);

      final whiteNotes = notes.where((n) => !n.isAccidental).toList();
      final blackNotes = notes.where((n) => n.isAccidental).toList();

      expect(whiteNotes.length, 8); // 7 + 1 ending C
      expect(blackNotes.length, 5);
      expect(notes.first.label, 'C3');
      expect(notes.last.label, 'C4');
    });

    test('isInMagicScale filters out dissonant semitones (F and B in C Major Pentatonic)', () {
      final notes = PianoNotes.generateNotes(startOctave: 4, octaveCount: 1, includeEndingRoot: false);
      final c4 = notes.firstWhere((n) => n.name == 'C');
      final d4 = notes.firstWhere((n) => n.name == 'D');
      final e4 = notes.firstWhere((n) => n.name == 'E');
      final f4 = notes.firstWhere((n) => n.name == 'F');
      final g4 = notes.firstWhere((n) => n.name == 'G');
      final a4 = notes.firstWhere((n) => n.name == 'A');
      final b4 = notes.firstWhere((n) => n.name == 'B');

      expect(PianoNotes.isInMagicScale(c4), isTrue);
      expect(PianoNotes.isInMagicScale(d4), isTrue);
      expect(PianoNotes.isInMagicScale(e4), isTrue);
      expect(PianoNotes.isInMagicScale(f4), isFalse); // Dissonant half-step omitted
      expect(PianoNotes.isInMagicScale(g4), isTrue);
      expect(PianoNotes.isInMagicScale(a4), isTrue);
      expect(PianoNotes.isInMagicScale(b4), isFalse); // Leading tone half-step omitted
    });
  });

  group('ChordDetector', () {
    test('detects single note, intervals, and triads accurately', () {
      expect(ChordDetector.detectChord({}), 'Tap or slide keys');
      expect(ChordDetector.detectChord({60}), 'C4'); // Middle C
      expect(ChordDetector.detectChord({60, 67}), 'C + G • Perfect 5th');
      expect(ChordDetector.detectChord({60, 64, 67}), 'C Major'); // C-E-G
      expect(ChordDetector.detectChord({57, 60, 64}), 'A Minor'); // A-C-E
    });
  });

  group('KeyboardLayout Zero-Allocation Cache', () {
    test('Layout precomputes immutable white and black note lists for pianoKeys mode', () {
      final controller = KeyboardController();
      controller.setKeyboardMode(KeyboardMode.pianoKeys);

      // Default is 2 octaves (15 white keys, 10 black keys)
      expect(controller.layout.whiteNotes.length, 15);
      expect(controller.layout.blackNotes.length, 10);
      expect(controller.layout.blackToPrecedingWhiteIndex.length, 10);

      // Can switch to 1 octave
      controller.setOctaveSpan(1);
      expect(controller.layout.whiteNotes.length, 8);
      expect(controller.layout.blackNotes.length, 5);

      // Verify that C#3 (first black key) maps to C3 (white key index 0)
      final cSharp3 = controller.layout.blackNotes.first;
      expect(cSharp3.name, 'C#');
      expect(controller.layout.blackToPrecedingWhiteIndex[cSharp3], 0);
    });
  });

  group('KeyboardController State & Multi-Touch', () {
    test('Defaults to isomorphic pad grid mode with 16 notes', () {
      final controller = KeyboardController();
      expect(controller.keyboardMode, KeyboardMode.isomorphicGrid);
      expect(controller.notes.length, 16);
      expect(controller.octaveRangeLabel, 'C3 – D5');
    });

    test('Octave shift changes visible notes and updates layout', () {
      final controller = KeyboardController();
      expect(controller.baseOctave, 3);
      expect(controller.octaveRangeLabel, 'C3 – D5');

      controller.shiftOctaveUp();
      expect(controller.baseOctave, 4);
      expect(controller.octaveRangeLabel, 'C4 – D6');

      controller.shiftOctaveDown();
      expect(controller.baseOctave, 3);
      expect(controller.octaveRangeLabel, 'C3 – D5');
    });

    test('Pointer down, move, and up tracks pressed MIDI notes and updates active chord', () {
      final controller = KeyboardController();
      // In 4x4 isomorphic grid, C3 is note at index 12, G3 is note at index 8
      final c3 = controller.notes.firstWhere((n) => n.label == 'C3');
      final g3 = controller.notes.firstWhere((n) => n.label == 'G3');

      // Pointer 1 strikes C3 with velocity
      controller.handlePointerDown(1, c3, velocity: 0.85);
      expect(controller.pressedMidiNotes.contains(c3.midiNumber), isTrue);
      expect(controller.activeChord, 'C3');

      // Pointer 2 strikes G3 simultaneously (multi-touch 5th interval)
      controller.handlePointerDown(2, g3, velocity: 0.95);
      expect(controller.pressedMidiNotes.contains(c3.midiNumber), isTrue);
      expect(controller.pressedMidiNotes.contains(g3.midiNumber), isTrue);
      expect(controller.activeChord, contains('Perfect 5th'));

      // Pointer 1 lifts
      controller.handlePointerUp(1);
      expect(controller.pressedMidiNotes.contains(c3.midiNumber), isFalse);
      expect(controller.pressedMidiNotes.contains(g3.midiNumber), isTrue);

      // Pointer 2 lifts
      controller.handlePointerUp(2);
      expect(controller.pressedMidiNotes.isEmpty, isTrue);
      expect(controller.activeChord, 'Tap or slide keys');
    });

    test('Sustain pedal toggle updates mode', () {
      final controller = KeyboardController();
      expect(controller.isSustainEnabled, isTrue);

      controller.toggleSustain();
      expect(controller.isSustainEnabled, isFalse);

      controller.toggleSustain();
      expect(controller.isSustainEnabled, isTrue);
    });

    test('Magic Scale disables discordant notes from being struck', () {
      final controller = KeyboardController();
      controller.toggleMagicScale();
      expect(controller.isMagicScale, isTrue);

      final fNote = controller.notes.firstWhere((n) => n.name == 'F');
      expect(controller.isNotePlayable(fNote), isFalse);

      controller.handlePointerDown(1, fNote);
      expect(controller.pressedMidiNotes.contains(fNote.midiNumber), isFalse);
    });

    test('Switching keyboard mode toggles between grid and piano keys', () {
      final controller = KeyboardController();
      expect(controller.keyboardMode, KeyboardMode.isomorphicGrid);
      expect(controller.notes.length, 16);

      controller.toggleKeyboardMode();
      expect(controller.keyboardMode, KeyboardMode.pianoKeys);
      expect(controller.notes.length, 25);
      expect(controller.octaveRangeLabel, 'C3 – C5');

      controller.toggleKeyboardMode();
      expect(controller.keyboardMode, KeyboardMode.isomorphicGrid);
      expect(controller.notes.length, 16);
    });
  });
}
