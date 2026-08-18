import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n_helper.dart';
import '../models/theme_settings.dart';
import '../services/wallpaper_color.dart';
import '../state/app_controller.dart';

/// 配色方案设置：预设色板 / 跟随壁纸 / 自定义颜色。
class ThemeDialog extends StatelessWidget {
  const ThemeDialog({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final scheme = Theme.of(context).colorScheme;
        final t = controller.theme;
        final l10n = l10nOf(context);
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.palette_outlined),
              const SizedBox(width: 10),
              Text(l10n.themeSettings),
            ],
          ),
          content: SizedBox(
            width: 560,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _preview(context, scheme, t),
                  const SizedBox(height: 16),
                  Text(l10n.presetPalette,
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 8),
                  _presetGrid(context, t),
                  const SizedBox(height: 16),
                  _wallpaperRow(context, scheme),
                  const Divider(height: 32),
                  Text(l10n.customColor,
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                  Text(
                    l10n.customColorHint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ColorPicker(
                    color: t.customColor,
                    onColorChanged: controller.setCustomTheme,
                    pickersEnabled: const {
                      ColorPickerType.both: false,
                      ColorPickerType.primary: true,
                      ColorPickerType.accent: false,
                      ColorPickerType.bw: false,
                      ColorPickerType.custom: false,
                      ColorPickerType.customSecondary: false,
                      ColorPickerType.wheel: true,
                    },
                    enableOpacity: false,
                    showColorCode: true,
                    colorCodeHasColor: true,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () => controller.setPresetTheme(0),
              icon: const Icon(Icons.restart_alt, size: 18),
              label: Text(l10n.restoreDefault),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.close),
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceBetween,
        );
      },
    );
  }

  Widget _preview(BuildContext context, ColorScheme scheme, ThemeSettings t) {
    final seed = t.seed;
    final l10n = l10nOf(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: seed,
              shape: BoxShape.circle,
              border: Border.all(color: scheme.outlineVariant, width: 1),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.currentTheme,
                  style: Theme.of(context).textTheme.labelMedium),
              Text(
                  '#${(seed.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}'
                  ' · ${_sourceLabel(l10n, t.source)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
              ),
            ],
          ),
          const Spacer(),
          if (t.source == ThemeSource.wallpaper && t.wallpaperColor != null)
            Text(
              l10n.wallpaperColorLabel,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.primary,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _presetGrid(BuildContext context, ThemeSettings t) {
    final l10n = l10nOf(context);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (var i = 0; i < ThemeSettings.presets.length; i++)
          _PresetDot(
            color: ThemeSettings.presets[i],
            name: _presetName(l10n, i),
            selected: t.source == ThemeSource.preset && t.presetIndex == i,
            onTap: () => controller.setPresetTheme(i),
          ),
      ],
    );
  }

  static String _presetName(AppLocalizations l10n, int i) => switch (i) {
        0 => l10n.colorDefault,
        1 => l10n.colorBlue,
        2 => l10n.colorCyan,
        3 => l10n.colorTeal,
        4 => l10n.colorGreen,
        5 => l10n.colorLime,
        6 => l10n.colorAmber,
        7 => l10n.colorOrange,
        8 => l10n.colorCoral,
        9 => l10n.colorPink,
        10 => l10n.colorPurple,
        11 => l10n.colorViolet,
        12 => l10n.colorIndigo,
        _ => l10n.colorBlueGrey,
      };

  static String _sourceLabel(AppLocalizations l10n, ThemeSource s) =>
      switch (s) {
        ThemeSource.preset => l10n.sourcePreset,
        ThemeSource.custom => l10n.sourceCustom,
        ThemeSource.wallpaper => l10n.sourceWallpaper,
      };

  Widget _wallpaperRow(BuildContext context, ColorScheme scheme) {
    final supported = WallpaperColor.supported;
    final l10n = l10nOf(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.wallpaper_outlined,
            color: supported ? scheme.primary : scheme.outline,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.followWallpaper,
                    style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  supported
                      ? l10n.wallpaperHint
                      : l10n.wallpaperOnlyWindows,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          if (controller.theme.wallpaperColor != null) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: controller.theme.wallpaperColor,
                shape: BoxShape.circle,
                border: Border.all(color: scheme.outlineVariant),
              ),
            ),
            const SizedBox(width: 10),
          ],
          FilledButton.tonalIcon(
            onPressed: supported && !controller.wallpaperExtracting
                ? () async {
                    final ok = await controller.applyWallpaperTheme();
                    if (!ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.wallpaperFailed),
                        ),
                      );
                    }
                  }
                : null,
            icon: controller.wallpaperExtracting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.colorize, size: 18),
            label: Text(
              controller.wallpaperExtracting
                  ? l10n.extracting
                  : l10n.fromWallpaper,
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetDot extends StatelessWidget {
  const _PresetDot({
    required this.color,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: name,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? scheme.onSurface : scheme.outlineVariant,
              width: selected ? 3 : 1,
            ),
          ),
          child: selected
              ? Icon(Icons.check, size: 18, color: _contrast(color))
              : null,
        ),
      ),
    );
  }

  Color _contrast(Color c) {
    // 简单亮度判断，选黑白勾
    final l = c.computeLuminance();
    return l > 0.5 ? Colors.black87 : Colors.white;
  }
}
