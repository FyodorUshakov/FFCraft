// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'FFCraft · 轻量影音工具箱 | Built with Flutter';

  @override
  String get appName => 'FFCraft';

  @override
  String get appSubtitle => '轻量影音工具箱 | Built with Flutter';

  @override
  String get modeAudio => '音频转码';

  @override
  String get modeVideo => '视频转码';

  @override
  String get modeMux => '合流封装';

  @override
  String get modeConcat => '拼接';

  @override
  String get hintAudio =>
      '把音频文件转换成 AAC / MP3 / FLAC / ALAC / WAV / Opus / OGG 等格式';

  @override
  String get hintVideo => '转换视频编码、分辨率、码率，可保留或重编码音轨';

  @override
  String get hintMux => '把视频与音频轨道原样合并进新的容器（不重编码，纯合流）';

  @override
  String get hintConcat => '把多段同编码的音视频无缝拼接为一个文件';

  @override
  String settingsTitle(String mode) {
    return '参数设置 · $mode';
  }

  @override
  String get engineReady => 'ffmpeg 就绪';

  @override
  String get engineMissing => 'ffmpeg 未找到';

  @override
  String get tooltipTheme => '配色方案';

  @override
  String get tooltipEngine => '设置';

  @override
  String get queueTitle => '文件队列';

  @override
  String itemCount(int n) {
    return '$n 个';
  }

  @override
  String get addFiles => '添加文件';

  @override
  String get addFolder => '添加文件夹';

  @override
  String get clearQueue => '清空队列';

  @override
  String get dragFiles => '拖拽文件到此处';

  @override
  String get dragHintAudio => '拖拽音频文件到此处\n或点击右上角「添加文件 / 添加文件夹」';

  @override
  String get dragHintVideo => '拖拽视频文件到此处\n或点击右上角「添加文件 / 添加文件夹」';

  @override
  String get dragHintConcat => '拖拽多个音视频文件到此处\n（各段编码与参数需一致，拼接更顺畅）';

  @override
  String get dropMore => '拖拽更多文件或文件夹到此处';

  @override
  String get remove => '移除';

  @override
  String get statusQueued => '等待中';

  @override
  String get statusRunning => '处理中';

  @override
  String get statusDone => '已完成';

  @override
  String get statusFailed => '失败';

  @override
  String get statusCancelled => '已取消';

  @override
  String get processing => '处理中…';

  @override
  String get starting => '启动中…';

  @override
  String doneTo(String path) {
    return '完成 → $path';
  }

  @override
  String failedExit(int code) {
    return '失败 (exit=$code)';
  }

  @override
  String get outputDir => '输出目录';

  @override
  String get sameAsSource => '与源文件相同';

  @override
  String get customDir => '指定目录';

  @override
  String get browse => '浏览…';

  @override
  String get clearOutDir => '清除输出目录';

  @override
  String get parallelTasks => '并行任务';

  @override
  String get singleTaskNote => '（合流/拼接为单任务）';

  @override
  String get startAudio => '开始转码';

  @override
  String get startVideo => '开始转码';

  @override
  String get startMux => '开始合流';

  @override
  String get startConcat => '开始拼接';

  @override
  String get needVideoFile => '请选择视频文件';

  @override
  String get needAudioFile => '请添加音频文件';

  @override
  String get needVideoFiles => '请添加视频文件';

  @override
  String get needTwoFiles => '至少添加 2 个文件';

  @override
  String get stop => '停止';

  @override
  String get tooltipLogShow => '查看日志';

  @override
  String get tooltipLogHide => '收起日志';

  @override
  String get outputCodec => '输出编码';

  @override
  String get sampleRate => '采样率';

  @override
  String get sampleRateKeep => '保持原样';

  @override
  String get sampleRateHint => '保持原样最稳妥；只有需要统一采样率时才更改';

  @override
  String get copyMetadata => '复制元数据';

  @override
  String get copyMetadataHint => '标题、艺术家、封面等标签随文件一起保留';

  @override
  String get losslessParams => '无损参数';

  @override
  String get bitDepth => '位深';

  @override
  String get bitDepthHint => '位深越高动态范围越大、文件也越大；16bit≈CD 音质，24bit 是录音/母带常用';

  @override
  String get flacCompression => 'FLAC 压缩等级';

  @override
  String get flacCompressionHint => '等级越高压缩率越高但越慢；0 最快，8 最小（默认 5）';

  @override
  String get bitrateControl => '码率控制';

  @override
  String get bitrateModeHint =>
      '固定码率(CBR)：体积稳定；可变码率(VBR)：同码率下质量更好；平均码率(ABR)：两者折中';

  @override
  String get modeCbr => '固定码率';

  @override
  String get modeVbr => '可变码率';

  @override
  String get modeAbr => '平均码率';

  @override
  String get bitrate => '码率';

  @override
  String get bitrateHint => '码率越高音质越好、文件越大；对大多数音乐 128–256 kbps 已足够';

  @override
  String get opusVbrHint => 'Opus 默认采用可变码率；选择「固定码率」可关闭 VBR';

  @override
  String get qualityRangeMp3 => '0-9（0 最高）';

  @override
  String get qualityRangeVorbis => '0-10（越高越好）';

  @override
  String get vbrQuality => 'VBR 质量';

  @override
  String qualityRangeHint(String range) {
    return '数值越低质量越高、文件越大；数值越高文件越小（范围 $range）';
  }

  @override
  String get coverNotSupportedHint => 'OGG/Opus/WAV 容器不支持内嵌封面，转换时封面将被忽略';

  @override
  String get decodeTailInfo => '输出完整可正常播放；源文件尾部附加数据（常见于网易云下载的 FLAC）已忽略';

  @override
  String get videoCodec => '视频编码';

  @override
  String get hardwareAccel => '硬件加速';

  @override
  String get hardwareAccelHint => '使用显卡/核显编码，速度更快；是否可用取决于设备与 ffmpeg 编译';

  @override
  String get hwEncoder => '硬件编码器';

  @override
  String get hwEncoderHint => '未检测到可用的硬件编码器，请检查显卡驱动或 ffmpeg 是否包含相应模块';

  @override
  String get hwPreset => '硬件档位';

  @override
  String get hwPresetNvencHint => 'NVENC：p1 最快，p7 质量最佳（默认 p4）';

  @override
  String get hwPresetQsvHint => 'QSV：veryfast 最快，veryslow 质量最佳（默认 medium）';

  @override
  String get hwPresetAmfHint => 'AMF：speed 最快，high_quality 质量最佳（默认 balanced）';

  @override
  String get codecCopy => '原样复制';

  @override
  String get preset => '编码预设';

  @override
  String get presetUltrafast => '极速 · 文件最大';

  @override
  String get presetSuperfast => '超快 · 文件很大';

  @override
  String get presetVeryfast => '很快 · 文件较大';

  @override
  String get presetFaster => '较快';

  @override
  String get presetFast => '快';

  @override
  String get presetMedium => '平衡（默认）';

  @override
  String get presetSlow => '慢 · 压缩更好';

  @override
  String get presetSlower => '较慢 · 文件更小';

  @override
  String get presetVeryslow => '最慢 · 文件最小';

  @override
  String get presetAv1Slow => '极慢 · 压缩率最高';

  @override
  String get presetAv1MedSlow => '较慢 · 高压缩';

  @override
  String get presetAv1Balanced => '平衡（默认）';

  @override
  String get presetAv1Fast => '较快 · 文件更大';

  @override
  String get presetAv1Fastest => '最快 · 质量损失较多';

  @override
  String get presetHintX264 =>
      '预设只影响编码速度与文件大小，不影响画质：越快 → 文件越大，越慢 → 压缩率越高。medium 为默认平衡点。';

  @override
  String get presetHintAv1 =>
      'preset 数值越低编码越慢、压缩率越高（文件越小）；越高越快但文件更大。默认 8 为平衡点。';

  @override
  String get resolution => '分辨率';

  @override
  String get resolutionKeep => '保持原样';

  @override
  String get customEllipsis => '自定义…';

  @override
  String get resolutionHint => '按宽度等比缩放、高度自适应，不会拉伸变形';

  @override
  String get customWidth => '宽';

  @override
  String get customHeight => '高';

  @override
  String get crfQuality => 'CRF 质量';

  @override
  String crfHint(String codec, int max) {
    return '数值越小画质越高、文件越大；$codec 范围 0-$max（默认 23；超过 28 画质开始明显下降）';
  }

  @override
  String get targetBitrate => '目标码率';

  @override
  String get maxBitrate => '最大码率';

  @override
  String get bitrateVideoHint => '码率越高画质越好、文件越大；1080p 建议 4000–12000 kbps';

  @override
  String get frameRate => '帧率';

  @override
  String get frameRateHint => '通常保持原样；更改会丢帧/补帧，可能影响流畅度';

  @override
  String get audioTrack => '音频轨道';

  @override
  String get audioTrackHint => '保持不变 = 原样复制音轨（最快无损）；AAC/MP3 会重新编码';

  @override
  String get trackKeep => '保持不变';

  @override
  String get trackAac => '转码为 AAC';

  @override
  String get trackMp3 => '转码为 MP3';

  @override
  String get trackNone => '移除音轨';

  @override
  String get audioBitrate => '音频码率';

  @override
  String get compatMode => '兼容模式 (yuv420p)';

  @override
  String get compatModeHint => '使用广泛兼容的像素格式，适合播放器与剪辑软件';

  @override
  String get muxInput => '合流输入';

  @override
  String get muxNoReencode => '纯封装 · 不重编码';

  @override
  String get videoFile => '视频文件';

  @override
  String get videoFileHint => '视频轨道来源（必选）';

  @override
  String get audioFiles => '音频文件';

  @override
  String get audioFilesHint => '音频轨道来源，可添加多条（可选，缺省时仅更换容器）';

  @override
  String get container => '封装容器';

  @override
  String get muxInfo =>
      '合流使用 -c copy 原样复制全部轨道，速度极快且不损失任何质量。注意目标容器需支持源轨道编码（如 MP4 通常装 H.264/H.265 + AAC）。';

  @override
  String get select => '选择';

  @override
  String get clear => '清空';

  @override
  String get outputContainer => '输出容器';

  @override
  String get autoContainer => '自动（同输入）';

  @override
  String get compatReencode => '兼容模式（重新编码）';

  @override
  String get compatReencodeHint => '各段编码或参数不一致时，重新编码为 H.265 + AAC 后再拼接';

  @override
  String get concatInfoCopy =>
      '复制模式（默认）直接拼接，不重编码、速度快、质量无损；要求各片段的编码、采样率、帧率等参数完全一致。';

  @override
  String get concatInfoReencode =>
      '兼容模式会重新编码全部片段（H.265 + AAC 256k，统一为最高分辨率），保证能拼在一起，但会损失质量且耗时较长。';

  @override
  String get logTitle => 'ffmpeg 日志';

  @override
  String get copyLog => '复制日志';

  @override
  String get logCopied => '日志已复制到剪贴板';

  @override
  String get noLog => '暂无日志';

  @override
  String get settings => '设置';

  @override
  String get engineSettings => 'ffmpeg 设置';

  @override
  String get aboutTitle => '关于 FFCraft';

  @override
  String get versionLabel => '版本';

  @override
  String get currentStatus => '当前状态';

  @override
  String get engineAvailable => 'ffmpeg 可用';

  @override
  String get engineUnavailable => 'ffmpeg 不可用';

  @override
  String get detecting => '正在检测 ffmpeg…';

  @override
  String get manualDirLabel => '手动指定目录（留空 = 自动查找）';

  @override
  String get manualDirHint => '例如 /usr/bin 或 E:\\ffmpeg\\bin';

  @override
  String get manualSpecify => '手动指定…';

  @override
  String get clearManual => '清除手动指定';

  @override
  String get autoFindOrder =>
      '自动查找顺序：手动指定 → 程序旁的 ffmpeg 文件夹\n→ 系统 PATH → 常见安装位置（如 /usr/bin、/opt/ffmpeg、C:\\ffmpeg 等）';

  @override
  String get restoreAuto => '恢复自动';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String versionLine(String version) {
    return 'FFCraft · v$version';
  }

  @override
  String get copyrightLine => '版权所有 © 2026 万能的乌沙科夫（@FyodorUshakov）';

  @override
  String get githubLine =>
      'GitHub：万能的乌沙科夫（@FyodorUshakov）\nhttps://github.com/FyodorUshakov';

  @override
  String get licenseTitle => '开源许可';

  @override
  String get licenseText =>
      '本项目以 MIT 协议开源，允许自由使用、修改与分发。\nffmpeg 为外部调用程序，遵循其自身的开源许可（如 GPL/LGPL），不在本项目 MIT 许可范围内。';

  @override
  String get thirdPartyTitle => '第三方组件';

  @override
  String get thirdPartyText => 'ffmpeg（https://ffmpeg.org）——音视频处理引擎，由外部调用。';

  @override
  String get language => '语言';

  @override
  String manualDirValue(String dir) {
    return '手动指定：$dir';
  }

  @override
  String autoDirValue(String dir) {
    return '自动检测：$dir';
  }

  @override
  String get themeSettings => '配色方案';

  @override
  String get presetPalette => '预设色板';

  @override
  String get followWallpaper => '跟随壁纸';

  @override
  String get fromWallpaper => '从壁纸取色';

  @override
  String get extracting => '取色中…';

  @override
  String get wallpaperHint => '读取当前壁纸主色调作为主题色；失败时回退系统强调色';

  @override
  String get wallpaperOnlyWindows => '仅 Windows 支持从壁纸取色';

  @override
  String get customColor => '自定义颜色';

  @override
  String get customColorHint => '拖动色环或输入 Hex，选择后立即生效';

  @override
  String get restoreDefault => '恢复默认';

  @override
  String get close => '关闭';

  @override
  String get wallpaperColorLabel => '壁纸取色';

  @override
  String get wallpaperFailed => '未能从壁纸取色，已保留当前配色';

  @override
  String get currentTheme => '当前主题';

  @override
  String get sourcePreset => '预设';

  @override
  String get sourceCustom => '自定义';

  @override
  String get sourceWallpaper => '跟随壁纸';

  @override
  String get colorDefault => '默认 · 淡蓝';

  @override
  String get colorBlue => '蓝';

  @override
  String get colorCyan => '天青';

  @override
  String get colorTeal => '青绿';

  @override
  String get colorGreen => '翠绿';

  @override
  String get colorLime => '黄绿';

  @override
  String get colorAmber => '琥珀';

  @override
  String get colorOrange => '橙';

  @override
  String get colorCoral => '珊瑚';

  @override
  String get colorPink => '粉';

  @override
  String get colorPurple => '紫';

  @override
  String get colorViolet => '紫罗兰';

  @override
  String get colorIndigo => '靛蓝';

  @override
  String get colorBlueGrey => '蓝灰';

  @override
  String addedFiles(int n) {
    return '已添加 $n 个文件';
  }

  @override
  String readDirFailed(String err) {
    return '读取目录失败: $err';
  }

  @override
  String switchedMode(String mode) {
    return '切换到「$mode」';
  }

  @override
  String startBatch(int n, String dir) {
    return '━━ 开始处理 ━━ 共 $n 个任务，ffmpeg：$dir';
  }

  @override
  String doneAll(int ok, int fail) {
    return '全部完成：成功 $ok 个，失败 $fail 个';
  }

  @override
  String stoppedDone(int n) {
    return '已停止，共完成 $n 个';
  }

  @override
  String get cancelled => '已取消';

  @override
  String get stopping => '正在停止…';

  @override
  String get decodeWarning => '⚠ 输出中存在解码错误/警告，请检查源文件是否完整';

  @override
  String get doneWithWarning => '完成（有解码警告）';

  @override
  String noOutput(String path) {
    return '未生成输出文件：$path';
  }

  @override
  String engineDirMissing(String dir) {
    return '指定目录中未找到 ffmpeg：$dir';
  }

  @override
  String get engineNotFound => '未找到 ffmpeg，请在设置中手动指定 ffmpeg 所在目录';

  @override
  String launchFailed(String err) {
    return '启动失败: $err';
  }

  @override
  String compatResolution(int w, int h) {
    return '兼容模式：统一输出 ${w}x$h（H.265 + AAC 256k）';
  }
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'FFCraft · 輕量影音工具箱 | Built with Flutter';

  @override
  String get appName => 'FFCraft';

  @override
  String get appSubtitle => '輕量影音工具箱 | Built with Flutter';

  @override
  String get modeAudio => '音訊轉檔';

  @override
  String get modeVideo => '影片轉檔';

  @override
  String get modeMux => '合併封裝';

  @override
  String get modeConcat => '串接';

  @override
  String get hintAudio =>
      '把音訊檔轉換成 AAC / MP3 / FLAC / ALAC / WAV / Opus / OGG 等格式';

  @override
  String get hintVideo => '轉換影片編碼、解析度、位元率，可保留或重新編碼音軌';

  @override
  String get hintMux => '把影片與音軌原樣合併進新容器（不重新編碼，純合併）';

  @override
  String get hintConcat => '把多段相同編碼的影音無縫串接成一個檔案';

  @override
  String settingsTitle(String mode) {
    return '參數設定 · $mode';
  }

  @override
  String get engineReady => 'ffmpeg 就緒';

  @override
  String get engineMissing => '找不到 ffmpeg';

  @override
  String get tooltipTheme => '配色方案';

  @override
  String get tooltipEngine => '設定';

  @override
  String get queueTitle => '檔案佇列';

  @override
  String itemCount(int n) {
    return '$n 個';
  }

  @override
  String get addFiles => '新增檔案';

  @override
  String get addFolder => '新增資料夾';

  @override
  String get clearQueue => '清除佇列';

  @override
  String get dragFiles => '拖曳檔案到這裡';

  @override
  String get dragHintAudio => '拖曳音訊檔到這裡\n或按右上角「新增檔案 / 新增資料夾」';

  @override
  String get dragHintVideo => '拖曳影片檔到這裡\n或按右上角「新增檔案 / 新增資料夾」';

  @override
  String get dragHintConcat => '拖曳多個影音檔到這裡\n（各段編碼與參數需一致，串接更順暢）';

  @override
  String get dropMore => '拖曳更多檔案或資料夾到這裡';

  @override
  String get remove => '移除';

  @override
  String get statusQueued => '等待中';

  @override
  String get statusRunning => '處理中';

  @override
  String get statusDone => '已完成';

  @override
  String get statusFailed => '失敗';

  @override
  String get statusCancelled => '已取消';

  @override
  String get processing => '處理中…';

  @override
  String get starting => '啟動中…';

  @override
  String doneTo(String path) {
    return '完成 → $path';
  }

  @override
  String failedExit(int code) {
    return '失敗 (exit=$code)';
  }

  @override
  String get outputDir => '輸出資料夾';

  @override
  String get sameAsSource => '與來源相同';

  @override
  String get customDir => '指定資料夾';

  @override
  String get browse => '瀏覽…';

  @override
  String get clearOutDir => '清除輸出資料夾';

  @override
  String get parallelTasks => '並行任務';

  @override
  String get singleTaskNote => '（合併/串接為單一任務）';

  @override
  String get startAudio => '開始轉檔';

  @override
  String get startVideo => '開始轉檔';

  @override
  String get startMux => '開始合併';

  @override
  String get startConcat => '開始串接';

  @override
  String get needVideoFile => '請選擇影片檔';

  @override
  String get needAudioFile => '請新增音訊檔';

  @override
  String get needVideoFiles => '請新增影片檔';

  @override
  String get needTwoFiles => '至少新增 2 個檔案';

  @override
  String get stop => '停止';

  @override
  String get tooltipLogShow => '檢視日誌';

  @override
  String get tooltipLogHide => '收起日誌';

  @override
  String get outputCodec => '輸出編碼';

  @override
  String get sampleRate => '取樣率';

  @override
  String get sampleRateKeep => '保持原樣';

  @override
  String get sampleRateHint => '保持原樣最穩妥；只有需要統一取樣率時才更改';

  @override
  String get copyMetadata => '複製中繼資料';

  @override
  String get copyMetadataHint => '標題、演出者、封面等標籤隨檔案一起保留';

  @override
  String get losslessParams => '無損參數';

  @override
  String get bitDepth => '位元深度';

  @override
  String get bitDepthHint => '位元深度越高動態範圍越大、檔案也越大；16bit≈CD 音質，24bit 是錄音/母帶常用';

  @override
  String get flacCompression => 'FLAC 壓縮等級';

  @override
  String get flacCompressionHint => '等級越高壓縮率越高但越慢；0 最快，8 最小（預設 5）';

  @override
  String get bitrateControl => '位元率控制';

  @override
  String get bitrateModeHint =>
      '固定位元率(CBR)：體積穩定；可變位元率(VBR)：同碼率下品質更好；平均位元率(ABR)：兩者折衷';

  @override
  String get modeCbr => '固定位元率';

  @override
  String get modeVbr => '可變位元率';

  @override
  String get modeAbr => '平均位元率';

  @override
  String get bitrate => '位元率';

  @override
  String get bitrateHint => '位元率越高音質越好、檔案越大；對大多數音樂 128–256 kbps 已足夠';

  @override
  String get opusVbrHint => 'Opus 預設採用可變位元率；選擇「固定位元率」可關閉 VBR';

  @override
  String get qualityRangeMp3 => '0-9（0 最高）';

  @override
  String get qualityRangeVorbis => '0-10（越高越好）';

  @override
  String get vbrQuality => 'VBR 品質';

  @override
  String qualityRangeHint(String range) {
    return '數值越低品質越高、檔案越大；數值越高檔案越小（範圍 $range）';
  }

  @override
  String get coverNotSupportedHint => 'OGG/Opus/WAV 容器不支援內嵌封面，轉換時封面將被忽略';

  @override
  String get decodeTailInfo => '輸出完整可正常播放；來源檔案尾部附加資料（常見於網易雲下載的 FLAC）已忽略';

  @override
  String get videoCodec => '影片編碼';

  @override
  String get hardwareAccel => '硬體加速';

  @override
  String get hardwareAccelHint => '使用顯示卡/內顯編碼，速度更快；是否可用取決於裝置與 ffmpeg 編譯';

  @override
  String get hwEncoder => '硬體編碼器';

  @override
  String get hwEncoderHint => '未偵測到可用的硬體編碼器，請檢查顯示卡驅動或 ffmpeg 是否包含相應模組';

  @override
  String get hwPreset => '硬體檔位';

  @override
  String get hwPresetNvencHint => 'NVENC：p1 最快，p7 品質最佳（預設 p4）';

  @override
  String get hwPresetQsvHint => 'QSV：veryfast 最快，veryslow 品質最佳（預設 medium）';

  @override
  String get hwPresetAmfHint => 'AMF：speed 最快，high_quality 品質最佳（預設 balanced）';

  @override
  String get codecCopy => '原樣複製';

  @override
  String get preset => '編碼預設';

  @override
  String get presetUltrafast => '極速 · 檔案最大';

  @override
  String get presetSuperfast => '超快 · 檔案很大';

  @override
  String get presetVeryfast => '很快 · 檔案較大';

  @override
  String get presetFaster => '較快';

  @override
  String get presetFast => '快';

  @override
  String get presetMedium => '平衡（預設）';

  @override
  String get presetSlow => '慢 · 壓縮更好';

  @override
  String get presetSlower => '較慢 · 檔案更小';

  @override
  String get presetVeryslow => '最慢 · 檔案最小';

  @override
  String get presetAv1Slow => '極慢 · 壓縮率最高';

  @override
  String get presetAv1MedSlow => '較慢 · 高壓縮';

  @override
  String get presetAv1Balanced => '平衡（預設）';

  @override
  String get presetAv1Fast => '較快 · 檔案更大';

  @override
  String get presetAv1Fastest => '最快 · 品質損失較多';

  @override
  String get presetHintX264 =>
      '預設只影響編碼速度與檔案大小，不影響畫質：越快 → 檔案越大，越慢 → 壓縮率越高。medium 為預設平衡點。';

  @override
  String get presetHintAv1 =>
      'preset 數值越低編碼越慢、壓縮率越高（檔案越小）；越高越快但檔案更大。預設 8 為平衡點。';

  @override
  String get resolution => '解析度';

  @override
  String get resolutionKeep => '保持原樣';

  @override
  String get customEllipsis => '自訂…';

  @override
  String get resolutionHint => '按寬度等比縮放、高度自動適應，不會拉伸變形';

  @override
  String get customWidth => '寬';

  @override
  String get customHeight => '高';

  @override
  String get crfQuality => 'CRF 品質';

  @override
  String crfHint(String codec, int max) {
    return '數值越小畫質越高、檔案越大；$codec 範圍 0-$max（預設 23；超過 28 畫質開始明顯下降）';
  }

  @override
  String get targetBitrate => '目標位元率';

  @override
  String get maxBitrate => '最大位元率';

  @override
  String get bitrateVideoHint => '位元率越高畫質越好、檔案越大；1080p 建議 4000–12000 kbps';

  @override
  String get frameRate => '影格率';

  @override
  String get frameRateHint => '通常保持原樣；更改會丟格/補格，可能影響流暢度';

  @override
  String get audioTrack => '音軌';

  @override
  String get audioTrackHint => '保持不變 = 原樣複製音軌（最快無損）；AAC/MP3 會重新編碼';

  @override
  String get trackKeep => '保持不變';

  @override
  String get trackAac => '轉碼為 AAC';

  @override
  String get trackMp3 => '轉碼為 MP3';

  @override
  String get trackNone => '移除音軌';

  @override
  String get audioBitrate => '音訊位元率';

  @override
  String get compatMode => '相容模式 (yuv420p)';

  @override
  String get compatModeHint => '使用廣泛相容的像素格式，適合播放器與剪輯軟體';

  @override
  String get muxInput => '合併輸入';

  @override
  String get muxNoReencode => '純封裝 · 不重新編碼';

  @override
  String get videoFile => '影片檔';

  @override
  String get videoFileHint => '影片軌來源（必選）';

  @override
  String get audioFiles => '音訊檔';

  @override
  String get audioFilesHint => '音軌來源，可新增多條（選填，缺省時僅更換容器）';

  @override
  String get container => '封裝容器';

  @override
  String get muxInfo =>
      '合併使用 -c copy 原樣複製全部軌道，速度極快且不損失任何品質。注意目標容器需支援來源軌編碼（如 MP4 通常裝 H.264/H.265 + AAC）。';

  @override
  String get select => '選擇';

  @override
  String get clear => '清空';

  @override
  String get outputContainer => '輸出容器';

  @override
  String get autoContainer => '自動（同輸入）';

  @override
  String get compatReencode => '相容模式（重新編碼）';

  @override
  String get compatReencodeHint => '各段編碼或參數不一致時，重新編碼為 H.265 + AAC 後再串接';

  @override
  String get concatInfoCopy =>
      '複製模式（預設）直接串接，不重新編碼、速度快、品質無損；要求各段編碼、取樣率、影格率等參數完全一致。';

  @override
  String get concatInfoReencode =>
      '相容模式會重新編碼全部片段（H.265 + AAC 256k，統一為最高解析度），保證能拼在一起，但會損失品質且耗時較長。';

  @override
  String get logTitle => 'ffmpeg 日誌';

  @override
  String get copyLog => '複製日誌';

  @override
  String get logCopied => '日誌已複製到剪貼簿';

  @override
  String get noLog => '暫無日誌';

  @override
  String get settings => '設定';

  @override
  String get engineSettings => 'ffmpeg 設定';

  @override
  String get aboutTitle => '關於 FFCraft';

  @override
  String get versionLabel => '版本';

  @override
  String get currentStatus => '目前狀態';

  @override
  String get engineAvailable => 'ffmpeg 可用';

  @override
  String get engineUnavailable => 'ffmpeg 不可用';

  @override
  String get detecting => '正在偵測 ffmpeg…';

  @override
  String get manualDirLabel => '手動指定資料夾（留空 = 自動搜尋）';

  @override
  String get manualDirHint => '例如 /usr/bin 或 E:\\ffmpeg\\bin';

  @override
  String get manualSpecify => '手動指定…';

  @override
  String get clearManual => '清除手動指定';

  @override
  String get autoFindOrder =>
      '自動搜尋順序：手動指定 → 程式旁的 ffmpeg 資料夾\n→ 系統 PATH → 常見安裝位置（如 /usr/bin、/opt/ffmpeg、C:\\ffmpeg 等）';

  @override
  String get restoreAuto => '還原自動';

  @override
  String get cancel => '取消';

  @override
  String get save => '儲存';

  @override
  String versionLine(String version) {
    return 'FFCraft · v$version';
  }

  @override
  String get copyrightLine => '版權所有 © 2026 萬能的烏沙科夫（@FyodorUshakov）';

  @override
  String get githubLine =>
      'GitHub：萬能的烏沙科夫（@FyodorUshakov）\nhttps://github.com/FyodorUshakov';

  @override
  String get licenseTitle => '開源授權';

  @override
  String get licenseText =>
      '本專案以 MIT 授權開源，允許自由使用、修改與散佈。\nffmpeg 為外部呼叫程式，遵循其自身的開源授權（如 GPL/LGPL），不在本專案 MIT 授權範圍內。';

  @override
  String get thirdPartyTitle => '第三方元件';

  @override
  String get thirdPartyText => 'ffmpeg（https://ffmpeg.org）——影音處理引擎，由外部呼叫。';

  @override
  String get language => '語言';

  @override
  String manualDirValue(String dir) {
    return '手動指定：$dir';
  }

  @override
  String autoDirValue(String dir) {
    return '自動偵測：$dir';
  }

  @override
  String get themeSettings => '配色方案';

  @override
  String get presetPalette => '預設色板';

  @override
  String get followWallpaper => '跟隨桌布';

  @override
  String get fromWallpaper => '從桌布取色';

  @override
  String get extracting => '取色中…';

  @override
  String get wallpaperHint => '讀取目前桌布主色調作為主題色；失敗時回退系統強調色';

  @override
  String get wallpaperOnlyWindows => '僅 Windows 支援從桌布取色';

  @override
  String get customColor => '自訂顏色';

  @override
  String get customColorHint => '拖動色環或輸入 Hex，選擇後立即生效';

  @override
  String get restoreDefault => '還原預設';

  @override
  String get close => '關閉';

  @override
  String get wallpaperColorLabel => '桌布取色';

  @override
  String get wallpaperFailed => '無法從桌布取色，已保留目前配色';

  @override
  String get currentTheme => '目前主題';

  @override
  String get sourcePreset => '預設';

  @override
  String get sourceCustom => '自訂';

  @override
  String get sourceWallpaper => '跟隨桌布';

  @override
  String get colorDefault => '預設 · 淡藍';

  @override
  String get colorBlue => '藍';

  @override
  String get colorCyan => '天青';

  @override
  String get colorTeal => '青綠';

  @override
  String get colorGreen => '翠綠';

  @override
  String get colorLime => '黃綠';

  @override
  String get colorAmber => '琥珀';

  @override
  String get colorOrange => '橙';

  @override
  String get colorCoral => '珊瑚';

  @override
  String get colorPink => '粉';

  @override
  String get colorPurple => '紫';

  @override
  String get colorViolet => '紫羅蘭';

  @override
  String get colorIndigo => '靛藍';

  @override
  String get colorBlueGrey => '藍灰';

  @override
  String addedFiles(int n) {
    return '已新增 $n 個檔案';
  }

  @override
  String readDirFailed(String err) {
    return '讀取資料夾失敗: $err';
  }

  @override
  String switchedMode(String mode) {
    return '已切換到「$mode」';
  }

  @override
  String startBatch(int n, String dir) {
    return '━━ 開始處理 ━━ 共 $n 個任務，ffmpeg：$dir';
  }

  @override
  String doneAll(int ok, int fail) {
    return '全部完成：成功 $ok 個，失敗 $fail 個';
  }

  @override
  String stoppedDone(int n) {
    return '已停止，共完成 $n 個';
  }

  @override
  String get cancelled => '已取消';

  @override
  String get stopping => '正在停止…';

  @override
  String get decodeWarning => '⚠ 輸出中存在解碼錯誤/警告，請檢查來源檔是否完整';

  @override
  String get doneWithWarning => '完成（有解碼警告）';

  @override
  String noOutput(String path) {
    return '未產生輸出檔：$path';
  }

  @override
  String engineDirMissing(String dir) {
    return '指定資料夾中找不到 ffmpeg：$dir';
  }

  @override
  String get engineNotFound => '找不到 ffmpeg，請在設定中手動指定 ffmpeg 所在資料夾';

  @override
  String launchFailed(String err) {
    return '啟動失敗: $err';
  }

  @override
  String compatResolution(int w, int h) {
    return '相容模式：統一輸出 ${w}x$h（H.265 + AAC 256k）';
  }
}
