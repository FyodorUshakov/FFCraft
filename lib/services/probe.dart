import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'ffmpeg_manager.dart';

/// 解析 ffmpeg -i 输出得到的媒体信息。
class MediaInfo {
  final double? durationSec;
  final int? bitrateKbps;
  final String? audioCodec;
  final String? sampleRate;
  final String? channels;
  final String? videoCodec;
  final String? resolution;
  final int? width;
  final int? height;
  final String? sampleFormat;
  final int? bitDepth;
  final String? bitDepthLabel;

  const MediaInfo({
    this.durationSec,
    this.bitrateKbps,
    this.audioCodec,
    this.sampleRate,
    this.channels,
    this.videoCodec,
    this.resolution,
    this.width,
    this.height,
    this.sampleFormat,
    this.bitDepth,
    this.bitDepthLabel,
  });

  /// 从 ffmpeg -i 的标准错误输出解析。
  factory MediaInfo.parse(String text) {
    double? duration;
    int? bitrate;
    String? audioCodec;
    String? sampleRate;
    String? channels;
    String? sampleFormat;
    int? bitDepth;
    String? bitDepthLabel;
    String? videoCodec;
    String? resolution;
    int? width;
    int? height;

    final dur = RegExp(r'Duration:\s*(\d+):(\d+):(\d+(?:\.\d+)?)')
        .firstMatch(text);
    if (dur != null) {
      duration = int.parse(dur.group(1)!) * 3600 +
          int.parse(dur.group(2)!) * 60 +
          double.parse(dur.group(3)!);
    }
    final br = RegExp(r'bitrate:\s*(\d+(?:\.\d+)?)\s*kb/s')
        .firstMatch(text);
    if (br != null) bitrate = double.parse(br.group(1)!).round();

    final audio = RegExp(
      r'Stream #\d+:\d+.*?Audio:\s*([^,\s]+)(?:\s*\([^)]*\))?,\s*(\d+)\s*Hz,\s*([^,\s]+)(?:,\s*([^,\s]+))?',
    ).firstMatch(text);
    if (audio != null) {
      audioCodec = audio.group(1);
      sampleRate = audio.group(2);
      channels = audio.group(3);
      sampleFormat = audio.group(4);
    }

    // 位深：优先 bits_per_raw_sample（如 pcm_s24le 以 s32 存储但真实位深为 24），
    // 否则按采样格式推断；仅对无损格式显示
    final codec = audioCodec ?? '';
    final isLossless = codec.contains('pcm') ||
        const {
          'flac', 'alac', 'ape', 'wv', 'tta', 'wavpack',
          'mlp', 'truehd', 'aiff',
        }.contains(codec);
    if (isLossless) {
      final raw =
          RegExp(r'bits_per_raw_sample=(\d+)').firstMatch(text)?.group(1);
      final rawDepth = raw == null ? null : int.tryParse(raw);
      bitDepth = rawDepth ?? _sampleFmtDepth(sampleFormat);
      bitDepthLabel = _depthLabel(bitDepth, sampleFormat);
    }

    final video = RegExp(
      r'Stream #\d+:\d+.*?Video:\s*([^,\s]+)',
    ).firstMatch(text);
    if (video != null) videoCodec = video.group(1);
    final res = RegExp(r'(\d{2,5})x(\d{2,5})').firstMatch(text);
    if (res != null) {
      resolution = '${res.group(1)}×${res.group(2)}';
      width = int.parse(res.group(1)!);
      height = int.parse(res.group(2)!);
    }

    return MediaInfo(
      durationSec: duration,
      bitrateKbps: bitrate,
      audioCodec: audioCodec,
      sampleRate: sampleRate,
      channels: channels,
      videoCodec: videoCodec,
      resolution: resolution,
      width: width,
      height: height,
      sampleFormat: sampleFormat,
      bitDepth: bitDepth,
      bitDepthLabel: bitDepthLabel,
    );
  }
}

/// 采样格式 → 位深（整数 PCM）。
int? _sampleFmtDepth(String? fmt) {
  switch (fmt) {
    case 's16':
    case 's16p':
      return 16;
    case 's24':
      return 24;
    case 's32':
    case 's32p':
      return 32;
    case 'flt':
    case 'fltp':
      return 32;
    case 'dbl':
    case 'dblp':
      return 64;
  }
  return null;
}

/// 位深展示文案；浮点格式单独标注。
String? _depthLabel(int? depth, String? fmt) {
  if (depth == null) return null;
  if (fmt == 'flt' || fmt == 'fltp') return '32-bit float';
  if (fmt == 'dbl' || fmt == 'dblp') return '64-bit float';
  return '$depth-bit';
}

/// 用 ffmpeg 探测媒体信息（时长、码率、流信息等）。
class MediaProbe {
  static Future<double?> duration(String ffmpegDir, String input) async {
    final result = await info(ffmpegDir, input);
    return result?.durationSec;
  }

  static Future<MediaInfo?> info(String ffmpegDir, String input) async {
    try {
      final proc = await Process.start(
        FfmpegManager.exePath(ffmpegDir),
        ['-hide_banner', '-i', input],
        workingDirectory: ffmpegDir,
        includeParentEnvironment: true,
      );
      final errFuture = proc.stderr
          .transform(const Utf8Decoder(allowMalformed: true))
          .join()
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () {
              proc.kill();
              return '';
            },
          );
      final err = await errFuture;
      if (err.isEmpty) return null;
      return MediaInfo.parse(err);
    } catch (_) {
      return null;
    }
  }
}
