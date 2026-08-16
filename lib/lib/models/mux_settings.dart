import 'dart:convert';

import 'app_mode.dart';

/// 合流输出容器。
enum MuxContainer { mp4, mkv, mov, webm, ts }

extension MuxContainerX on MuxContainer {
  String get label => switch (this) {
        MuxContainer.mp4 => 'MP4',
        MuxContainer.mkv => 'MKV',
        MuxContainer.mov => 'MOV',
        MuxContainer.webm => 'WebM',
        MuxContainer.ts => 'TS',
      };

  String get ext => name;
}

/// 音视频合流（纯封装）参数。
class MuxSettings {
  MuxContainer container;
  bool copyMetadata;

  MuxSettings({
    this.container = MuxContainer.mp4,
    this.copyMetadata = true,
  });

  factory MuxSettings.fromJson(Map<String, dynamic> json) {
    return MuxSettings(
      container: MuxContainer.values.asNameMap()[json['container']] ??
          MuxContainer.mp4,
      copyMetadata: json['copyMetadata'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'container': container.name,
        'copyMetadata': copyMetadata,
      };

  String encode() => jsonEncode(toJson());

  static MuxSettings decode(String raw) {
    try {
      return MuxSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return MuxSettings();
    }
  }

  String outputPathFor(String videoFile, String outDir) {
    final name = videoFile.split(RegExp(r'[\\/]')).last;
    final dot = name.lastIndexOf('.');
    final stem = dot > 0 ? name.substring(0, dot) : name;
    return safeOutputPath(outDir, videoFile, stem, container.ext);
  }

  /// 生成 ffmpeg 合流参数：所有轨道原样复制（-c copy）。
  List<String> buildArgs(
    String videoFile,
    List<String> audioFiles,
    String outDir,
  ) {
    final inputs = [videoFile, ...audioFiles];
    final args = <String>['-hide_banner', '-y'];
    for (final p in inputs) {
      args.addAll(['-i', p]);
    }
    if (audioFiles.isEmpty) {
      // 单个文件：仅更换封装容器
      args.addAll(['-c', 'copy']);
    } else {
      args.addAll(['-map', '0:v:0']);
      for (var i = 1; i < inputs.length; i++) {
        args.addAll(['-map', '$i:a:0']);
      }
      args.addAll(['-c', 'copy']);
    }
    if (copyMetadata) {
      args.addAll(['-map_metadata', '0']);
    } else {
      args.addAll(['-map_metadata', '-1']);
    }
    args.add(outputPathFor(videoFile, outDir));
    return args;
  }
}
