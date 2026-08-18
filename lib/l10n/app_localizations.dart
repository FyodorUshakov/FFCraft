import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('ru'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'FFCraft · 轻量影音工具箱 | Built with Flutter'**
  String get appTitle;

  /// No description provided for @appName.
  ///
  /// In zh, this message translates to:
  /// **'FFCraft'**
  String get appName;

  /// No description provided for @appSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'轻量影音工具箱 | Built with Flutter'**
  String get appSubtitle;

  /// No description provided for @modeAudio.
  ///
  /// In zh, this message translates to:
  /// **'音频转码'**
  String get modeAudio;

  /// No description provided for @modeVideo.
  ///
  /// In zh, this message translates to:
  /// **'视频转码'**
  String get modeVideo;

  /// No description provided for @modeMux.
  ///
  /// In zh, this message translates to:
  /// **'合流封装'**
  String get modeMux;

  /// No description provided for @modeConcat.
  ///
  /// In zh, this message translates to:
  /// **'拼接'**
  String get modeConcat;

  /// No description provided for @hintAudio.
  ///
  /// In zh, this message translates to:
  /// **'把音频文件转换成 AAC / MP3 / FLAC / ALAC / WAV / Opus / OGG 等格式'**
  String get hintAudio;

  /// No description provided for @hintVideo.
  ///
  /// In zh, this message translates to:
  /// **'转换视频编码、分辨率、码率，可保留或重编码音轨'**
  String get hintVideo;

  /// No description provided for @hintMux.
  ///
  /// In zh, this message translates to:
  /// **'把视频与音频轨道原样合并进新的容器（不重编码，纯合流）'**
  String get hintMux;

  /// No description provided for @hintConcat.
  ///
  /// In zh, this message translates to:
  /// **'把多段同编码的音视频无缝拼接为一个文件'**
  String get hintConcat;

  /// No description provided for @settingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'参数设置 · {mode}'**
  String settingsTitle(String mode);

  /// No description provided for @engineReady.
  ///
  /// In zh, this message translates to:
  /// **'ffmpeg 就绪'**
  String get engineReady;

  /// No description provided for @engineMissing.
  ///
  /// In zh, this message translates to:
  /// **'ffmpeg 未找到'**
  String get engineMissing;

  /// No description provided for @tooltipTheme.
  ///
  /// In zh, this message translates to:
  /// **'配色方案'**
  String get tooltipTheme;

  /// No description provided for @tooltipEngine.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get tooltipEngine;

  /// No description provided for @queueTitle.
  ///
  /// In zh, this message translates to:
  /// **'文件队列'**
  String get queueTitle;

  /// No description provided for @itemCount.
  ///
  /// In zh, this message translates to:
  /// **'{n} 个'**
  String itemCount(int n);

  /// No description provided for @addFiles.
  ///
  /// In zh, this message translates to:
  /// **'添加文件'**
  String get addFiles;

  /// No description provided for @addFolder.
  ///
  /// In zh, this message translates to:
  /// **'添加文件夹'**
  String get addFolder;

  /// No description provided for @clearQueue.
  ///
  /// In zh, this message translates to:
  /// **'清空队列'**
  String get clearQueue;

  /// No description provided for @dragFiles.
  ///
  /// In zh, this message translates to:
  /// **'拖拽文件到此处'**
  String get dragFiles;

  /// No description provided for @dragHintAudio.
  ///
  /// In zh, this message translates to:
  /// **'拖拽音频文件到此处\n或点击右上角「添加文件 / 添加文件夹」'**
  String get dragHintAudio;

  /// No description provided for @dragHintVideo.
  ///
  /// In zh, this message translates to:
  /// **'拖拽视频文件到此处\n或点击右上角「添加文件 / 添加文件夹」'**
  String get dragHintVideo;

  /// No description provided for @dragHintConcat.
  ///
  /// In zh, this message translates to:
  /// **'拖拽多个音视频文件到此处\n（各段编码与参数需一致，拼接更顺畅）'**
  String get dragHintConcat;

  /// No description provided for @dropMore.
  ///
  /// In zh, this message translates to:
  /// **'拖拽更多文件或文件夹到此处'**
  String get dropMore;

  /// No description provided for @remove.
  ///
  /// In zh, this message translates to:
  /// **'移除'**
  String get remove;

  /// No description provided for @statusQueued.
  ///
  /// In zh, this message translates to:
  /// **'等待中'**
  String get statusQueued;

  /// No description provided for @statusRunning.
  ///
  /// In zh, this message translates to:
  /// **'处理中'**
  String get statusRunning;

  /// No description provided for @statusDone.
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get statusDone;

  /// No description provided for @statusFailed.
  ///
  /// In zh, this message translates to:
  /// **'失败'**
  String get statusFailed;

  /// No description provided for @statusCancelled.
  ///
  /// In zh, this message translates to:
  /// **'已取消'**
  String get statusCancelled;

  /// No description provided for @processing.
  ///
  /// In zh, this message translates to:
  /// **'处理中…'**
  String get processing;

  /// No description provided for @starting.
  ///
  /// In zh, this message translates to:
  /// **'启动中…'**
  String get starting;

  /// No description provided for @doneTo.
  ///
  /// In zh, this message translates to:
  /// **'完成 → {path}'**
  String doneTo(String path);

  /// No description provided for @failedExit.
  ///
  /// In zh, this message translates to:
  /// **'失败 (exit={code})'**
  String failedExit(int code);

  /// No description provided for @outputDir.
  ///
  /// In zh, this message translates to:
  /// **'输出目录'**
  String get outputDir;

  /// No description provided for @sameAsSource.
  ///
  /// In zh, this message translates to:
  /// **'与源文件相同'**
  String get sameAsSource;

  /// No description provided for @customDir.
  ///
  /// In zh, this message translates to:
  /// **'指定目录'**
  String get customDir;

  /// No description provided for @browse.
  ///
  /// In zh, this message translates to:
  /// **'浏览…'**
  String get browse;

  /// No description provided for @clearOutDir.
  ///
  /// In zh, this message translates to:
  /// **'清除输出目录'**
  String get clearOutDir;

  /// No description provided for @parallelTasks.
  ///
  /// In zh, this message translates to:
  /// **'并行任务'**
  String get parallelTasks;

  /// No description provided for @singleTaskNote.
  ///
  /// In zh, this message translates to:
  /// **'（合流/拼接为单任务）'**
  String get singleTaskNote;

  /// No description provided for @startAudio.
  ///
  /// In zh, this message translates to:
  /// **'开始转码'**
  String get startAudio;

  /// No description provided for @startVideo.
  ///
  /// In zh, this message translates to:
  /// **'开始转码'**
  String get startVideo;

  /// No description provided for @startMux.
  ///
  /// In zh, this message translates to:
  /// **'开始合流'**
  String get startMux;

  /// No description provided for @startConcat.
  ///
  /// In zh, this message translates to:
  /// **'开始拼接'**
  String get startConcat;

  /// No description provided for @needVideoFile.
  ///
  /// In zh, this message translates to:
  /// **'请选择视频文件'**
  String get needVideoFile;

  /// No description provided for @needAudioFile.
  ///
  /// In zh, this message translates to:
  /// **'请添加音频文件'**
  String get needAudioFile;

  /// No description provided for @needVideoFiles.
  ///
  /// In zh, this message translates to:
  /// **'请添加视频文件'**
  String get needVideoFiles;

  /// No description provided for @needTwoFiles.
  ///
  /// In zh, this message translates to:
  /// **'至少添加 2 个文件'**
  String get needTwoFiles;

  /// No description provided for @stop.
  ///
  /// In zh, this message translates to:
  /// **'停止'**
  String get stop;

  /// No description provided for @tooltipLogShow.
  ///
  /// In zh, this message translates to:
  /// **'查看日志'**
  String get tooltipLogShow;

  /// No description provided for @tooltipLogHide.
  ///
  /// In zh, this message translates to:
  /// **'收起日志'**
  String get tooltipLogHide;

  /// No description provided for @outputCodec.
  ///
  /// In zh, this message translates to:
  /// **'输出编码'**
  String get outputCodec;

  /// No description provided for @sampleRate.
  ///
  /// In zh, this message translates to:
  /// **'采样率'**
  String get sampleRate;

  /// No description provided for @sampleRateKeep.
  ///
  /// In zh, this message translates to:
  /// **'保持原样'**
  String get sampleRateKeep;

  /// No description provided for @sampleRateHint.
  ///
  /// In zh, this message translates to:
  /// **'保持原样最稳妥；只有需要统一采样率时才更改'**
  String get sampleRateHint;

  /// No description provided for @copyMetadata.
  ///
  /// In zh, this message translates to:
  /// **'复制元数据'**
  String get copyMetadata;

  /// No description provided for @copyMetadataHint.
  ///
  /// In zh, this message translates to:
  /// **'标题、艺术家、封面等标签随文件一起保留'**
  String get copyMetadataHint;

  /// No description provided for @losslessParams.
  ///
  /// In zh, this message translates to:
  /// **'无损参数'**
  String get losslessParams;

  /// No description provided for @bitDepth.
  ///
  /// In zh, this message translates to:
  /// **'位深'**
  String get bitDepth;

  /// No description provided for @bitDepthHint.
  ///
  /// In zh, this message translates to:
  /// **'位深越高动态范围越大、文件也越大；16bit≈CD 音质，24bit 是录音/母带常用'**
  String get bitDepthHint;

  /// No description provided for @flacCompression.
  ///
  /// In zh, this message translates to:
  /// **'FLAC 压缩等级'**
  String get flacCompression;

  /// No description provided for @flacCompressionHint.
  ///
  /// In zh, this message translates to:
  /// **'等级越高压缩率越高但越慢；0 最快，8 最小（默认 5）'**
  String get flacCompressionHint;

  /// No description provided for @bitrateControl.
  ///
  /// In zh, this message translates to:
  /// **'码率控制'**
  String get bitrateControl;

  /// No description provided for @bitrateModeHint.
  ///
  /// In zh, this message translates to:
  /// **'固定码率(CBR)：体积稳定；可变码率(VBR)：同码率下质量更好；平均码率(ABR)：两者折中'**
  String get bitrateModeHint;

  /// No description provided for @modeCbr.
  ///
  /// In zh, this message translates to:
  /// **'固定码率'**
  String get modeCbr;

  /// No description provided for @modeVbr.
  ///
  /// In zh, this message translates to:
  /// **'可变码率'**
  String get modeVbr;

  /// No description provided for @modeAbr.
  ///
  /// In zh, this message translates to:
  /// **'平均码率'**
  String get modeAbr;

  /// No description provided for @bitrate.
  ///
  /// In zh, this message translates to:
  /// **'码率'**
  String get bitrate;

  /// No description provided for @bitrateHint.
  ///
  /// In zh, this message translates to:
  /// **'码率越高音质越好、文件越大；对大多数音乐 128–256 kbps 已足够'**
  String get bitrateHint;

  /// No description provided for @opusVbrHint.
  ///
  /// In zh, this message translates to:
  /// **'Opus 默认采用可变码率；选择「固定码率」可关闭 VBR'**
  String get opusVbrHint;

  /// No description provided for @qualityRangeMp3.
  ///
  /// In zh, this message translates to:
  /// **'0-9（0 最高）'**
  String get qualityRangeMp3;

  /// No description provided for @qualityRangeVorbis.
  ///
  /// In zh, this message translates to:
  /// **'0-10（越高越好）'**
  String get qualityRangeVorbis;

  /// No description provided for @vbrQuality.
  ///
  /// In zh, this message translates to:
  /// **'VBR 质量'**
  String get vbrQuality;

  /// No description provided for @qualityRangeHint.
  ///
  /// In zh, this message translates to:
  /// **'数值越低质量越高、文件越大；数值越高文件越小（范围 {range}）'**
  String qualityRangeHint(String range);

  /// No description provided for @coverNotSupportedHint.
  ///
  /// In zh, this message translates to:
  /// **'OGG/Opus/WAV 容器不支持内嵌封面，转换时封面将被忽略'**
  String get coverNotSupportedHint;

  /// No description provided for @decodeTailInfo.
  ///
  /// In zh, this message translates to:
  /// **'输出完整可正常播放；源文件尾部附加数据（常见于网易云下载的 FLAC）已忽略'**
  String get decodeTailInfo;

  /// No description provided for @videoCodec.
  ///
  /// In zh, this message translates to:
  /// **'视频编码'**
  String get videoCodec;

  /// No description provided for @hardwareAccel.
  ///
  /// In zh, this message translates to:
  /// **'硬件加速'**
  String get hardwareAccel;

  /// No description provided for @hardwareAccelHint.
  ///
  /// In zh, this message translates to:
  /// **'使用显卡/核显编码，速度更快；是否可用取决于设备与 ffmpeg 编译'**
  String get hardwareAccelHint;

  /// No description provided for @hwEncoder.
  ///
  /// In zh, this message translates to:
  /// **'硬件编码器'**
  String get hwEncoder;

  /// No description provided for @hwEncoderHint.
  ///
  /// In zh, this message translates to:
  /// **'未检测到可用的硬件编码器，请检查显卡驱动或 ffmpeg 是否包含相应模块'**
  String get hwEncoderHint;

  /// No description provided for @hwPreset.
  ///
  /// In zh, this message translates to:
  /// **'硬件档位'**
  String get hwPreset;

  /// No description provided for @hwPresetNvencHint.
  ///
  /// In zh, this message translates to:
  /// **'NVENC：p1 最快，p7 质量最佳（默认 p4）'**
  String get hwPresetNvencHint;

  /// No description provided for @hwPresetQsvHint.
  ///
  /// In zh, this message translates to:
  /// **'QSV：veryfast 最快，veryslow 质量最佳（默认 medium）'**
  String get hwPresetQsvHint;

  /// No description provided for @hwPresetAmfHint.
  ///
  /// In zh, this message translates to:
  /// **'AMF：speed 最快，high_quality 质量最佳（默认 balanced）'**
  String get hwPresetAmfHint;

  /// No description provided for @codecCopy.
  ///
  /// In zh, this message translates to:
  /// **'原样复制'**
  String get codecCopy;

  /// No description provided for @preset.
  ///
  /// In zh, this message translates to:
  /// **'编码预设'**
  String get preset;

  /// No description provided for @presetUltrafast.
  ///
  /// In zh, this message translates to:
  /// **'极速 · 文件最大'**
  String get presetUltrafast;

  /// No description provided for @presetSuperfast.
  ///
  /// In zh, this message translates to:
  /// **'超快 · 文件很大'**
  String get presetSuperfast;

  /// No description provided for @presetVeryfast.
  ///
  /// In zh, this message translates to:
  /// **'很快 · 文件较大'**
  String get presetVeryfast;

  /// No description provided for @presetFaster.
  ///
  /// In zh, this message translates to:
  /// **'较快'**
  String get presetFaster;

  /// No description provided for @presetFast.
  ///
  /// In zh, this message translates to:
  /// **'快'**
  String get presetFast;

  /// No description provided for @presetMedium.
  ///
  /// In zh, this message translates to:
  /// **'平衡（默认）'**
  String get presetMedium;

  /// No description provided for @presetSlow.
  ///
  /// In zh, this message translates to:
  /// **'慢 · 压缩更好'**
  String get presetSlow;

  /// No description provided for @presetSlower.
  ///
  /// In zh, this message translates to:
  /// **'较慢 · 文件更小'**
  String get presetSlower;

  /// No description provided for @presetVeryslow.
  ///
  /// In zh, this message translates to:
  /// **'最慢 · 文件最小'**
  String get presetVeryslow;

  /// No description provided for @presetAv1Slow.
  ///
  /// In zh, this message translates to:
  /// **'极慢 · 压缩率最高'**
  String get presetAv1Slow;

  /// No description provided for @presetAv1MedSlow.
  ///
  /// In zh, this message translates to:
  /// **'较慢 · 高压缩'**
  String get presetAv1MedSlow;

  /// No description provided for @presetAv1Balanced.
  ///
  /// In zh, this message translates to:
  /// **'平衡（默认）'**
  String get presetAv1Balanced;

  /// No description provided for @presetAv1Fast.
  ///
  /// In zh, this message translates to:
  /// **'较快 · 文件更大'**
  String get presetAv1Fast;

  /// No description provided for @presetAv1Fastest.
  ///
  /// In zh, this message translates to:
  /// **'最快 · 质量损失较多'**
  String get presetAv1Fastest;

  /// No description provided for @presetHintX264.
  ///
  /// In zh, this message translates to:
  /// **'预设只影响编码速度与文件大小，不影响画质：越快 → 文件越大，越慢 → 压缩率越高。medium 为默认平衡点。'**
  String get presetHintX264;

  /// No description provided for @presetHintAv1.
  ///
  /// In zh, this message translates to:
  /// **'preset 数值越低编码越慢、压缩率越高（文件越小）；越高越快但文件更大。默认 8 为平衡点。'**
  String get presetHintAv1;

  /// No description provided for @resolution.
  ///
  /// In zh, this message translates to:
  /// **'分辨率'**
  String get resolution;

  /// No description provided for @resolutionKeep.
  ///
  /// In zh, this message translates to:
  /// **'保持原样'**
  String get resolutionKeep;

  /// No description provided for @customEllipsis.
  ///
  /// In zh, this message translates to:
  /// **'自定义…'**
  String get customEllipsis;

  /// No description provided for @resolutionHint.
  ///
  /// In zh, this message translates to:
  /// **'按宽度等比缩放、高度自适应，不会拉伸变形'**
  String get resolutionHint;

  /// No description provided for @customWidth.
  ///
  /// In zh, this message translates to:
  /// **'宽'**
  String get customWidth;

  /// No description provided for @customHeight.
  ///
  /// In zh, this message translates to:
  /// **'高'**
  String get customHeight;

  /// No description provided for @crfQuality.
  ///
  /// In zh, this message translates to:
  /// **'CRF 质量'**
  String get crfQuality;

  /// No description provided for @crfHint.
  ///
  /// In zh, this message translates to:
  /// **'数值越小画质越高、文件越大；{codec} 范围 0-{max}（默认 23；超过 28 画质开始明显下降）'**
  String crfHint(String codec, int max);

  /// No description provided for @targetBitrate.
  ///
  /// In zh, this message translates to:
  /// **'目标码率'**
  String get targetBitrate;

  /// No description provided for @maxBitrate.
  ///
  /// In zh, this message translates to:
  /// **'最大码率'**
  String get maxBitrate;

  /// No description provided for @bitrateVideoHint.
  ///
  /// In zh, this message translates to:
  /// **'码率越高画质越好、文件越大；1080p 建议 4000–12000 kbps'**
  String get bitrateVideoHint;

  /// No description provided for @frameRate.
  ///
  /// In zh, this message translates to:
  /// **'帧率'**
  String get frameRate;

  /// No description provided for @frameRateHint.
  ///
  /// In zh, this message translates to:
  /// **'通常保持原样；更改会丢帧/补帧，可能影响流畅度'**
  String get frameRateHint;

  /// No description provided for @audioTrack.
  ///
  /// In zh, this message translates to:
  /// **'音频轨道'**
  String get audioTrack;

  /// No description provided for @audioTrackHint.
  ///
  /// In zh, this message translates to:
  /// **'保持不变 = 原样复制音轨（最快无损）；AAC/MP3 会重新编码'**
  String get audioTrackHint;

  /// No description provided for @trackKeep.
  ///
  /// In zh, this message translates to:
  /// **'保持不变'**
  String get trackKeep;

  /// No description provided for @trackAac.
  ///
  /// In zh, this message translates to:
  /// **'转码为 AAC'**
  String get trackAac;

  /// No description provided for @trackMp3.
  ///
  /// In zh, this message translates to:
  /// **'转码为 MP3'**
  String get trackMp3;

  /// No description provided for @trackNone.
  ///
  /// In zh, this message translates to:
  /// **'移除音轨'**
  String get trackNone;

  /// No description provided for @audioBitrate.
  ///
  /// In zh, this message translates to:
  /// **'音频码率'**
  String get audioBitrate;

  /// No description provided for @compatMode.
  ///
  /// In zh, this message translates to:
  /// **'兼容模式 (yuv420p)'**
  String get compatMode;

  /// No description provided for @compatModeHint.
  ///
  /// In zh, this message translates to:
  /// **'使用广泛兼容的像素格式，适合播放器与剪辑软件'**
  String get compatModeHint;

  /// No description provided for @muxInput.
  ///
  /// In zh, this message translates to:
  /// **'合流输入'**
  String get muxInput;

  /// No description provided for @muxNoReencode.
  ///
  /// In zh, this message translates to:
  /// **'纯封装 · 不重编码'**
  String get muxNoReencode;

  /// No description provided for @videoFile.
  ///
  /// In zh, this message translates to:
  /// **'视频文件'**
  String get videoFile;

  /// No description provided for @videoFileHint.
  ///
  /// In zh, this message translates to:
  /// **'视频轨道来源（必选）'**
  String get videoFileHint;

  /// No description provided for @audioFiles.
  ///
  /// In zh, this message translates to:
  /// **'音频文件'**
  String get audioFiles;

  /// No description provided for @audioFilesHint.
  ///
  /// In zh, this message translates to:
  /// **'音频轨道来源，可添加多条（可选，缺省时仅更换容器）'**
  String get audioFilesHint;

  /// No description provided for @container.
  ///
  /// In zh, this message translates to:
  /// **'封装容器'**
  String get container;

  /// No description provided for @muxInfo.
  ///
  /// In zh, this message translates to:
  /// **'合流使用 -c copy 原样复制全部轨道，速度极快且不损失任何质量。注意目标容器需支持源轨道编码（如 MP4 通常装 H.264/H.265 + AAC）。'**
  String get muxInfo;

  /// No description provided for @select.
  ///
  /// In zh, this message translates to:
  /// **'选择'**
  String get select;

  /// No description provided for @clear.
  ///
  /// In zh, this message translates to:
  /// **'清空'**
  String get clear;

  /// No description provided for @outputContainer.
  ///
  /// In zh, this message translates to:
  /// **'输出容器'**
  String get outputContainer;

  /// No description provided for @autoContainer.
  ///
  /// In zh, this message translates to:
  /// **'自动（同输入）'**
  String get autoContainer;

  /// No description provided for @compatReencode.
  ///
  /// In zh, this message translates to:
  /// **'兼容模式（重新编码）'**
  String get compatReencode;

  /// No description provided for @compatReencodeHint.
  ///
  /// In zh, this message translates to:
  /// **'各段编码或参数不一致时，重新编码为 H.265 + AAC 后再拼接'**
  String get compatReencodeHint;

  /// No description provided for @concatInfoCopy.
  ///
  /// In zh, this message translates to:
  /// **'复制模式（默认）直接拼接，不重编码、速度快、质量无损；要求各片段的编码、采样率、帧率等参数完全一致。'**
  String get concatInfoCopy;

  /// No description provided for @concatInfoReencode.
  ///
  /// In zh, this message translates to:
  /// **'兼容模式会重新编码全部片段（H.265 + AAC 256k，统一为最高分辨率），保证能拼在一起，但会损失质量且耗时较长。'**
  String get concatInfoReencode;

  /// No description provided for @logTitle.
  ///
  /// In zh, this message translates to:
  /// **'ffmpeg 日志'**
  String get logTitle;

  /// No description provided for @copyLog.
  ///
  /// In zh, this message translates to:
  /// **'复制日志'**
  String get copyLog;

  /// No description provided for @logCopied.
  ///
  /// In zh, this message translates to:
  /// **'日志已复制到剪贴板'**
  String get logCopied;

  /// No description provided for @noLog.
  ///
  /// In zh, this message translates to:
  /// **'暂无日志'**
  String get noLog;

  /// No description provided for @settings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settings;

  /// No description provided for @engineSettings.
  ///
  /// In zh, this message translates to:
  /// **'ffmpeg 设置'**
  String get engineSettings;

  /// No description provided for @aboutTitle.
  ///
  /// In zh, this message translates to:
  /// **'关于 FFCraft'**
  String get aboutTitle;

  /// No description provided for @versionLabel.
  ///
  /// In zh, this message translates to:
  /// **'版本'**
  String get versionLabel;

  /// No description provided for @currentStatus.
  ///
  /// In zh, this message translates to:
  /// **'当前状态'**
  String get currentStatus;

  /// No description provided for @engineAvailable.
  ///
  /// In zh, this message translates to:
  /// **'ffmpeg 可用'**
  String get engineAvailable;

  /// No description provided for @engineUnavailable.
  ///
  /// In zh, this message translates to:
  /// **'ffmpeg 不可用'**
  String get engineUnavailable;

  /// No description provided for @detecting.
  ///
  /// In zh, this message translates to:
  /// **'正在检测 ffmpeg…'**
  String get detecting;

  /// No description provided for @manualDirLabel.
  ///
  /// In zh, this message translates to:
  /// **'手动指定目录（留空 = 自动查找）'**
  String get manualDirLabel;

  /// No description provided for @manualDirHint.
  ///
  /// In zh, this message translates to:
  /// **'例如 /usr/bin 或 E:\\ffmpeg\\bin'**
  String get manualDirHint;

  /// No description provided for @manualSpecify.
  ///
  /// In zh, this message translates to:
  /// **'手动指定…'**
  String get manualSpecify;

  /// No description provided for @clearManual.
  ///
  /// In zh, this message translates to:
  /// **'清除手动指定'**
  String get clearManual;

  /// No description provided for @autoFindOrder.
  ///
  /// In zh, this message translates to:
  /// **'自动查找顺序：手动指定 → 程序旁的 ffmpeg 文件夹\n→ 系统 PATH → 常见安装位置（如 /usr/bin、/opt/ffmpeg、C:\\ffmpeg 等）'**
  String get autoFindOrder;

  /// No description provided for @restoreAuto.
  ///
  /// In zh, this message translates to:
  /// **'恢复自动'**
  String get restoreAuto;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @versionLine.
  ///
  /// In zh, this message translates to:
  /// **'FFCraft · v{version}'**
  String versionLine(String version);

  /// No description provided for @copyrightLine.
  ///
  /// In zh, this message translates to:
  /// **'版权所有 © 2026 万能的乌沙科夫（@FyodorUshakov）'**
  String get copyrightLine;

  /// No description provided for @githubLine.
  ///
  /// In zh, this message translates to:
  /// **'GitHub：万能的乌沙科夫（@FyodorUshakov）\nhttps://github.com/FyodorUshakov'**
  String get githubLine;

  /// No description provided for @licenseTitle.
  ///
  /// In zh, this message translates to:
  /// **'开源许可'**
  String get licenseTitle;

  /// No description provided for @licenseText.
  ///
  /// In zh, this message translates to:
  /// **'本项目以 MIT 协议开源，允许自由使用、修改与分发。\nffmpeg 为外部调用程序，遵循其自身的开源许可（如 GPL/LGPL），不在本项目 MIT 许可范围内。'**
  String get licenseText;

  /// No description provided for @thirdPartyTitle.
  ///
  /// In zh, this message translates to:
  /// **'第三方组件'**
  String get thirdPartyTitle;

  /// No description provided for @thirdPartyText.
  ///
  /// In zh, this message translates to:
  /// **'ffmpeg（https://ffmpeg.org）——音视频处理引擎，由外部调用。'**
  String get thirdPartyText;

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get language;

  /// No description provided for @manualDirValue.
  ///
  /// In zh, this message translates to:
  /// **'手动指定：{dir}'**
  String manualDirValue(String dir);

  /// No description provided for @autoDirValue.
  ///
  /// In zh, this message translates to:
  /// **'自动检测：{dir}'**
  String autoDirValue(String dir);

  /// No description provided for @themeSettings.
  ///
  /// In zh, this message translates to:
  /// **'配色方案'**
  String get themeSettings;

  /// No description provided for @presetPalette.
  ///
  /// In zh, this message translates to:
  /// **'预设色板'**
  String get presetPalette;

  /// No description provided for @followWallpaper.
  ///
  /// In zh, this message translates to:
  /// **'跟随壁纸'**
  String get followWallpaper;

  /// No description provided for @fromWallpaper.
  ///
  /// In zh, this message translates to:
  /// **'从壁纸取色'**
  String get fromWallpaper;

  /// No description provided for @extracting.
  ///
  /// In zh, this message translates to:
  /// **'取色中…'**
  String get extracting;

  /// No description provided for @wallpaperHint.
  ///
  /// In zh, this message translates to:
  /// **'读取当前壁纸主色调作为主题色；失败时回退系统强调色'**
  String get wallpaperHint;

  /// No description provided for @wallpaperOnlyWindows.
  ///
  /// In zh, this message translates to:
  /// **'仅 Windows 支持从壁纸取色'**
  String get wallpaperOnlyWindows;

  /// No description provided for @customColor.
  ///
  /// In zh, this message translates to:
  /// **'自定义颜色'**
  String get customColor;

  /// No description provided for @customColorHint.
  ///
  /// In zh, this message translates to:
  /// **'拖动色环或输入 Hex，选择后立即生效'**
  String get customColorHint;

  /// No description provided for @restoreDefault.
  ///
  /// In zh, this message translates to:
  /// **'恢复默认'**
  String get restoreDefault;

  /// No description provided for @close.
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get close;

  /// No description provided for @wallpaperColorLabel.
  ///
  /// In zh, this message translates to:
  /// **'壁纸取色'**
  String get wallpaperColorLabel;

  /// No description provided for @wallpaperFailed.
  ///
  /// In zh, this message translates to:
  /// **'未能从壁纸取色，已保留当前配色'**
  String get wallpaperFailed;

  /// No description provided for @currentTheme.
  ///
  /// In zh, this message translates to:
  /// **'当前主题'**
  String get currentTheme;

  /// No description provided for @sourcePreset.
  ///
  /// In zh, this message translates to:
  /// **'预设'**
  String get sourcePreset;

  /// No description provided for @sourceCustom.
  ///
  /// In zh, this message translates to:
  /// **'自定义'**
  String get sourceCustom;

  /// No description provided for @sourceWallpaper.
  ///
  /// In zh, this message translates to:
  /// **'跟随壁纸'**
  String get sourceWallpaper;

  /// No description provided for @colorDefault.
  ///
  /// In zh, this message translates to:
  /// **'默认 · 淡蓝'**
  String get colorDefault;

  /// No description provided for @colorBlue.
  ///
  /// In zh, this message translates to:
  /// **'蓝'**
  String get colorBlue;

  /// No description provided for @colorCyan.
  ///
  /// In zh, this message translates to:
  /// **'天青'**
  String get colorCyan;

  /// No description provided for @colorTeal.
  ///
  /// In zh, this message translates to:
  /// **'青绿'**
  String get colorTeal;

  /// No description provided for @colorGreen.
  ///
  /// In zh, this message translates to:
  /// **'翠绿'**
  String get colorGreen;

  /// No description provided for @colorLime.
  ///
  /// In zh, this message translates to:
  /// **'黄绿'**
  String get colorLime;

  /// No description provided for @colorAmber.
  ///
  /// In zh, this message translates to:
  /// **'琥珀'**
  String get colorAmber;

  /// No description provided for @colorOrange.
  ///
  /// In zh, this message translates to:
  /// **'橙'**
  String get colorOrange;

  /// No description provided for @colorCoral.
  ///
  /// In zh, this message translates to:
  /// **'珊瑚'**
  String get colorCoral;

  /// No description provided for @colorPink.
  ///
  /// In zh, this message translates to:
  /// **'粉'**
  String get colorPink;

  /// No description provided for @colorPurple.
  ///
  /// In zh, this message translates to:
  /// **'紫'**
  String get colorPurple;

  /// No description provided for @colorViolet.
  ///
  /// In zh, this message translates to:
  /// **'紫罗兰'**
  String get colorViolet;

  /// No description provided for @colorIndigo.
  ///
  /// In zh, this message translates to:
  /// **'靛蓝'**
  String get colorIndigo;

  /// No description provided for @colorBlueGrey.
  ///
  /// In zh, this message translates to:
  /// **'蓝灰'**
  String get colorBlueGrey;

  /// No description provided for @addedFiles.
  ///
  /// In zh, this message translates to:
  /// **'已添加 {n} 个文件'**
  String addedFiles(int n);

  /// No description provided for @readDirFailed.
  ///
  /// In zh, this message translates to:
  /// **'读取目录失败: {err}'**
  String readDirFailed(String err);

  /// No description provided for @switchedMode.
  ///
  /// In zh, this message translates to:
  /// **'切换到「{mode}」'**
  String switchedMode(String mode);

  /// No description provided for @startBatch.
  ///
  /// In zh, this message translates to:
  /// **'━━ 开始处理 ━━ 共 {n} 个任务，ffmpeg：{dir}'**
  String startBatch(int n, String dir);

  /// No description provided for @doneAll.
  ///
  /// In zh, this message translates to:
  /// **'全部完成：成功 {ok} 个，失败 {fail} 个'**
  String doneAll(int ok, int fail);

  /// No description provided for @stoppedDone.
  ///
  /// In zh, this message translates to:
  /// **'已停止，共完成 {n} 个'**
  String stoppedDone(int n);

  /// No description provided for @cancelled.
  ///
  /// In zh, this message translates to:
  /// **'已取消'**
  String get cancelled;

  /// No description provided for @stopping.
  ///
  /// In zh, this message translates to:
  /// **'正在停止…'**
  String get stopping;

  /// No description provided for @decodeWarning.
  ///
  /// In zh, this message translates to:
  /// **'⚠ 输出中存在解码错误/警告，请检查源文件是否完整'**
  String get decodeWarning;

  /// No description provided for @doneWithWarning.
  ///
  /// In zh, this message translates to:
  /// **'完成（有解码警告）'**
  String get doneWithWarning;

  /// No description provided for @noOutput.
  ///
  /// In zh, this message translates to:
  /// **'未生成输出文件：{path}'**
  String noOutput(String path);

  /// No description provided for @engineDirMissing.
  ///
  /// In zh, this message translates to:
  /// **'指定目录中未找到 ffmpeg：{dir}'**
  String engineDirMissing(String dir);

  /// No description provided for @engineNotFound.
  ///
  /// In zh, this message translates to:
  /// **'未找到 ffmpeg，请在设置中手动指定 ffmpeg 所在目录'**
  String get engineNotFound;

  /// No description provided for @launchFailed.
  ///
  /// In zh, this message translates to:
  /// **'启动失败: {err}'**
  String launchFailed(String err);

  /// No description provided for @compatResolution.
  ///
  /// In zh, this message translates to:
  /// **'兼容模式：统一输出 {w}x{h}（H.265 + AAC 256k）'**
  String compatResolution(int w, int h);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
