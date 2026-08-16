import 'package:flutter_test/flutter_test.dart';
import 'package:ffmpeg_gui_flutter/models/log_style.dart';

void main() {
  test('错误行标红', () {
    expect(classifyLogLine('[flac @ 0x1] invalid sync code'), LogKind.error);
    expect(classifyLogLine('Decoding error: Invalid data found'), LogKind.error);
    expect(classifyLogLine('⚠ 测试文件 转换失败 (exit=1)'), LogKind.error);
    expect(classifyLogLine('Conversion failed!'), LogKind.error);
  });

  test('警告行标橙黄', () {
    expect(classifyLogLine('Warning: something odd'), LogKind.warning);
    expect(classifyLogLine('   ⚠ 未生成输出文件'), LogKind.warning);
  });

  test('进度指标行淡蓝', () {
    expect(
      classifyLogLine('size=14954KiB time=00:02:00.01 bitrate=1020.7kbits/s'),
      LogKind.progress,
    );
    expect(classifyLogLine('out_time_us=123456789'), LogKind.progress);
    expect(classifyLogLine('progress=end'), LogKind.progress);
  });

  test('普通行与摘要不误判', () {
    expect(classifyLogLine('[17:12:12] 已添加 1 个文件'), LogKind.normal);
    expect(classifyLogLine('全部完成：成功 1 个，失败 0 个'), LogKind.normal);
    expect(classifyLogLine('Stream #0:0: Audio: flac, 44100 Hz, stereo'),
        LogKind.normal);
  });
}
