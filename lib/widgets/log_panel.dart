import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n_helper.dart';
import '../models/log_style.dart';
import '../state/app_controller.dart';

class LogPanel extends StatefulWidget {
  const LogPanel({super.key, required this.controller, required this.onClose});

  final AppController controller;
  final VoidCallback onClose;

  @override
  State<LogPanel> createState() => _LogPanelState();
}

class _LogPanelState extends State<LogPanel> {
  final _scroll = ScrollController();
  int _lastCount = 0;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final lines = widget.controller.logLines;
        final l10n = l10nOf(context);
        if (lines.length != _lastCount) {
          _lastCount = lines.length;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scroll.hasClients) {
              _scroll.jumpTo(_scroll.position.maxScrollExtent);
            }
          });
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Container(
            height: 170,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 8, 4),
                  child: Row(
                    children: [
                      Icon(Icons.terminal, size: 15, color: scheme.primary),
                      const SizedBox(width: 6),
                      Text(
                        l10n.logTitle,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const Spacer(),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.copy, size: 16),
                        tooltip: l10n.copyLog,
                        onPressed: () async {
                          final text =
                              widget.controller.logLines.join('\n');
                          await Clipboard.setData(ClipboardData(text: text));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.logCopied),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: widget.controller.clearLog,
                        child: Text(l10n.clear),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.close, size: 17),
                        tooltip: l10n.tooltipLogHide,
                        onPressed: widget.onClose,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: lines.isEmpty
                      ? Center(
                          child: Text(
                            l10n.noLog,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scroll,
                          padding: const EdgeInsets.fromLTRB(12, 2, 12, 10),
                          itemCount: lines.length,
                          itemBuilder: (context, i) =>
                              _logLine(context, scheme, lines[i]),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _logLine(BuildContext context, ColorScheme scheme, String line) {
    final base = TextStyle(
      fontFamily: 'CascadiaMono',
      fontSize: 12,
      height: 1.45,
      color: scheme.onSurfaceVariant,
    );
    final ts = RegExp(r'^(\[\d{2}:\d{2}:\d{2}\])\s?(.*)$').firstMatch(line);
    final Color contentColor;
    final bool bold;
    switch (classifyLogLine(line)) {
      case LogKind.error:
        contentColor = scheme.error;
        bold = true;
      case LogKind.warning:
        contentColor = const Color(0xFFF9A825);
        bold = false;
      case LogKind.progress:
        contentColor = scheme.primary;
        bold = false;
      case LogKind.normal:
        contentColor = scheme.onSurfaceVariant;
        bold = false;
    }
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          if (ts != null)
            TextSpan(
              text: '${ts.group(1)} ',
              style: TextStyle(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.45),
              ),
            ),
          TextSpan(
            text: ts != null ? ts.group(2) ?? '' : line,
            style: TextStyle(
              color: contentColor,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
