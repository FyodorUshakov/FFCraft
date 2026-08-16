/// 一个待执行的 ffmpeg 任务。
class Job {
  Job({
    required this.label,
    required this.args,
    required this.outputPath,
    this.input = '',
  });

  final String label;
  final List<String> args;
  final String outputPath;

  /// 主输入文件（用于探测时长与进度），合流/拼接可能为空。
  final String input;
}
