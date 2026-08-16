import 'package:flutter/material.dart';

import '../l10n/l10n_helper.dart';
import '../models/app_locale.dart';
import '../state/app_controller.dart';
import 'about_dialog.dart' as app;
import 'engine_dialog.dart';

/// 设置主页面：语言 + 子菜单（ffmpeg 设置、关于）。
class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final l10n = l10nOf(context);
        final scheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.settings_outlined),
              const SizedBox(width: 10),
              Text(l10n.settings),
            ],
          ),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.language,
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 6),
                DropdownButtonFormField<AppLocale>(
                  key: ValueKey('lang-${controller.locale.name}'),
                  initialValue: controller.locale,
                  isExpanded: true,
                  items: [
                    for (final l in AppLocale.values)
                      DropdownMenuItem(value: l, child: Text(l.label)),
                  ],
                  onChanged: (v) {
                    if (v != null) controller.setLocale(v);
                  },
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 4),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.settings_ethernet,
                      color: scheme.primary),
                  title: Text(l10n.engineSettings),
                  subtitle: Text(
                    controller.engineReady
                        ? l10n.engineAvailable
                        : l10n.engineUnavailable,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (_) => EngineDialog(controller: controller),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.info_outline, color: scheme.primary),
                  title: Text(l10n.aboutTitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (_) => app.AboutDialog(controller: controller),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.close),
            ),
          ],
          actionsAlignment: MainAxisAlignment.end,
        );
      },
    );
  }
}
