import 'app_localizations.dart';
import 'package:flutter/widgets.dart';

export 'app_localizations.dart';
import '../models/app_mode.dart';

/// 由 MaterialApp.builder 注入的当前本地化实例，
/// 供无 BuildContext 的控制器生成日志等文案使用。
AppLocalizations? gL10n;

/// 当前 BuildContext 下的本地化实例（生成类返回可空，这里统一非空化）。
AppLocalizations l10nOf(BuildContext context) =>
    Localizations.of<AppLocalizations>(context, AppLocalizations)!;

/// 取当前语言文案；本地化未就绪时回退到简体中文。
String l10n(String Function(AppLocalizations) pick, String fallback) =>
    gL10n == null ? fallback : pick(gL10n!);

/// 当前语言下的模式名称（供无上下文场景使用）。
String modeLabel(AppMode mode) => switch (mode) {
      AppMode.audio => gL10n?.modeAudio ?? '音频转码',
      AppMode.video => gL10n?.modeVideo ?? '视频转码',
      AppMode.mux => gL10n?.modeMux ?? '合流封装',
      AppMode.concat => gL10n?.modeConcat ?? '拼接',
    };
