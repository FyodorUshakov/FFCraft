import 'dart:convert';

import 'package:flutter/material.dart';

/// 配色来源。
enum ThemeSource { preset, custom, wallpaper }

/// 应用配色方案：预设色板 / 自定义颜色 / 跟随壁纸（Windows）。
class ThemeSettings {
  ThemeSource source;
  int presetIndex;
  Color customColor;
  Color? wallpaperColor;

  ThemeSettings({
    this.source = ThemeSource.preset,
    this.presetIndex = 0,
    this.customColor = defaultPreset,
    this.wallpaperColor,
  });

  static const defaultPreset = Color(0xFF4FC3F7);

  static const presets = <Color>[
    Color(0xFF4FC3F7), // 默认 · 淡蓝
    Color(0xFF42A5F5), // 蓝
    Color(0xFF00BCD4), // 天青
    Color(0xFF26A69A), // 青绿
    Color(0xFF66BB6A), // 翠绿
    Color(0xFF9CCC65), // 黄绿
    Color(0xFFFFCA28), // 琥珀
    Color(0xFFFFA726), // 橙
    Color(0xFFFF7043), // 珊瑚
    Color(0xFFF06292), // 粉
    Color(0xFFBA68C8), // 紫
    Color(0xFF9575CD), // 紫罗兰
    Color(0xFF5C6BC0), // 靛蓝
    Color(0xFF78909C), // 蓝灰
  ];

  static const presetNames = <String>[
    '默认 · 淡蓝', '蓝', '天青', '青绿', '翠绿', '黄绿',
    '琥珀', '橙', '珊瑚', '粉', '紫', '紫罗兰', '靛蓝', '蓝灰',
  ];

  /// 当前生效的主题种子色。
  Color get seed => switch (source) {
        ThemeSource.preset =>
          presets[presetIndex.clamp(0, presets.length - 1)],
        ThemeSource.custom => customColor,
        ThemeSource.wallpaper =>
          wallpaperColor ?? presets[presetIndex.clamp(0, presets.length - 1)],
      };

  String get sourceLabel => switch (source) {
        ThemeSource.preset => '预设',
        ThemeSource.custom => '自定义',
        ThemeSource.wallpaper => '跟随壁纸',
      };

  factory ThemeSettings.fromJson(Map<String, dynamic> json) {
    return ThemeSettings(
      source: ThemeSource.values.asNameMap()[json['source']] ??
          ThemeSource.preset,
      presetIndex: (json['presetIndex'] as num?)?.toInt() ?? 0,
      customColor:
          _colorFromInt((json['customColor'] as num?)?.toInt()) ??
              defaultPreset,
      wallpaperColor: _colorFromInt((json['wallpaperColor'] as num?)?.toInt()),
    );
  }

  Map<String, dynamic> toJson() => {
        'source': source.name,
        'presetIndex': presetIndex,
        'customColor': customColor.toARGB32(),
        'wallpaperColor': wallpaperColor?.toARGB32(),
      };

  String encode() => jsonEncode(toJson());

  static ThemeSettings decode(String raw) {
    try {
      return ThemeSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return ThemeSettings();
    }
  }

  static Color? _colorFromInt(int? v) =>
      v == null ? null : Color(v & 0xFFFFFFFF);
}
