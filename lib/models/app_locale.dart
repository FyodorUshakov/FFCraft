import 'package:flutter/material.dart';

/// 支持的语言。
enum AppLocale { zhHans, zhHant, en, ru, ja, ko }

extension AppLocaleX on AppLocale {
  String get label => switch (this) {
        AppLocale.zhHans => '简体中文',
        AppLocale.zhHant => '繁體中文',
        AppLocale.en => 'English',
        AppLocale.ru => 'Русский',
        AppLocale.ja => '日本語',
        AppLocale.ko => '한국어',
      };

  Locale get locale => switch (this) {
        AppLocale.zhHans => const Locale('zh', 'CN'),
        AppLocale.zhHant => const Locale('zh', 'TW'),
        AppLocale.en => const Locale('en'),
        AppLocale.ru => const Locale('ru'),
        AppLocale.ja => const Locale('ja'),
        AppLocale.ko => const Locale('ko'),
      };
}
