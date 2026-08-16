import 'dart:io';

import 'package:flutter/material.dart';

import 'app.dart';
import 'models/app_mode.dart';
import 'models/audio_settings.dart';
import 'models/concat_settings.dart';
import 'models/mux_settings.dart';
import 'models/video_settings.dart';
import 'state/app_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.environment['FFMPEG_SELFTEST'] == '1') {
    runSelftest();
    return;
  }
  final controller = AppController();
  // 调试用：FFMPEG_DEBUG_LOG=1 时启动即展开日志并填入示例行（用于 UI 截图评估）
  if (Platform.environment['FFMPEG_DEBUG_LOG'] == '1') {
    controller.setLogVisible(true);
    const sample = [
      '普通日志：参数设置完成',
      '   [error] 示例错误行：invalid sync code',
      '   ⚠ 警告示例：输出文件未生成',
      'size=14954KiB time=00:02:00.01 bitrate=1020.7kbits/s speed=325x',
    ];
    for (final l in sample) {
      controller.addLog(l);
    }
  }
  runApp(FfmpegGuiApp(controller: controller));
}

/// 隐藏自检模式：FFMPEG_SELFTEST=1 时按指定模式处理文件并写出结果。
/// 环境变量：
///   FFMPEG_SELFTEST_MODE   audio|video|mux|concat
///   FFMPEG_SELFTEST_FILES  用 | 分隔的输入文件
///   FFMPEG_SELFTEST_OUTDIR 输出目录
///   FFMPEG_SELFTEST_OUT    结果文件
Future<void> runSelftest() async {
  final mode =
      AppMode.values.asNameMap()[Platform.environment['FFMPEG_SELFTEST_MODE']] ??
          AppMode.audio;
  final files = (Platform.environment['FFMPEG_SELFTEST_FILES'] ?? '')
      .split('|')
      .where((e) => e.trim().isNotEmpty)
      .map((e) => e.trim())
      .toList();
  final outDir = Platform.environment['FFMPEG_SELFTEST_OUTDIR'] ??
      Directory.systemTemp.path;
  final outFile = Platform.environment['FFMPEG_SELFTEST_OUT'] ?? '';

  String result;
  try {
    final c = AppController();
    await c.ready;
    await c.refreshEngine();
    if (!c.engineReady) {
      throw StateError('ffmpeg 不可用：${c.engineStatus}');
    }
    c.outDir = outDir;
    c.setMode(mode);
    // 自检使用默认参数，避免受用户已保存设置影响
    c.audio = AudioSettings();
    c.video = VideoSettings();
    c.mux = MuxSettings();
    c.concat = ConcatSettings();
    // 可选：FFMPEG_SELFTEST_CODEC=alac 等，用于指定编码器（音频模式）
    final codecName = Platform.environment['FFMPEG_SELFTEST_CODEC'];
    if (mode == AppMode.audio && codecName != null) {
      final codec = AudioCodec.values.asNameMap()[codecName];
      if (codec != null) {
        c.audio.codec = codec;
        final depth =
            int.tryParse(Platform.environment['FFMPEG_SELFTEST_BITDEPTH'] ?? '');
        if (depth != null) c.audio.bitDepth = depth;
      }
    }
    switch (mode) {
      case AppMode.audio:
      case AppMode.video:
        c.addFiles(files);
      case AppMode.mux:
        if (files.isNotEmpty) c.setVideoFile(files[0]);
        if (files.length > 1) c.addAudioFile(files[1]);
      case AppMode.concat:
        c.addFiles(files);
    }
    if (mode == AppMode.concat &&
        Platform.environment['FFMPEG_SELFTEST_CONCAT_REENCODE'] == '1') {
      c.concat.reEncode = true;
    }
    await c.start();

    final expected = <String>[];
    switch (mode) {
      case AppMode.audio:
        for (final f in files) {
          expected.add(c.audio.outputPathFor(f, outDir));
        }
      case AppMode.video:
        for (final f in files) {
          expected.add(c.video.outputPathFor(f, outDir));
        }
      case AppMode.mux:
        if (files.isNotEmpty) expected.add(c.mux.outputPathFor(files[0], outDir));
      case AppMode.concat:
        expected.add(c.concat.outputPathFor(files, outDir));
    }
    final details = [
      for (final p in expected)
        '${File(p).existsSync() ? 'OK' : 'MISSING'}:$p'
    ];
    result =
        'completed=${!c.running} failed=${c.failedCount}\n${details.join('\n')}';
  } catch (e) {
    result = 'ERR $e';
  }
  try {
    File(outFile).writeAsStringSync(result, flush: true);
  } catch (_) {}
  exit(0);
}
