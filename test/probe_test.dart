import 'package:flutter_test/flutter_test.dart';
import 'package:ffmpeg_gui_flutter/models/queue_item.dart';
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

  test('pcm_s24le 位深识别（bits_per_raw_sample）', () {
    final info = MediaInfo.parse('''
Input #0, wav, from 'x.wav':
  Duration: 00:00:02.00, start: 0.000000, bitrate: 2116 kb/s
  Stream #0:0: Audio: pcm_s24le, 44100 Hz, stereo, s32, 2116 kb/s
    bits_per_raw_sample=24
''');
    expect(info.bitDepth, 24);
    expect(info.bitDepthLabel, '24-bit');
  });

  test('FLAC 16-bit 位深识别', () {
    final info = MediaInfo.parse('''
  Stream #0:0: Audio: flac, 44100 Hz, stereo, s16
''');
    expect(info.bitDepth, 16);
    expect(info.bitDepthLabel, '16-bit');
  });

  test('FLAC 24-bit 括号标注识别（s32 (24 bit)）', () {
    final info = MediaInfo.parse('''
Input #0, flac, from 'Ado - おどるポンポコリン.flac':
  Duration: 00:03:14.53, start: 0.000000, bitrate: 1900 kb/s
  Stream #0:0: Audio: flac, 48000 Hz, stereo, s32 (24 bit)
''');
    expect(info.bitDepth, 24);
    expect(info.bitDepthLabel, '24-bit');
    expect(info.sampleRate, '48000');
  });

  test('浮点 WAV 标注 float', () {
    final info = MediaInfo.parse('''
  Stream #0:0: Audio: pcm_f32le, 44100 Hz, stereo, flt, 4233 kb/s
''');
    expect(info.bitDepth, 32);
    expect(info.bitDepthLabel, '32-bit float');
  });

  test('有损格式不显示位深', () {
    final info = MediaInfo.parse('''
  Stream #0:0: Audio: mp3, 44100 Hz, stereo, fltp, 320 kb/s
''');
    expect(info.bitDepth, isNull);
    expect(info.bitDepthLabel, isNull);
  });

  test('队列元数据摘要包含位深', () {
    final item = QueueItem(r'D:\x\song.flac');
    item.format = 'flac';
    item.sizeMb = 12.34;
    item.durationSec = 125;
    item.bitrateKbps = 900;
    item.bitDepthLabel = '24-bit';
    final line = item.metaLine;
    expect(line, contains('FLAC'));
    expect(line, contains('24-bit'));
    expect(line, contains('900 kbps'));
  });
}
