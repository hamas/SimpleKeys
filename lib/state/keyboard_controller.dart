import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../core/audio/audio_engine.dart';
import '../core/audio/sound_presets.dart';
import '../core/constants/chord_detector.dart';
import '../core/constants/piano_notes.dart';
import '../models/key_note.dart';

/// Precomputed immutable keyboard layout metadata for zero-allocation hit testing and rendering.
@immutable
class KeyboardLayout {
  final List<KeyNote> allNotes;
  final List<KeyNote> whiteNotes;
  final List<KeyNote> blackNotes;
  final Map<KeyNote, int> blackToPrecedingWhiteIndex;

  KeyboardLayout({required this.allNotes})
      : whiteNotes = allNotes.where((n) => !n.isAccidental).toList(growable: false),
        blackNotes = allNotes.where((n) => n.isAccidental).toList(growable: false),
        blackToPrecedingWhiteIndex = _buildPrecedingMap(allNotes);

  static Map<KeyNote, int> _buildPrecedingMap(List<KeyNote> notes) {
    final Map<KeyNote, int> map = {};
    for (int i = 0; i < notes.length; i++) {
      final note = notes[i];
      if (note.isAccidental && i > 0) {
        final prev = notes[i - 1];
        if (!prev.isAccidental && prev.whiteKeyIndex != null) {
          map[note] = prev.whiteKeyIndex!;
        }
      }
    }
    return Map.unmodifiable(map);
  }
}

/// Lightweight controller managing keyboard state, active octaves, presets, and multi-touch pointer routing.
class KeyboardController extends ChangeNotifier {
  final AudioEngine _audioEngine;

  KeyboardController({AudioEngine? audioEngine})
      : _audioEngine = audioEngine ?? AudioEngine.instance {
    _refreshNotes();
  }

  int _baseOctave = 3;
  int get baseOctave => _baseOctave;

  int _octaveSpan = 1; // 1 = Couch thumb mode (8 white keys), 2 = Wide mode (15 white keys)
  int get octaveSpan => _octaveSpan;

  SoundBankType _soundPreset = SoundBankType.feltPiano;
  SoundBankType get soundPreset => _soundPreset;

  bool _isMagicScale = false;
  bool get isMagicScale => _isMagicScale;

  bool _isSustainEnabled = true;
  bool get isSustainEnabled => _isSustainEnabled;

  late KeyboardLayout _layout;
  KeyboardLayout get layout => _layout;
  List<KeyNote> get notes => _layout.allNotes;

  /// Currently depressed MIDI notes (for visual glow / depressed state).
  final Set<int> _pressedMidiNotes = {};
  Set<int> get pressedMidiNotes => Set.unmodifiable(_pressedMidiNotes);

  /// Real-time musical chord or interval detection.
  String get activeChord => ChordDetector.detectChord(_pressedMidiNotes);

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
    final generated = PianoNotes.generateNotes(
      startOctave: _baseOctave,
      octaveCount: _octaveSpan,
      includeEndingRoot: true,
    );
    _layout = KeyboardLayout(allNotes: generated);
  }

  Future<void> _reloadSoundBank() async {
    await _audioEngine.loadSoundBank(
      notes: _layout.allNotes,
      preset: _soundPreset,
    );
  }

  /// Sets visible keyboard octave span (1 or 2 octaves).
  void setOctaveSpan(int span) {
    if (span != 1 && span != 2) return;
    if (_octaveSpan == span) return;
    _octaveSpan = span;
    _refreshNotes();
    _reloadSoundBank();
    notifyListeners();
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

  /// Toggles sustain pedal mode (sustain vs staccato damping).
  void toggleSustain() {
    _isSustainEnabled = !_isSustainEnabled;
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  /// Check whether a note is playable in the current scale mode.
  bool isNotePlayable(KeyNote note) {
    if (!_isMagicScale) return true;
    return PianoNotes.isInMagicScale(note);
  }

  /// Called when a pointer hits a key.
  void handlePointerDown(int pointerId, KeyNote note, {double velocity = 1.0}) {
    if (!isNotePlayable(note)) return;

    _pointerToMidi[pointerId] = note.midiNumber;
    _pressedMidiNotes.add(note.midiNumber);

    HapticFeedback.selectionClick();
    _audioEngine.playNote(note.midiNumber, volume: velocity);

    notifyListeners();
  }

  /// Called when a pointer drags across the keyboard (glissando/slide).
  void handlePointerMove(int pointerId, KeyNote? newNote, {double velocity = 1.0}) {
    final currentMidi = _pointerToMidi[pointerId];

    if (newNote == null || !isNotePlayable(newNote)) {
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
      if (currentMidi != null && !_isSustainEnabled) {
        _audioEngine.stopNote(currentMidi);
      }

      _pointerToMidi[pointerId] = newNote.midiNumber;
      _pressedMidiNotes.add(newNote.midiNumber);

      HapticFeedback.selectionClick();
      _audioEngine.playNote(newNote.midiNumber, volume: velocity);

      _recalculatePressedNotes();
      notifyListeners();
    }
  }

  /// Called when a pointer is lifted or canceled.
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
