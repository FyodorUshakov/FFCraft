import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/l10n_helper.dart';
import '../../models/video_settings.dart';
import '../../state/app_controller.dart';
import 'form_helpers.dart';

class VideoForm extends StatelessWidget {
  const VideoForm({super.key, required this.controller});

  final AppController controller;

  static const _hwByCodec = <VideoCodec, List<String>>{
    VideoCodec.h264: [
      'h264_nvenc', 'h264_qsv', 'h264_amf', 'h264_videotoolbox',
    ],
    VideoCodec.h265: [
      'hevc_nvenc', 'hevc_qsv', 'hevc_amf', 'hevc_videotoolbox',
    ],
    VideoCodec.av1: ['av1_nvenc', 'av1_qsv', 'av1_amf'],
    VideoCodec.vp9: ['vp9_qsv'],
    VideoCodec.mpeg4: [],
    VideoCodec.copy: [],
  };

  /// 当前编码对应的硬件编码器候选：优先显示本机检测到的。
  List<String> _hwCandidatesFor(VideoCodec codec) {
    final known = _hwByCodec[codec] ?? const [];
    final available = controller.hwEncoders;
    if (available.isEmpty) return known;
    return known.where(available.contains).toList();
  }

  static const bitratePresets = [2000, 4000, 8000, 12000];
  static const resolutionOptions = [
    ('keep', 'keepOriginal'),
    ('1920x1080', '1920×1080 (1080p)'),
    ('1280x720', '1280×720 (720p)'),
    ('854x480', '854×480 (480p)'),
    ('640x360', '640×360 (360p)'),
    ('custom', '自定义…'),
  ];
  static const fpsOptions = [
    ('keep', 'keepOriginal'),
    ('24000/1001', '23.976'),
    ('24', '24'),
    ('25', '25'),
    ('30', '30'),
    ('50', '50'),
    ('60', '60'),
  ];

  void _switchCodec(VideoCodec c) {
    controller.updateVideo((s) {
      s.codec = c;
      s.preset = c == VideoCodec.av1 ? '8' : 'medium';
      if (!c.supportsCrf && s.bitrateMode == VideoBitrateMode.crf) {
        s.bitrateMode = VideoBitrateMode.abr;
      }
      // 每种编码：识别到硬件编码器则默认启用，否则默认关闭
      final cands = _hwCandidatesFor(c);
      if (cands.isNotEmpty) {
        s.hwAccel = true;
        // 硬件编码器始终默认选中候选列表中的第一个
        s.hwEncoder = cands.first;
        s.hwPreset = defaultHwPreset(cands.first);
      } else {
        s.hwAccel = false;
        s.hwEncoder = '';
        s.hwPreset = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = controller.video;
    final l10n = l10nOf(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionLabel(l10n.videoCodec),
          ChipGroup<VideoCodec>(
            values: VideoCodec.values,
            labelOf: (c) =>
                c == VideoCodec.copy ? l10n.codecCopy : c.label,
            selected: s.codec,
            onSelected: _switchCodec,
          ),
          if (s.codec != VideoCodec.copy) ...[
            if (!s.hwAccel) ...[
              const SizedBox(height: 16),
              _DropdownField(
                label: l10n.preset,
                value: s.preset,
                hint: s.codec == VideoCodec.av1
                    ? l10n.presetHintAv1
                    : l10n.presetHintX264,
                items: [
                  for (final p in presetsFor(s.codec))
                    (p, '$p · ${_presetDesc(l10n, s.codec, p)}'),
                ],
                onChanged: (v) =>
                    controller.updateVideo((x) => x.preset = v),
              ),
            ],
            const SizedBox(height: 16),
            SectionLabel(l10n.hardwareAccel),
            SwitchRow(
              title: l10n.hardwareAccel,
              subtitle: _hwCandidatesFor(s.codec).isEmpty
                  ? l10n.hwEncoderHint
                  : l10n.hardwareAccelHint,
              value: s.hwAccel && _hwCandidatesFor(s.codec).isNotEmpty,
              onChanged: _hwCandidatesFor(s.codec).isEmpty
                  ? null
                  : (v) => controller.updateVideo((x) {
                      if (v) {
                        final cands = _hwCandidatesFor(x.codec);
                        x.hwAccel = true;
                        // 重新开启时同样默认选中列表第一个
                        x.hwEncoder = cands.first;
                        x.hwPreset = defaultHwPreset(cands.first);
                      } else {
                        x.hwAccel = false;
                        x.hwEncoder = '';
                        x.hwPreset = '';
                      }
                    }),
            ),
            if (s.hwAccel && _hwCandidatesFor(s.codec).isNotEmpty) ...[
              const SizedBox(height: 8),
              _DropdownField(
                label: l10n.hwEncoder,
                value: s.hwEncoder,
                hint: controller.hwEncoders.isEmpty ? l10n.hwEncoderHint : null,
                items: [
                  for (final e in _hwCandidatesFor(s.codec)) (e, e),
                ],
                onChanged: (v) => controller.updateVideo((x) {
                  x.hwEncoder = v;
                  x.hwPreset = defaultHwPreset(v);
                }),
              ),
              if (hwPresetsFor(s.hwEncoder).isNotEmpty) ...[
                const SizedBox(height: 8),
                _DropdownField(
                  label: l10n.hwPreset,
                  value: hwPresetsFor(s.hwEncoder).contains(s.hwPreset)
                      ? s.hwPreset
                      : defaultHwPreset(s.hwEncoder),
                  hint: _hwPresetHint(l10n, s.hwEncoder),
                  items: [
                    for (final p in hwPresetsFor(s.hwEncoder)) (p, p),
                  ],
                  onChanged: (v) =>
                      controller.updateVideo((x) => x.hwPreset = v),
                ),
              ],
            ],
            const SizedBox(height: 12),
            _DropdownField(
              label: l10n.resolution,
              value: s.resolution,
              items: [
                for (final (v, t) in resolutionOptions)
                  (v, t == 'keepOriginal' ? l10n.resolutionKeep : t),
              ],
              onChanged: (v) =>
                  controller.updateVideo((x) => x.resolution = v),
            ),
            HintText(l10n.resolutionHint),
            if (s.resolution == 'custom') ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: l10n.customWidth,
                        suffixText: 'px',
                      ),
                      onSubmitted: (v) => _setCustom(v, true),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('×'),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: l10n.customHeight,
                        suffixText: 'px',
                      ),
                      onSubmitted: (v) => _setCustom(v, false),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            SectionLabel(l10n.bitrateControl),
            SegmentedButton<VideoBitrateMode>(
              segments: [
                for (final m in VideoBitrateMode.values)
                  ButtonSegment(
                    value: m,
                    label: Text(_bitrateModeLabel(l10n, m)),
                  ),
              ],
              selected: {s.bitrateMode},
              onSelectionChanged: (v) =>
                  controller.updateVideo((x) => x.bitrateMode = v.first),
              showSelectedIcon: false,
            ),
            HintText(l10n.bitrateModeHint),
            const SizedBox(height: 12),
            if (s.bitrateMode == VideoBitrateMode.crf && s.codec.supportsCrf)
              _crfBlock(context, s)
            else
              _bitrateBlocks(context, s),
            const SizedBox(height: 12),
            _DropdownField(
              label: l10n.frameRate,
              value: s.framerate,
              items: [
                for (final (v, t) in fpsOptions)
                  (v, t == 'keepOriginal' ? l10n.resolutionKeep : t),
              ],
              onChanged: (v) => controller.updateVideo((x) => x.framerate = v),
            ),
            HintText(l10n.frameRateHint),
          ],
          const SizedBox(height: 12),
          SectionLabel(l10n.audioTrack),
          _DropdownField(
            label: l10n.audioTrack,
            value: s.audioTrack.name,
            items: [
              for (final t in VideoAudioTrack.values)
                (t.name, _trackLabel(l10n, t)),
            ],
            onChanged: (v) => controller.updateVideo(
              (x) => x.audioTrack =
              VideoAudioTrack.values.asNameMap()[v] ?? VideoAudioTrack.keep,
            ),
          ),
          HintText(l10n.audioTrackHint),
          if (s.audioTrack == VideoAudioTrack.aac ||
              s.audioTrack == VideoAudioTrack.mp3) ...[
            const SizedBox(height: 8),
            _DropdownField(
              label: l10n.audioBitrate,
              value: '${s.audioBitrate}',
              items: [
                for (final b in [96, 128, 192, 256, 320]) ('$b', '$b kbps'),
              ],
              onChanged: (v) => controller
                  .updateVideo((x) => x.audioBitrate = int.parse(v)),
            ),
          ],
          const SizedBox(height: 8),
          const Divider(height: 24),
          SwitchRow(
            title: l10n.compatMode,
            subtitle: l10n.compatModeHint,
            value: s.pixCompat,
            onChanged: (v) => controller.updateVideo((x) => x.pixCompat = v),
          ),
          SwitchRow(
            title: l10n.copyMetadata,
            value: s.copyMetadata,
            onChanged: (v) => controller.updateVideo((x) => x.copyMetadata = v),
          ),
        ],
      ),
    );
  }

  void _setCustom(String v, bool isWidth) {
    final n = int.tryParse(v);
    if (n == null || n <= 0) return;
    controller.updateVideo((x) {
      final parts = x.customResolution.toLowerCase().split('x');
      final w = isWidth ? '$n' : (parts.length == 2 ? parts[0] : '1920');
      final h = isWidth ? (parts.length == 2 ? parts[1] : '1080') : '$n';
      x.customResolution = '${int.parse(w)}x${int.parse(h)}';
    });
  }

  Widget _crfBlock(BuildContext context, VideoSettings s) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = l10nOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(l10n.crfQuality),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${s.crf}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: scheme.onPrimaryContainer),
              ),
            ),
          ],
        ),
        Slider(
          value: s.crf.clamp(0, s.codec.maxCrf).toDouble(),
          min: 0,
          max: s.codec.maxCrf.toDouble(),
          divisions: s.codec.maxCrf,
          label: '${s.crf}',
          onChanged: (v) => controller.updateVideo((x) => x.crf = v.round()),
        ),
        Text(
          l10n.crfHint(s.codec.label, s.codec.maxCrf),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _bitrateBlocks(BuildContext context, VideoSettings s) {
    final l10n = l10nOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _bitrateSlider(context, l10n.targetBitrate, s.bitrate, (v) =>
            controller.updateVideo((x) => x.bitrate = v)),
        if (s.bitrateMode == VideoBitrateMode.vbr) ...[
          const SizedBox(height: 4),
          _bitrateSlider(context, l10n.maxBitrate, s.maxBitrate, (v) =>
              controller.updateVideo((x) => x.maxBitrate = v)),
        ],
        Wrap(
          spacing: 8,
          children: [
            for (final p in bitratePresets)
              ActionChip(
                label: Text('$p'),
                onPressed: () => controller.updateVideo((x) => x.bitrate = p),
              ),
          ],
        ),
        HintText(l10n.bitrateVideoHint),
      ],
    );
  }

  Widget _bitrateSlider(
    BuildContext context,
    String label,
    int value,
    ValueChanged<int> onChanged,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(label),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$value kbps',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: scheme.onPrimaryContainer),
              ),
            ),
          ],
        ),
        Slider(
          value: value.clamp(500, 20000).toDouble(),
          min: 500,
          max: 20000,
          divisions: 39,
          label: '$value kbps',
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }

  static String _presetDesc(AppLocalizations l10n, VideoCodec codec, String p) {
    if (codec == VideoCodec.av1) {
      final n = int.tryParse(p) ?? 8;
      if (n <= 2) return l10n.presetAv1Slow;
      if (n <= 5) return l10n.presetAv1MedSlow;
      if (n <= 8) return l10n.presetAv1Balanced;
      if (n <= 11) return l10n.presetAv1Fast;
      return l10n.presetAv1Fastest;
    }
    switch (p) {
      case 'ultrafast':
        return l10n.presetUltrafast;
      case 'superfast':
        return l10n.presetSuperfast;
      case 'veryfast':
        return l10n.presetVeryfast;
      case 'faster':
        return l10n.presetFaster;
      case 'fast':
        return l10n.presetFast;
      case 'medium':
        return l10n.presetMedium;
      case 'slow':
        return l10n.presetSlow;
      case 'slower':
        return l10n.presetSlower;
      case 'veryslow':
        return l10n.presetVeryslow;
      default:
        return p;
    }
  }

  static String? _hwPresetHint(AppLocalizations l10n, String encoder) {
    if (encoder.contains('nvenc')) return l10n.hwPresetNvencHint;
    if (encoder.contains('qsv')) return l10n.hwPresetQsvHint;
    if (encoder.contains('amf')) return l10n.hwPresetAmfHint;
    return null;
  }

  static String _bitrateModeLabel(AppLocalizations l10n, VideoBitrateMode m) =>
      switch (m) {
        VideoBitrateMode.crf => l10n.crfQuality,
        VideoBitrateMode.cbr => l10n.modeCbr,
        VideoBitrateMode.vbr => l10n.modeVbr,
        VideoBitrateMode.abr => l10n.modeAbr,
      };

  static String _trackLabel(AppLocalizations l10n, VideoAudioTrack t) =>
      switch (t) {
        VideoAudioTrack.keep => l10n.trackKeep,
        VideoAudioTrack.aac => l10n.trackAac,
        VideoAudioTrack.mp3 => l10n.trackMp3,
        VideoAudioTrack.none => l10n.trackNone,
      };
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  final String label;
  final String value;
  final List<(String, String)> items;
  final ValueChanged<String> onChanged;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
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
        if (hint != null) ...[
          const SizedBox(height: 6),
          Text(
            hint!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ],
    );
  }
}
