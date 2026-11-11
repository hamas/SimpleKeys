import 'package:flutter_test/flutter_test.dart';
import 'package:simplekeys/core/audio/sound_presets.dart';
import 'package:simplekeys/core/constants/piano_notes.dart';
import 'package:simplekeys/presentation/widgets/candy_pad_style.dart';
import 'package:simplekeys/state/keyboard_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('4x5 Isomorphic Pad Grid Geometry & Note Mapping', () {
    test('generateIsomorphicGridNotes generates exactly 20 notes arranged in 5 rows', () {
      final notes20 = PianoNotes.generateIsomorphicGridNotes(baseOctave: 3, rows: 5);
      expect(notes20.length, 20);

      // Row 5 (Top): E5, F5, G5, A5 (indices 0..3)
      expect(notes20[0].label, 'E5');
      expect(notes20[1].label, 'F5');
      expect(notes20[2].label, 'G5');
      expect(notes20[3].label, 'A5');

      // Row 4: A4, B4, C5, D5 (indices 4..7)
      expect(notes20[4].label, 'A4');
      expect(notes20[5].label, 'B4');
      expect(notes20[6].label, 'C5');
      expect(notes20[7].label, 'D5');

      // Row 3: D4, E4, F4, G4 (indices 8..11)
      expect(notes20[8].label, 'D4');
      expect(notes20[9].label, 'E4');
      expect(notes20[10].label, 'F4');
      expect(notes20[11].label, 'G4');

      // Row 2: G3, A3, B3, C4 (indices 12..15)
      expect(notes20[12].label, 'G3');
      expect(notes20[13].label, 'A3');
      expect(notes20[14].label, 'B3');
      expect(notes20[15].label, 'C4');

      // Row 1 (Bottom): C3, D3, E3, F3 (indices 16..19)
      expect(notes20[16].label, 'C3');
      expect(notes20[17].label, 'D3');
      expect(notes20[18].label, 'E3');
      expect(notes20[19].label, 'F3');
    });

    test('Base octave shift correctly updates isomorphic pad pitch frequencies', () {
      final notesOctave2 = PianoNotes.generateIsomorphicGridNotes(baseOctave: 2, rows: 5);
      final notesOctave4 = PianoNotes.generateIsomorphicGridNotes(baseOctave: 4, rows: 5);

      expect(notesOctave2[16].label, 'C2');
      expect(notesOctave4[16].label, 'C4');
      expect(notesOctave4[16].midiNumber - notesOctave2[16].midiNumber, 24);
    });

    test('CandyPadLayout static pattern provides 20 distinct color and note icon styles', () {
      expect(CandyPadLayout.layout20.length, 20);

      // Verify row 0 top edge
      final pad0 = CandyPadLayout.getPadStyle(0);
      expect(pad0.$1, CandyColor.pink);
      expect(pad0.$2, NoteIconType.double);

      final pad1 = CandyPadLayout.getPadStyle(1);
      expect(pad1.$1, CandyColor.blue);
      expect(pad1.$2, NoteIconType.double);
    });
  });

  group('Modes System: Play vs Teach Mode', () {
    test('Defaults to Play mode and toggles to Teach mode', () {
      final controller = KeyboardController();
      expect(controller.appMode, AppMode.play);

      controller.toggleAppMode();
      expect(controller.appMode, AppMode.teach);

      controller.toggleAppMode();
      expect(controller.appMode, AppMode.play);
    });

    test('Teach Mode identifies target note and advances only on correct key hit', () {
      final controller = KeyboardController();
      controller.setAppMode(AppMode.teach);

      // Initial lesson is C Major Scale, first step is C
      expect(controller.currentLesson.title, 'C Major Scale');
      expect(controller.lessonStepIndex, 0);
      expect(controller.currentTargetStep?.noteName, 'C');

      final cNote = controller.isomorphicNotes.firstWhere((n) => n.name == 'C');
      final dNote = controller.isomorphicNotes.firstWhere((n) => n.name == 'D');

      expect(controller.isNoteTargetedInTeach(cNote), isTrue);
      expect(controller.isNoteTargetedInTeach(dNote), isFalse);

      final initialScore = controller.score;
      final initialLives = controller.lives;

      // Striking wrong note does NOT advance sequencer and reduces lives
      controller.handlePointerDown(1, dNote);
      controller.handlePointerUp(1);
      expect(controller.lessonStepIndex, 0);
      expect(controller.lives, initialLives - 1);

      // Striking correct note (C) advances to step 1 (D) and adds 100 points
      controller.handlePointerDown(2, cNote);
      controller.handlePointerUp(2);
      expect(controller.lessonStepIndex, 1);
      expect(controller.currentTargetStep?.noteName, 'D');
      expect(controller.isNoteTargetedInTeach(dNote), isTrue);
      expect(controller.score, initialScore + 100);
    });
  });

  group('Game Stats & Formatting', () {
    test('formattedScore formats numbers with leading zeros and comma', () {
      final controller = KeyboardController();
      expect(controller.formattedScore, '02,840');

      controller.addScore(100);
      expect(controller.formattedScore, '02,940');
    });

    test('Level progression', () {
      final controller = KeyboardController();
      expect(controller.level, 1);
      controller.nextLevel();
      expect(controller.level, 2);
    });
  });

  group('Utility States: Notation, Sustain, Sound Presets', () {
    test('ABC vs DoReMi notation formatting', () {
      final controller = KeyboardController();
      final c3 = controller.isomorphicNotes.firstWhere((n) => n.label == 'C3');

      expect(controller.notation, NoteNotation.scientific);
      expect(controller.getFormattedNoteLabel(c3), 'C3');

      controller.toggleNotation();
      expect(controller.notation, NoteNotation.solfege);
      expect(controller.getFormattedNoteLabel(c3), 'Do3');
    });

    test('Sustain toggle', () {
      final controller = KeyboardController();
      expect(controller.isSustainEnabled, isTrue);
      controller.toggleSustain();
      expect(controller.isSustainEnabled, isFalse);
    });

    test('Sound preset switching', () {
      final controller = KeyboardController();
      expect(controller.soundPreset, SoundBankType.feltPiano);

      controller.setSoundPreset(SoundBankType.musicBox);
      expect(controller.soundPreset, SoundBankType.musicBox);

      controller.setSoundPreset(SoundBankType.dreamPad);
      expect(controller.soundPreset, SoundBankType.dreamPad);
    });
  });
}
