import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color, Locale;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_mode.dart';
import '../models/app_locale.dart';
import '../models/audio_settings.dart';
import '../models/concat_settings.dart';
import '../models/job.dart';
import '../models/mux_settings.dart';
import '../models/queue_item.dart';
import '../models/theme_settings.dart';
import '../models/video_settings.dart';
import '../services/ffmpeg_manager.dart';
import '../services/job_builder.dart';
import '../models/log_style.dart';
import '../services/probe.dart';
import '../services/wallpaper_color.dart';
import '../l10n/l10n_helper.dart';

/// 全局状态：模式、设置、队列、引擎与批量任务。
class AppController extends ChangeNotifier {
  AppController() {
    _restore();
  }

  AppMode mode = AppMode.audio;
  AudioSettings audio = AudioSettings();
  VideoSettings video = VideoSettings();
  MuxSettings mux = MuxSettings();
  ConcatSettings concat = ConcatSettings();

  // 合流输入（mux 模式）
  String videoFile = '';
  final List<String> audioFiles = [];

  final List<QueueItem> items = [];
  final List<String> logLines = [];

  bool running = false;
  bool cancelRequested = false;
  int doneCount = 0;
  int failedCount = 0;
  int totalJobs = 0;
  bool engineReady = false;
  String engineDir = '';
  String engineStatus = '检测中…';
  bool engineDetecting = false;
  String userEngineDir = ''; // 用户手动指定的目录（默认留空）
  AppLocale locale = AppLocale.zhHans;
  ThemeSettings theme = ThemeSettings();
  bool wallpaperExtracting = false;
  /// 仅供 MaterialApp 监听的主题种子色，避免进度刷新导致整棵树重建。
  final ValueNotifier<Color> themeSeed =
      ValueNotifier<Color>(ThemeSettings.defaultPreset);
  /// 仅供 MaterialApp 监听的语言，切换时即时生效。
  final ValueNotifier<Locale> localeNotifier =
      ValueNotifier<Locale>(const Locale('zh', 'CN'));
  bool showLog = false;
  DateTime? startedAt;
  String outDir = ''; // 空 = 输出到源目录
  int maxWorkers = 2;

  final List<Process> _procs = [];
  final Map<String, double> _jobProgress = {};
  List<Job> _jobs = [];
  int _nextJob = 0;
  int _active = 0;
  Completer<void>? _batchDone;
  String? _concatListFile;
  final Completer<void> _ready = Completer<void>();

  /// 初始化（设置恢复 + 引擎检测）完成。
  Future<void> get ready => _ready.future;

  static const _prefsCommon = 'ffmpeg_common_v1';
  static const _prefsTheme = 'ffmpeg_theme_v1';

  // ------------------------------------------------------------- 模式

  void setMode(AppMode m) {
    if (running || m == mode) return;
    mode = m;
    items.clear();
    videoFile = '';
    audioFiles.clear();
    doneCount = 0;
    failedCount = 0;
    addLog(
      l10n(
        (a) => a.switchedMode(modeLabel(m)),
        '切换到「${modeLabel(m)}」模式',
      ),
    );
    notifyListeners();
  }

  /// 切换界面语言。
  void setLocale(AppLocale l) {
    if (l == locale) return;
    locale = l;
    localeNotifier.value = l.locale;
    _saveCommon();
    notifyListeners();
  }

  // ------------------------------------------------------------- 队列

  bool _accept(String path) {
    switch (mode) {
      case AppMode.audio:
        return isAudioExtension(path);
      case AppMode.video:
        return isVideoExtension(path);
      case AppMode.mux:
      case AppMode.concat:
        return isAudioExtension(path) || isVideoExtension(path);
    }
  }

  void addFiles(List<String> paths) {
    if (running) return;
    final existing = items.map((e) => e.path).toSet();
    var added = 0;
    for (final p in paths) {
      if (_accept(p) && !existing.contains(p)) {
        final item = QueueItem(p);
        _initItemMeta(item);
        items.add(item);
        existing.add(p);
        added++;
      }
    }
    if (added > 0) {
      addLog(l10n((a) => a.addedFiles(added), '已添加 $added 个文件'));
      notifyListeners();
    }
  }

  Future<void> addFolder(String dir) async {
    if (running) return;
    final found = <String>[];
    try {
      await for (final entity
          in Directory(dir).list(recursive: true, followLinks: false)) {
        if (entity is File && _accept(entity.path)) found.add(entity.path);
      }
    } catch (e) {
      addLog(l10n((a) => a.readDirFailed(e.toString()), '读取目录失败: $e'));
    }
    found.sort();
    addFiles(found);
  }

  void removeAt(int index) {
    if (running) return;
    items.removeAt(index);
    notifyListeners();
  }

  void _initItemMeta(QueueItem item) {
    try {
      final f = File(item.path);
      item.sizeMb = f.lengthSync() / (1024 * 1024);
    } catch (_) {}
    final dot = item.path.lastIndexOf('.');
    if (dot >= 0) item.format = item.path.substring(dot + 1);
    _probeItemMeta(item);
  }

  Future<void> _probeItemMeta(QueueItem item) async {
    String dir = engineDir;
    if (dir.isEmpty) {
      try {
        dir = await FfmpegManager.resolveEngine(userDir: userEngineDir);
      } catch (_) {
        return;
      }
    }
    final info = await MediaProbe.info(dir, item.path);
    if (info == null) return;
    item.durationSec = info.durationSec;
    item.bitrateKbps = info.bitrateKbps;
    item.audioCodec = info.audioCodec;
    notifyListeners();
  }

  void clearQueue() {
    if (running) return;
    items.clear();
    doneCount = 0;
    failedCount = 0;
    notifyListeners();
  }

  // ------------------------------------------------------------- 合流输入

  void setVideoFile(String path) {
    if (running) return;
    videoFile = path;
    notifyListeners();
  }

  void addAudioFile(String path) {
    if (running || audioFiles.contains(path)) return;
    audioFiles.add(path);
    notifyListeners();
  }

  void removeAudioFileAt(int index) {
    if (running) return;
    audioFiles.removeAt(index);
    notifyListeners();
  }

  // ------------------------------------------------------------- 日志

  void addLog(String line) {
    final now = DateTime.now();
    final ts = '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    logLines.add('[$ts] $line');
    if (logLines.length > 3000) {
      logLines.removeRange(0, logLines.length - 3000);
    }
    notifyListeners();
  }

  void clearLog() {
    logLines.clear();
    notifyListeners();
  }

  void setLogVisible(bool visible) {
    showLog = visible;
    notifyListeners();
  }

  // ------------------------------------------------------------- 设置持久化

  Future<void> _restore() async {
    try {
      try {
        final p = await SharedPreferences.getInstance();
        audio =
            AudioSettings.decode(p.getString('ffmpeg_audio_settings') ?? '');
        video =
            VideoSettings.decode(p.getString('ffmpeg_video_settings') ?? '');
        mux = MuxSettings.decode(p.getString('ffmpeg_mux_settings') ?? '');
        concat =
            ConcatSettings.decode(p.getString('ffmpeg_concat_settings') ?? '');
        final common = p.getString(_prefsCommon);
        if (common != null) {
          try {
            final j = jsonDecode(common) as Map<String, dynamic>;
            userEngineDir = (j['userEngineDir'] as String?) ?? '';
            outDir = (j['outDir'] as String?) ?? '';
            maxWorkers = ((j['maxWorkers'] as num?)?.toInt() ?? 2).clamp(1, 8);
            locale = AppLocale.values.asNameMap()[j['locale']] ??
                AppLocale.zhHans;
            localeNotifier.value = locale.locale;
          } catch (_) {}
        }
        theme = ThemeSettings.decode(p.getString(_prefsTheme) ?? '');
        themeSeed.value = theme.seed;
      } catch (_) {}
      notifyListeners();
      await refreshEngine();
    } finally {
      if (!_ready.isCompleted) _ready.complete();
    }
  }

  void _saveCommon() {
    SharedPreferences.getInstance().then(
      (p) => p.setString(
        _prefsCommon,
        jsonEncode({
          'userEngineDir': userEngineDir,
          'outDir': outDir,
          'maxWorkers': maxWorkers,
          'locale': locale.name,
        }),
      ),
    );
  }

  void updateAudio(void Function(AudioSettings) change) {
    change(audio);
    notifyListeners();
    SharedPreferences.getInstance()
        .then((p) => p.setString('ffmpeg_audio_settings', audio.encode()));
  }

  void updateVideo(void Function(VideoSettings) change) {
    change(video);
    notifyListeners();
    SharedPreferences.getInstance()
        .then((p) => p.setString('ffmpeg_video_settings', video.encode()));
  }

  void updateMux(void Function(MuxSettings) change) {
    change(mux);
    notifyListeners();
    SharedPreferences.getInstance()
        .then((p) => p.setString('ffmpeg_mux_settings', mux.encode()));
  }

  void updateConcat(void Function(ConcatSettings) change) {
    change(concat);
    notifyListeners();
    SharedPreferences.getInstance()
        .then((p) => p.setString('ffmpeg_concat_settings', concat.encode()));
  }

  void updateCommon(void Function() change) {
    change();
    notifyListeners();
    _saveCommon();
  }

  // ------------------------------------------------------------- 主题

  void _saveTheme() {
    SharedPreferences.getInstance()
        .then((p) => p.setString(_prefsTheme, theme.encode()));
  }

  /// 选择预设色板（index 0 即默认淡蓝）。
  void setPresetTheme(int index) {
    theme
      ..source = ThemeSource.preset
      ..presetIndex = index.clamp(0, ThemeSettings.presets.length - 1);
    themeSeed.value = theme.seed;
    _saveTheme();
    notifyListeners();
  }

  /// 自定义颜色（实时生效）。
  void setCustomTheme(Color color) {
    theme
      ..source = ThemeSource.custom
      ..customColor = color;
    themeSeed.value = theme.seed;
    _saveTheme();
    notifyListeners();
  }

  /// 从 Windows 壁纸取色并应用；返回是否成功。
  Future<bool> applyWallpaperTheme() async {
    if (!WallpaperColor.supported) return false;
    wallpaperExtracting = true;
    notifyListeners();
    String dir = '';
    try {
      dir = await FfmpegManager.resolveEngine(userDir: userEngineDir);
    } catch (_) {}
    final color = await WallpaperColor.extract(ffmpegDir: dir);
    wallpaperExtracting = false;
    if (color != null) {
      theme
        ..source = ThemeSource.wallpaper
        ..wallpaperColor = color;
      themeSeed.value = theme.seed;
      _saveTheme();
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  // ------------------------------------------------------------- 引擎

  Future<void> refreshEngine() async {
    engineDetecting = true;
    engineStatus = '检测中…';
    notifyListeners();
    try {
      final dir = await FfmpegManager.resolveEngine(userDir: userEngineDir);
      engineDir = dir;
      engineReady = true;
      final version = await FfmpegManager.version(dir);
      engineStatus = version.split('\n').first.trim();
    } catch (e) {
      engineDir = '';
      engineReady = false;
      engineStatus = e.toString();
    } finally {
      engineDetecting = false;
      notifyListeners();
    }
  }

  /// 清除手动指定，恢复自动查找。
  void resetEngineDir() {
    userEngineDir = '';
    _saveCommon();
    refreshEngine();
  }

  // ------------------------------------------------------------- 任务编排

  Future<void> start() async {
    if (running || !_canStart()) return;
    running = true;
    cancelRequested = false;
    startedAt = DateTime.now();

    String dir;
    try {
      dir = await FfmpegManager.resolveEngine(userDir: userEngineDir);
      engineDir = dir;
      engineReady = true;
      engineStatus = (await FfmpegManager.version(dir)).split('\n').first;
    } catch (e) {
      engineDir = '';
      engineReady = false;
      engineStatus = e.toString();
      addLog(l10n((a) => a.launchFailed(e.toString()), '⚠ $e'));
      running = false;
      notifyListeners();
      return;
    }
    if (cancelRequested) {
      running = false;
      addLog(l10n((a) => a.cancelled, '已取消'));
      notifyListeners();
      return;
    }

    final out = outDir.trim();
    if (out.isNotEmpty) {
      try {
        Directory(out).createSync(recursive: true);
      } catch (_) {}
    }

    if (mode == AppMode.concat && !concat.reEncode) {
      _concatListFile = await JobBuilder.writeConcatList(
        [for (final i in items) i.path],
      );
    }
    // 兼容模式（视频）：探测各段分辨率，取最高者作为统一输出分辨率
    (int, int)? concatTarget;
    if (mode == AppMode.concat &&
        concat.reEncode &&
        items.isNotEmpty &&
        isVideoExtension(items.first.path)) {
      final sizes = <(int, int)>[];
      for (final item in items) {
        final info = await MediaProbe.info(dir, item.path);
        if (info != null && info.width != null && info.height != null) {
          sizes.add((info.width!, info.height!));
        }
      }
      if (sizes.isNotEmpty) {
        sizes.sort((a, b) => (a.$1 * a.$2).compareTo(b.$1 * b.$2));
        concatTarget = sizes.last;
        final w = concatTarget.$1;
        final h = concatTarget.$2;
        addLog(
          l10n(
            (a) => a.compatResolution(w, h),
            '兼容模式：统一输出 ${w}x$h（H.265 + AAC 256k）',
          ),
        );
      }
    }
    _jobs = _buildJobs(concatTarget: concatTarget);
    totalJobs = _jobs.length;
    doneCount = 0;
    failedCount = 0;
    _jobProgress.clear();
    for (final j in _jobs) {
      _jobProgress[j.outputPath] = 0;
    }
    _nextJob = 0;
    _active = 0;
    _procs.clear();
    _batchDone = Completer<void>();
    for (final item in items) {
      item.status = FileStatus.queued;
      item.progress = 0;
      item.detail = '';
    }
    // 音频/视频模式：任务与队列项一一对应，用于逐文件进度
    if (mode == AppMode.audio || mode == AppMode.video) {
      for (var i = 0; i < _jobs.length && i < items.length; i++) {
        items[i].outputPath = _jobs[i].outputPath;
      }
    }
    addLog(
      l10n(
        (a) => a.startBatch(totalJobs, dir),
        '━━ 开始处理 ━━ 共 $totalJobs 个任务，ffmpeg：$dir',
      ),
    );
    showLog = true;
    notifyListeners();

    final workers = mode == AppMode.audio || mode == AppMode.video
        ? maxWorkers.clamp(1, totalJobs)
        : 1;
    for (var i = 0; i < workers; i++) {
      _worker();
    }
    await _batchDone!.future;

    final cancelled = cancelRequested;
    running = false;
    _procs.clear();
    if (_concatListFile != null) {
      try {
        final f = File(_concatListFile!);
        final parent = f.parent;
        if (f.existsSync()) f.deleteSync();
        if (parent.existsSync()) parent.deleteSync();
      } catch (_) {}
      _concatListFile = null;
    }
    if (cancelled) {
      addLog(
        l10n((a) => a.stoppedDone(doneCount), '已停止，共完成 $doneCount 个'),
      );
    } else {
      addLog(
        l10n(
          (a) => a.doneAll(doneCount - failedCount, failedCount),
          '全部完成：成功 ${doneCount - failedCount} 个，失败 $failedCount 个',
        ),
      );
    }
    notifyListeners();
  }

  bool _canStart() {
    switch (mode) {
      case AppMode.audio:
      case AppMode.video:
        return items.isNotEmpty;
      case AppMode.mux:
        return videoFile.isNotEmpty;
      case AppMode.concat:
        return items.length >= 2;
    }
  }

  List<Job> _buildJobs({(int, int)? concatTarget}) {
    switch (mode) {
      case AppMode.audio:
        return JobBuilder.audioJobs(audio, items, outDir);
      case AppMode.video:
        return JobBuilder.videoJobs(video, items, outDir);
      case AppMode.mux:
        final job = JobBuilder.muxJob(mux, videoFile, audioFiles, outDir);
        return [?job];
      case AppMode.concat:
        final job = JobBuilder.concatJob(
          concat,
          items,
          outDir,
          listFile: _concatListFile ?? '',
          targetResolution: concatTarget,
        );
        return [?job];
    }
  }

  void stop() {
    if (!running) return;
    cancelRequested = true;
    for (final p in List<Process>.of(_procs)) {
      try {
        p.kill();
      } catch (_) {}
    }
    addLog(l10n((a) => a.stopping, '正在停止…'));
    notifyListeners();
  }

  double get overallProgress {
    if (!running || totalJobs == 0) return 0;
    var sum = 0.0;
    for (final j in _jobs) {
      sum += _jobProgress[j.outputPath] ?? 0;
    }
    return (sum / totalJobs).clamp(0.0, 1.0);
  }

  // ------------------------------------------------------------- 执行

  void _worker() async {
    while (!cancelRequested) {
      final idx = _nextJob++;
      if (idx >= _jobs.length) break;
      final job = _jobs[idx];
      _active++;
      await _runOne(job);
      _active--;
    }
    if (_active == 0 && !_batchDone!.isCompleted) {
      _batchDone!.complete();
    }
  }

  Future<void> _runOne(Job job) async {
    // 关联队列项（音频/视频模式一一对应）
    QueueItem? item;
    for (final i in items) {
      if (i.outputPath == job.outputPath) {
        item = i;
        break;
      }
    }
    if (mode == AppMode.concat) {
      for (final i in items) {
        i.status = FileStatus.running;
        i.detail = l10n((a) => a.processing, '拼接中…');
      }
    }
    if (item != null) {
      item.status = FileStatus.running;
      item.detail = l10n((a) => a.starting, '启动中…');
      item.outputPath = job.outputPath;
    }
    notifyListeners();

    final args = job.args;

    // 探测时长（用于进度百分比）
    double? duration;
    if (job.input.isNotEmpty) {
      duration = await MediaProbe.duration(engineDir, job.input);
    }

    final runArgs = ['-nostats', '-progress', 'pipe:1', ...args];
    addLog('▶ ffmpeg ${runArgs.join(' ')}');
    var sawError = false;
    Process? proc;
    try {
      proc = await Process.start(
        '$engineDir${Platform.pathSeparator}ffmpeg.exe',
        runArgs,
        workingDirectory: engineDir,
        includeParentEnvironment: true,
      );
    } catch (e) {
      _finishJob(
        job,
        item,
        false,
        l10n((a) => a.launchFailed(e.toString()), '启动失败: $e'),
      );
      return;
    }

    _procs.add(proc);
    proc.stdout
        .transform(const Utf8Decoder(allowMalformed: true))
        .transform(const LineSplitter())
        .listen((line) {
      final l = line.trim();
      if (l.startsWith('out_time_us=')) {
        final us = int.tryParse(l.substring('out_time_us='.length));
        if (us != null && duration != null && duration > 0) {
          _setJobProgress(job, item, (us / 1e6 / duration).clamp(0.0, 1.0));
        }
      } else if (l.startsWith('progress=')) {
        if (l == 'progress=end') _setJobProgress(job, item, 1.0);
      }
    }, onError: (_) {});
    proc.stderr
        .transform(const Utf8Decoder(allowMalformed: true))
        .transform(const LineSplitter())
        .listen((line) {
      final l = line.trim();
      if (l.isNotEmpty && !l.startsWith('frame=') && !l.startsWith('fps=')) {
        if (classifyLogLine(l) == LogKind.error) sawError = true;
        addLog('   $l');
      }
    }, onError: (_) {});

    final code = await proc.exitCode;
    _procs.remove(proc);

    if (cancelRequested) {
      _setJobProgress(job, item, 0);
      if (item != null) {
        item.status = FileStatus.cancelled;
      item.detail = l10n((a) => a.cancelled, '已停止');
      }
      for (final i in items) {
        if (i.status == FileStatus.running && mode == AppMode.concat) {
          i.status = FileStatus.cancelled;
          i.detail = l10n((a) => a.cancelled, '已停止');
        }
      }
      try {
        if (File(job.outputPath).existsSync()) File(job.outputPath).deleteSync();
      } catch (_) {}
      notifyListeners();
      return;
    }

    final ok = code == 0 && File(job.outputPath).existsSync();
    if (ok && sawError) {
      addLog(l10n((a) => a.decodeWarning, '   ⚠ 输出中存在解码错误/警告，请检查源文件是否完整'));
      if (item != null) {
        item.hasWarning = true;
      } else if (mode == AppMode.concat) {
        for (final i in items) {
          i.hasWarning = true;
        }
      }
      _finishJob(
        job,
        item,
        true,
        l10n((a) => a.doneWithWarning, '完成（有解码警告）'),
      );
      return;
    }
    _finishJob(
      job,
      item,
      ok,
      ok ? '' : l10n((a) => a.failedExit(code), '失败 (exit=$code)'),
    );
  }

  void _setJobProgress(Job job, QueueItem? item, double v) {
    _jobProgress[job.outputPath] = v;
    if (item != null) item.progress = v;
    notifyListeners();
  }

  void _finishJob(Job job, QueueItem? item, bool ok, String detail) {
    _jobProgress[job.outputPath] = ok ? 1.0 : 0.0;
    if (ok) {
      doneCount++;
    } else {
      failedCount++;
    }
    if (item != null) {
      item.status = ok ? FileStatus.done : FileStatus.failed;
      item.progress = ok ? 1.0 : 0.0;
      item.detail = ok
          ? l10n((a) => a.doneTo(job.outputPath), '完成 → ${job.outputPath}')
          : detail;
      if (!ok) addLog('   ⚠ ${item.name} $detail');
    } else if (mode == AppMode.concat) {
      for (final i in items) {
        i.status = ok ? FileStatus.done : FileStatus.failed;
        i.detail = ok
            ? l10n((a) => a.doneTo(job.outputPath), '完成 → ${job.outputPath}')
            : detail;
      }
      if (!ok) addLog('   ⚠ 拼接 $detail');
    } else {
      if (!ok) addLog('   ⚠ ${job.label} $detail');
    }
    if (!ok && !File(job.outputPath).existsSync()) {
      addLog(
        l10n(
          (a) => a.noOutput(job.outputPath),
          '   未生成输出文件：${job.outputPath}',
        ),
      );
    }
    notifyListeners();
  }
}
