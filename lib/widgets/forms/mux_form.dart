import 'package:flutter/material.dart';

import '../../l10n/l10n_helper.dart';
import '../../models/mux_settings.dart';
import '../../state/app_controller.dart';
import 'form_helpers.dart';

class MuxForm extends StatelessWidget {
  const MuxForm({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final s = controller.mux;
    final l10n = l10nOf(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionLabel(l10n.container),
          ChipGroup<MuxContainer>(
            values: MuxContainer.values,
            labelOf: (c) => c.label,
            selected: s.container,
            onSelected: (c) => controller.updateMux((x) => x.container = c),
          ),
          const SizedBox(height: 8),
          SwitchRow(
            title: l10n.copyMetadata,
            value: s.copyMetadata,
            onChanged: (v) => controller.updateMux((x) => x.copyMetadata = v),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 18, color: scheme.primary),
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
    );
  }
}
