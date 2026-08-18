import 'package:ffmpeg_gui_flutter/models/audio_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Opus 单声道码率钳制', () {
    test('单声道 320k 钳制到 256k', () {
      expect(AudioSettings.opusClampForChannels(320, 'mono'), 256);
      expect(AudioSettings.opusClampForChannels(320, '1'), 256);
    });

    test('单声道 256k 及以下不调整', () {
      expect(AudioSettings.opusClampForChannels(256, 'mono'), isNull);
      expect(AudioSettings.opusClampForChannels(192, 'mono'), isNull);
    });

    test('立体声/多声道不调整', () {
      expect(AudioSettings.opusClampForChannels(320, 'stereo'), isNull);
      expect(AudioSettings.opusClampForChannels(320, '5.1(side)'), isNull);
    });

    test('未知声道不调整', () {
      expect(AudioSettings.opusClampForChannels(320, null), isNull);
    });
  });
}
