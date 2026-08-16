import 'package:flutter/material.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
      ),
    );
  }
}

/// 控件下方的灰色说明文字。
class HintText extends StatelessWidget {
  const HintText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

class SwitchRow extends StatelessWidget {
  const SwitchRow({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      value: value,
      onChanged: onChanged,
    );
  }
}

class ValueSwitchRow extends StatelessWidget {
  const ValueSwitchRow({
    super.key,
    required this.title,
    required this.unit,
    required this.hint,
    required this.enabled,
    required this.initial,
    required this.onEnabled,
    required this.onSubmit,
  });

  final String title;
  final String unit;
  final String hint;
  final bool enabled;
  final String initial;
  final ValueChanged<bool> onEnabled;
  final ValueChanged<String> onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Switch(value: enabled, onChanged: onEnabled),
              const SizedBox(width: 8),
              Expanded(child: Text(title)),
              if (enabled)
                SizedBox(
                  width: 170,
                  child: TextField(
                    enabled: enabled,
                    decoration: InputDecoration(
                      hintText: hint,
                      suffixText: unit.isEmpty ? null : unit,
                      isDense: true,
                    ),
                    onSubmitted: onSubmit,
                  ),
                ),
            ],
          ),
          if (!enabled)
            Padding(
              padding: const EdgeInsets.only(left: 56),
              child: Text(
                hint,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

class ChipGroup<T> extends StatelessWidget {
  const ChipGroup({
    super.key,
    required this.values,
    required this.labelOf,
    required this.selected,
    required this.onSelected,
    this.disabled = const {},
  });

  final List<T> values;
  final String Function(T) labelOf;
  final T selected;
  final ValueChanged<T> onSelected;
  final Set<T> disabled;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final v in values)
          ChoiceChip(
            label: Text(labelOf(v)),
            selected: selected == v,
            showCheckmark: false,
            onSelected: disabled.contains(v) ? null : (_) => onSelected(v),
          ),
      ],
    );
  }
}
