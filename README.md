# SimpleKeys 🎹

> A minimalist, couch-friendly, zero-latency piano app for Android built with Flutter and backed by a high-performance C++ audio engine (`flutter_soloud` via FFI).

[![Flutter](https://img.shields.io/badge/Flutter-3.47.9-02569B?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%2024%2B-3DDC84?logo=android)](https://developer.android.com)
[![Audio](https://img.shields.io/badge/Audio-C%2B%2B%20AAudio%20%2F%20Oboe-FF6F00)](https://github.com/fluttercommunity/flutter_soloud)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## 🌟 Philosophy & Features

SimpleKeys is designed from the ground up for zero friction:

- ⚡ **Instant Launch (<500ms)**: Boots straight into playable keys without splash screens, onboarding delays, or menus.
- ⏱️ **Zero-Latency Audio**: Backed by `flutter_soloud` (miniaudio/AAudio FFI) running directly at the Android audio sub-system level with 512-frame stream buffers.
- 🖐️ **Low-Latency Multi-Touch**: Bypasses Flutter's gesture arena via custom raw `Listener` tracking pointers by `pointerId`. Supports concurrent 10-finger chords and natural glissando/slides without tap delay.
- 🎯 **Accurate Hit-Testing**: Mathematical black-over-white key bound detection eliminates touch-box bleeding between sharps and naturals.
- 🎨 **Minimal Dark Mode Aesthetic**: Deep obsidian matte blacks (`#16171B`), warm ivory felt (`#EEEBE4`), and subtle dynamic depression glow states.
- 🪄 **Magic Scale Toggle**: Harmonically dims discordant semitones (e.g. F and B in C Major), enabling zero-mistake casual improvisation.
- 🎼 **Multiple Sound Banks**:
  - **Felt Piano**: Warm acoustic felt hammers with natural exponential body resonance.
  - **Music Box**: Crisp crystalline bell chimes with shimmering overtones.
  - **Dream Pad**: Lush ambient pad with soft attack and airy sustained tail.
- 📳 **Haptic Feedback**: Fires subtle `HapticFeedback.selectionClick()` on every new key strike.

---

## 📂 Architecture & Directory Structure

```
lib/
├── main.dart                          # Immersive entrypoint, hardware orientation lock, fast boot
├── core/
│   ├── audio/
│   │   ├── audio_engine.dart          # Polyphonic SoLoud C++ AAudio audio stream wrapper
│   │   └── sound_presets.dart         # Synthesized PCM WAV audio generators (Felt, Music Box, Pad)
│   ├── theme/
│   │   ├── app_colors.dart            # Deep matte blacks, warm ivory felt, subtle touch highlights
│   │   └── app_theme.dart             # Dark minimalist theme configurations
│   └── constants/
│       └── piano_notes.dart           # Frequencies, MIDI numbers, note mappings (C3 - B5) & magic scale masks
├── models/
│   └── key_note.dart                  # Model representing pitch, octave, accidental, frequency, and scale state
├── state/
│   └── keyboard_controller.dart       # State for active octave, sound preset, magic scale toggle, multi-touch state
└── presentation/
    ├── screens/
    │   └── piano_screen.dart          # One-screen ergonomic layout (Top Bar + Responsive Keyboard)
    └── widgets/
        ├── top_bar.dart               # Octave selector, preset pill switcher, magic scale toggle
        ├── piano_keyboard.dart        # Multi-touch pointer tracker using Listener (pointerId tracking)
        ├── white_key.dart             # Ivory felt key with touch depression & glow feedback
        └── black_key.dart             # Matte black elevated sharp key with precise touch bounds
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>= 3.13.7)
- Android SDK (API level 24 or higher)

### Setup & Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/hamas/SimpleKeys.git
   cd SimpleKeys
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run static analysis**:
   ```bash
   flutter analyze
   ```

4. **Run unit & widget tests**:
   ```bash
   flutter test
   ```

5. **Launch on an Android device**:
   ```bash
   flutter run -d android
   ```

---

## 🧪 Testing

The test suite covers scale generation, octave shifting, magic scale dissonance filtering, and multi-touch pointer tracking:

```bash
flutter test test/widget_test.dart
```

---

## 📄 License

This project is open-source under the [MIT License](LICENSE).
