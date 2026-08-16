import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n_helper.dart';
import '../state/app_controller.dart';

class EngineDialog extends StatefulWidget {
  const EngineDialog({super.key, required this.controller});

  final AppController controller;

  @override
  State<EngineDialog> createState() => _EngineDialogState();
}

class _EngineDialogState extends State<EngineDialog> {
  late final TextEditingController _dir;
  bool _showManual = false;

  @override
  void initState() {
    super.initState();
    _dir = TextEditingController(text: widget.controller.userEngineDir);
    _showManual = widget.controller.userEngineDir.isNotEmpty;
  }

  @override
  void dispose() {
    _dir.dispose();
    super.dispose();
  }

  Future<void> _browse() async {
    final dir = await FilePicker.platform.getDirectoryPath(
      dialogTitle: l10nOf(context).engineSettings,
    );
    if (dir != null) {
      setState(() => _dir.text = dir);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = widget.controller;
    // 实时监听引擎状态，避免“检测中…”停留在旧画面
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        final l10n = l10nOf(context);
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.settings_outlined),
              const SizedBox(width: 10),
              Text(l10n.engineSettings),
            ],
          ),
          content: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Text(l10n.currentStatus,
                  style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (c.engineDetecting)
                      Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.detecting,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      )
                    else ...[
                      Row(
                        children: [
                          Icon(
                            c.engineReady
                                ? Icons.check_circle
                                : Icons.error_outline,
                            size: 18,
                            color: c.engineReady
                                ? const Color(0xFF43A047)
                                : scheme.error,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              c.engineReady
                                  ? l10n.engineAvailable
                                  : l10n.engineUnavailable,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        c.engineStatus,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      if (c.userEngineDir.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          l10n.manualDirValue(c.userEngineDir),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: scheme.primary),
                        ),
                      ] else if (c.engineDir.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          l10n.autoDirValue(c.engineDir),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (!_showManual)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.manualDirLabel,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _showManual = true),
                      icon: const Icon(Icons.folder_open, size: 18),
                      label: Text(l10n.manualSpecify),
                    ),
                  ],
                )
              else ...[
                Text(l10n.manualDirLabel,
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dir,
                        decoration: InputDecoration(
                          hintText: l10n.manualDirHint,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: _browse,
                      icon: const Icon(Icons.folder_open, size: 18),
                      label: Text(l10n.browse),
                    ),
                    IconButton(
                      tooltip: l10n.clearManual,
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => setState(() {
                        _dir.clear();
                        _showManual = false;
                      }),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Text(
                l10n.autoFindOrder,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _dir.clear();
                _showManual = false;
              });
              widget.controller.resetEngineDir();
            },
            child: Text(l10n.restoreAuto),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final v = _dir.text.trim();
              if (v.isEmpty) {
                widget.controller.resetEngineDir();
              } else {
                widget.controller
                    .updateCommon(() => widget.controller.userEngineDir = v);
                widget.controller.refreshEngine();
              }
              Navigator.of(context).pop();
            },
            child: Text(l10n.save),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
      );
    },
  );
  }
}
