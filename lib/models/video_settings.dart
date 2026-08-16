import 'dart:convert';

import 'app_mode.dart';

/// 视频输出编码。
enum VideoCodec { h264, h265, av1, vp9, mpeg4, copy }

extension VideoCodecX on VideoCodec {
  String get label => switch (this) {
        VideoCodec.h264 => 'H.264',
        VideoCodec.h265 => 'H.265 (HEVC)',
        VideoCodec.av1 => 'AV1',
        VideoCodec.vp9 => 'VP9',
        VideoCodec.mpeg4 => 'MPEG-4',
        VideoCodec.copy => '原样复制',
      };

  String get ffmpegName => switch (this) {
        VideoCodec.h264 => 'libx264',
        VideoCodec.h265 => 'libx265',
        VideoCodec.av1 => 'libsvtav1',
        VideoCodec.vp9 => 'libvpx-vp9',
        VideoCodec.mpeg4 => 'mpeg4',
        VideoCodec.copy => 'copy',
      };

  bool get supportsCrf =>
      this == VideoCodec.h264 ||
      this == VideoCodec.h265 ||
      this == VideoCodec.av1 ||
      this == VideoCodec.vp9;

  int get maxCrf => (this == VideoCodec.av1 || this == VideoCodec.vp9) ? 63 : 51;

  String get outputExt =>
      this == VideoCodec.vp9 ? 'webm' : 'mp4';
}

/// 视频码率控制模式。
enum VideoBitrateMode { crf, cbr, vbr, abr }

extension VideoBitrateModeX on VideoBitrateMode {
  String get label => switch (this) {
        VideoBitrateMode.crf => '质量 (CRF)',
        VideoBitrateMode.cbr => '固定码率',
        VideoBitrateMode.vbr => '可变码率',
        VideoBitrateMode.abr => '平均码率',
      };
}

/// 音轨处理方式。
enum VideoAudioTrack { keep, aac, mp3, none }

extension VideoAudioTrackX on VideoAudioTrack {
  String get label => switch (this) {
        VideoAudioTrack.keep => '保持不变',
        VideoAudioTrack.aac => '转码为 AAC',
        VideoAudioTrack.mp3 => '转码为 MP3',
        VideoAudioTrack.none => '移除音轨',
      };
}

/// 视频转码参数。
class VideoSettings {
  VideoCodec codec;
  String preset; // x264/x265: veryfast..veryslow；AV1: 1-13
  String resolution; // keep / WxH / 自定义
  String customResolution; // "宽x高"
  VideoBitrateMode bitrateMode;
  int crf;
  int bitrate; // kbps 目标码率
  int maxBitrate; // kbps 最大码率（VBR）
  String framerate; // keep / 数值
  VideoAudioTrack audioTrack;
  int audioBitrate; // kbps
  bool copyMetadata;
  bool pixCompat; // yuv420p 兼容模式
  bool hwAccel; // 硬件加速
  String hwEncoder; // 如 h264_nvenc

  VideoSettings({
    this.codec = VideoCodec.h264,
    this.preset = 'medium',
    this.resolution = 'keep',
    this.customResolution = '1920x1080',
    this.bitrateMode = VideoBitrateMode.crf,
    this.crf = 23,
    this.bitrate = 4000,
    this.maxBitrate = 8000,
    this.framerate = 'keep',
    this.audioTrack = VideoAudioTrack.keep,
    this.audioBitrate = 192,
    this.copyMetadata = true,
    this.pixCompat = true,
    this.hwAccel = false,
    this.hwEncoder = '',
  });

  factory VideoSettings.fromJson(Map<String, dynamic> json) {
    return VideoSettings(
      codec: VideoCodec.values.asNameMap()[json['codec']] ?? VideoCodec.h264,
      preset: json['preset'] as String? ?? 'medium',
      resolution: json['resolution'] as String? ?? 'keep',
      customResolution: json['customResolution'] as String? ?? '1920x1080',
      bitrateMode: VideoBitrateMode.values
              .asNameMap()[json['bitrateMode']] ??
          VideoBitrateMode.crf,
      crf: (json['crf'] as num?)?.toInt() ?? 23,
      bitrate: (json['bitrate'] as num?)?.toInt() ?? 4000,
      maxBitrate: (json['maxBitrate'] as num?)?.toInt() ?? 8000,
      framerate: json['framerate'] as String? ?? 'keep',
      audioTrack: VideoAudioTrack.values
              .asNameMap()[json['audioTrack']] ??
          VideoAudioTrack.keep,
      audioBitrate: (json['audioBitrate'] as num?)?.toInt() ?? 192,
      copyMetadata: json['copyMetadata'] as bool? ?? true,
      pixCompat: json['pixCompat'] as bool? ?? true,
      hwAccel: json['hwAccel'] as bool? ?? false,
      hwEncoder: json['hwEncoder'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'codec': codec.name,
        'preset': preset,
        'resolution': resolution,
        'customResolution': customResolution,
        'bitrateMode': bitrateMode.name,
        'crf': crf,
        'bitrate': bitrate,
        'maxBitrate': maxBitrate,
        'framerate': framerate,
        'audioTrack': audioTrack.name,
        'audioBitrate': audioBitrate,
        'copyMetadata': copyMetadata,
        'pixCompat': pixCompat,
        'hwAccel': hwAccel,
        'hwEncoder': hwEncoder,
      };

  String encode() => jsonEncode(toJson());

  static VideoSettings decode(String raw) {
    try {
      return VideoSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return VideoSettings();
    }
  }

  /// 有效分辨率字符串，例如 1920x1080；keep 返回空。
  String get effectiveResolution {
    if (resolution == 'custom') {
      final r = customResolution.trim().toLowerCase();
      if (RegExp(r'^\d+x\d+$').hasMatch(r)) return r;
      return '';
    }
    if (resolution != 'keep') return resolution;
    return '';
  }

  String outputPathFor(String input, String outDir) {
    final name = input.split(RegExp(r'[\\/]')).last;
    final dot = name.lastIndexOf('.');
    final stem = dot > 0 ? name.substring(0, dot) : name;
    if (hwAccel && hwEncoder.isNotEmpty) {
      return safeOutputPath(outDir, input, stem, 'mp4');
    }
    String ext;
    if (codec == VideoCodec.copy) {
      final src = extensionOf(input);
      ext = ['mp4', 'mkv', 'mov', 'webm', 'avi', 'ts', 'flv'].contains(src)
          ? src
          : 'mp4';
    } else {
      ext = codec.outputExt;
    }
    return safeOutputPath(outDir, input, stem, ext);
  }

  /// 生成 ffmpeg 视频转码参数。
  List<String> buildArgs(String input, String outDir) {
    final args = <String>['-hide_banner', '-y', '-i', input];
    if (copyMetadata) {
      args.addAll(['-map_metadata', '0']);
    } else {
      args.addAll(['-map_metadata', '-1']);
    }

    final usingHw = codec != VideoCodec.copy && hwAccel && hwEncoder.isNotEmpty;
    if (codec != VideoCodec.copy) {
      if (usingHw) {
        args.addAll(['-c:v', hwEncoder]);
      } else {
        args.addAll(['-c:v', codec.ffmpegName]);
        final presetList = presetsFor(codec);
        if (presetList.isNotEmpty && preset.isNotEmpty) {
          args.addAll(['-preset', preset]);
        }
      }
      final res = effectiveResolution;
      if (res.isNotEmpty) {
        final parts = res.split('x');
        if (parts.length == 2) {
          args.addAll(['-vf', 'scale=${parts[0]}:-2']);
        }
      }
      if (framerate != 'keep') {
        args.addAll(['-r', framerate]);
      }

      if (usingHw) {
        final enc = hwEncoder;
        switch (bitrateMode) {
          case VideoBitrateMode.crf:
            if (enc.contains('nvenc')) {
              args.addAll(['-rc', 'vbr', '-cq', crf.clamp(0, 51).toString()]);
            } else if (enc.contains('qsv')) {
              args.addAll(
                  ['-global_quality', crf.clamp(0, 51).toString()]);
            } else if (enc.contains('videotoolbox')) {
              args.addAll(['-q:v', crf.clamp(0, 100).toString()]);
            } else if (enc.contains('amf')) {
              args.addAll(
                  ['-rc', 'cqp', '-qp_i', '$crf', '-qp_p', '$crf']);
            } else {
              args.addAll(['-b:v', '${bitrate}k']);
            }
          case VideoBitrateMode.cbr:
            args.addAll(['-b:v', '${bitrate}k']);
            if (enc.contains('nvenc') || enc.contains('qsv')) {
              args.addAll([
                '-minrate', '${bitrate}k',
                '-maxrate', '${bitrate}k',
                '-bufsize', '${bitrate * 2}k',
              ]);
            }
          case VideoBitrateMode.vbr:
            args.addAll(['-b:v', '${bitrate}k']);
            if (enc.contains('nvenc') || enc.contains('qsv')) {
              args.addAll([
                '-maxrate', '${maxBitrate}k',
                '-bufsize', '${maxBitrate * 2}k',
              ]);
            }
          case VideoBitrateMode.abr:
            args.addAll(['-b:v', '${bitrate}k']);
        }
        if (pixCompat) {
          args.addAll(['-pix_fmt', 'yuv420p']);
        }
      } else if (bitrateMode == VideoBitrateMode.crf && codec.supportsCrf) {
        args.addAll(['-crf', crf.clamp(0, codec.maxCrf).toString()]);
      } else {
        switch (bitrateMode) {
          case VideoBitrateMode.cbr:
            args.addAll([
              '-b:v', '${bitrate}k',
              '-minrate', '${bitrate}k',
              '-maxrate', '${bitrate}k',
              '-bufsize', '${bitrate * 2}k',
            ]);
          case VideoBitrateMode.vbr:
            args.addAll([
              '-b:v', '${bitrate}k',
              '-maxrate', '${maxBitrate}k',
              '-bufsize', '${maxBitrate * 2}k',
            ]);
          case VideoBitrateMode.abr:
          case VideoBitrateMode.crf:
            args.addAll(['-b:v', '${bitrate}k']);
        }
      }

      if (pixCompat && (codec == VideoCodec.h264 ||
          codec == VideoCodec.h265 ||
          codec == VideoCodec.mpeg4)) {
        args.addAll(['-pix_fmt', 'yuv420p']);
      }
    } else {
      args.addAll(['-c:v', 'copy']);
    }

    switch (audioTrack) {
      case VideoAudioTrack.keep:
        args.addAll(['-c:a', 'copy']);
      case VideoAudioTrack.aac:
        args.addAll(['-c:a', 'aac', '-b:a', '${audioBitrate}k']);
      case VideoAudioTrack.mp3:
        args.addAll(['-c:a', 'libmp3lame', '-b:a', '${audioBitrate}k']);
      case VideoAudioTrack.none:
        args.add('-an');
    }

    args.add(outputPathFor(input, outDir));
    return args;
  }
}

/// 各编码支持的预设列表。
List<String> presetsFor(VideoCodec codec) {
  switch (codec) {
    case VideoCodec.h264:
    case VideoCodec.h265:
      return const [
        'ultrafast', 'superfast', 'veryfast', 'faster', 'fast',
        'medium', 'slow', 'slower', 'veryslow',
      ];
    case VideoCodec.av1:
      return const [
        '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13',
      ];
    default:
      return const [];
  }
}
