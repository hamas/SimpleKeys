import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../core/audio/audio_engine.dart';
import '../core/audio/sound_presets.dart';
import '../core/constants/piano_notes.dart';
import '../core/lessons/tutorial_lessons.dart';
import '../models/key_note.dart';

/// App operation mode: Free Play vs Assisted Learning.
enum AppMode {
  play,
  teach,
}

/// Note naming convention: Scientific Pitch ("ABC") vs Solfège ("DoReMi").
enum NoteNotation {
  scientific,
  solfege,
}

/// Central controller managing 4x5 candy pad audio routing,
/// assisted Teach mode lesson progression, and game stats.
class KeyboardController extends ChangeNotifier {
  final AudioEngine _audioEngine;

  KeyboardController({AudioEngine? audioEngine})
      : _audioEngine = audioEngine ?? AudioEngine.instance {
    _refreshNotes();
  }

  // --- Octaves & Notes ---
  int _baseOctave = 3;
  int get baseOctave => _baseOctave;

  late List<KeyNote> _isomorphicNotes;
  List<KeyNote> get isomorphicNotes => _isomorphicNotes;

  // --- Sound & Pitch Configuration ---
  SoundBankType _soundPreset = SoundBankType.feltPiano;
  SoundBankType get soundPreset => _soundPreset;

  bool _isSustainEnabled = true;
  bool get isSustainEnabled => _isSustainEnabled;

  NoteNotation _notation = NoteNotation.scientific;
  NoteNotation get notation => _notation;

  // --- Modes & Lessons ---
  AppMode _appMode = AppMode.play;
  AppMode get appMode => _appMode;

  TutorialSong _currentLesson = TutorialSong.sampleSongs[0];
  TutorialSong get currentLesson => _currentLesson;

  int _lessonStepIndex = 0;
  int get lessonStepIndex => _lessonStepIndex;

  LessonStep? get currentTargetStep =>
      (_appMode == AppMode.teach && _lessonStepIndex < _currentLesson.steps.length)
          ? _currentLesson.steps[_lessonStepIndex]
          : null;

  // --- Candy Game Stats ---
  int _score = 2840;
  int get score => _score;
  String get formattedScore {
    final s = _score.toString().padLeft(5, '0');
    if (s.length >= 5) {
      return '${s.substring(0, 2)},${s.substring(2)}';
    }
    return s;
  }

  int _lives = 5;
  int get lives => _lives;

  int _level = 1;
  int get level => _level;

  // --- Pressed Notes Tracking ---
  final Set<int> _pressedMidiNotes = {};
  Set<int> get pressedMidiNotes => Set.unmodifiable(_pressedMidiNotes);

  final Map<int, int> _pointerToMidi = {};

  bool _isAudioReady = false;
  bool get isAudioReady => _isAudioReady;

  /// Initializes the audio engine and preloads the initial sound bank.
  Future<void> initializeAudio() async {
    await _audioEngine.initialize();
    await _reloadSoundBank();
    _isAudioReady = true;
    notifyListeners();
  }

  void _refreshNotes() {
    _isomorphicNotes = PianoNotes.generateIsomorphicGridNotes(
      baseOctave: _baseOctave,
      rows: 5,
    );
  }

  Future<void> _reloadSoundBank() async {
    await _audioEngine.loadSoundBank(
      notes: _isomorphicNotes,
      preset: _soundPreset,
    );
  }

  // --- State Modifiers ---
  void setAppMode(AppMode mode) {
    if (_appMode == mode) return;
    _appMode = mode;
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  void toggleAppMode() {
    setAppMode(_appMode == AppMode.play ? AppMode.teach : AppMode.play);
  }

  void toggleNotation() {
    _notation = _notation == NoteNotation.scientific
        ? NoteNotation.solfege
        : NoteNotation.scientific;
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  void toggleSustain() {
    _isSustainEnabled = !_isSustainEnabled;
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  void setSoundPreset(SoundBankType preset) {
    if (_soundPreset == preset) return;
    _soundPreset = preset;
    unawaited(_reloadSoundBank());
    notifyListeners();
  }

  void setLesson(TutorialSong song) {
    _currentLesson = song;
    _lessonStepIndex = 0;
    notifyListeners();
  }

  void resetLesson() {
    _lessonStepIndex = 0;
    notifyListeners();
  }

  void shiftOctaveUp() {
    if (_baseOctave >= 4) return;
    _baseOctave++;
    _refreshNotes();
    unawaited(_reloadSoundBank());
    notifyListeners();
  }

  void shiftOctaveDown() {
    if (_baseOctave <= 2) return;
    _baseOctave--;
    _refreshNotes();
    unawaited(_reloadSoundBank());
    notifyListeners();
  }

  void nextLevel() {
    _level++;
    notifyListeners();
  }

  void addScore(int points) {
    _score += points;
    notifyListeners();
  }

  void nextLevel() {
    _level++;
    notifyListeners();
  }

  void addScore(int points) {
    _score += points;
    notifyListeners();
  }

  /// Checks if a note is currently targeted in Teach mode.
  bool isNoteTargetedInTeach(KeyNote note) {
    if (_appMode != AppMode.teach) return false;
    final target = currentTargetStep;
    if (target == null) return false;
    if (target.preferredOctave != null) {
      return target.noteName == note.name && target.preferredOctave == note.octave;
    }
    return target.noteName == note.name;
  }

  /// Formatted note label (e.g., "C3" or "Do3").
  String getFormattedNoteLabel(KeyNote note) {
    if (_notation == NoteNotation.solfege) {
      return PianoNotes.toSolfege(note.name, note.octave);
    }
    return note.label;
  }

  bool isNotePlayable(KeyNote note) => true;

  // --- Multi-Touch Event Routing ---
  void handlePointerDown(int pointerId, KeyNote note, {double velocity = 1.0}) {
    // Check Teach Mode progression
    if (_appMode == AppMode.teach && isNoteTargetedInTeach(note)) {
      _lessonStepIndex = (_lessonStepIndex + 1) % _currentLesson.steps.length;
      _score += 100;
    } else if (_appMode == AppMode.teach && !isNoteTargetedInTeach(note)) {
      if (_lives > 1) {
        _lives--;
      }
    } else {
      _score += 10;
    }

    _pointerToMidi[pointerId] = note.midiNumber;
    _pressedMidiNotes.add(note.midiNumber);

    _audioEngine.playNote(note.midiNumber, volume: velocity);
    notifyListeners();
  }

  void handlePointerMove(int pointerId, KeyNote? newNote, {double velocity = 1.0}) {
    final currentMidi = _pointerToMidi[pointerId];

    if (newNote == null) {
      if (currentMidi != null) {
        if (!_isSustainEnabled) {
          _audioEngine.stopNote(currentMidi);
        }
        _pointerToMidi.remove(pointerId);
        _recalculatePressedNotes();
        notifyListeners();
      }
      return;
    }

    if (currentMidi != newNote.midiNumber) {
      if (currentMidi != null) {
        if (!_isSustainEnabled) {
          _audioEngine.stopNote(currentMidi);
        }
      }

      // Check Teach Mode progression
      if (_appMode == AppMode.teach && isNoteTargetedInTeach(newNote)) {
        _lessonStepIndex = (_lessonStepIndex + 1) % _currentLesson.steps.length;
        _score += 100;
      }

      _pointerToMidi[pointerId] = newNote.midiNumber;
      _pressedMidiNotes.add(newNote.midiNumber);

      _audioEngine.playNote(newNote.midiNumber, volume: velocity);
      _recalculatePressedNotes();
      notifyListeners();
    }
  }

  void handlePointerUp(int pointerId) {
    final releasedMidi = _pointerToMidi.remove(pointerId);
    if (releasedMidi != null) {
      if (!_isSustainEnabled) {
        _audioEngine.stopNote(releasedMidi);
      }
      _recalculatePressedNotes();
      notifyListeners();
    }
  }

  void _recalculatePressedNotes() {
    _pressedMidiNotes.clear();
    _pressedMidiNotes.addAll(_pointerToMidi.values);
  }

  @override
  void dispose() {
    _audioEngine.dispose();
    super.dispose();
  }
}
