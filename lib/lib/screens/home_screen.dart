import 'dart:io';

import 'package:flutter/material.dart';

import '../l10n/l10n_helper.dart';
import '../models/app_mode.dart';
import '../state/app_controller.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/engine_dialog.dart';
import '../widgets/forms/audio_form.dart';
import '../widgets/forms/concat_form.dart';
import '../widgets/forms/mux_form.dart';
import '../widgets/forms/video_form.dart';
import '../widgets/log_panel.dart';
import '../widgets/mux_panel.dart';
import '../widgets/queue_panel.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/theme_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 调试用：设置 FFMPEG_DEBUG_DIALOG=1 时启动即打开引擎设置对话框。
    if (Platform.environment['FFMPEG_DEBUG_DIALOG'] == '1') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showDialog<void>(
          context: context,
          builder: (_) => EngineDialog(controller: widget.controller),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final scheme = Theme.of(context).colorScheme;
        final l10n = l10nOf(context);
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 16,
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [scheme.primary, scheme.tertiary],
                    ),
                  ),
                  child:
                      Icon(Icons.movie_filter, color: scheme.onPrimary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        l10n.appSubtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              letterSpacing: 0.3,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: _EngineChip(controller: controller),
              ),
              IconButton(
                tooltip: l10n.tooltipTheme,
                icon: const Icon(Icons.palette_outlined),
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => ThemeDialog(controller: controller),
                ),
              ),
              IconButton(
                tooltip: l10n.tooltipEngine,
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => SettingsDialog(controller: controller),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<AppMode>(
                        segments: [
                          for (final m in AppMode.values)
                            ButtonSegment(
                              value: m,
                              label: Text(_modeLabel(l10n, m)),
                              icon: Icon(_modeIcon(m), size: 18),
                            ),
                        ],
                        selected: {controller.mode},
                        onSelectionChanged: controller.running
                            ? null
                            : (v) => controller.setMode(v.first),
                        showSelectedIcon: false,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _modeHint(l10n, controller.mode),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 3,
                        child: controller.mode == AppMode.mux
                            ? MuxPanel(controller: controller)
                            : QueuePanel(controller: controller),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: _SettingsCard(controller: controller),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.showLog)
                LogPanel(
                  controller: controller,
                  onClose: () => controller.setLogVisible(false),
                ),
              BottomBar(controller: controller),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  IconData _modeIcon(AppMode m) => switch (m) {
        AppMode.audio => Icons.music_note,
        AppMode.video => Icons.videocam_outlined,
        AppMode.mux => Icons.merge_type,
        AppMode.concat => Icons.join_full,
      };
}

String _modeLabel(AppLocalizations l10n, AppMode m) => switch (m) {
      AppMode.audio => l10n.modeAudio,
      AppMode.video => l10n.modeVideo,
      AppMode.mux => l10n.modeMux,
      AppMode.concat => l10n.modeConcat,
    };

String _modeHint(AppLocalizations l10n, AppMode m) => switch (m) {
      AppMode.audio => l10n.hintAudio,
      AppMode.video => l10n.hintVideo,
      AppMode.mux => l10n.hintMux,
      AppMode.concat => l10n.hintConcat,
    };

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = l10nOf(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Icon(Icons.tune, size: 20, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.settingsTitle(_modeLabel(l10n, controller.mode)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: switch (controller.mode) {
              AppMode.audio => AudioForm(controller: controller),
              AppMode.video => VideoForm(controller: controller),
              AppMode.mux => MuxForm(controller: controller),
              AppMode.concat => ConcatForm(controller: controller),
            },
          ),
        ],
      ),
    );
  }
}

class _EngineChip extends StatelessWidget {
  const _EngineChip({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = l10nOf(context);
    final ok = controller.engineReady;
    final color = ok ? const Color(0xFF43A047) : scheme.error;
    return Tooltip(
      message: controller.engineStatus.isEmpty
          ? l10n.detecting
          : '${controller.engineStatus}\n${controller.engineDir}',
      waitDuration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: (ok ? scheme.secondaryContainer : scheme.errorContainer)
              .withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 9, color: color),
            const SizedBox(width: 7),
            Text(
              ok ? l10n.engineReady : l10n.engineMissing,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: scheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
