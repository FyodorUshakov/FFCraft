import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n_helper.dart';
import '../models/app_mode.dart';
import '../models/queue_item.dart';
import '../state/app_controller.dart';

class QueuePanel extends StatefulWidget {
  const QueuePanel({super.key, required this.controller});

  final AppController controller;

  @override
  State<QueuePanel> createState() => _QueuePanelState();
}

class _QueuePanelState extends State<QueuePanel> {
  bool _hover = false;

  String get _hint {
    final l10n = l10nOf(context);
    switch (widget.controller.mode) {
      case AppMode.audio:
        return l10n.dragHintAudio;
      case AppMode.video:
        return l10n.dragHintVideo;
      case AppMode.concat:
        return l10n.dragHintConcat;
      case AppMode.mux:
        return '';
    }
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
      dialogTitle: l10nOf(context).addFiles,
    );
    if (result == null) return;
    widget.controller
        .addFiles(result.files.map((f) => f.path ?? '').where((p) => p.isNotEmpty).toList());
  }

  Future<void> _pickFolder() async {
    final dir = await FilePicker.platform.getDirectoryPath(
      dialogTitle: l10nOf(context).addFolder,
    );
    if (dir == null) return;
    await widget.controller.addFolder(dir);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = l10nOf(context);
    final c = widget.controller;
    return DropTarget(
      onDragDone: (details) {
        setState(() => _hover = false);
        c.addFiles(details.files.map((f) => f.path).toList());
      },
      onDragEntered: (_) => setState(() => _hover = true),
      onDragExited: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            width: 2,
            color: _hover ? scheme.primary : Colors.transparent,
          ),
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Row(
                          children: [
                            Icon(_queueHeaderIcon(c.mode),
                                size: 20, color: scheme.primary),
                            const SizedBox(width: 8),
                        Text(
                          l10n.queueTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: scheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(999),
                              ),
                          child: Text(
                            l10n.itemCount(c.items.length),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                            const Spacer(),
                        IconButton(
                          tooltip: l10n.clearQueue,
                              onPressed: c.running || c.items.isEmpty
                                  ? null
                                  : c.clearQueue,
                              icon: const Icon(Icons.delete_sweep_outlined,
                                  size: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Wrap(
                          spacing: 4,
                          children: [
                            TextButton.icon(
                          onPressed: c.running ? null : _pickFiles,
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(l10n.addFiles),
                            ),
                            TextButton.icon(
                              onPressed: c.running ? null : _pickFolder,
                          icon: const Icon(
                                  Icons.create_new_folder_outlined,
                                  size: 18),
                          label: Text(l10n.addFolder),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: c.items.isEmpty
                    ? _emptyHint(context)
                    : Column(
                        children: [
                          Expanded(child: _list(context)),
                          _DropZone(hover: _hover),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyHint(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = l10nOf(context);
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.cloud_upload_outlined,
                    size: 32, color: scheme.primary),
              ),
              const SizedBox(height: 12),
              Text(l10n.dragFiles,
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 6),
              Text(
                _hint,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _list(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = widget.controller;
    final l10n = l10nOf(context);
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: c.items.length,
      separatorBuilder: (_, _) => const Divider(height: 1, indent: 68),
      itemBuilder: (context, index) {
        final item = c.items[index];
        return ListTile(
          dense: true,
          leading: _StatusIcon(item: item),
          title: Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: item.status == FileStatus.done
                  ? scheme.onSurfaceVariant
                  : scheme.onSurface,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.metaLine.isNotEmpty ? item.metaLine : item.dir,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: item.status == FileStatus.failed
                          ? scheme.error
                          : scheme.onSurfaceVariant,
                    ),
              ),
              if (item.status == FileStatus.running) ...[
                const SizedBox(height: 3),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: item.progress > 0 ? item.progress : null,
                          minHeight: 4,
                          backgroundColor: scheme.surfaceContainerHighest,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${(item.progress * 100).round()}%',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: scheme.primary,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                    ),
                  ],
                ),
              ] else if (item.status == FileStatus.done &&
                  item.detail.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  item.detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ] else if (item.status == FileStatus.failed &&
                  item.detail.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  item.detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.error,
                      ),
                ),
              ],
            ],
          ),
                  trailing: c.running
              ? null
              : IconButton(
                  tooltip: l10n.remove,
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => c.removeAt(index),
                ),
        );
      },
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.item});

  final QueueItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (item.status) {
      FileStatus.queued => Icon(
          _formatIcon(item.path),
          color: scheme.primary,
          size: 22,
        ),
      FileStatus.running => SizedBox(
          width: 22,
          height: 22,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              value: item.progress > 0 ? item.progress : null,
            ),
          ),
        ),
      FileStatus.done => item.hasWarning
          ? Icon(Icons.warning_amber_rounded, color: const Color(0xFFF9A825))
          : Icon(Icons.check_circle, color: const Color(0xFF43A047)),
      FileStatus.failed => Icon(Icons.error, color: scheme.error),
      FileStatus.cancelled => Icon(Icons.block, color: scheme.outline),
    };
  }
}

IconData _formatIcon(String path) {
  if (isVideoExtension(path)) return Icons.videocam_outlined;
  if (isAudioExtension(path)) return Icons.music_note;
  return Icons.insert_drive_file_outlined;
}

/// 队列面板标题图标：视频模式用“三条横杠 + 播放”图标，其余按模式切换。
IconData _queueHeaderIcon(AppMode mode) => switch (mode) {
      AppMode.audio => Icons.queue_music,
      AppMode.video => Icons.playlist_play,
      AppMode.mux => Icons.merge_type,
      AppMode.concat => Icons.join_full,
    };

/// 虚线拖放区：拖拽更多文件或文件夹到此处。
class _DropZone extends StatelessWidget {
  const _DropZone({required this.hover});

  final bool hover;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = l10nOf(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: hover ? scheme.primary : scheme.outlineVariant,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 56,
          decoration: BoxDecoration(
            color: hover
                ? scheme.primaryContainer.withValues(alpha: 0.35)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 18,
                color: hover ? scheme.primary : scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.dropMore,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: hover
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(12),
        ),
      );
    const dash = 6.0;
    const gap = 4.0;
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        final end = (d + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(d, end), paint);
        d = end + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color;
}
