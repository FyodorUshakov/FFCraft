import 'dart:io';

/// 四大工作模式。
enum AppMode { audio, video, mux, concat }

extension AppModeX on AppMode {
  String get label => switch (this) {
        AppMode.audio => '音频转码',
        AppMode.video => '视频转码',
        AppMode.mux => '合流封装',
        AppMode.concat => '拼接',
      };

  String get icon => switch (this) {
        AppMode.audio => 'music',
        AppMode.video => 'video',
        AppMode.mux => 'merge',
        AppMode.concat => 'join',
      };

  String get hint => switch (this) {
        AppMode.audio => '把音频文件转换成 AAC / MP3 / FLAC / ALAC / WAV / Opus / OGG 等格式',
        AppMode.video => '转换视频编码、分辨率、码率，可保留或重编码音轨',
        AppMode.mux => '把视频与音频轨道原样合并进新的容器（不重编码，纯合流）',
        AppMode.concat => '把多段同编码的音视频无缝拼接为一个文件',
      };
}

/// 常见音视频扩展名，用于按模式过滤文件。
const audioExtensions = {
  'flac', 'wav', 'aac', 'm4a', 'mp3', 'ogg', 'opus', 'wma', 'ape',
  'aiff', 'aif', 'caf', 'alac', 'mp2', 'ac3', 'dts', 'amr', 'au', 'wv',
};

const videoExtensions = {
  'mp4', 'mkv', 'mov', 'avi', 'webm', 'flv', 'ts', 'm4v', 'wmv',
  'mpg', 'mpeg', 'm2ts', '3gp', 'rmvb', 'vob', 'ogv',
};

bool isVideoExtension(String path) {
  final dot = path.lastIndexOf('.');
  if (dot < 0) return false;
  return videoExtensions.contains(path.substring(dot + 1).toLowerCase());
}

bool isAudioExtension(String path) {
  final dot = path.lastIndexOf('.');
  if (dot < 0) return false;
  return audioExtensions.contains(path.substring(dot + 1).toLowerCase());
}

String extensionOf(String path) {
  final dot = path.lastIndexOf('.');
  return dot < 0 ? '' : path.substring(dot + 1).toLowerCase();
}

/// 生成输出路径；若与输入同名（如 m4a→m4a）则追加 _out 后缀避免覆盖。
String safeOutputPath(String outDir, String input, String stem, String ext) {
  var path = '$outDir${Platform.pathSeparator}$stem.$ext';
  if (path.toLowerCase() == input.toLowerCase()) {
    path = '$outDir${Platform.pathSeparator}${stem}_out.$ext';
  }
  return path;
}
