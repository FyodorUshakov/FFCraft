import 'package:flutter/material.dart';

import '../../l10n/l10n_helper.dart';
import '../../models/concat_settings.dart';
import '../../state/app_controller.dart';
import 'form_helpers.dart';

class ConcatForm extends StatelessWidget {
  const ConcatForm({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final s = controller.concat;
    final l10n = l10nOf(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionLabel(l10n.outputContainer),
          DropdownButtonFormField<String>(
            key: ValueKey('concat-${s.container.name}'),
            initialValue: s.container.name,
            isExpanded: true,
            items: [
              for (final c in ConcatContainer.values)
                DropdownMenuItem(
                  value: c.name,
                  child: Text(
                    c == ConcatContainer.auto
                        ? l10n.autoContainer
                        : c.label,
                  ),
                ),
            ],
            onChanged: (v) {
              if (v == null) return;
              controller.updateConcat(
                (x) => x.container =
                    ConcatContainer.values.asNameMap()[v] ?? ConcatContainer.auto,
              );
            },
          ),
          const SizedBox(height: 8),
          SwitchRow(
            title: l10n.compatReencode,
            subtitle: l10n.compatReencodeHint,
            value: s.reEncode,
            onChanged: (v) => controller.updateConcat((x) => x.reEncode = v),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 18, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s.reEncode
                        ? l10n.concatInfoReencode
                        : l10n.concatInfoCopy,
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
    );
  }
}
