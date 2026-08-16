/// 日志行分类，用于高亮显示。
enum LogKind { normal, error, warning, progress }

/// 根据内容判断日志行类型：
/// - error：ffmpeg 报错 / 转换失败
/// - warning：警告
/// - progress：进度指标（time / bitrate / size / speed 等）
LogKind classifyLogLine(String line) {
  final l = line.toLowerCase();
  if (l.contains('error') ||
      l.contains('failed') ||
      l.contains('invalid') ||
      l.contains('decoding error') ||
      l.contains('conversion failed') ||
      l.contains('转换失败') ||
      l.contains('启动失败') ||
      l.contains('失败 (exit')) {
    return LogKind.error;
  }
  if (l.contains('warning') ||
      l.contains('warn:') ||
      l.contains('警告') ||
      l.contains('⚠')) {
    return LogKind.warning;
  }
  if (l.contains('time=') ||
      l.contains('bitrate=') ||
      l.contains('size=') ||
      l.contains('speed=') ||
      l.contains('fps=') ||
      l.contains('frame=') ||
      l.contains('out_time') ||
      l.contains('progress=')) {
    return LogKind.progress;
  }
  return LogKind.normal;
}
