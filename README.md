# voxsynth

Procedural chiptune and sound effect synthesizer in pure Dart, inspired by sfxr.

`voxsynth` generates retro waveforms, chiptune sound effects, raw PCM buffers, and standard RIFF WAVE (`.wav`) files in memory with zero external audio assets.

## Features

- **Pure Dart & Host Decoupled**: Zero dependencies, runs on Dart VM, web, and desktop.
- **Waveform Oscillators**: Square (with duty cycle sweep), Sawtooth, Sine, Triangle, Noise.
- **Envelope & Pitch Controls**: Attack, Sustain, Punch, Decay, Frequency Slide, Delta Slide, Vibrato.
- **One-Click Presets**:
  - `voxsynth.laser()`
  - `voxsynth.explosion()`
  - `voxsynth.jump()`
  - `voxsynth.coin()`
  - `voxsynth.powerup()`
  - `voxsynth.hit()`
  - `voxsynth.blip()`
- **Audio Output**:
  - `generatePcm({sampleRate})`: 32-bit float audio samples in `[-1.0, 1.0]`.
  - `generatePcm16({sampleRate})`: 16-bit signed integer samples.
  - `toWavBytes({sampleRate})`: Standard RIFF WAVE format bytes ready for browser playback or file writing.

## Usage

```dart
import 'dart:io';
import 'package:voxsynth/voxsynth.dart';

void main() {
  // Generate a retro laser sound effect
  final laser = voxsynth.laser();

  // Export directly as .wav bytes
  final wavBytes = laser.toWavBytes();
  File('laser.wav').writeAsBytesSync(wavBytes);

  // Or get raw float PCM samples
  final pcmSamples = laser.generatePcm();
  print('Generated ${pcmSamples.length} audio samples');
}
```

## License

MIT
