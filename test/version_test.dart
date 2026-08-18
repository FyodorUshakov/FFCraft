import 'dart:io';

import 'package:ffmpeg_gui_flutter/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('kAppVersion 与 pubspec 版本号一致', () {
    final pubspec = File('pubspec.yaml').readAsLinesSync();
    final versionLine = pubspec.firstWhere(
      (line) => line.trimLeft().startsWith('version:'),
    );
    final pubspecVersion = versionLine.split(':')[1].trim();
    expect(
      kAppVersion,
      pubspecVersion,
      reason: '升级版本时请同步更新 lib/app.dart 中的 kAppVersion',
    );
  });
}
