import 'dart:math' as math;
import 'dart:typed_data';

enum SoundBankType {
  feltPiano('Felt Piano', 'Warm, soft acoustic felt hammers with rich decay'),
  musicBox('Music Box', 'Crisp bell-like chimes with metallic shimmer'),
  dreamPad('Dream Pad', 'Lush ambient tones with soft attack and airy release');

  final String title;
  final String description;
  const SoundBankType(this.title, this.description);
}

/// Generates synthesized low-latency 16-bit PCM WAV audio in memory.
abstract final class SoundPresets {
  static const int sampleRate = 22050; // Optimized sample rate for instant memory synthesis

  /// Synthesizes a mono 16-bit WAV file in memory for a given pitch and preset.
  static Uint8List synthesizeWav({
    required double frequency,
    required SoundBankType preset,
    double durationSeconds = 2.0,
  }) {
    final int totalSamples = (durationSeconds * sampleRate).toInt();
    final ByteData pcmData = ByteData(totalSamples * 2);

    final double twoPi = 2.0 * math.pi;
    final double fundamentalDelta = (twoPi * frequency) / sampleRate;

    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      double sample = 0.0;

      switch (preset) {
        case SoundBankType.feltPiano:
          // Warm percussive acoustic character:
          // Strong fundamental, warm 2nd harmonic, gentle 3rd harmonic, natural exponential decay.
          final double env = math.exp(-3.2 * t);
          final double h1 = math.sin(fundamentalDelta * i);
          final double h2 = 0.35 * math.sin(fundamentalDelta * 2 * i);
          final double h3 = 0.12 * math.sin(fundamentalDelta * 3 * i);
          final double h4 = 0.05 * math.sin(fundamentalDelta * 4 * i);
          sample = (h1 + h2 + h3 + h4) * env;

        case SoundBankType.musicBox:
          // Bell / Celeste character:
          // Crisp instantaneous attack, prominent inharmonic overtone (2.76x) and shimmering decay.
          final double env = math.exp(-2.6 * t);
          final double h1 = math.sin(fundamentalDelta * i);
          final double h2 = 0.45 * math.sin(fundamentalDelta * 2.76 * i);
          final double h3 = 0.20 * math.sin(fundamentalDelta * 5.4 * i);
          sample = (h1 + h2 + h3) * env;

        case SoundBankType.dreamPad:
          // Ethereal ambient pad:
          // Soft attack envelope (first 40ms fade-in), slight detuning chorus, long lush tail.
          final double attack = (t < 0.04) ? (t / 0.04) : 1.0;
          final double decay = math.exp(-1.4 * t);
          final double env = attack * decay;
          final double h1 = math.sin(fundamentalDelta * i);
          final double detune = math.sin(fundamentalDelta * 1.004 * i);
          final double h2 = 0.25 * math.sin(fundamentalDelta * 2 * i);
          sample = (h1 * 0.5 + detune * 0.5 + h2) * env;
      }

      // Soft-clip saturation to prevent digital distortion
      final double clamped = sample.clamp(-1.0, 1.0);
      final int pcmSample = (clamped * 32767.0).toInt().clamp(-32768, 32767);
      pcmData.setInt16(i * 2, pcmSample, Endian.little);
    }

    return _buildWavContainer(
      pcmBytes: pcmData.buffer.asUint8List(),
      sampleRate: sampleRate,
      channels: 1,
      bitsPerSample: 16,
    );
  }

  /// Wraps raw 16-bit PCM bytes inside a standard 44-byte RIFF/WAVE header.
  static Uint8List _buildWavContainer({
    required Uint8List pcmBytes,
    required int sampleRate,
    required int channels,
    required int bitsPerSample,
  }) {
    final int byteRate = sampleRate * channels * (bitsPerSample ~/ 8);
    final int blockAlign = channels * (bitsPerSample ~/ 8);
    final int dataSize = pcmBytes.length;
    final int chunkSize = 36 + dataSize;

    final ByteData header = ByteData(44);

    // RIFF chunk descriptor
    header.setUint8(0, 0x52); // 'R'
    header.setUint8(1, 0x49); // 'I'
    header.setUint8(2, 0x46); // 'F'
    header.setUint8(3, 0x46); // 'F'
    header.setUint32(4, chunkSize, Endian.little);
    header.setUint8(8, 0x57);  // 'W'
    header.setUint8(9, 0x41);  // 'A'
    header.setUint8(10, 0x56); // 'V'
    header.setUint8(11, 0x45); // 'E'

    // "fmt " sub-chunk
    header.setUint8(12, 0x66); // 'f'
    header.setUint8(13, 0x6D); // 'm'
    header.setUint8(14, 0x74); // 't'
    header.setUint8(15, 0x20); // ' '
    header.setUint32(16, 16, Endian.little);          // Subchunk1Size (16 for PCM)
    header.setUint16(20, 1, Endian.little);           // AudioFormat (1 = PCM)
    header.setUint16(22, channels, Endian.little);    // NumChannels
    header.setUint32(24, sampleRate, Endian.little);  // SampleRate
    header.setUint32(28, byteRate, Endian.little);    // ByteRate
    header.setUint16(32, blockAlign, Endian.little);  // BlockAlign
    header.setUint16(34, bitsPerSample, Endian.little); // BitsPerSample

    // "data" sub-chunk
    header.setUint8(36, 0x64); // 'd'
    header.setUint8(37, 0x61); // 'a'
    header.setUint8(38, 0x74); // 't'
    header.setUint8(39, 0x61); // 'a'
    header.setUint32(40, dataSize, Endian.little);

    final Uint8List wavBytes = Uint8List(44 + dataSize);
    wavBytes.setRange(0, 44, header.buffer.asUint8List());
    wavBytes.setRange(44, 44 + dataSize, pcmBytes);
    return wavBytes;
  }
}
