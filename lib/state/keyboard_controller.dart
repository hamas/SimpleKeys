import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../core/audio/audio_engine.dart';
import '../core/audio/sound_presets.dart';
import '../core/constants/piano_notes.dart';
import '../models/key_note.dart';

/// Lightweight controller managing keyboard state, active octaves, presets, and multi-touch pointer routing.
class KeyboardController extends ChangeNotifier {
  final AudioEngine _audioEngine;

  KeyboardController({AudioEngine? audioEngine})
      : _audioEngine = audioEngine ?? AudioEngine.instance {
    _refreshNotes();
  }

  int _baseOctave = 3;
  int get baseOctave => _baseOctave;

  SoundBankType _soundPreset = SoundBankType.feltPiano;
  SoundBankType get soundPreset => _soundPreset;

  bool _isMagicScale = false;
  bool get isMagicScale => _isMagicScale;

  List<KeyNote> _notes = const [];
  List<KeyNote> get notes => _notes;

  /// Currently depressed MIDI notes (for visual glow / depressed state).
  final Set<int> _pressedMidiNotes = {};
  Set<int> get pressedMidiNotes => Set.unmodifiable(_pressedMidiNotes);

  /// Map of active pointer IDs to their currently triggered MIDI note number.
  final Map<int, int> _pointerToMidi = {};

  bool _isAudioReady = false;
  bool get isAudioReady => _isAudioReady;

  /// Initializes audio engine and preloads initial sound bank.
  Future<void> initializeAudio() async {
    await _audioEngine.initialize();
    await _reloadSoundBank();
    _isAudioReady = true;
    notifyListeners();
  }

  void _refreshNotes() {
    _notes = PianoNotes.generateNotes(
      startOctave: _baseOctave,
      octaveCount: 2,
      includeEndingRoot: true, // e.g. C3 through C5 (25 keys: 15 white, 10 black)
    );
  }

  Future<void> _reloadSoundBank() async {
    await _audioEngine.loadSoundBank(
      notes: _notes,
      preset: _soundPreset,
    );
  }

  /// Shift visible octave up (max base octave 5).
  void shiftOctaveUp() {
    if (_baseOctave >= 5) return;
    _baseOctave++;
    _refreshNotes();
    _reloadSoundBank();
    notifyListeners();
  }

  /// Shift visible octave down (min base octave 2).
  void shiftOctaveDown() {
    if (_baseOctave <= 2) return;
    _baseOctave--;
    _refreshNotes();
    _reloadSoundBank();
    notifyListeners();
  }

  /// Switch the active instrument sound preset.
  void setSoundPreset(SoundBankType preset) {
    if (_soundPreset == preset) return;
    _soundPreset = preset;
    _reloadSoundBank();
    notifyListeners();
  }

  /// Toggles the "Magic Scale" (Harmonic Pentatonic lock).
  void toggleMagicScale() {
    _isMagicScale = !_isMagicScale;
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  /// Check whether a note is playable in the current scale mode.
  bool isNotePlayable(KeyNote note) {
    if (!_isMagicScale) return true;
    return PianoNotes.isInMagicScale(note);
  }

  /// Called when a pointer hits a key.
  void handlePointerDown(int pointerId, KeyNote note) {
    if (!isNotePlayable(note)) return;

    _pointerToMidi[pointerId] = note.midiNumber;
    _pressedMidiNotes.add(note.midiNumber);

    HapticFeedback.selectionClick();
    _audioEngine.playNote(note.midiNumber);

    notifyListeners();
  }

  /// Called when a pointer drags across the keyboard (glissando/slide).
  void handlePointerMove(int pointerId, KeyNote? newNote) {
    final currentMidi = _pointerToMidi[pointerId];

    if (newNote == null || !isNotePlayable(newNote)) {
      if (currentMidi != null) {
        _pointerToMidi.remove(pointerId);
        _recalculatePressedNotes();
        notifyListeners();
      }
      return;
    }

    if (currentMidi != newNote.midiNumber) {
      _pointerToMidi[pointerId] = newNote.midiNumber;
      _pressedMidiNotes.add(newNote.midiNumber);

      HapticFeedback.selectionClick();
      _audioEngine.playNote(newNote.midiNumber);

      _recalculatePressedNotes();
      notifyListeners();
    }
  }

  /// Called when a pointer is lifted or canceled.
  void handlePointerUp(int pointerId) {
    if (_pointerToMidi.containsKey(pointerId)) {
      _pointerToMidi.remove(pointerId);
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

