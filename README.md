# SimpleKeys 🎹

> A minimalist, couch-friendly, zero-latency piano app for Android built with Flutter and backed by a high-performance C++ audio engine (`flutter_soloud` via FFI).

<p align="center">
  <img src="assets/app_logo.png" width="160" alt="SimpleKeys App Icon" style="border-radius: 36px; box-shadow: 0 8px 24px rgba(0,0,0,0.4);" />
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.47.9-02569B?logo=flutter" alt="Flutter" /></a>
  <a href="https://developer.android.com"><img src="https://img.shields.io/badge/Platform-Android%2024%2B-3DDC84?logo=android" alt="Platform" /></a>
  <a href="https://github.com/fluttercommunity/flutter_soloud"><img src="https://img.shields.io/badge/Audio-C%2B%2B%20AAudio%20%2F%20Oboe-FF6F00" alt="Audio" /></a>
  <a href="https://github.com/hamas/SimpleKeys/actions"><img src="https://github.com/hamas/SimpleKeys/actions/workflows/ci.yml/badge.svg" alt="CI Status" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License" /></a>
</p>

---

## 🌟 Philosophy & Features

SimpleKeys is designed from the ground up for couch-side playing and zero-friction keyboard practice:

- ⚡ **Instant Launch (<500ms)**: Direct to keys without splash screens, onboarding delays, or menus.
- ⏱️ **Zero-Latency Audio**: Backed by `flutter_soloud` (miniaudio/AAudio FFI) running directly at the Android audio sub-system level with 512-frame stream buffers.
- 🖐️ **Zero-Lag Multi-Touch Hot Path**: Bypasses Flutter's gesture arena via custom raw `Listener` tracking pointers by `pointerId`. Precomputed `KeyboardLayout` cache ensures zero garbage collection pressure during 120Hz glissando slides.
- 🎯 **Mathematical Hit-Testing**: Upper 60% black-over-white key bound detection eliminates touch-box bleeding between sharps and naturals.
- 🎹 **Key Physics & 3D Tactility**:
  - **White Keys**: 3.5px mechanical key depression (`Transform.translate`), front-lip 3D depth bevel, and warm amber ambient glow on strike.
  - **Black Keys**: 2.5px downward travel, dual-bevel edge highlights, top satin specular reflection, and electric cyan under-glow.
- 💥 **Dynamic Strike Velocity**: Normalizes vertical touch coordinates ($y$-position) and touch force/pressure to dynamically modulate acoustic strike volume ($0.5$ to $1.0$).
- 🎛️ **Material 3 Expressive Control Deck**:
  - **Fluid Segmented Preset Switcher**: Animated spring pill transitions across *Felt Piano*, *Music Box*, and *Dream Pad*.
  - **Octave Stepper Pill**: Connected stepper container with pitch badge (`C3 – C5`).
  - **Radiant Magic Scale Pill**: Ambient pulsating cyan glow badge; harmonically dims discordant semitones (e.g. F and B in C Major) for casual zero-mistake improvisation.
  - **Sustain / Damper Pedal**: Instant toggle between natural acoustic ring-out and crisp staccato release.
- 📳 **Haptic Feedback**: Fires subtle `HapticFeedback.selectionClick()` on every new key strike.
- 🎨 **Full-Bleed Adaptive Icon**: Native Android 8.0+ adaptive icon suite with a full-bleed deep slate background (`#1C202B`) that seamlessly extends across circular, squircle, and pebble launcher masks without letterboxing.

---

## 📂 Architecture & Directory Structure

```
lib/
├── main.dart                          # Immersive entrypoint, hardware orientation lock, fast boot
├── core/
│   ├── audio/
│   │   ├── audio_engine.dart          # Polyphonic SoLoud C++ AAudio stream engine & generation guard
│   │   └── sound_presets.dart         # Pure in-memory 16-bit PCM WAV additive synthesis engines
│   ├── constants/
│   │   └── piano_notes.dart           # Frequencies, MIDI numbers, note mappings (C3 - B5) & magic scale masks
│   └── theme/
│       ├── app_colors.dart            # M3 Expressive tonal containers, key materials & glow accents
│       └── app_theme.dart             # Dark minimalist theme configurations
├── models/
│   └── key_note.dart                  # Immutable value model (pitch, accidental, geometry metadata)
├── state/
│   └── keyboard_controller.dart       # State holder for layout cache, octaves, presets, pedal & pointer routing
└── presentation/
    ├── screens/
    │   └── piano_screen.dart          # Single-screen landscape scaffold
    └── widgets/
        ├── top_bar.dart               # M3 Expressive floating pill control deck
        ├── piano_keyboard.dart        # Zero-allocation multi-touch Listener with velocity estimation
        ├── white_key.dart             # Tactile ivory felt key with 3D front lip & key travel physics
        └── black_key.dart             # Elevated matte-black sharp key with dual bevels & cyan under-glow
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

4. **Run unit & multi-touch test suites**:
   ```bash
   flutter test
   ```

5. **Build and install on Android**:
   ```bash
   flutter build apk --release
   flutter install -d <device-id>
   ```

---

## 🧪 Testing

The automated test suite covers scale generation, octave transposition, zero-allocation layout caching, sustain pedal damping, velocity handling, and multi-touch pointer tracking:

```bash
flutter test test/widget_test.dart
```

---

## 📄 License

This project is open-source under the [MIT License](LICENSE).
