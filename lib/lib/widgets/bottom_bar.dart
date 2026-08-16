import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n_helper.dart';
import '../models/app_mode.dart';
import '../state/app_controller.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key, required this.controller});

  final AppController controller;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (widget.controller.running) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _elapsed(DateTime? start) {
    if (start == null) return '00:00';
    final d = DateTime.now().difference(start);
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _pickOutDir() async {
    final dir = await FilePicker.platform.getDirectoryPath(
      dialogTitle: l10nOf(context).outputDir,
    );
    if (dir == null) return;
    widget.controller.updateCommon(() => widget.controller.outDir = dir);
  }

  String get _startHint {
    final c = widget.controller;
    final l10n = l10nOf(context);
    switch (c.mode) {
      case AppMode.concat:
        return c.items.length < 2 ? l10n.needTwoFiles : l10n.startConcat;
      case AppMode.mux:
        return c.videoFile.isEmpty ? l10n.needVideoFile : l10n.startMux;
      case AppMode.audio:
        return c.items.isEmpty ? l10n.needAudioFile : l10n.startAudio;
      case AppMode.video:
        return c.items.isEmpty ? l10n.needVideoFiles : l10n.startVideo;
    }
  }

  bool get _canStart {
    final c = widget.controller;
    switch (c.mode) {
      case AppMode.concat:
        return c.items.length >= 2;
      case AppMode.mux:
        return c.videoFile.isNotEmpty;
      case AppMode.audio:
      case AppMode.video:
        return c.items.isNotEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = l10nOf(context);
    final c = widget.controller;
    final s = c.mode == AppMode.audio || c.mode == AppMode.video;
    final hasOut = c.outDir.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                      Icon(Icons.folder_outlined,
                          size: 20, color: scheme.primary),
                      Text(l10n.outputDir,
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(width: 12),
                      ChoiceChip(
                        label: Text(l10n.sameAsSource),
                        selected: !hasOut,
                        showCheckmark: false,
                        visualDensity: VisualDensity.compact,
                        onSelected: (_) =>
                            c.updateCommon(() => c.outDir = ''),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text(l10n.customDir),
                        selected: hasOut,
                        showCheckmark: false,
                        visualDensity: VisualDensity.compact,
                        onSelected: (_) {
                          if (!hasOut) _pickOutDir();
                        },
                      ),
                      if (hasOut) ...[
                        const SizedBox(width: 12),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 320),
                          child: Tooltip(
                            message: c.outDir,
                            child: Text(
                              c.outDir,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _pickOutDir,
                          child: Text(l10n.browse),
                        ),
                        IconButton(
                          tooltip: l10n.clearOutDir,
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => c.updateCommon(() => c.outDir = ''),
                        ),
                      ],
                ],
              ),
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  final narrow = constraints.maxWidth < 760;
                  final left = Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(Icons.speed, size: 20, color: scheme.primary),
                      Text(l10n.parallelTasks,
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text(
                        '${s ? c.maxWorkers : 1}',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: scheme.primary),
                      ),
                      SizedBox(
                        width: 140,
                        child: Slider(
                          value: (s ? c.maxWorkers : 1).toDouble(),
                          min: 1,
                          max: 8,
                          divisions: 7,
                          label: '${s ? c.maxWorkers : 1}',
                          onChanged: c.running || !s
                              ? null
                              : (v) => c.updateCommon(
                                  () => c.maxWorkers = v.round()),
                        ),
                      ),
                      if (!s)
                        Text(
                          l10n.singleTaskNote,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                        ),
                    ],
                  );
                  final right = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (c.running) ...[
                        Icon(Icons.timer_outlined,
                            size: 17, color: scheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          _elapsed(c.startedAt),
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: scheme.onSurfaceVariant,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Text(
                        '${c.doneCount}/${c.totalJobs}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: c.overallProgress,
                            minHeight: 8,
                            backgroundColor: scheme.surfaceContainerHighest,
                            color: c.failedCount > 0
                                ? scheme.error
                                : scheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (c.running)
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: scheme.errorContainer,
                            foregroundColor: scheme.onErrorContainer,
                            minimumSize: const Size(120, 46),
                          ),
                          onPressed: c.stop,
                          icon: const Icon(Icons.stop),
                          label: Text(l10n.stop),
                        )
                      else
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(140, 46),
                          ),
                          onPressed: _canStart ? () => c.start() : null,
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: Text(_startHint),
                        ),
                      const SizedBox(width: 4),
                      IconButton(
                        tooltip:
                            c.showLog ? l10n.tooltipLogHide : l10n.tooltipLogShow,
                        icon: Icon(
                          c.showLog
                              ? Icons.terminal
                              : Icons.terminal_outlined,
                        ),
                        onPressed: () => c.setLogVisible(!c.showLog),
                      ),
                    ],
                  );
                  if (narrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        left,
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [right],
                        ),
                      ],
                    );
                  }
                  return Row(
                    children: [left, const Spacer(), right],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
