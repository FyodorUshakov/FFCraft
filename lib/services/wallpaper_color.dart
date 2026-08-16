import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart' show Color;
import 'package:win32/win32.dart';

/// Windows 壁纸取色：
/// 1. 读取壁纸文件路径（SPI_GETDESKWALLPAPER）
/// 2. 用 ffmpeg 把壁纸缩到 8x8，统计主色调
/// 3. 失败时回退到系统强调色（DwmGetColorizationColor，Win10/11 自动跟随壁纸）
class WallpaperColor {
  static bool get supported => Platform.isWindows;

  static String? _wallpaperPath() {
    if (!supported) return null;
    final buf = calloc<Uint16>(260);
    try {
      final ok = SystemParametersInfo(SPI_GETDESKWALLPAPER, 0, buf, 0);
      if (ok == 0) return null;
      final chars = buf.asTypedList(260);
      final end = chars.indexOf(0);
      final path = String.fromCharCodes(
        end < 0 ? chars : chars.take(end),
      );
      return path.isEmpty ? null : path;
    } catch (_) {
      return null;
    } finally {
      calloc.free(buf);
    }
  }

  /// 用 ffmpeg 取主色调：缩放到 8x8 后按色域分桶统计。
  static Future<Color?> _dominantColor(String ffmpegDir, String path) async {
    try {
      final proc = await Process.start(
        '$ffmpegDir${Platform.pathSeparator}ffmpeg.exe',
        [
          '-hide_banner', '-loglevel', 'error', '-y',
          '-i', path,
          '-vf', 'scale=8:8',
          '-frames:v', '1',
          '-f', 'rawvideo', '-pix_fmt', 'rgb24', '-',
        ],
        workingDirectory: ffmpegDir,
        includeParentEnvironment: true,
      );
      final builder = BytesBuilder();
      final sub = proc.stdout.listen(builder.add);
      final code = await proc.exitCode.timeout(
        const Duration(seconds: 40),
        onTimeout: () {
          proc.kill();
          return -1;
        },
      );
      await sub.cancel();
      if (code != 0) return null;
      final bytes = builder.takeBytes();
      if (bytes.length < 3) return null;
      return _dominantFromRgb24(bytes);
    } catch (_) {
      return null;
    }
  }

  static Color _dominantFromRgb24(Uint8List bytes) {
    final counts = <int, List<int>>{};
    var sumR = 0, sumG = 0, sumB = 0;
    final n = bytes.length ~/ 3;
    for (var i = 0; i + 2 < bytes.length; i += 3) {
      final r = bytes[i], g = bytes[i + 1], b = bytes[i + 2];
      sumR += r;
      sumG += g;
      sumB += b;
      final key = (r >> 5) << 10 | (g >> 5) << 5 | (b >> 5);
      counts.putIfAbsent(key, () => [0, 0, 0, 0]);
      final c = counts[key]!;
      c[0]++;
      c[1] += r;
      c[2] += g;
      c[3] += b;
    }
    if (counts.isEmpty) return const Color(0xFF4FC3F7);
    // 选出现次数最多的色桶；平局取第一个
    List<int>? best;
    for (final c in counts.values) {
      if (best == null || c[0] > best[0]) best = c;
    }
    if (best != null && best[0] >= 2) {
      return Color(0xFF000000 |
          ((best[1] ~/ best[0]) << 16) |
          ((best[2] ~/ best[0]) << 8) |
          (best[3] ~/ best[0]));
    }
    // 颜色太分散时退回整体平均色
    return Color(0xFF000000 |
        ((sumR ~/ n) << 16) |
        ((sumG ~/ n) << 8) |
        (sumB ~/ n));
  }

  /// Windows 系统强调色（跟随壁纸的自动配色）。
  static Color? _accentColor() {
    if (!supported) return null;
    final p = calloc<Uint32>(1);
    final o = calloc<Int32>(1);
    try {
      final hr = DwmGetColorizationColor(p, o);
      if (hr != 0) return null;
      final v = p.value; // 0xAARRGGBB
      return Color(0xFF000000 | (v & 0xFFFFFF));
    } catch (_) {
      return null;
    } finally {
      calloc.free(p);
      calloc.free(o);
    }
  }

  /// 从壁纸取色；ffmpegDir 为空时跳过壁纸文件分析，直接回退系统强调色。
  static Future<Color?> extract({String ffmpegDir = ''}) async {
    if (!supported) return null;
    final path = _wallpaperPath();
    if (path != null && ffmpegDir.isNotEmpty) {
      final c = await _dominantColor(ffmpegDir, path);
      if (c != null) return c;
    }
    return _accentColor();
  }
}
