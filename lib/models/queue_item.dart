/// 单个文件的转换状态。
enum FileStatus { queued, running, done, failed, cancelled }

extension FileStatusX on FileStatus {
  String get label => switch (this) {
        FileStatus.queued => '等待中',
        FileStatus.running => '处理中',
        FileStatus.done => '已完成',
        FileStatus.failed => '失败',
        FileStatus.cancelled => '已取消',
      };
}

/// 队列中的待处理文件。
class QueueItem {
  QueueItem(this.path) : status = FileStatus.queued;

  final String path;
  FileStatus status;
  String detail = '';
  double progress = 0;
  double? durationSec;
  String? outputPath;
  double? sizeMb;
  String? format; // 原格式（扩展名）
  int? bitrateKbps;
  String? audioCodec;
  String? bitDepthLabel; // 无损音源位深，如 24-bit
  bool hasWarning = false; // 完成但解码/处理过程有警告

  String get name => path.split(RegExp(r'[\\/]')).last;
  String get dir => path.contains(RegExp(r'[\\/]'))
      ? path.substring(0, path.lastIndexOf(RegExp(r'[\\/]')))
      : '.';

  /// 元数据摘要：格式 · 大小 · 时长 · 码率。
  String get metaLine {
    final parts = <String>[];
    if (format != null && format!.isNotEmpty) parts.add(format!.toUpperCase());
    if (sizeMb != null) parts.add('${sizeMb!.toStringAsFixed(1)} MB');
    if (durationSec != null) {
      final t = durationSec!.round();
      final m = (t ~/ 60).toString();
      final s = (t % 60).toString().padLeft(2, '0');
      parts.add('$m:$s');
    }
    if (bitrateKbps != null && bitrateKbps! > 0) {
      parts.add('$bitrateKbps kbps');
    }
    if (bitDepthLabel != null && bitDepthLabel!.isNotEmpty) {
      parts.add(bitDepthLabel!);
    }
    return parts.join(' · ');
  }
}
