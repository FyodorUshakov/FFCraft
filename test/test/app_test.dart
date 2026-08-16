import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ffmpeg_gui_flutter/app.dart';
import 'package:ffmpeg_gui_flutter/models/app_mode.dart';
import 'package:ffmpeg_gui_flutter/models/app_locale.dart';
import 'package:ffmpeg_gui_flutter/models/theme_settings.dart';
import 'package:ffmpeg_gui_flutter/state/app_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<AppController> pumpApp(WidgetTester tester) async {
    final controller = AppController();
    await tester.pumpWidget(FfmpegGuiApp(controller: controller));
    await tester.pump(const Duration(milliseconds: 100));
    return controller;
  }

  Future<void> openEngineDialog(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('主界面渲染正常', (tester) async {
    await pumpApp(tester);

    expect(find.text('FFCraft'), findsOneWidget);
    expect(find.text('音频转码'), findsOneWidget);
    expect(find.text('视频转码'), findsOneWidget);
    expect(find.text('合流封装'), findsOneWidget);
    expect(find.text('拼接'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('模式切换正常', (tester) async {
    final controller = await pumpApp(tester);

    await tester.tap(find.text('视频转码'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(controller.mode, AppMode.video);
    expect(find.text('视频编码'), findsOneWidget);

    await tester.tap(find.text('合流封装'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(controller.mode, AppMode.mux);
    expect(find.text('合流输入'), findsOneWidget);
    expect(find.text('封装容器'), findsOneWidget);
  });

  testWidgets('设置页面打开并含子菜单', (tester) async {
    await pumpApp(tester);
    await openEngineDialog(tester);

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
    expect(find.text('ffmpeg 设置'), findsOneWidget);
    expect(find.text('关于 FFCraft'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ffmpeg 设置子菜单：手动目录默认隐藏，点击后出现', (tester) async {
    await pumpApp(tester);
    await openEngineDialog(tester);
    await tester.tap(find.text('ffmpeg 设置'));
    await tester.pump(const Duration(milliseconds: 400));

    // 默认不显示输入框，只有“手动指定…”按钮
    expect(find.text('手动指定…'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.text('手动指定…'));
    await tester.pump();

    expect(find.byType(TextField), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('配色方案：顶栏按钮打开，点击预设生效', (tester) async {
    final controller = await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.palette_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('配色方案'), findsOneWidget);
    expect(find.text('跟随壁纸'), findsOneWidget);

    await tester.tap(find.byTooltip('天青'));
    await tester.pump(const Duration(milliseconds: 200));

    expect(controller.theme.source, ThemeSource.preset);
    expect(controller.theme.presetIndex, 2);
    expect(controller.themeSeed.value, ThemeSettings.presets[2]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('日志面板可复制', (tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => null,
    );
    final controller = await pumpApp(tester);
    controller.addLog('测试日志行 1');
    controller.addLog('测试日志行 2');
    await tester.pump();

    await tester.tap(find.byIcon(Icons.terminal_outlined));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('ffmpeg 日志'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.copy));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('日志已复制到剪贴板'), findsOneWidget);
    expect(tester.takeException(), isNull);
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    );
  });

  testWidgets('设置中可切换语言', (tester) async {
    final controller = await pumpApp(tester);
    await openEngineDialog(tester);

    await tester.tap(find.byType(DropdownButtonFormField<AppLocale>));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('English').last);
    await tester.pump(const Duration(milliseconds: 300));

    expect(controller.locale, AppLocale.en);
    expect(find.text('FFCraft'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
  });

}
