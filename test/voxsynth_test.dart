import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:voxsynth/voxsynth.dart';

void main() {
  group('voxsynth - Procedural Chiptune & SFX Synthesizer Suite', () {
    test('Preset generators instantiate valid SynthParams', () {
      final laser = voxsynth.laser();
      expect(laser.params.slide, lessThan(0.0)); // laser pitch drops

      final jump = voxsynth.jump();
      expect(jump.params.slide, greaterThan(0.0)); // jump pitch rises

      final explosion = voxsynth.explosion();
      expect(explosion.params.waveType, equals(Waveform.noise));

      final coin = voxsynth.coin();
      expect(coin.params.waveType, equals(Waveform.sine));

      final blip = voxsynth.blip();
      expect(blip.params.sustainTime, lessThanOrEqualTo(0.1));
    });

    test('PCM float and 16-bit sample generation bounds', () {
      final sfx = voxsynth.laser();
      final pcm = sfx.generatePcm(sampleRate: 44100);

      expect(pcm.length, greaterThan(500));
      for (final s in pcm) {
        expect(s, inInclusiveRange(-1.0, 1.0));
      }

      final pcm16 = sfx.generatePcm16(sampleRate: 44100);
      expect(pcm16.length, equals(pcm.length));
      for (final s in pcm16) {
        expect(s, inInclusiveRange(-32768, 32767));
      }
    });

    test('Valid RIFF WAVE file header and sample serialization', () {
      final sfx = voxsynth.coin();
      final wav = sfx.toWavBytes(sampleRate: 44100);

      expect(wav.length, greaterThan(44));

      // RIFF header
      expect(String.fromCharCodes(wav.sublist(0, 4)), equals('RIFF'));
      expect(String.fromCharCodes(wav.sublist(8, 12)), equals('WAVE'));

      // fmt chunk
      expect(String.fromCharCodes(wav.sublist(12, 16)), equals('fmt '));
      final bd = ByteData.sublistView(wav);
      expect(bd.getUint16(20, Endian.little), equals(1)); // PCM format
      expect(bd.getUint16(22, Endian.little), equals(1)); // 1 channel (mono)
      expect(bd.getUint32(24, Endian.little), equals(44100)); // Sample rate
      expect(bd.getUint16(34, Endian.little), equals(16)); // 16 bits per sample

      // data chunk
      expect(String.fromCharCodes(wav.sublist(36, 40)), equals('data'));
      final dataSize = bd.getUint32(40, Endian.little);
      expect(wav.length, equals(44 + dataSize));
    });
  });
}
