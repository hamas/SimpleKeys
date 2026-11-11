import 'package:flutter_test/flutter_test.dart';
import 'package:simplekeys/core/constants/piano_notes.dart';
import 'package:simplekeys/state/keyboard_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  group('KeyboardLayout Zero-Allocation Cache', () {
    test('Layout precomputes immutable white and black note lists and preceding indices', () {
      final controller = KeyboardController();
      final layout = controller.layout;

      expect(layout.whiteNotes.length, 15);
      expect(layout.blackNotes.length, 10);
      expect(layout.blackToPrecedingWhiteIndex.length, 10);

      // Verify that C#3 (first black key) maps to C3 (white key index 0)
      final cSharp3 = layout.blackNotes.first;
      expect(cSharp3.name, 'C#');
      expect(layout.blackToPrecedingWhiteIndex[cSharp3], 0);
    });
  });

  group('KeyboardController State & Multi-Touch', () {
    test('Octave shift changes visible notes and updates layout', () {
      final controller = KeyboardController();
      expect(controller.baseOctave, 3);
      expect(controller.notes.first.label, 'C3');

      controller.shiftOctaveUp();
      expect(controller.baseOctave, 4);
      expect(controller.notes.first.label, 'C4');
      expect(controller.layout.whiteNotes.first.label, 'C4');

      controller.shiftOctaveDown();
      expect(controller.baseOctave, 3);
      expect(controller.notes.first.label, 'C3');
    });

    test('Pointer down, move, and up tracks pressed MIDI notes with velocity', () {
      final controller = KeyboardController();
      final note1 = controller.notes.first; // C3
      final note2 = controller.notes[2];    // D3

      // Pointer 1 strikes C3 with velocity
      controller.handlePointerDown(1, note1, velocity: 0.85);
      expect(controller.pressedMidiNotes.contains(note1.midiNumber), isTrue);

      // Pointer 2 strikes D3 simultaneously (multi-touch)
      controller.handlePointerDown(2, note2, velocity: 0.95);
      expect(controller.pressedMidiNotes.contains(note1.midiNumber), isTrue);
      expect(controller.pressedMidiNotes.contains(note2.midiNumber), isTrue);

      // Pointer 1 lifts
      controller.handlePointerUp(1);
      expect(controller.pressedMidiNotes.contains(note1.midiNumber), isFalse);
      expect(controller.pressedMidiNotes.contains(note2.midiNumber), isTrue);

      // Pointer 2 lifts
      controller.handlePointerUp(2);
      expect(controller.pressedMidiNotes.isEmpty, isTrue);
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
  });
}
