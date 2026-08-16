import 'package:flutter_test/flutter_test.dart';
import 'package:ffmpeg_gui_flutter/models/audio_settings.dart';
import 'package:ffmpeg_gui_flutter/models/concat_settings.dart';
import 'package:ffmpeg_gui_flutter/models/mux_settings.dart';
import 'package:ffmpeg_gui_flutter/models/queue_item.dart';
import 'package:ffmpeg_gui_flutter/models/video_settings.dart';
import 'package:ffmpeg_gui_flutter/services/job_builder.dart';

void main() {
  const input = r'D:\Music\测试 文件.flac';
  const outDir = r'D:\Out';

  group('音频转码参数', () {
    test('AAC 固定码率', () {
      final s = AudioSettings(codec: AudioCodec.aac, bitrate: 192);
      final args = s.buildArgs(input, outDir);
      expect(args, containsAllInOrder(['-c:a', 'aac']));
      expect(args, containsAllInOrder(['-b:a', '192k']));
      expect(args, contains('-vn'));
      expect(args, containsAllInOrder(['-map_metadata', '0']));
      expect(args.last, r'D:\Out\测试 文件.m4a');
    });

    test('MP3 VBR 质量', () {
      final s = AudioSettings(
        codec: AudioCodec.mp3,
        bitrateMode: AudioBitrateMode.vbr,
        vbrQuality: 3,
      );
      final args = s.buildArgs(input, outDir);
      expect(args, containsAllInOrder(['-c:a', 'libmp3lame']));
      expect(args, containsAllInOrder(['-q:a', '3']));
    });

    test('FLAC 压缩等级与位深', () {
      final s = AudioSettings(
        codec: AudioCodec.flac,
        bitDepth: 24,
        flacCompression: 8,
      );
      final args = s.buildArgs(input, outDir);
      expect(args, containsAllInOrder(['-c:a', 'flac']));
      expect(args, containsAllInOrder(['-sample_fmt', 's32']));
      expect(args, containsAllInOrder(['-compression_level', '8']));
      expect(args.last, endsWith('.flac'));
    });

    test('ALAC 使用平面采样格式', () {
      final s16 = AudioSettings(codec: AudioCodec.alac, bitDepth: 16);
      final a16 = s16.buildArgs(input, outDir);
      expect(a16, containsAllInOrder(['-c:a', 'alac']));
      expect(a16, containsAllInOrder(['-sample_fmt', 's16p']));
      expect(a16.last, endsWith('.m4a'));

      final s24 = AudioSettings(codec: AudioCodec.alac, bitDepth: 24);
      final a24 = s24.buildArgs(input, outDir);
      expect(a24, containsAllInOrder(['-sample_fmt', 's32p']));
    });

    test('不复制元数据', () {
      final s = AudioSettings(copyMetadata: false);
      final args = s.buildArgs(input, outDir);
      expect(args, containsAllInOrder(['-map_metadata', '-1']));
    });

    test('输出与输入同名时加 _out 后缀', () {
      final s = AudioSettings(codec: AudioCodec.aac);
      final p = s.outputPathFor(r'D:\Out\same.m4a', r'D:\Out');
      expect(p, r'D:\Out\same_out.m4a');
    });
  });

  group('视频转码参数', () {
    const vinput = r'D:\Videos\测试.mp4';

    test('H.264 CRF + 分辨率缩放 + 保留音轨', () {
      final s = VideoSettings(
        codec: VideoCodec.h264,
        resolution: '1920x1080',
        crf: 20,
      );
      final args = s.buildArgs(vinput, outDir);
      expect(args, containsAllInOrder(['-c:v', 'libx264']));
      expect(args, containsAllInOrder(['-vf', 'scale=1920:-2']));
      expect(args, containsAllInOrder(['-crf', '20']));
      expect(args, containsAllInOrder(['-c:a', 'copy']));
      expect(args, containsAllInOrder(['-pix_fmt', 'yuv420p']));
    });

    test('H.265 可变码率', () {
      final s = VideoSettings(
        codec: VideoCodec.h265,
        bitrateMode: VideoBitrateMode.vbr,
        bitrate: 4000,
        maxBitrate: 8000,
      );
      final args = s.buildArgs(vinput, outDir);
      expect(args, containsAllInOrder(['-c:v', 'libx265']));
      expect(args, containsAllInOrder(['-b:v', '4000k']));
      expect(args, containsAllInOrder(['-maxrate', '8000k']));
    });

    test('原样复制视频轨道', () {
      final s = VideoSettings(codec: VideoCodec.copy);
      final args = s.buildArgs(vinput, outDir);
      expect(args, containsAllInOrder(['-c:v', 'copy']));
      expect(args, isNot(contains('-crf')));
    });

    test('AV1 CRF 上限 63 与 VP9 输出 webm', () {
      final av1 = VideoSettings(codec: VideoCodec.av1, crf: 40);
      expect(av1.buildArgs(vinput, outDir), containsAllInOrder(['-crf', '40']));
      expect(av1.codec.maxCrf, 63);
      final vp9 = VideoSettings(codec: VideoCodec.vp9);
      expect(vp9.outputPathFor(vinput, outDir), endsWith('.webm'));
    });

    test('音轨转 AAC 或移除', () {
      final a = VideoSettings(
        audioTrack: VideoAudioTrack.aac,
        audioBitrate: 256,
      );
      expect(
        a.buildArgs(vinput, outDir),
        containsAllInOrder(['-c:a', 'aac', '-b:a', '256k']),
      );
      final n = VideoSettings(audioTrack: VideoAudioTrack.none);
      expect(n.buildArgs(vinput, outDir), contains('-an'));
    });
  });

  group('合流参数', () {
    test('视频+音频纯复制', () {
      final s = MuxSettings();
      final args = s.buildArgs(r'D:\v\movie.mp4', [r'D:\a\sound.m4a'], outDir);
      expect(args, containsAllInOrder(['-i', r'D:\v\movie.mp4']));
      expect(args, containsAllInOrder(['-i', r'D:\a\sound.m4a']));
      expect(args, containsAllInOrder(['-map', '0:v:0']));
      expect(args, containsAllInOrder(['-map', '1:a:0']));
      expect(args, contains('-c'));
      expect(args, contains('copy'));
      expect(args.last, endsWith('.mp4'));
    });

    test('多音轨合流', () {
      final s = MuxSettings();
      final args = s.buildArgs(
        r'D:\v\movie.mp4',
        [r'D:\a\a.m4a', r'D:\a\b.m4a'],
        outDir,
      );
      expect(args, containsAllInOrder(['-map', '2:a:0']));
    });
  });

  group('拼接参数', () {
    final items = [
      QueueItem(r'D:\c\a.mp4'),
      QueueItem(r'D:\c\b.mp4'),
    ];

    test('复制模式 concat demuxer', () {
      final s = ConcatSettings();
      final job = JobBuilder.concatJob(
        s,
        items,
        outDir,
        listFile: r'C:\Temp\list.txt',
      )!;
      expect(job.args, containsAllInOrder(['-f', 'concat', '-safe', '0']));
      expect(job.args, containsAllInOrder(['-i', r'C:\Temp\list.txt']));
      expect(job.args, containsAllInOrder(['-c', 'copy']));
      expect(job.outputPath, endsWith('_concat.mp4'));
    });

    test('兼容模式重编码拼接（H.265 + AAC 256k）', () {
      final s = ConcatSettings(reEncode: true);
      final job = JobBuilder.concatJob(s, items, outDir, listFile: '')!;
      expect(job.args, containsAllInOrder(['-filter_complex',
        '[0:v][0:a][1:v][1:a]concat=n=2:v=1:a=1[v][a]']));
      expect(job.args, containsAllInOrder(['-map', '[v]']));
      expect(job.args, containsAllInOrder(['-c:v', 'libx265']));
      expect(job.args, containsAllInOrder(['-preset', 'medium']));
      expect(job.args, containsAllInOrder(['-c:a', 'aac', '-b:a', '256k']));
    });

    test('兼容模式按最高分辨率缩放后拼接', () {
      final s = ConcatSettings(reEncode: true);
      final job = JobBuilder.concatJob(
        s,
        items,
        outDir,
        listFile: '',
        targetResolution: (1280, 720),
      )!;
      expect(
        job.args,
        contains(
          '[0:v]scale=1280:720:force_original_aspect_ratio=decrease,'
          'pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1[v0];'
          '[1:v]scale=1280:720:force_original_aspect_ratio=decrease,'
          'pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1[v1];'
          '[v0][0:a][v1][1:a]concat=n=2:v=1:a=1[v][a]',
        ),
      );
      expect(job.args, containsAllInOrder(['-c:v', 'libx265']));
    });
  });
}
