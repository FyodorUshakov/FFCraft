import 'dart:convert';

import 'app_mode.dart';

/// 音频输出编码。
enum AudioCodec { aac, mp3, flac, alac, wav, opus, vorbis }

extension AudioCodecX on AudioCodec {
  String get label => switch (this) {
        AudioCodec.aac => 'AAC',
        AudioCodec.mp3 => 'MP3',
        AudioCodec.flac => 'FLAC',
        AudioCodec.alac => 'ALAC',
        AudioCodec.wav => 'WAV (PCM)',
        AudioCodec.opus => 'Opus',
        AudioCodec.vorbis => 'Vorbis (OGG)',
      };

  String get ffmpegName => switch (this) {
        AudioCodec.aac => 'aac',
        AudioCodec.mp3 => 'libmp3lame',
        AudioCodec.flac => 'flac',
        AudioCodec.alac => 'alac',
        AudioCodec.wav => 'pcm_s16le',
        AudioCodec.opus => 'libopus',
        AudioCodec.vorbis => 'libvorbis',
      };

  bool get isLossless =>
      this == AudioCodec.flac || this == AudioCodec.alac || this == AudioCodec.wav;

  /// 输出容器是否支持内嵌封面（attached_pic）。
  /// 实测 OGG(Vorbis) / Opus / WAV 容器不支持图片流，映射会导致整个任务失败。
  bool get supportsCoverArt =>
      this == AudioCodec.aac ||
      this == AudioCodec.mp3 ||
      this == AudioCodec.flac ||
      this == AudioCodec.alac;

  String get outputExt => switch (this) {
        AudioCodec.aac => 'm4a',
        AudioCodec.mp3 => 'mp3',
        AudioCodec.flac => 'flac',
        AudioCodec.alac => 'm4a',
        AudioCodec.wav => 'wav',
        AudioCodec.opus => 'opus',
        AudioCodec.vorbis => 'ogg',
      };
}

/// 码率控制模式（有损编码）。
enum AudioBitrateMode { cbr, vbr, abr }

extension AudioBitrateModeX on AudioBitrateMode {
  String get label => switch (this) {
        AudioBitrateMode.cbr => '固定码率',
        AudioBitrateMode.vbr => '可变码率',
        AudioBitrateMode.abr => '平均码率',
      };
}

/// 音频转码参数。
class AudioSettings {
  AudioCodec codec;
  String sampleRate; // keep / Hz
  bool copyMetadata;
  int bitDepth; // 16 / 24 / 32（无损格式）
  int flacCompression; // 0-8
  AudioBitrateMode bitrateMode;
  int bitrate; // kbps（有损）
  double vbrQuality; // 编码器质量（MP3 0-9、AAC 0.1-2.0、Vorbis 0-10）

  AudioSettings({
    this.codec = AudioCodec.aac,
    this.sampleRate = 'keep',
    this.copyMetadata = true,
    this.bitDepth = 16,
    this.flacCompression = 5,
    this.bitrateMode = AudioBitrateMode.cbr,
    this.bitrate = 192,
    this.vbrQuality = 5,
  });

  factory AudioSettings.fromJson(Map<String, dynamic> json) {
    return AudioSettings(
      codec: AudioCodec.values.asNameMap()[json['codec']] ?? AudioCodec.aac,
      sampleRate: json['sampleRate'] as String? ?? 'keep',
      copyMetadata: json['copyMetadata'] as bool? ?? true,
      bitDepth: (json['bitDepth'] as num?)?.toInt() ?? 16,
      flacCompression: (json['flacCompression'] as num?)?.toInt() ?? 5,
      bitrateMode: AudioBitrateMode.values
              .asNameMap()[json['bitrateMode']] ??
          AudioBitrateMode.cbr,
      bitrate: (json['bitrate'] as num?)?.toInt() ?? 192,
      vbrQuality: (json['vbrQuality'] as num?)?.toDouble() ?? 5,
    );
  }

  Map<String, dynamic> toJson() => {
        'codec': codec.name,
        'sampleRate': sampleRate,
        'copyMetadata': copyMetadata,
        'bitDepth': bitDepth,
        'flacCompression': flacCompression,
        'bitrateMode': bitrateMode.name,
        'bitrate': bitrate,
        'vbrQuality': vbrQuality,
      };

  String encode() => jsonEncode(toJson());

  static AudioSettings decode(String raw) {
    try {
      return AudioSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return AudioSettings();
    }
  }

  String get outputExt => codec.outputExt;

  String outputPathFor(String input, String outDir) {
    final name = input.split(RegExp(r'[\\/]')).last;
    final dot = name.lastIndexOf('.');
    final stem = dot > 0 ? name.substring(0, dot) : name;
    return safeOutputPath(outDir, input, stem, outputExt);
  }

  /// 生成 ffmpeg 音频转码参数。
  List<String> buildArgs(String input, String outDir) {
    final args = <String>['-hide_banner', '-y', '-i', input];
    if (copyMetadata) {
      args.addAll(['-map_metadata', '0']);
    } else {
      args.addAll(['-map_metadata', '-1']);
    }
    // 只映射音频轨；若目标容器支持且源文件内嵌封面图（attached_pic），
    // 则一并原样复制，避免封面随 -vn 被丢弃。
    args.addAll(['-map', '0:a?']);
    if (codec.supportsCoverArt) {
      args.addAll(['-map', '0:v?', '-c:v', 'copy']);
    }
    args.addAll(['-c:a', codec.ffmpegName]);

    if (sampleRate != 'keep') {
      args.addAll(['-ar', sampleRate]);
    }

    if (codec.isLossless) {
      // 位深与（FLAC 的）压缩等级
      final fmt = _sampleFmtFor(codec);
      if (fmt.isNotEmpty) args.addAll(['-sample_fmt', fmt]);
      if (codec == AudioCodec.flac) {
        args.addAll(['-compression_level', '$flacCompression']);
      }
    } else {
      // 有损编码的码率 / 质量
      switch (codec) {
        case AudioCodec.aac:
          if (bitrateMode == AudioBitrateMode.vbr) {
            args.addAll([
              '-q:a',
              vbrQuality.clamp(0.1, 2.0).toStringAsFixed(1),
            ]);
          } else {
            args.addAll(['-b:a', '${bitrate}k']);
          }
        case AudioCodec.mp3:
          switch (bitrateMode) {
            case AudioBitrateMode.cbr:
              args.addAll(['-b:a', '${bitrate}k']);
            case AudioBitrateMode.abr:
              args.addAll(['-b:a', '${bitrate}k', '-abr', '1']);
            case AudioBitrateMode.vbr:
              args.addAll(['-q:a', vbrQuality.round().clamp(0, 9).toString()]);
          }
        case AudioCodec.opus:
          args.addAll(['-b:a', '${bitrate}k']);
          args.addAll([
            '-vbr',
            bitrateMode == AudioBitrateMode.cbr ? 'off' : 'on',
          ]);
        case AudioCodec.vorbis:
          if (bitrateMode == AudioBitrateMode.vbr) {
            args.addAll(['-q:a', vbrQuality.round().clamp(0, 10).toString()]);
          } else {
            args.addAll(['-b:a', '${bitrate}k']);
          }
        case AudioCodec.flac:
        case AudioCodec.alac:
        case AudioCodec.wav:
          break; // 无损，走上面的分支
      }
    }

    args.add(outputPathFor(input, outDir));
    return args;
  }

  String _sampleFmtFor(AudioCodec c) {
    switch (c) {
      case AudioCodec.wav:
        return switch (bitDepth) {
          24 => 'pcm_s24le',
          32 => 'pcm_s32le',
          _ => 'pcm_s16le',
        };
      case AudioCodec.alac:
        // ALAC 编码器只支持平面格式 s16p / s32p
        return bitDepth >= 24 ? 's32p' : 's16p';
      case AudioCodec.flac:
        return bitDepth >= 24 ? 's32' : 's16';
      default:
        return '';
    }
  }
}
