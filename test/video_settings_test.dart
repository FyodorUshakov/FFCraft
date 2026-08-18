import 'package:ffmpeg_gui_flutter/models/video_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('硬件编码档位', () {
    const input = r'D:\Video\测试.mp4';
    const outDir = r'D:\Out';

    test('NVENC 档位 p1-p7，默认 p4', () {
      expect(hwPresetsFor('h264_nvenc'), ['p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7']);
      expect(defaultHwPreset('h264_nvenc'), 'p4');
      final s = VideoSettings(
        hwAccel: true,
        hwEncoder: 'h264_nvenc',
        hwPreset: 'p6',
      );
      final args = s.buildArgs(input, outDir);
      expect(args, containsAllInOrder(['-c:v', 'h264_nvenc']));
      expect(args, containsAllInOrder(['-preset', 'p6']));
      expect(args, isNot(contains('-quality')));
    });

    test('QSV 档位 veryfast-veryslow，默认 medium', () {
      expect(hwPresetsFor('hevc_qsv').first, 'veryfast');
      expect(hwPresetsFor('hevc_qsv').last, 'veryslow');
      expect(defaultHwPreset('hevc_qsv'), 'medium');
      final s = VideoSettings(
        codec: VideoCodec.h265,
        hwAccel: true,
        hwEncoder: 'hevc_qsv',
        hwPreset: 'slower',
      );
      final args = s.buildArgs(input, outDir);
      expect(args, containsAllInOrder(['-c:v', 'hevc_qsv']));
      expect(args, containsAllInOrder(['-preset', 'slower']));
    });

    test('AMF 使用 -quality，默认 balanced', () {
      expect(hwPresetsFor('h264_amf'),
          ['speed', 'balanced', 'quality', 'high_quality']);
      expect(defaultHwPreset('h264_amf'), 'balanced');
      final s = VideoSettings(
        hwAccel: true,
        hwEncoder: 'h264_amf',
        hwPreset: 'high_quality',
      );
      final args = s.buildArgs(input, outDir);
      expect(args, containsAllInOrder(['-quality', 'high_quality']));
      expect(args, isNot(contains('-preset')));
    });

    test('VideoToolbox 无档位参数', () {
      expect(hwPresetsFor('h264_videotoolbox'), isEmpty);
      final s = VideoSettings(
        hwAccel: true,
        hwEncoder: 'h264_videotoolbox',
      );
      final args = s.buildArgs(input, outDir);
      expect(args, containsAllInOrder(['-c:v', 'h264_videotoolbox']));
      expect(args, isNot(contains('-preset')));
      expect(args, isNot(contains('-quality')));
    });

    test('软件模式仍使用软件预设', () {
      final s = VideoSettings(
        codec: VideoCodec.h264,
        preset: 'veryfast',
        hwAccel: false,
      );
      final args = s.buildArgs(input, outDir);
      expect(args, containsAllInOrder(['-c:v', 'libx264']));
      expect(args, containsAllInOrder(['-preset', 'veryfast']));
    });

    test('hwPreset 持久化往返', () {
      final s = VideoSettings(
        hwAccel: true,
        hwEncoder: 'hevc_nvenc',
        hwPreset: 'p2',
      );
      final restored = VideoSettings.decode(s.encode());
      expect(restored.hwPreset, 'p2');
      expect(restored.hwEncoder, 'hevc_nvenc');
      expect(restored.hwAccel, isTrue);
    });
  });
}
