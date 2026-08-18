import 'dart:io';

import '../models/app_mode.dart';
import '../models/audio_settings.dart';
import '../models/concat_settings.dart';
import '../models/job.dart';
import '../models/mux_settings.dart';
import '../models/queue_item.dart';
import '../models/video_settings.dart';
import '../l10n/l10n_helper.dart';

/// 根据模式与设置生成 ffmpeg 任务。
class JobBuilder {
  static String _dirFor(String outDir, String input) {
    final d = outDir.trim();
    return d.isEmpty ? File(input).parent.path : d;
  }

  static List<Job> audioJobs(
    AudioSettings s,
    List<QueueItem> items,
    String outDir,
  ) {
    return [
      for (final item in items)
        _makeJob(
          s.buildArgs(item.path, _dirFor(outDir, item.path)),
          s.outputPathFor(item.path, _dirFor(outDir, item.path)),
          '${modeLabel(AppMode.audio)} ${item.name}',
          item.path,
        ),
    ];
  }

  static List<Job> videoJobs(
    VideoSettings s,
    List<QueueItem> items,
    String outDir,
  ) {
    return [
      for (final item in items)
        _makeJob(
          s.buildArgs(item.path, _dirFor(outDir, item.path)),
          s.outputPathFor(item.path, _dirFor(outDir, item.path)),
          '${modeLabel(AppMode.video)} ${item.name}',
          item.path,
        ),
    ];
  }

  static Job? muxJob(
    MuxSettings s,
    String videoFile,
    List<String> audioFiles,
    String outDir,
  ) {
    if (videoFile.isEmpty) return null;
    final dir = _dirFor(outDir, videoFile);
    return _makeJob(
      s.buildArgs(videoFile, audioFiles, dir),
      s.outputPathFor(videoFile, dir),
      '${modeLabel(AppMode.mux)} ${videoFile.split(RegExp(r'[\\/]')).last}',
      videoFile,
    );
  }

  static Job? concatJob(
    ConcatSettings s,
    List<QueueItem> items,
    String outDir, {
    required String listFile,
    (int, int)? targetResolution,
  }) {
    if (items.isEmpty) return null;
    final inputs = [for (final i in items) i.path];
    final first = inputs.first;
    final dir = _dirFor(outDir, first);
    final videoSource = isVideoExtension(first);
    final kindLabel = s.kind == ConcatKind.audio
        ? l10n((a) => a.concatKindAudio, '音频拼接')
        : l10n((a) => a.concatKindVideo, '视频拼接');
    return _makeJob(
      s.buildArgs(
        inputs,
        dir,
        listFile: listFile,
        videoSource: videoSource,
        targetResolution: targetResolution,
      ),
      s.outputPathFor(inputs, dir),
      '$kindLabel ${inputs.length}',
      first,
    );
  }

  static Job _makeJob(
    List<String> args,
    String outputPath,
    String label,
    String input,
  ) {
    return Job(
      label: label,
      input: input,
      args: args,
      outputPath: outputPath,
    );
  }

  /// 写 concat 列表文件（-f concat 使用）。
  static Future<String> writeConcatList(List<String> paths) async {
    final dir = Directory.systemTemp.createTempSync('ffmpeg_concat_');
    final listFile = File('${dir.path}${Platform.pathSeparator}list.txt');
    final buf = StringBuffer();
    for (final p in paths) {
      buf.writeln("file '${p.replaceAll('\\', '/')}'");
    }
    await listFile.writeAsString(buf.toString());
    return listFile.path;
  }
}
