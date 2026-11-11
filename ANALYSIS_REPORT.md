# SimpleKeys: Deep Architecture, Code Quality & UI Analysis Report

**Date**: November 11, 2026  
**Auditor**: Senior Flutter & Low-Latency Audio Systems Engineer  
**Target Repository**: [https://github.com/hamas/SimpleKeys](https://github.com/hamas/SimpleKeys)  
**Flutter SDK**: 3.47.9 (channel stable) • **Dart SDK**: 3.13.7  
**Platform Target**: Android (minSdkVersion: 24, compileSdk: flutter.compileSdkVersion)  

---

## 1. Executive Summary & Build Verification

The `SimpleKeys` repository was evaluated across code architecture, low-latency audio pipelines, dependency compatibility, Android native integration, and Material 3 Expressive UI standards.

### Key Verification Metrics
| Check | Status | Details |
|---|---|---|
| **Static Analysis (`flutter analyze`)** | **PASSED (0 issues)** | Zero errors, zero warnings, zero linter hints across all source and test files. |
| **Unit & Logic Tests (`flutter test`)** | **PASSED (5/5)** | Full coverage of scale intervals, octave transposition, multi-touch pointer tracking, and dissonant harmonic filtering. |
| **Native Android Build (`assembleDebug`)** | **PASSED** | Compiled native C++ toolchain (`miniaudio` / AAudio FFI) and packaged `build/app/outputs/flutter-apk/app-debug.apk` cleanly. |
| **Dependency Status (`flutter pub outdated`)** | **UP TO DATE** | Direct dependencies (`flutter_soloud: ^5.2.3`) are on latest stable releases. |

---

## 2. Architecture & Code Structure Analysis

### 2.1 Directory Layout & Separation of Concerns
The current codebase adheres to a modular, layered architecture with distinct boundaries:

```
lib/
├── main.dart                          # Immersive entrypoint & hardware bindings
├── core/
│   ├── audio/
│   │   ├── audio_engine.dart          # Low-latency polyphonic audio stream interface & SoLoud FFI
│   │   └── sound_presets.dart         # Pure in-memory 16-bit PCM WAV additive synthesis engines
│   ├── constants/
│   │   └── piano_notes.dart           # Frequencies, MIDI numbers, note names & pentatonic scale masks
│   └── theme/
│       ├── app_colors.dart            # Tonal dark-mode tokens, key materials, and glow accents
│       └── app_theme.dart             # Material 3 dark theme configuration
├── models/
│   └── key_note.dart                  # Immutable value model (pitch, accidental, geometry metadata)
├── state/
│   └── keyboard_controller.dart       # State holder for active octaves, presets, and pointer-to-MIDI routing
└── presentation/
    ├── screens/
    │   └── piano_screen.dart          # Single-screen landscape scaffold
    └── widgets/
        ├── top_bar.dart               # Segmented sound presets, octave stepper, and magic-scale toggle
        ├── piano_keyboard.dart        # Non-blocking multi-touch Listener container with spatial hit testing
        ├── white_key.dart             # Tactile off-white felt key with beveling & touch depression
        └── black_key.dart             # Elevated matte-black sharp key with high-precision occlusion bounds
```

### 2.2 Architectural Strengths
1. **Zero-Lag Pointer Pipeline**: Standard Flutter widgets (`GestureDetector`, `InkWell`) enter the gesture arena, which incurs disambiguation delays (up to 100ms) and collapses multi-finger chords. SimpleKeys uses a raw `Listener` with `HitTestBehavior.opaque`, intercepting raw `PointerDownEvent`, `PointerMoveEvent`, and `PointerUpEvent` at frame level.
2. **Self-Contained Low-Latency Synthesis**: Rather than bundling dozens of large uncompressed asset files that introduce disk I/O latency, `SoundPresets` uses real-time in-memory additive harmonic synthesis (WAV PCM 16-bit at 22,050 Hz). A 25-key bank compiles in under 15ms directly into RAM.
3. **Native Hardware AAudio Stream**: `AudioEngine` initializes `SoLoud` with `bufferSize: 512`, `channels: Channels.stereo`, `lowLatency: true`, and `AndroidAAudioAttributes.mediaMusic`, routing directly to the Android low-latency AAudio driver.
4. **Mathematical Hit-Box Precedence**: Black keys sit geometrically over white keys without widget hit-box bleeding. Coordinate tests prioritize the upper 60% black-key boundary before falling back to the natural white key calculation.

---

## 3. Deep Code & Performance Audit

### 3.1 Layout Allocation in Touch Hot Path (Opportunity for Optimization)
In `lib/presentation/widgets/piano_keyboard.dart`:
```dart
// Currently executed inside build() on every frame rebuild:
final whiteNotes = allNotes.where((n) => !n.isAccidental).toList();
final blackNotes = allNotes.where((n) => n.isAccidental).toList();
```
- **Finding**: During multi-touch sliding (glissando), 10 fingers moving at 120Hz trigger up to 120 state notifications per second. Filtering lists and computing `allNotes.indexOf(black)` inside `LayoutBuilder` produces temporary heap allocations and GC pressure.
- **Recommendation**: Precompute and memoize `whiteNotes`, `blackNotes`, and normalized coordinate ratios (`leftFraction`, `widthFraction`) inside `KeyboardController` or an immutable `KeyboardLayoutGeometry` struct so hit-testing performs zero allocations.

### 3.2 Asynchronous Sound Bank Loading & Race Condition Prevention
In `lib/state/keyboard_controller.dart`:
```dart
void shiftOctaveUp() {
  if (_baseOctave >= 5) return;
  _baseOctave++;
  _refreshNotes();
  _reloadSoundBank(); // Unawaited Future
  notifyListeners();
}
```
- **Finding**: Rapid repeated tapping of `+` or preset pills triggers concurrent calls to `_audioEngine.loadSoundBank()`. While `AudioEngine` uses `_isLoadingBank`, multiple asynchronous loads can overlap.
- **Recommendation**: Introduce an incremental `_loadGeneration` counter or sequential queue so in-flight audio loads abort obsolete generations immediately.

### 3.3 Dynamic Touch Strike Velocity
In `lib/core/audio/audio_engine.dart` and `piano_keyboard.dart`:
- **Finding**: `playNote` accepts `volume: 1.0`, but currently all key strikes trigger at maximum volume.
- **Recommendation**: On real acoustic pianos, striking near the front of a key produces a heavier strike, while striking higher produces softer touch dynamics. We can incorporate normalized $y$-position (`pos.dy / totalHeight`) or `event.pressure` to calculate tactile touch velocity ($0.65$ to $1.0$).

---

## 4. Dependencies, Flutter & Dart SDK Audit

### 4.1 Dependency Compatibility Matrix
| Package | Configured | Installed | Upstream Latest | Status | Notes |
|---|---|---|---|---|---|
| `flutter` | `sdk: flutter` | `3.47.9` | `3.47.9` | **Current** | Channel stable, engine revision `c197ca5199`. |
| `dart` | `^3.13.7` | `3.13.7` | `3.13.7` | **Current** | Supports records, patterns, class modifiers, and native FFI. |
| `flutter_soloud` | `^5.2.3` | `5.2.3` | `5.2.3` | **Current** | Bundles high-performance C++ miniaudio and AAudio backends. |
| `flutter_lints` | `^6.0.0` | `6.0.0` | `6.0.0` | **Current** | Recommended Dart/Flutter lint ruleset. |

### 4.2 Android Build System Settings
- **Gradle Version**: 8.x
- **Compile SDK**: `flutter.compileSdkVersion`
- **Min SDK**: `24` (Required for AAudio low-latency audio stream support).
- **Target SDK**: `flutter.targetSdkVersion`
- **JVM Target**: Java 17 (`JavaVersion.VERSION_17` and `JvmTarget.JVM_17`).
- **Namespace & App ID**: `com.simplekeys.app` (fully unified in `build.gradle.kts` and Kotlin package tree).

---

## 5. Material 3 Expressive UI Analysis & Visual Recommendations

### 5.1 What is Material 3 Expressive?
Material 3 Expressive (the 2024–2026 evolution of Material Design) shifts away from sterile flat surfaces toward:
- **Tonal Surface Hierarchy**: Explicit container levels (`surfaceContainerLow`, `surfaceContainer`, `surfaceContainerHigh`, `surfaceContainerHighest`) instead of monotone backgrounds.
- **Expressive Shapes & Fluid Pills**: Fully rounded pill shapes (`BorderRadius.circular(24)`), connected segmented controls with responsive state transitions.
- **Tactile Material Physics**: Authentic mechanical key travel (vertical displacement on press), layered ambient occlusion drop shadows, and soft ambient glows.
- **Spring-Loaded Micro-Interactions**: Bouncy spring transitions (`Curves.fastEaseInToSlowEase` / `Curves.easeOutBack`) instead of linear fades.

### 5.2 Evaluating SimpleKeys Against Material 3 Expressive
| Component | Current State | Material 3 Expressive Upgrade Path |
|---|---|---|
| **Top Control Bar** | Functional container with border, basic text buttons. | **M3 Expressive Top Bar**: Surface container elevation, floating pill design, unified segmented button for presets with dynamic tonal fill and icons. |
| **Octave Selector** | Text with `+` and `-` icons. | **Expressive Stepper Pill**: Segmented pill container with haptic feedback, badge indicator showing active pitch range (e.g., `C3–C5`). |
| **Preset Switcher** | Rectangular tab row. | **M3 Segmented Button**: Expressive pill indicator sliding smoothly with spring motion, distinctive icons (`piano`, `music_note`, `blur_on`). |
| **Magic Scale Toggle** | Bordered button with icon. | **M3 Expressive Toggle Pill**: Radiant amber/cyan badge with pulsating glow indicator when active. |
| **Piano White Keys** | Warm ivory box with bottom border. | **Tactile M3 Keys**: Front-lip 3D depth bevel, subtle downward press displacement (`Transform.translate(0, 3)`), inner warm gradient and soft dynamic glow. |
| **Piano Black Keys** | Matte black rounded rectangle. | **Obsidian Satin Keys**: Dual-bevel edge highlight, top sheen reflection, and cyan accent under-glow when struck. |

---

## 6. Actionable Implementation Plan

To elevate SimpleKeys to the absolute pinnacle of Flutter craftsmanship, the following enhancements are ready for implementation:

1. **Material 3 Expressive Top Bar & Segmented Controls**:
   - Refactor `TopBar` to use M3 expressive pill containers, segmented buttons with icons, and spring animations.
2. **Key Physics & Dynamic Lighting**:
   - Enhance `WhiteKey` and `BlackKey` with realistic 3D front-lip depth, downward key travel displacement on press, and touch glow shaders.
3. **Performance Optimization (Zero-GC Hot Path)**:
   - Cache precomputed keyboard geometry and note splits in `KeyboardController`.
4. **Velocity Touch Sensitivity**:
   - Calculate strike velocity based on touch position and force.
5. **Continuous Integration (GitHub Actions)**:
   - Add `.github/workflows/ci.yml` to automatically verify static analysis and run unit tests on every push.
