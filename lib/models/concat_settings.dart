import 'dart:convert';

import 'app_mode.dart';

/// 拼接工作模式。
enum ConcatKind { video, audio }

/// 拼接输出容器。
enum ConcatContainer { auto, mp4, mkv, mov, webm, ts }

extension ConcatContainerX on ConcatContainer {
  String get label => switch (this) {
        ConcatContainer.auto => '自动（同输入）',
        ConcatContainer.mp4 => 'MP4',
        ConcatContainer.mkv => 'MKV',
        ConcatContainer.mov => 'MOV',
        ConcatContainer.webm => 'WebM',
        ConcatContainer.ts => 'TS',
      };

  String? get ext => this == ConcatContainer.auto ? null : name;
}

/// 音视频拼接参数。
class ConcatSettings {
  ConcatKind kind; // 视频拼接 / 音频拼接
  ConcatContainer container;
  bool reEncode; // 兼容模式：重新编码拼接

  ConcatSettings({
    this.kind = ConcatKind.video,
    this.container = ConcatContainer.auto,
    this.reEncode = false,
  });

  factory ConcatSettings.fromJson(Map<String, dynamic> json) {
    return ConcatSettings(
      kind: ConcatKind.values.asNameMap()[json['kind']] ?? ConcatKind.video,
      container: ConcatContainer.values.asNameMap()[json['container']] ??
          ConcatContainer.auto,
      reEncode: json['reEncode'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'kind': kind.name,
        'container': container.name,
        'reEncode': reEncode,
      };

  String encode() => jsonEncode(toJson());

  static ConcatSettings decode(String raw) {
    try {
      return ConcatSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return ConcatSettings();
    }
  }

  String outputPathFor(List<String> inputs, String outDir) {
    final first = inputs.first;
    final name = first.split(RegExp(r'[\\/]')).last;
    final dot = name.lastIndexOf('.');
    final stem = dot > 0 ? name.substring(0, dot) : name;
    if (kind == ConcatKind.audio) {
      final src = extensionOf(first);
      // 兼容模式统一输出 WAV；复制模式沿用源音频扩展名
      final ext = reEncode
          ? 'wav'
          : (audioExtensions.contains(src) ? src : 'm4a');
      return safeOutputPath(outDir, first, '${stem}_concat', ext);
    }
    String ext;
    final c = container.ext;
    if (c != null) {
      ext = c;
    } else {
      final src = extensionOf(first);
      ext = ['mp4', 'mkv', 'mov', 'webm', 'ts', 'avi', 'flv'].contains(src)
          ? src
          : (isVideoExtension(first)
              ? 'mp4'
              // 纯音频源沿用其自身扩展名（flac→flac），避免塞进不兼容的 m4a
              : (audioExtensions.contains(src) ? src : 'm4a'));
    }
    return safeOutputPath(outDir, first, '${stem}_concat', ext);
  }

  /// 拼接参数。listFile 为 concat 列表（仅复制模式使用）。
  List<String> buildArgs(
    List<String> inputs,
    String outDir, {
    required String listFile,
    required bool videoSource,
    (int, int)? targetResolution,
  }) {
    final output = outputPathFor(inputs, outDir);
    final args = <String>['-hide_banner', '-y'];
    if (reEncode) {
      // 兼容模式：用 concat 滤镜重编码
      for (final p in inputs) {
        args.addAll(['-i', p]);
      }
      final n = inputs.length;
      if (kind == ConcatKind.audio) {
        // 音频拼接：各段统一转码为 WAV 后拼接
        args.addAll([
          '-filter_complex',
          '[0:a]${List.generate(n - 1, (i) => '[${i + 1}:a]').join()}'
              'concat=n=$n:v=0:a=1[a]',
          '-map', '[a]',
          '-c:a', 'pcm_s16le',
        ]);
      } else if (videoSource) {
        final w = targetResolution?.$1;
        final h = targetResolution?.$2;
        if (w != null && h != null) {
          // 统一缩放到目标分辨率（取各段最高者），不足部分补黑边
          final chain = StringBuffer();
          final labels = <String>[];
          for (var i = 0; i < n; i++) {
            chain.write(
              '[$i:v]scale=$w:$h:force_original_aspect_ratio=decrease,'
              'pad=$w:$h:(ow-iw)/2:(oh-ih)/2,setsar=1[v$i];',
            );
            labels.addAll(['[v$i]', '[$i:a]']);
          }
          chain.write('${labels.join()}concat=n=$n:v=1:a=1[v][a]');
          args.addAll(['-filter_complex', chain.toString()]);
        } else {
          final labels = <String>[];
          for (var i = 0; i < n; i++) {
            labels.addAll(['[$i:v]', '[$i:a]']);
          }
          args.addAll([
            '-filter_complex',
            '${labels.join()}concat=n=$n:v=1:a=1[v][a]',
          ]);
        }
        args.addAll([
          '-map', '[v]',
          '-map', '[a]',
          '-c:v', 'libx265',
          '-crf', '23',
          '-preset', 'medium',
          '-pix_fmt', 'yuv420p',
          '-c:a', 'aac',
          '-b:a', '256k',
        ]);
      } else {
        args.addAll([
          '-filter_complex',
          '[0:a]${List.generate(n - 1, (i) => '[${i + 1}:a]').join()}'
              'concat=n=$n:v=0:a=1[a]',
          '-map', '[a]',
          '-c:a', 'aac',
          '-b:a', '256k',
        ]);
      }
    } else {
      args.addAll(['-f', 'concat', '-safe', '0', '-i', listFile]);
      args.addAll(['-c', 'copy']);
    }
    args.add(output);
    return args;
  }
}
