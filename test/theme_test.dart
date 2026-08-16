import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ffmpeg_gui_flutter/models/theme_settings.dart';

void main() {
  test('默认使用淡蓝预设', () {
    final t = ThemeSettings();
    expect(t.source, ThemeSource.preset);
    expect(t.seed, const Color(0xFF4FC3F7));
  });

  test('预设索引与自定义颜色', () {
    final t = ThemeSettings(source: ThemeSource.preset, presetIndex: 3);
    expect(t.seed, ThemeSettings.presets[3]);

    final c = ThemeSettings(source: ThemeSource.custom, customColor: Colors.purple);
    expect(c.seed, Colors.purple);
  });

  test('壁纸颜色缺省时回退预设', () {
    final t = ThemeSettings(source: ThemeSource.wallpaper);
    expect(t.seed, ThemeSettings.defaultPreset);

    final w = ThemeSettings(
      source: ThemeSource.wallpaper,
      wallpaperColor: const Color(0xFF112233),
    );
    expect(w.seed, const Color(0xFF112233));
  });

  test('序列化往返', () {
    final t = ThemeSettings(
      source: ThemeSource.custom,
      customColor: const Color(0xFFABCDEF),
    );
    final r = ThemeSettings.decode(t.encode());
    expect(r.source, ThemeSource.custom);
    expect(r.customColor, const Color(0xFFABCDEF));
  });
}
