/// Procedural chiptune and sound effect synthesizer in pure Dart, inspired by sfxr.
///
/// Generates 16-bit PCM waveforms and RIFF WAV buffers on the fly without external assets.
library voxsynth;

import 'dart:math' as math;
import 'dart:typed_data';

/// Basic oscillator waveform shapes.
enum Waveform {
  square,
  sawtooth,
  sine,
  triangle,
  noise,
}

/// Synthesis parameters defining a procedural sound effect.
final class SynthParams {
  Waveform waveType = Waveform.square;

  // Envelope
  double attackTime = 0.0;
  double sustainTime = 0.3;
  double sustainPunch = 0.0;
  double decayTime = 0.4;

  // Frequency
  double startFrequency = 0.3;
  double minFrequency = 0.0;
  double slide = 0.0;
  double deltaSlide = 0.0;

  // Vibrato
  double vibratoDepth = 0.0;
  double vibratoSpeed = 0.0;

  // Tone change
  double changeAmount = 0.0;
  double changeSpeed = 0.0;

  // Square wave duty cycle
  double squareDuty = 0.5;
  double dutySweep = 0.0;

  // Repeat
  double repeatSpeed = 0.0;

  // Flanger / Phaser
  double phaserOffset = 0.0;
  double phaserSweep = 0.0;

  // Low-pass filter
  double lpfCutoff = 1.0;
  double lpfCutoffSweep = 0.0;
  double lpfResonance = 0.0;

  // High-pass filter
  double hpfCutoff = 0.0;
  double hpfCutoffSweep = 0.0;

  // Master Volume
  double masterVolume = 0.5;

  SynthParams clone() {
    final p = SynthParams();
    p.waveType = waveType;
    p.attackTime = attackTime;
    p.sustainTime = sustainTime;
    p.sustainPunch = sustainPunch;
    p.decayTime = decayTime;
    p.startFrequency = startFrequency;
    p.minFrequency = minFrequency;
    p.slide = slide;
    p.deltaSlide = deltaSlide;
    p.vibratoDepth = vibratoDepth;
    p.vibratoSpeed = vibratoSpeed;
    p.changeAmount = changeAmount;
    p.changeSpeed = changeSpeed;
    p.squareDuty = squareDuty;
    p.dutySweep = dutySweep;
    p.repeatSpeed = repeatSpeed;
    p.phaserOffset = phaserOffset;
    p.phaserSweep = phaserSweep;
    p.lpfCutoff = lpfCutoff;
    p.lpfCutoffSweep = lpfCutoffSweep;
    p.lpfResonance = lpfResonance;
    p.hpfCutoff = hpfCutoff;
    p.hpfCutoffSweep = hpfCutoffSweep;
    p.masterVolume = masterVolume;
    return p;
  }
}

/// Synthesized procedural sound effect providing PCM waveforms and WAV audio encoding.
final class SynthSound {
  final SynthParams params;

  SynthSound(this.params);

  // --- Preset Generators ---

  factory SynthSound.laser({math.Random? random}) {
    final rnd = random ?? math.Random();
    final p = SynthParams();
    p.waveType = rnd.nextDouble() < 0.5 ? Waveform.square : Waveform.sawtooth;
    p.startFrequency = 0.5 + rnd.nextDouble() * 0.4;
    p.minFrequency = 0.1;
    p.slide = -0.35 - rnd.nextDouble() * 0.3;
    p.attackTime = 0.0;
    p.sustainTime = 0.1 + rnd.nextDouble() * 0.1;
    p.decayTime = 0.1 + rnd.nextDouble() * 0.15;
    p.squareDuty = rnd.nextDouble() * 0.5;
    p.dutySweep = -0.05;
    return SynthSound(p);
  }

  factory SynthSound.explosion({math.Random? random}) {
    final rnd = random ?? math.Random();
    final p = SynthParams();
    p.waveType = Waveform.noise;
    p.startFrequency = 0.2 + rnd.nextDouble() * 0.2;
    p.slide = -0.1 + rnd.nextDouble() * 0.2;
    p.attackTime = 0.0;
    p.sustainTime = 0.1 + rnd.nextDouble() * 0.2;
    p.sustainPunch = 0.3 + rnd.nextDouble() * 0.4;
    p.decayTime = 0.3 + rnd.nextDouble() * 0.4;
    return SynthSound(p);
  }

  factory SynthSound.powerup({math.Random? random}) {
    final rnd = random ?? math.Random();
    final p = SynthParams();
    p.waveType = rnd.nextDouble() < 0.5 ? Waveform.triangle : Waveform.square;
    p.startFrequency = 0.2 + rnd.nextDouble() * 0.3;
    p.slide = 0.3 + rnd.nextDouble() * 0.3;
    p.sustainTime = 0.2 + rnd.nextDouble() * 0.2;
    p.decayTime = 0.2 + rnd.nextDouble() * 0.2;
    return SynthSound(p);
  }

  factory SynthSound.hit({math.Random? random}) {
    final rnd = random ?? math.Random();
    final p = SynthParams();
    p.waveType = rnd.nextDouble() < 0.5 ? Waveform.noise : Waveform.square;
    p.startFrequency = 0.4 + rnd.nextDouble() * 0.4;
    p.slide = -0.4 - rnd.nextDouble() * 0.3;
    p.attackTime = 0.0;
    p.sustainTime = 0.05 + rnd.nextDouble() * 0.1;
    p.decayTime = 0.1 + rnd.nextDouble() * 0.15;
    return SynthSound(p);
  }

  factory SynthSound.jump({math.Random? random}) {
    final rnd = random ?? math.Random();
    final p = SynthParams();
    p.waveType = Waveform.square;
    p.startFrequency = 0.3 + rnd.nextDouble() * 0.3;
    p.slide = 0.2 + rnd.nextDouble() * 0.2;
    p.attackTime = 0.0;
    p.sustainTime = 0.15 + rnd.nextDouble() * 0.15;
    p.decayTime = 0.1 + rnd.nextDouble() * 0.2;
    return SynthSound(p);
  }

  factory SynthSound.coin({math.Random? random}) {
    final rnd = random ?? math.Random();
    final p = SynthParams();
    p.waveType = Waveform.sine;
    p.startFrequency = 0.4 + rnd.nextDouble() * 0.4;
    p.attackTime = 0.0;
    p.sustainTime = 0.1;
    p.decayTime = 0.2 + rnd.nextDouble() * 0.2;
    p.changeAmount = 0.3;
    p.changeSpeed = 0.1;
    return SynthSound(p);
  }

  factory SynthSound.blip({math.Random? random}) {
    final rnd = random ?? math.Random();
    final p = SynthParams();
    p.waveType = rnd.nextDouble() < 0.5 ? Waveform.square : Waveform.sine;
    p.startFrequency = 0.3 + rnd.nextDouble() * 0.4;
    p.sustainTime = 0.05 + rnd.nextDouble() * 0.05;
    p.decayTime = 0.05 + rnd.nextDouble() * 0.05;
    return SynthSound(p);
  }

  /// Synthesizes 32-bit floating-point audio samples in the range `[-1.0, 1.0]`.
  Float32List generatePcm({int sampleRate = 44100}) {
    final rnd = math.Random(1337);

    // Calculate envelope sample lengths
    final attSamples = (params.attackTime * params.attackTime * 100000.0).round();
    final susSamples = (params.sustainTime * params.sustainTime * 100000.0).round();
    final decSamples = (params.decayTime * params.decayTime * 100000.0).round();
    final totalSamples = math.max(1, attSamples + susSamples + decSamples);

    final out = Float32List(totalSamples);

    var period = 100.0 / (params.startFrequency * params.startFrequency + 0.001);
    final maxPeriod = 100.0 / (params.minFrequency * params.minFrequency + 0.001);
    var slide = 1.0 - math.pow(params.slide, 3.0) * 0.01;
    final dslide = -math.pow(params.deltaSlide, 3.0) * 0.000001;

    var squareDuty = 0.5 - params.squareDuty * 0.5;
    final dutySweep = -params.dutySweep * 0.00005;

    var phase = 0;
    var envStage = 0;
    var envTime = 0;
    var envVol = 0.0;

    for (var i = 0; i < totalSamples; i++) {
      // Advance Envelope
      envTime++;
      if (envStage == 0 && envTime > attSamples) {
        envStage = 1;
        envTime = 0;
      }
      if (envStage == 1 && envTime > susSamples) {
        envStage = 2;
        envTime = 0;
      }

      if (envStage == 0) {
        envVol = attSamples > 0 ? (envTime / attSamples) : 1.0;
      } else if (envStage == 1) {
        envVol = 1.0 + (1.0 - envTime / (susSamples > 0 ? susSamples : 1)) * 2.0 * params.sustainPunch;
      } else if (envStage == 2) {
        envVol = 1.0 - (envTime / (decSamples > 0 ? decSamples : 1));
      }
      envVol = envVol.clamp(0.0, 1.0);

      // Advance Frequency Slide
      slide += dslide;
      period *= slide;
      if (period > maxPeriod) {
        period = maxPeriod;
        if (params.minFrequency > 0.0) {
          break; // cut off
        }
      }

      var iperiod = period.round();
      if (iperiod < 8) iperiod = 8;

      squareDuty = (squareDuty + dutySweep).clamp(0.0, 0.5);

      // Synthesize Waveform Sample
      phase++;
      if (phase >= iperiod) phase %= iperiod;
      final fp = phase / iperiod;

      double sample = 0.0;
      switch (params.waveType) {
        case Waveform.square:
          sample = fp < squareDuty ? 0.5 : -0.5;
        case Waveform.sawtooth:
          sample = 1.0 - fp * 2.0;
        case Waveform.sine:
          sample = math.sin(fp * 2.0 * math.pi);
        case Waveform.triangle:
          sample = fp < 0.5 ? (fp * 4.0 - 1.0) : (3.0 - fp * 4.0);
        case Waveform.noise:
          sample = rnd.nextDouble() * 2.0 - 1.0;
      }

      out[i] = (sample * envVol * params.masterVolume).clamp(-1.0, 1.0);
    }

    return out;
  }

  /// Synthesizes 16-bit signed PCM audio samples.
  Int16List generatePcm16({int sampleRate = 44100}) {
    final floatSamples = generatePcm(sampleRate: sampleRate);
    final pcm16 = Int16List(floatSamples.length);
    for (var i = 0; i < floatSamples.length; i++) {
      pcm16[i] = (floatSamples[i] * 32767.0).round().clamp(-32768, 32767);
    }
    return pcm16;
  }

  /// Exports synthesized sound as a standard 16-bit Mono RIFF WAVE byte buffer.
  Uint8List toWavBytes({int sampleRate = 44100}) {
    final pcm16 = generatePcm16(sampleRate: sampleRate);
    final dataSize = pcm16.length * 2;
    final totalSize = 44 + dataSize;
    final bytes = Uint8List(totalSize);
    final bd = ByteData.sublistView(bytes);

    // RIFF chunk descriptor
    bytes[0] = 0x52; // 'R'
    bytes[1] = 0x49; // 'I'
    bytes[2] = 0x46; // 'F'
    bytes[3] = 0x46; // 'F'
    bd.setUint32(4, 36 + dataSize, Endian.little);
    bytes[8] = 0x57;  // 'W'
    bytes[9] = 0x41;  // 'A'
    bytes[10] = 0x56; // 'V'
    bytes[11] = 0x45; // 'E'

    // 'fmt ' sub-chunk
    bytes[12] = 0x66; // 'f'
    bytes[13] = 0x6D; // 'm'
    bytes[14] = 0x74; // 't'
    bytes[15] = 0x20; // ' '
    bd.setUint32(16, 16, Endian.little); // Subchunk1Size (16 for PCM)
    bd.setUint16(20, 1, Endian.little);  // AudioFormat (1 = PCM)
    bd.setUint16(22, 1, Endian.little);  // NumChannels (1 = Mono)
    bd.setUint32(24, sampleRate, Endian.little);
    bd.setUint32(28, sampleRate * 2, Endian.little); // ByteRate (sampleRate * 2 bytes/sample)
    bd.setUint16(32, 2, Endian.little);  // BlockAlign
    bd.setUint16(34, 16, Endian.little); // BitsPerSample (16)

    // 'data' sub-chunk
    bytes[36] = 0x64; // 'd'
    bytes[37] = 0x61; // 'a'
    bytes[38] = 0x74; // 't'
    bytes[39] = 0x61; // 'a'
    bd.setUint32(40, dataSize, Endian.little);

    // Sample data
    for (var i = 0; i < pcm16.length; i++) {
      bd.setInt16(44 + i * 2, pcm16[i], Endian.little);
    }

    return bytes;
  }
}

/// Convenience procedural synth singleton.
final class VoxSynth {
  SynthSound laser({math.Random? random}) => SynthSound.laser(random: random);
  SynthSound explosion({math.Random? random}) => SynthSound.explosion(random: random);
  SynthSound powerup({math.Random? random}) => SynthSound.powerup(random: random);
  SynthSound hit({math.Random? random}) => SynthSound.hit(random: random);
  SynthSound jump({math.Random? random}) => SynthSound.jump(random: random);
  SynthSound coin({math.Random? random}) => SynthSound.coin(random: random);
  SynthSound blip({math.Random? random}) => SynthSound.blip(random: random);
}

final voxsynth = VoxSynth();
