import 'package:flutter/material.dart';

import 'l10n/l10n_helper.dart';
import 'screens/home_screen.dart';
import 'state/app_controller.dart';

/// 应用版本号（与 pubspec.yaml 保持一致）。
const String kAppVersion = '1.6.6';

class FfmpegGuiApp extends StatelessWidget {
  const FfmpegGuiApp({super.key, required this.controller});

  final AppController controller;

  ThemeData _buildTheme(Brightness brightness, Color seed) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
    return ThemeData(
      fontFamily: 'MiSans',
      colorScheme: scheme,
      // 程序底色保持最纯的白色，功能区加深一档灰，增强区分度
      scaffoldBackgroundColor: scheme.surfaceContainerLowest,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: controller.themeSeed,
      builder: (context, seed, _) => ValueListenableBuilder<Locale>(
        valueListenable: controller.localeNotifier,
        builder: (context, locale, _) => MaterialApp(
          onGenerateTitle: (context) => l10nOf(context).appTitle,
          debugShowCheckedModeBanner: false,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) {
            gL10n = AppLocalizations.of(context);
            return child!;
          },
          theme: _buildTheme(Brightness.light, seed),
          darkTheme: _buildTheme(Brightness.dark, seed),
          themeMode: ThemeMode.system,
          home: HomeScreen(controller: controller),
        ),
      ),
    );
  }
}
