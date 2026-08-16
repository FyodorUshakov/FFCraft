import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n_helper.dart';
import '../state/app_controller.dart';

/// 合流模式的输入面板：一个视频文件 + 若干音频文件。
class MuxPanel extends StatelessWidget {
  const MuxPanel({super.key, required this.controller});

  final AppController controller;

  Future<void> _pickVideo(BuildContext context) async {
    final r = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
      dialogTitle: l10nOf(context).videoFile,
    );
    if (r != null && r.files.isNotEmpty) {
      controller.setVideoFile(r.files.first.path ?? '');
    }
  }

  Future<void> _pickAudio(BuildContext context) async {
    final r = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
      dialogTitle: l10nOf(context).audioFiles,
    );
    if (r == null) return;
    for (final f in r.files) {
      final p = f.path;
      if (p != null && p.isNotEmpty) controller.addAudioFile(p);
    }
  }

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
                Icon(Icons.merge_type, size: 20, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.muxInput,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  l10n.muxNoReencode,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SlotCard(
                  icon: Icons.videocam_outlined,
                  title: l10n.videoFile,
                  subtitle: l10n.videoFileHint,
                  path: controller.videoFile,
                  onPick: () => _pickVideo(context),
                  onClear: controller.videoFile.isEmpty
                      ? null
                      : () => controller.setVideoFile(''),
                ),
                const SizedBox(height: 12),
                _SlotCard(
                  icon: Icons.audiotrack,
                  title: l10n.audioFiles,
                  subtitle: l10n.audioFilesHint,
                  path: controller.audioFiles.isEmpty
                      ? ''
                      : controller.audioFiles.join('\n'),
                  onPick: () => _pickAudio(context),
                  onClear: controller.audioFiles.isEmpty
                      ? null
                      : () {
                          for (var i = controller.audioFiles.length - 1;
                              i >= 0;
                              i--) {
                            controller.removeAudioFileAt(i);
                          }
                        },
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 18, color: scheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.muxInfo,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.path,
    required this.onPick,
    this.onClear,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String path;
  final VoidCallback onPick;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = l10nOf(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.primary, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                if (path.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    path,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.primary,
                          fontFamily: 'CascadiaMono',
                          fontSize: 11,
                        ),
                  ),
                ],
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onPick,
            icon: const Icon(Icons.folder_open, size: 17),
            label: Text(l10n.select),
          ),
          if (onClear != null)
            IconButton(
              tooltip: l10n.clear,
              icon: const Icon(Icons.close, size: 18),
              onPressed: onClear,
            ),
        ],
      ),
    );
  }
}
