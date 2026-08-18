import 'dart:io';

import '../l10n/l10n_helper.dart';

class EngineNotFound implements Exception {
  EngineNotFound(this.message);
  final String message;

  @override
  String toString() => message;
}

/// 定位 ffmpeg：优先系统 PATH，其次常见安装位置，支持手动指定（跨平台）。
class FfmpegManager {
  /// Windows 下为 ffmpeg.exe，Linux/macOS 下为 ffmpeg。
  static String get exeName => Platform.isWindows ? 'ffmpeg.exe' : 'ffmpeg';

  /// 给定目录下的 ffmpeg 可执行文件全路径（同时区分平台的文件名与分隔符）。
  static String exePath(String dir) => '$dir${Platform.pathSeparator}$exeName';

  static String? _exeOf(String dir) {
    final d = exePath(dir);
    return File(d).existsSync() ? dir : null;
  }

  /// 按系统 PATH + 常见安装目录查找（PATH 分隔符按平台区分）。
  static Future<String?> findInPath() async {
    final candidates = <String>[];
    final path = Platform.environment['PATH'] ?? '';
    for (final dir in path.split(Platform.isWindows ? ';' : ':')) {
      final t = dir.trim();
      if (t.isNotEmpty) candidates.add(t);
    }
    if (Platform.isWindows) {
      candidates.addAll(const [
        r'C:\ffmpeg\bin', r'C:\ffmpeg',
        r'E:\ffmpeg\bin', r'E:\ffmpeg',
        r'F:\ffmpeg\bin', r'F:\ffmpeg',
      ]);
    } else {
      candidates.addAll(const [
        '/usr/bin', '/usr/local/bin', '/opt/homebrew/bin',
        '/opt/ffmpeg/bin', '/usr/local/ffmpeg/bin',
      ]);
    }
    for (final c in candidates) {
      final found = _exeOf(c);
      if (found != null) return found;
    }

    // where / which（严格按当前 PATH）
    try {
      final r = await Process.run(
        Platform.isWindows ? 'where.exe' : 'which',
        [exeName],
      );
      if (r.exitCode == 0) {
        final line = r.stdout.toString().trim().split('\n').first.trim();
        if (line.isNotEmpty && File(line).existsSync()) {
          return File(line).parent.path;
        }
      }
    } catch (_) {}

    // 仅 Windows 做顶层目录扫描（E:\、F:\、C:\ 下名称含 ffmpeg 的目录）
    if (!Platform.isWindows) return null;
    for (final root in const [r'E:\', r'F:\', r'C:\']) {
      try {
        final entries = Directory(root).listSync(followLinks: false);
        for (final e in entries) {
          if (e is! Directory) continue;
          final name = e.uri.pathSegments.isNotEmpty
              ? e.uri.pathSegments.last.toLowerCase()
              : '';
          if (!name.contains('ffmpeg')) continue;
          final found = _exeOf(e.path);
          if (found != null) return found;
          final inBin = _exeOf('${e.path}${Platform.pathSeparator}bin');
          if (inBin != null) return inBin;
        }
      } catch (_) {}
    }
    return null;
  }

  /// 查找顺序：手动指定目录 → 程序旁的 ffmpeg 文件夹 → PATH → 常见目录 → 顶层扫描。
  static Future<String> resolveEngine({String userDir = ''}) async {
    final user = userDir.trim();
    if (user.isNotEmpty) {
      final found = _exeOf(user);
      if (found != null) return found;
      throw EngineNotFound(
        l10n(
          (a) => a.engineDirMissing(user),
          '指定目录中未找到 $exeName：$user',
        ),
      );
    }

    final exeParent = File(Platform.resolvedExecutable).parent.path;
    for (final c in [
      '$exeParent${Platform.pathSeparator}ffmpeg',
      exeParent,
    ]) {
      final found = _exeOf(c);
      if (found != null) return found;
    }

    final inPath = await findInPath();
    if (inPath != null) return inPath;

    throw EngineNotFound(
      l10n(
        (a) => a.engineNotFound,
        '未找到 $exeName，请在设置中手动指定 ffmpeg 所在目录',
      ),
    );
  }

  static Future<String> version(String dir) async {
    try {
      final r = await Process.run(
        '$dir${Platform.pathSeparator}$exeName',
        ['-version'],
        workingDirectory: dir,
      );
      final line = r.stdout.toString().trim().split('\n').first.trim();
      return line.isEmpty ? 'exit=${r.exitCode}' : line;
    } catch (e) {
      return l10n((a) => a.launchFailed(e.toString()), '启动失败: $e');
    }
  }

  /// 查询当前 ffmpeg 支持的硬件编码器（nvenc / qsv / amf / videotoolbox 等）。
  static Future<Set<String>> hardwareEncoders(String dir) async {
    final set = <String>{};
    try {
      final r = await Process.run(
        '$dir${Platform.pathSeparator}$exeName',
        ['-hide_banner', '-encoders'],
        workingDirectory: dir,
      );
      for (final line in r.stdout.toString().split('\n')) {
        for (final m in RegExp(
          r'(\S*(?:nvenc|qsv|amf|videotoolbox)\S*)',
        ).allMatches(line)) {
          final name = m.group(1);
          if (name != null && name.isNotEmpty) set.add(name);
        }
      }
    } catch (_) {}
    return set;
  }
}
