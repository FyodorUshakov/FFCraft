import 'package:flutter/material.dart';

import '../../l10n/l10n_helper.dart';
import '../../models/audio_settings.dart';
import '../../state/app_controller.dart';
import 'form_helpers.dart';

class AudioForm extends StatelessWidget {
  const AudioForm({super.key, required this.controller});

  final AppController controller;

  static const bitratePresets = [96, 128, 192, 256, 320];

  void _switchCodec(AudioCodec c) {
    controller.updateAudio((s) {
      s.codec = c;
      s.bitrateMode = AudioBitrateMode.cbr;
      s.bitrate = 192;
      s.vbrQuality = c == AudioCodec.aac ? 1.0 : 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = controller.audio;
    final l10n = l10nOf(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionLabel(l10n.outputCodec),
          ChipGroup<AudioCodec>(
            values: AudioCodec.values,
            labelOf: (c) => c.label,
            selected: s.codec,
            onSelected: _switchCodec,
          ),
          if (!s.codec.supportsCoverArt) ...[
            const SizedBox(height: 8),
            HintText(l10n.coverNotSupportedHint),
          ],
          const SizedBox(height: 16),
          _LabeledDropdown(
            label: l10n.sampleRate,
            value: s.sampleRate,
            items: [
              ('keep', l10n.sampleRateKeep),
              ('44100', '44100 Hz'),
              ('48000', '48000 Hz'),
              ('88200', '88200 Hz'),
              ('96000', '96000 Hz'),
              ('192000', '192000 Hz'),
            ],
            onChanged: (v) => controller.updateAudio((x) => x.sampleRate = v),
          ),
          HintText(l10n.sampleRateHint),
          const SizedBox(height: 8),
          SwitchRow(
            title: l10n.copyMetadata,
            subtitle: l10n.copyMetadataHint,
            value: s.copyMetadata,
            onChanged: (v) => controller.updateAudio((x) => x.copyMetadata = v),
          ),
          const SizedBox(height: 8),
          const Divider(height: 24),
          if (s.codec.isLossless)
            _losslessSection(context, s)
          else
            _lossySection(context, s),
        ],
      ),
    );
  }

  Widget _losslessSection(BuildContext context, AudioSettings s) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = l10nOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(l10n.losslessParams),
        _LabeledDropdown(
          label: l10n.bitDepth,
          value: '${s.bitDepth}',
          items: const [
            ('16', '16 bit'),
            ('24', '24 bit'),
            ('32', '32 bit'),
          ],
          onChanged: (v) =>
              controller.updateAudio((x) => x.bitDepth = int.parse(v)),
        ),
        HintText(l10n.bitDepthHint),
        if (s.codec == AudioCodec.flac) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Text(l10n.flacCompression),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${s.flacCompression}',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: scheme.onPrimaryContainer),
                ),
              ),
            ],
          ),
          Slider(
            value: s.flacCompression.toDouble(),
            min: 0,
            max: 8,
            divisions: 8,
            label: '${s.flacCompression}',
            onChanged: (v) =>
                controller.updateAudio((x) => x.flacCompression = v.round()),
          ),
          Text(
            l10n.flacCompressionHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
      ],
    );
  }

  Widget _lossySection(BuildContext context, AudioSettings s) {
    final isOpus = s.codec == AudioCodec.opus;
    final l10n = l10nOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(l10n.bitrateControl),
        SegmentedButton<AudioBitrateMode>(
          segments: [
            for (final m in AudioBitrateMode.values)
              if (!(isOpus && m == AudioBitrateMode.abr))
                ButtonSegment(value: m, label: Text(_bitrateModeLabel(l10n, m))),
          ],
          selected: {s.bitrateMode},
          onSelectionChanged: (v) =>
              controller.updateAudio((x) => x.bitrateMode = v.first),
          showSelectedIcon: false,
        ),
        HintText(l10n.bitrateModeHint),
        const SizedBox(height: 12),
        if (s.bitrateMode != AudioBitrateMode.vbr || isOpus)
          _bitrateBlock(context, s)
        else
          _qualityBlock(context, s),
      ],
    );
  }

  Widget _bitrateBlock(BuildContext context, AudioSettings s) {
    final scheme = Theme.of(context).colorScheme;
    final isOpus = s.codec == AudioCodec.opus;
    final l10n = l10nOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(l10n.bitrate),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${s.bitrate} kbps',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: scheme.onPrimaryContainer),
              ),
            ),
          ],
        ),
        Slider(
          value: s.bitrate.clamp(32, 512).toDouble(),
          min: 32,
          max: 512,
          divisions: 30,
          label: '${s.bitrate} kbps',
          onChanged: (v) =>
              controller.updateAudio((x) => x.bitrate = v.round()),
        ),
        Wrap(
          spacing: 8,
          children: [
            for (final p in bitratePresets)
              ActionChip(
                label: Text('$p'),
                onPressed: () => controller.updateAudio((x) => x.bitrate = p),
              ),
          ],
        ),
        HintText(l10n.bitrateHint),
        if (isOpus)
          Text(
            l10n.opusVbrHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
      ],
    );
  }

  Widget _qualityBlock(BuildContext context, AudioSettings s) {
    final scheme = Theme.of(context).colorScheme;
    final isMp3 = s.codec == AudioCodec.mp3;
    final isAac = s.codec == AudioCodec.aac;
    final l10n = l10nOf(context);
    final (double min, double max, String unitLabel) = isMp3
        ? (0.0, 9.0, l10n.qualityRangeMp3)
        : isAac
            ? (0.1, 2.0, '0.1-2.0')
            : (0.0, 10.0, l10n.qualityRangeVorbis);
    final divisions = isMp3
        ? 9
        : isAac
            ? 19
            : 10;
    final val = s.vbrQuality.clamp(min, max);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(l10n.vbrQuality),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isMp3
                    ? '${val.round()}'
                    : val.toStringAsFixed(1),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: scheme.onPrimaryContainer),
              ),
            ),
          ],
        ),
        Slider(
          value: val,
          min: min,
          max: max,
          divisions: divisions,
          label: isMp3 ? '${val.round()}' : val.toStringAsFixed(1),
          onChanged: (v) => controller.updateAudio(
            (x) => x.vbrQuality =
                isMp3 ? v.roundToDouble() : double.parse(v.toStringAsFixed(1)),
          ),
        ),
        HintText(l10n.qualityRangeHint(unitLabel)),
      ],
    );
  }

  static String _bitrateModeLabel(AppLocalizations l10n, AudioBitrateMode m) =>
      switch (m) {
        AudioBitrateMode.cbr => l10n.modeCbr,
        AudioBitrateMode.vbr => l10n.modeVbr,
        AudioBitrateMode.abr => l10n.modeAbr,
      };
}

class _LabeledDropdown extends StatelessWidget {
  const _LabeledDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<(String, String)> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          key: ValueKey('$label-$value'),
          initialValue: value,
          isExpanded: true,
          items: [
            for (final (v, t) in items)
              DropdownMenuItem(value: v, child: Text(t)),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }
}
