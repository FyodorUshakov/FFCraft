import 'package:flutter_test/flutter_test.dart';
import 'package:ffmpeg_gui_flutter/state/app_controller.dart';

void main() {
  group('文件尾附加数据识别', () {
    test('识别网易云 FLAC 水印尾巴的典型错误行', () {
      expect(
        isFlacFrameDecodeError('[flac @ 00000001] invalid sync code'),
        isTrue,
      );
      expect(
        isFlacFrameDecodeError('[flac @ 00000001] invalid frame header'),
        isTrue,
      );
      expect(
        isFlacFrameDecodeError('[flac @ 00000001] decode_frame() failed'),
        isTrue,
      );
      expect(
        isFlacFrameDecodeError(
          '[aist#0:0/flac @ 00000001] [dec:flac @ 00000002] '
          'Decoding error: Invalid data found when processing input',
        ),
        isTrue,
      );
    });

    test('普通日志行不会被误判为帧解析错误', () {
      expect(isFlacFrameDecodeError('size= 8626KiB time=00:04:05.01'), isFalse);
      expect(isFlacFrameDecodeError('[aac @ 00000001] Qavg: 1.2'), isFalse);
      expect(isFlacFrameDecodeError('press [q] to stop'), isFalse);
    });
  });
}
