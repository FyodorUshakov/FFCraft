import 'package:flutter_test/flutter_test.dart';
import 'package:ffmpeg_gui_flutter/services/probe.dart';

void main() {
  test('解析 ffmpeg -i 输出', () {
    const text = '''
Input #0, flac, from 'x.flac':
  Duration: 00:02:00.02, start: 0.000000, bitrate: 999 kb/s
  Stream #0:0: Audio: flac, 44100 Hz, stereo, s16
  Stream #0:1: Video: mjpeg (Baseline), yuvj420p, 1080x1080 (attached pic)
''';
    final info = MediaInfo.parse(text);
    expect(info.durationSec, closeTo(120.02, 0.001));
    expect(info.bitrateKbps, 999);
    expect(info.audioCodec, 'flac');
    expect(info.sampleRate, '44100');
    expect(info.channels, 'stereo');
    expect(info.videoCodec, 'mjpeg');
    expect(info.resolution, '1080×1080');
    expect(info.width, 1080);
    expect(info.height, 1080);
  });

  test('无信息时返回空字段', () {
    final info = MediaInfo.parse('nothing useful');
    expect(info.durationSec, isNull);
    expect(info.bitrateKbps, isNull);
    expect(info.audioCodec, isNull);
  });
}
