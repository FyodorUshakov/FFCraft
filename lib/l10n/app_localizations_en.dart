// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle =>
      'FFCraft · Lightweight Audio & Video Toolkit | Built with Flutter';

  @override
  String get appName => 'FFCraft';

  @override
  String get appSubtitle =>
      'Lightweight Audio & Video Toolkit | Built with Flutter';

  @override
  String get modeAudio => 'Audio Convert';

  @override
  String get modeVideo => 'Video Convert';

  @override
  String get modeMux => 'Mux';

  @override
  String get modeConcat => 'Concatenate';

  @override
  String get hintAudio =>
      'Convert audio files to AAC / MP3 / FLAC / ALAC / WAV / Opus / OGG and more';

  @override
  String get hintVideo =>
      'Change video codec, resolution and bitrate; keep or re-encode the audio track';

  @override
  String get hintMux =>
      'Combine video and audio tracks into a new container without re-encoding';

  @override
  String get hintConcat =>
      'Join multiple audio/video segments of the same codec into one file';

  @override
  String settingsTitle(String mode) {
    return 'Settings · $mode';
  }

  @override
  String get engineReady => 'ffmpeg ready';

  @override
  String get engineMissing => 'ffmpeg not found';

  @override
  String get tooltipTheme => 'Color scheme';

  @override
  String get tooltipEngine => 'Settings';

  @override
  String get queueTitle => 'File Queue';

  @override
  String itemCount(int n) {
    return '$n';
  }

  @override
  String get addFiles => 'Add files';

  @override
  String get addFolder => 'Add folder';

  @override
  String get clearQueue => 'Clear queue';

  @override
  String get dragFiles => 'Drop files here';

  @override
  String get dragHintAudio =>
      'Drop audio files here\nor use \"Add files / Add folder\" in the top-right corner';

  @override
  String get dragHintVideo =>
      'Drop video files here\nor use \"Add files / Add folder\" in the top-right corner';

  @override
  String get dragHintConcat =>
      'Drop multiple audio/video files here\n(segments should share the same codec and settings for a smooth join)';

  @override
  String get dropMore => 'Drop more files or folders here';

  @override
  String get remove => 'Remove';

  @override
  String get statusQueued => 'Queued';

  @override
  String get statusRunning => 'Processing';

  @override
  String get statusDone => 'Done';

  @override
  String get statusFailed => 'Failed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get processing => 'Processing…';

  @override
  String get starting => 'Starting…';

  @override
  String doneTo(String path) {
    return 'Done → $path';
  }

  @override
  String failedExit(int code) {
    return 'Failed (exit=$code)';
  }

  @override
  String get outputDir => 'Output folder';

  @override
  String get sameAsSource => 'Same as source';

  @override
  String get customDir => 'Custom folder';

  @override
  String get browse => 'Browse…';

  @override
  String get clearOutDir => 'Clear output folder';

  @override
  String get parallelTasks => 'Parallel jobs';

  @override
  String get singleTaskNote => '(mux/concat run as a single job)';

  @override
  String get startAudio => 'Start';

  @override
  String get startVideo => 'Start';

  @override
  String get startMux => 'Start muxing';

  @override
  String get startConcat => 'Start joining';

  @override
  String get needVideoFile => 'Select a video file first';

  @override
  String get needAudioFile => 'Add audio files first';

  @override
  String get needVideoFiles => 'Add video files first';

  @override
  String get needTwoFiles => 'Add at least 2 files';

  @override
  String get stop => 'Stop';

  @override
  String get tooltipLogShow => 'Show log';

  @override
  String get tooltipLogHide => 'Hide log';

  @override
  String get outputCodec => 'Output codec';

  @override
  String get sampleRate => 'Sample rate';

  @override
  String get sampleRateKeep => 'Keep original';

  @override
  String get sampleRateHint =>
      'Keeping the original is safest; change only when a unified sample rate is needed';

  @override
  String get copyMetadata => 'Copy metadata';

  @override
  String get copyMetadataHint =>
      'Keep tags such as title, artist and cover art';

  @override
  String get losslessParams => 'Lossless options';

  @override
  String get bitDepth => 'Bit depth';

  @override
  String get bitDepthHint =>
      'Higher bit depth means wider dynamic range and larger files; 16-bit ≈ CD quality, 24-bit is common for recording and mastering';

  @override
  String get flacCompression => 'FLAC compression level';

  @override
  String get flacCompressionHint =>
      'Higher level compresses more but is slower; 0 is fastest, 8 is smallest (default 5)';

  @override
  String get bitrateControl => 'Bitrate control';

  @override
  String get bitrateModeHint =>
      'CBR: stable file size. VBR: better quality at the same bitrate. ABR: a compromise between the two.';

  @override
  String get modeCbr => 'CBR';

  @override
  String get modeVbr => 'VBR';

  @override
  String get modeAbr => 'ABR';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateHint =>
      'Higher bitrate means better quality and larger files; 128–256 kbps is enough for most music';

  @override
  String get opusVbrHint =>
      'Opus uses VBR by default; choosing CBR turns it off';

  @override
  String get qualityRangeMp3 => '0-9 (0 = highest)';

  @override
  String get qualityRangeVorbis => '0-10 (higher is better)';

  @override
  String get vbrQuality => 'VBR quality';

  @override
  String qualityRangeHint(String range) {
    return 'Lower value means higher quality and larger files; higher value means smaller files (range $range)';
  }

  @override
  String get coverNotSupportedHint =>
      'OGG, Opus and WAV containers do not support embedded cover art; the cover will be omitted';

  @override
  String get decodeTailInfo =>
      'Output is complete and playable; extra data at the end of the source file (common in NetEase Cloud Music FLAC downloads) was ignored';

  @override
  String get videoCodec => 'Video codec';

  @override
  String get hardwareAccel => 'Hardware acceleration';

  @override
  String get hardwareAccelHint =>
      'Encode with your GPU/iGPU for higher speed; availability depends on your device and ffmpeg build';

  @override
  String get hwEncoder => 'Hardware encoder';

  @override
  String get hwEncoderHint =>
      'No hardware encoders detected; check your GPU driver or whether ffmpeg includes the required modules';

  @override
  String get codecCopy => 'Copy as-is';

  @override
  String get preset => 'Preset';

  @override
  String get presetUltrafast => 'Ultrafast · largest files';

  @override
  String get presetSuperfast => 'Superfast · very large files';

  @override
  String get presetVeryfast => 'Veryfast · large files';

  @override
  String get presetFaster => 'Faster';

  @override
  String get presetFast => 'Fast';

  @override
  String get presetMedium => 'Medium (default)';

  @override
  String get presetSlow => 'Slow · better compression';

  @override
  String get presetSlower => 'Slower · smaller files';

  @override
  String get presetVeryslow => 'Veryslow · smallest files';

  @override
  String get presetAv1Slow => 'Very slow · best compression';

  @override
  String get presetAv1MedSlow => 'Slow · high compression';

  @override
  String get presetAv1Balanced => 'Balanced (default)';

  @override
  String get presetAv1Fast => 'Fast · larger files';

  @override
  String get presetAv1Fastest => 'Fastest · more quality loss';

  @override
  String get presetHintX264 =>
      'Presets only affect encode speed and file size, not quality: faster → larger files, slower → better compression. medium is the balanced default.';

  @override
  String get presetHintAv1 =>
      'Lower preset encodes slower with better compression (smaller files); higher is faster but larger. Default 8 is the balance point.';

  @override
  String get resolution => 'Resolution';

  @override
  String get resolutionKeep => 'Keep original';

  @override
  String get customEllipsis => 'Custom…';

  @override
  String get resolutionHint =>
      'Scales proportionally by width with auto height; no stretching';

  @override
  String get customWidth => 'Width';

  @override
  String get customHeight => 'Height';

  @override
  String get crfQuality => 'CRF quality';

  @override
  String crfHint(String codec, int max) {
    return 'Lower value means higher quality and larger files; $codec range 0-$max (default 23; quality drops noticeably above 28)';
  }

  @override
  String get targetBitrate => 'Target bitrate';

  @override
  String get maxBitrate => 'Max bitrate';

  @override
  String get bitrateVideoHint =>
      'Higher bitrate means better quality and larger files; 4000–12000 kbps is recommended for 1080p';

  @override
  String get frameRate => 'Frame rate';

  @override
  String get frameRateHint =>
      'Keeping the original is usually best; changing it drops or duplicates frames and may affect smoothness';

  @override
  String get audioTrack => 'Audio track';

  @override
  String get audioTrackHint =>
      'Keep = copy the track as-is (fastest, lossless); AAC/MP3 re-encode it';

  @override
  String get trackKeep => 'Keep as-is';

  @override
  String get trackAac => 'Re-encode to AAC';

  @override
  String get trackMp3 => 'Re-encode to MP3';

  @override
  String get trackNone => 'Remove audio';

  @override
  String get audioBitrate => 'Audio bitrate';

  @override
  String get compatMode => 'Compatibility mode (yuv420p)';

  @override
  String get compatModeHint =>
      'Use a widely compatible pixel format for players and editors';

  @override
  String get muxInput => 'Mux inputs';

  @override
  String get muxNoReencode => 'Pure mux · no re-encoding';

  @override
  String get videoFile => 'Video file';

  @override
  String get videoFileHint => 'Source of the video track (required)';

  @override
  String get audioFiles => 'Audio files';

  @override
  String get audioFilesHint =>
      'Source of audio tracks; multiple allowed (optional — with none, only the container changes)';

  @override
  String get container => 'Container';

  @override
  String get muxInfo =>
      'Muxing copies all tracks as-is with -c copy: very fast and lossless. The target container must support the source codecs (e.g. MP4 usually holds H.264/H.265 + AAC).';

  @override
  String get select => 'Select';

  @override
  String get clear => 'Clear';

  @override
  String get outputContainer => 'Output container';

  @override
  String get autoContainer => 'Auto (same as input)';

  @override
  String get compatReencode => 'Compatibility mode (re-encode)';

  @override
  String get compatReencodeHint =>
      'When segments differ in codec or settings, re-encode to H.265 + AAC before joining';

  @override
  String get concatInfoCopy =>
      'Copy mode (default) joins directly without re-encoding: fast and lossless, but all segments must match in codec, sample rate, frame rate, etc.';

  @override
  String get concatInfoReencode =>
      'Compatibility mode re-encodes every segment (H.265 + AAC 256k, unified to the highest resolution) so anything can be joined, at the cost of quality and time.';

  @override
  String get logTitle => 'ffmpeg log';

  @override
  String get copyLog => 'Copy log';

  @override
  String get logCopied => 'Log copied to clipboard';

  @override
  String get noLog => 'No log entries';

  @override
  String get settings => 'Settings';

  @override
  String get engineSettings => 'ffmpeg settings';

  @override
  String get aboutTitle => 'About FFCraft';

  @override
  String get versionLabel => 'Version';

  @override
  String get currentStatus => 'Current status';

  @override
  String get engineAvailable => 'ffmpeg available';

  @override
  String get engineUnavailable => 'ffmpeg unavailable';

  @override
  String get detecting => 'Detecting ffmpeg…';

  @override
  String get manualDirLabel => 'Manual folder (leave empty for auto detection)';

  @override
  String get manualDirHint => 'e.g. /usr/bin or E:\\ffmpeg\\bin';

  @override
  String get manualSpecify => 'Set manually…';

  @override
  String get clearManual => 'Clear manual path';

  @override
  String get autoFindOrder =>
      'Search order: manual path → ffmpeg folder next to the app\n→ system PATH → common locations (e.g. /usr/bin, /opt/ffmpeg, C:\\ffmpeg)';

  @override
  String get restoreAuto => 'Restore auto';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String versionLine(String version) {
    return 'FFCraft · v$version';
  }

  @override
  String get copyrightLine => 'Copyright © 2026 万能的乌沙科夫 (@FyodorUshakov)';

  @override
  String get githubLine =>
      'GitHub: 万能的乌沙科夫 (@FyodorUshakov)\nhttps://github.com/FyodorUshakov';

  @override
  String get licenseTitle => 'Open Source License';

  @override
  String get licenseText =>
      'This project is open source under the MIT License, allowing free use, modification and distribution.\nffmpeg is invoked as an external program and is covered by its own open-source licenses (e.g. GPL/LGPL); it is not part of this project\'s MIT license.';

  @override
  String get thirdPartyTitle => 'Third-party Components';

  @override
  String get thirdPartyText =>
      'ffmpeg (https://ffmpeg.org) — audio/video engine, invoked externally.';

  @override
  String get language => 'Language';

  @override
  String manualDirValue(String dir) {
    return 'Manual: $dir';
  }

  @override
  String autoDirValue(String dir) {
    return 'Auto-detected: $dir';
  }

  @override
  String get themeSettings => 'Color Scheme';

  @override
  String get presetPalette => 'Preset palette';

  @override
  String get followWallpaper => 'Follow wallpaper';

  @override
  String get fromWallpaper => 'Pick from wallpaper';

  @override
  String get extracting => 'Picking…';

  @override
  String get wallpaperHint =>
      'Use the dominant color of the current wallpaper; falls back to the system accent color';

  @override
  String get wallpaperOnlyWindows =>
      'Wallpaper color is only supported on Windows';

  @override
  String get customColor => 'Custom color';

  @override
  String get customColorHint =>
      'Drag the wheel or enter a Hex value; applies immediately';

  @override
  String get restoreDefault => 'Restore default';

  @override
  String get close => 'Close';

  @override
  String get wallpaperColorLabel => 'From wallpaper';

  @override
  String get wallpaperFailed =>
      'Could not pick from the wallpaper; the current scheme was kept';

  @override
  String get currentTheme => 'Current theme';

  @override
  String get sourcePreset => 'Preset';

  @override
  String get sourceCustom => 'Custom';

  @override
  String get sourceWallpaper => 'Wallpaper';

  @override
  String get colorDefault => 'Default · light blue';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorCyan => 'Cyan';

  @override
  String get colorTeal => 'Teal';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorLime => 'Lime';

  @override
  String get colorAmber => 'Amber';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorCoral => 'Coral';

  @override
  String get colorPink => 'Pink';

  @override
  String get colorPurple => 'Purple';

  @override
  String get colorViolet => 'Violet';

  @override
  String get colorIndigo => 'Indigo';

  @override
  String get colorBlueGrey => 'Blue grey';

  @override
  String addedFiles(int n) {
    return 'Added $n file(s)';
  }

  @override
  String readDirFailed(String err) {
    return 'Failed to read folder: $err';
  }

  @override
  String switchedMode(String mode) {
    return 'Switched to $mode mode';
  }

  @override
  String startBatch(int n, String dir) {
    return '━━ Processing started ━━ $n job(s), ffmpeg: $dir';
  }

  @override
  String doneAll(int ok, int fail) {
    return 'All done: $ok succeeded, $fail failed';
  }

  @override
  String stoppedDone(int n) {
    return 'Stopped; $n completed';
  }

  @override
  String get cancelled => 'Cancelled';

  @override
  String get stopping => 'Stopping…';

  @override
  String get decodeWarning =>
      '⚠ Decode errors/warnings occurred; please check whether the source file is intact';

  @override
  String get doneWithWarning => 'Done (with decode warnings)';

  @override
  String noOutput(String path) {
    return 'Output file was not created: $path';
  }

  @override
  String engineDirMissing(String dir) {
    return 'ffmpeg not found in the specified folder: $dir';
  }

  @override
  String get engineNotFound =>
      'ffmpeg not found. Specify its folder manually in settings.';

  @override
  String launchFailed(String err) {
    return 'Failed to start: $err';
  }

  @override
  String compatResolution(int w, int h) {
    return 'Compatibility mode: unified output ${w}x$h (H.265 + AAC 256k)';
  }
}
