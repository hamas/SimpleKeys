import 'dart:developer' as dev;
import 'package:flutter_soloud/flutter_soloud.dart';
import '../../models/key_note.dart';
import 'sound_presets.dart';

/// Low-latency, polyphonic audio engine interface & implementation backed by SoLoud C++ AAudio/miniaudio FFI.
class AudioEngine {
  static final AudioEngine instance = AudioEngine._internal();
  AudioEngine._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  SoundBankType _currentPreset = SoundBankType.feltPiano;
  SoundBankType get currentPreset => _currentPreset;

  final Map<int, AudioSource> _noteSources = {};
  final Map<int, List<SoundHandle>> _activeHandles = {};
  bool _isLoadingBank = false;
  int _activeLoadGeneration = 0;

  /// Initializes SoLoud low-latency audio stream with Android AAudio configuration.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final soloud = SoLoud.instance;
      if (!soloud.isInitialized) {
        await soloud.init(
          sampleRate: 44100,
          bufferSize: 512, // Minimal buffer for fastest key strike responsiveness
          channels: Channels.stereo,
          lowLatency: true,
          androidAAudioAttributes: AndroidAAudioAttributes.mediaMusic,
        );
      }
      _isInitialized = true;
      dev.log('AudioEngine: SoLoud C++ low-latency audio stream initialized successfully.');
    } catch (e, st) {
      dev.log('AudioEngine: Initialization error (running in fallback mode): $e\n$st');
      _isInitialized = false;
    }
  }

  /// Pre-loads synthesized audio samples for [notes] directly into memory.
  /// Uses generation tracking to prevent race conditions on rapid preset/octave switches.
  Future<void> loadSoundBank({
    required List<KeyNote> notes,
    SoundBankType preset = SoundBankType.feltPiano,
  }) async {
    if (!_isInitialized) {
      await initialize();
      if (!_isInitialized) return;
    }

    final generation = ++_activeLoadGeneration;
    _isLoadingBank = true;
    _currentPreset = preset;

    // Dispose old audio sources to prevent memory leaks
    await _disposeCurrentSources();

    try {
      final Map<int, AudioSource> loaded = {};
      for (final note in notes) {
        if (generation != _activeLoadGeneration) {
          // Obsolete generation: user triggered another change
          dev.log('AudioEngine: Aborting load generation $generation.');
          return;
        }

        final wavBytes = SoundPresets.synthesizeWav(
          frequency: note.frequency,
          preset: preset,
          durationSeconds: preset == SoundBankType.dreamPad ? 2.8 : 2.0,
        );

        final audioSource = await SoLoud.instance.loadMem(
          'piano_midi_${note.midiNumber}_${preset.name}',
          wavBytes,
          mode: LoadMode.memory,
        );

        loaded[note.midiNumber] = audioSource;
      }

      if (generation == _activeLoadGeneration) {
        _noteSources.addAll(loaded);
        dev.log('AudioEngine: Loaded ${_noteSources.length} notes for preset ${preset.title}.');
      }
    } catch (e, st) {
      dev.log('AudioEngine: Failed to load sound bank: $e\n$st');
    } finally {
      if (generation == _activeLoadGeneration) {
        _isLoadingBank = false;
      }
    }
  }

  /// Triggers instant playback of a note by its [midiNumber].
  /// Supports polyphony: multiple calls for the same or different notes
  /// play simultaneously on separate hardware voices without cutting off.
  SoundHandle? playNote(int midiNumber, {double volume = 1.0}) {
    if (!_isInitialized || _isLoadingBank) return null;

    final source = _noteSources[midiNumber];
    if (source == null) return null;

    try {
      final handle = SoLoud.instance.play(
        source,
        volume: volume.clamp(0.0, 1.0),
      );

      _activeHandles.putIfAbsent(midiNumber, () => []).add(handle);
      return handle;
    } catch (e) {
      dev.log('AudioEngine: Note trigger error for MIDI $midiNumber: $e');
      return null;
    }
  }

  /// Gently fades and stops any active voices for [midiNumber] (damper pedal release).
  void stopNote(int midiNumber, {Duration fadeTime = const Duration(milliseconds: 140)}) {
    if (!_isInitialized) return;

    final handles = _activeHandles.remove(midiNumber);
    if (handles == null || handles.isEmpty) return;

    for (final handle in handles) {
      try {
        SoLoud.instance.fadeVolume(handle, 0.0, fadeTime);
        SoLoud.instance.scheduleStop(handle, fadeTime);
      } catch (_) {
        // Voice may have completed naturally
      }
    }
  }

  Future<void> _disposeCurrentSources() async {
    _activeHandles.clear();
    for (final source in _noteSources.values) {
      try {
        await SoLoud.instance.disposeSource(source);
      } catch (_) {}
    }
    _noteSources.clear();
  }

  /// Full engine teardown.
  Future<void> dispose() async {
    await _disposeCurrentSources();
    if (_isInitialized) {
      try {
        SoLoud.instance.deinit();
      } catch (_) {}
      _isInitialized = false;
    }
  }
}
