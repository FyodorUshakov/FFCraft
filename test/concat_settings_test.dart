import 'package:ffmpeg_gui_flutter/models/concat_settings.dart';
import 'package:ffmpeg_gui_flutter/models/queue_item.dart';
import 'package:ffmpeg_gui_flutter/services/job_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const outDir = r'D:\Out';
  final audioItems = [
    QueueItem(r'D:\c\a.m4a'),
    QueueItem(r'D:\c\b.m4a'),
  ];

  group('音频拼接', () {
    test('复制模式：concat demuxer，输出沿用源扩展名', () {
      final s = ConcatSettings(kind: ConcatKind.audio);
      final job = JobBuilder.concatJob(
        s,
        audioItems,
        outDir,
        listFile: r'C:\Temp\list.txt',
      )!;
      expect(job.args, containsAllInOrder(['-f', 'concat', '-safe', '0']));
      expect(job.args, containsAllInOrder(['-i', r'C:\Temp\list.txt']));
      expect(job.args, containsAllInOrder(['-c', 'copy']));
      expect(job.outputPath, endsWith('_concat.m4a'));
    });

    test('兼容模式：转码为 WAV 后拼接', () {
      final s = ConcatSettings(kind: ConcatKind.audio, reEncode: true);
      final job = JobBuilder.concatJob(s, audioItems, outDir, listFile: '')!;
      expect(
        job.args,
        containsAllInOrder([
          '-filter_complex',
          '[0:a][1:a]concat=n=2:v=0:a=1[a]',
        ]),
      );
      expect(job.args, containsAllInOrder(['-map', '[a]']));
      expect(job.args, containsAllInOrder(['-c:a', 'pcm_s16le']));
      expect(job.outputPath, endsWith('.wav'));
    });

    test('兼容模式输出路径始终为 wav，不受容器设置影响', () {
      final s = ConcatSettings(
        kind: ConcatKind.audio,
        container: ConcatContainer.mp4,
        reEncode: true,
      );
      expect(s.outputPathFor(audioItems.map((i) => i.path).toList(), outDir),
          endsWith('_concat.wav'));
    });
  });

  group('视频拼接', () {
    test('默认仍为视频模式且行为不变', () {
      final s = ConcatSettings();
      expect(s.kind, ConcatKind.video);
      final job = JobBuilder.concatJob(
        s,
        [
          QueueItem(r'D:\c\a.mp4'),
          QueueItem(r'D:\c\b.mp4'),
        ],
        outDir,
        listFile: r'C:\Temp\list.txt',
      )!;
      expect(job.outputPath, endsWith('_concat.mp4'));
      expect(job.args, containsAllInOrder(['-f', 'concat', '-safe', '0']));
      expect(job.args, containsAllInOrder(['-c', 'copy']));
    });
  });

  test('kind 持久化往返', () {
    final s = ConcatSettings(kind: ConcatKind.audio, reEncode: true);
    final restored = ConcatSettings.decode(s.encode());
    expect(restored.kind, ConcatKind.audio);
    expect(restored.reEncode, isTrue);
    expect(ConcatSettings.decode('{}').kind, ConcatKind.video);
  });
}
