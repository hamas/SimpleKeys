# SimpleKeys 🍬🎹

> A juicy, tactile 3D candy-style music and keyboard game for Android built with Flutter and backed by a high-performance C++ audio engine (`flutter_soloud` via FFI).

<p align="center">
  <img src="assets/app_logo.png" width="160" alt="SimpleKeys App Icon" style="border-radius: 36px; box-shadow: 0 8px 24px rgba(0,0,0,0.3);" />
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

SimpleKeys combines a vibrant, glossy 3D "Candy Crush" aesthetic with a responsive 4×5 isomorphic musical pad grid and low-latency audio synthesis:

- 🍬 **Tactile 3D Candy Jelly Pads**:
  - 4 vibrant candy color hues: Bubblegum Pink, Sky Blue, Apple Green, and Mango Yellow.
  - Glossy curved pillow highlights and solid 5dp 3D bottom bevels.
  - Physically debossed musical notes (♪ single and ♫ double beamed notes) molded into each pad.
  - Realistic 4dp downward physical key travel with instant haptic feedback.
- ⚡ **Zero-Latency Audio Engine**:
  - Backed by `flutter_soloud` (miniaudio/AAudio FFI) running directly on the Android hardware audio subsystem.
  - Multi-touch raw `Listener` bypassing Flutter's gesture arena for instant polyphonic chord triggering.
- 🎓 **Interactive Teach & Play Modes**:
  - **🕹️ Play Mode**: Free-form couch-side jamming across a 2.5-octave isomorphic scale.
  - **🎓 Teach Mode**: Step-by-step interactive lessons (e.g. *C Major Scale*, *Twinkle Twinkle*, *Ode to Joy*). Follow the golden sparkling pads on the board!
- 🏆 **Game Stats & Progression**:
  - 3D **Lives** tracking with an embossed red heart badge.
  - Real-time **Score** tracking (`02,840` format) rewarding musical accuracy.
  - **Level** badge integrated into the 3D lavender board rim.
- 🎛️ **Sound Instruments & Customization**:
  - Multi-preset synthesis: *Felt Piano*, *Music Box*, and *Dream Pad*.
  - Notation toggle: Standard Scientific Pitch (`C3`, `G4`) vs Solfège (`Do3`, `Sol4`).
  - Sustain toggle for acoustic ring-out vs staccato release.
- 📱 **Edge-to-Edge Android UI**:
  - Portrait-locked layout tailored for one-handed and two-handed thumb/finger play.
  - Transparent system status bar with dynamic dark icons on top of a soft pastel mint background.

---

## 📂 Architecture & Directory Structure

```text
lib/
├── main.dart                          # App entrypoint, portrait orientation lock, edge-to-edge UI
├── core/
│   ├── audio/
│   │   ├── audio_engine.dart          # Low-latency polyphonic SoLoud C++ AAudio stream engine
│   │   └── sound_presets.dart         # Pure in-memory 16-bit PCM WAV additive synthesis
│   ├── constants/
│   │   └── piano_notes.dart           # 4x5 isomorphic pad note definitions & Solfège mapping
│   ├── lessons/
│   │   └── tutorial_lessons.dart      # Interactive song lessons for Teach mode
│   └── theme/
│       ├── app_colors.dart            # Unified 3D Candy & Pastel color tokens
│       └── app_theme.dart             # Material 3 light/pastel Candy theme
├── models/
│   └── key_note.dart                  # Immutable musical note model (pitch, octave, MIDI, frequency)
├── state/
│   └── keyboard_controller.dart       # State management for pads, audio routing, lessons, and stats
└── presentation/
    ├── screens/
    │   └── piano_screen.dart          # Primary Candy game screen scaffold
    └── widgets/
        ├── candy_bottom_bar.dart      # 3D PLAY, SONGS, STORE pill buttons & modal sheets
        ├── candy_decorations.dart     # Pastel mint background painter & 3D rainbow logo
        ├── candy_header.dart          # 3D Lives, Score & Settings header deck
        ├── candy_pad_style.dart       # 4x5 Candy pad color palettes & note icon layout
        ├── isomorphic_pad.dart        # 3D glossy Candy pad with debossed note painter
        └── isomorphic_pad_grid.dart   # 3D Lavender tray frame with Level badge
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

4. **Run unit tests**:
   ```bash
   flutter test
   ```

5. **Run on connected Android device**:
   ```bash
   flutter run
   ```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
