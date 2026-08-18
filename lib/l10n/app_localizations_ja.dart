// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'FFCraft · 軽量な音声・動画ツールボックス | Built with Flutter';

  @override
  String get appName => 'FFCraft';

  @override
  String get appSubtitle => '軽量な音声・動画ツールボックス | Built with Flutter';

  @override
  String get modeAudio => '音声変換';

  @override
  String get modeVideo => '動画変換';

  @override
  String get modeMux => '多重化';

  @override
  String get modeConcat => '結合';

  @override
  String get hintAudio =>
      '音声ファイルを AAC / MP3 / FLAC / ALAC / WAV / Opus / OGG などに変換';

  @override
  String get hintVideo => '動画のコーデック・解像度・ビットレートを変更。音声は維持または再エンコード';

  @override
  String get hintMux => '映像と音声トラックを再エンコードせず新しいコンテナにまとめる';

  @override
  String get hintConcat => '同じコーデックの複数セグメントをシームレスに1ファイルへ結合';

  @override
  String settingsTitle(String mode) {
    return '設定 · $mode';
  }

  @override
  String get engineReady => 'ffmpeg 使用可';

  @override
  String get engineMissing => 'ffmpeg が見つかりません';

  @override
  String get tooltipTheme => '配色';

  @override
  String get tooltipEngine => '設定';

  @override
  String get queueTitle => 'ファイルキュー';

  @override
  String itemCount(int n) {
    return '$n 個';
  }

  @override
  String get addFiles => 'ファイルを追加';

  @override
  String get addFolder => 'フォルダーを追加';

  @override
  String get clearQueue => 'キューをクリア';

  @override
  String get dragFiles => 'ここにファイルをドロップ';

  @override
  String get dragHintAudio => 'ここに音声ファイルをドロップ\nまたは右上の「ファイルを追加 / フォルダーを追加」';

  @override
  String get dragHintVideo => 'ここに動画ファイルをドロップ\nまたは右上の「ファイルを追加 / フォルダーを追加」';

  @override
  String get dragHintConcat =>
      'ここに複数の音声・動画ファイルをドロップ\n（スムーズに結合するにはコーデックと設定を揃えてください）';

  @override
  String get dropMore => 'ここにさらにファイルやフォルダーをドロップ';

  @override
  String get remove => '削除';

  @override
  String get statusQueued => '待機中';

  @override
  String get statusRunning => '処理中';

  @override
  String get statusDone => '完了';

  @override
  String get statusFailed => '失敗';

  @override
  String get statusCancelled => 'キャンセル';

  @override
  String get processing => '処理中…';

  @override
  String get starting => '起動中…';

  @override
  String doneTo(String path) {
    return '完了 → $path';
  }

  @override
  String failedExit(int code) {
    return '失敗 (exit=$code)';
  }

  @override
  String get outputDir => '出力フォルダー';

  @override
  String get sameAsSource => '元と同じ場所';

  @override
  String get customDir => '指定する';

  @override
  String get browse => '参照…';

  @override
  String get clearOutDir => '出力フォルダーをクリア';

  @override
  String get parallelTasks => '並列タスク数';

  @override
  String get singleTaskNote => '（多重化/結合は単一タスク）';

  @override
  String get startAudio => '変換開始';

  @override
  String get startVideo => '変換開始';

  @override
  String get startMux => '多重化開始';

  @override
  String get startConcat => '結合開始';

  @override
  String get needVideoFile => '動画ファイルを選択してください';

  @override
  String get needAudioFile => '音声ファイルを追加してください';

  @override
  String get needVideoFiles => '動画ファイルを追加してください';

  @override
  String get needTwoFiles => '2つ以上のファイルを追加してください';

  @override
  String get stop => '停止';

  @override
  String get tooltipLogShow => 'ログを表示';

  @override
  String get tooltipLogHide => 'ログを閉じる';

  @override
  String get outputCodec => '出力コーデック';

  @override
  String get sampleRate => 'サンプリングレート';

  @override
  String get sampleRateKeep => '元のまま';

  @override
  String get sampleRateHint => '元のままが最も安全です。統一が必要なときだけ変更してください';

  @override
  String get copyMetadata => 'メタデータをコピー';

  @override
  String get copyMetadataHint => 'タイトル・アーティスト・ジャケットなどのタグを保持';

  @override
  String get losslessParams => 'ロスレス設定';

  @override
  String get bitDepth => 'ビット深度';

  @override
  String get bitDepthHint =>
      'ビット深度が高いほどダイナミックレンジが広くファイルも大きくなります。16bit≈CD音質、24bitは録音・マスタリングで一般的';

  @override
  String get flacCompression => 'FLAC 圧縮レベル';

  @override
  String get flacCompressionHint => 'レベルが高いほど圧縮率は上がりますが遅くなります。0=最速、8=最小（既定 5）';

  @override
  String get bitrateControl => 'ビットレート制御';

  @override
  String get bitrateModeHint => 'CBR：サイズ安定。VBR：同じビットレートで品質向上。ABR：その中間。';

  @override
  String get modeCbr => 'CBR';

  @override
  String get modeVbr => 'VBR';

  @override
  String get modeAbr => 'ABR';

  @override
  String get bitrate => 'ビットレート';

  @override
  String get bitrateHint =>
      'ビットレートが高いほど音質は良くファイルは大きくなります。多くの音楽では 128–256 kbps で十分';

  @override
  String get opusVbrHint => 'Opus は既定で VBR です。「CBR」を選ぶと VBR をオフにできます';

  @override
  String get qualityRangeMp3 => '0-9（0 が最高）';

  @override
  String get qualityRangeVorbis => '0-10（大きいほど良い）';

  @override
  String get vbrQuality => 'VBR 品質';

  @override
  String qualityRangeHint(String range) {
    return '値が小さいほど品質が高くファイルは大きくなり、大きいほどファイルは小さくなります（範囲 $range）';
  }

  @override
  String get coverNotSupportedHint =>
      'OGG/Opus/WAV コンテナは埋め込みカバーアートに対応していないため、変換時にカバーは省略されます';

  @override
  String get opusMonoClamp =>
      'モノラル音源を検出したため、Opus ビットレートを 256 kbps（モノラル上限）に自動調整しました';

  @override
  String get decodeTailInfo =>
      '出力は完全で再生に問題ありません。ソースファイル末尾の付加データ（NetEase Cloud Music の FLAC ダウンロードに多く見られる）は無視されました';

  @override
  String get videoCodec => '動画コーデック';

  @override
  String get hardwareAccel => 'ハードウェアアクセラレーション';

  @override
  String get hardwareAccelHint =>
      'GPU/iGPU でエンコードして高速化。利用可否はデバイスと ffmpeg のビルドに依存';

  @override
  String get hwEncoder => 'ハードウェアエンコーダー';

  @override
  String get hwEncoderHint =>
      '利用可能なハードウェアエンコーダーが見つかりません。GPU ドライバーや ffmpeg のビルドを確認してください';

  @override
  String get hwPreset => 'ハードウェアプリセット';

  @override
  String get hwPresetNvencHint => 'NVENC：p1 が最速、p7 が最高品質（既定 p4）';

  @override
  String get hwPresetQsvHint => 'QSV：veryfast が最速、veryslow が最高品質（既定 medium）';

  @override
  String get hwPresetAmfHint => 'AMF：speed が最速、high_quality が最高品質（既定 balanced）';

  @override
  String get codecCopy => 'そのままコピー';

  @override
  String get preset => 'プリセット';

  @override
  String get presetUltrafast => 'Ultrafast · ファイル最大';

  @override
  String get presetSuperfast => 'Superfast · かなり大きい';

  @override
  String get presetVeryfast => 'Veryfast · 大きい';

  @override
  String get presetFaster => 'Faster';

  @override
  String get presetFast => 'Fast';

  @override
  String get presetMedium => 'Medium（既定）';

  @override
  String get presetSlow => 'Slow · 圧縮率が良い';

  @override
  String get presetSlower => 'Slower · ファイル小';

  @override
  String get presetVeryslow => 'Veryslow · 最小';

  @override
  String get presetAv1Slow => '非常に遅い · 圧縮率最高';

  @override
  String get presetAv1MedSlow => '遅い · 高圧縮';

  @override
  String get presetAv1Balanced => 'バランス（既定）';

  @override
  String get presetAv1Fast => '速い · ファイル大';

  @override
  String get presetAv1Fastest => '最速 · 品質低下あり';

  @override
  String get presetHintX264 =>
      'プリセットは品質ではなく速度とファイルサイズに影響します：速い→大きい、遅い→圧縮率が高い。medium がバランスの既定値';

  @override
  String get presetHintAv1 =>
      'preset の値が小さいほど遅く圧縮率が高く（ファイルが小さく）なり、大きいほど速くなります。既定 8 がバランス点';

  @override
  String get resolution => '解像度';

  @override
  String get resolutionKeep => '元のまま';

  @override
  String get customEllipsis => 'カスタム…';

  @override
  String get resolutionHint => '幅に合わせて縦横比を保ったまま拡大縮小します（歪みません）';

  @override
  String get customWidth => '幅';

  @override
  String get customHeight => '高さ';

  @override
  String get crfQuality => 'CRF 品質';

  @override
  String crfHint(String codec, int max) {
    return '値が小さいほど画質が高くファイルも大きくなります。$codec の範囲 0-$max（既定 23。28 を超えると画質低下が目立ちます）';
  }

  @override
  String get targetBitrate => '目標ビットレート';

  @override
  String get maxBitrate => '最大ビットレート';

  @override
  String get bitrateVideoHint =>
      'ビットレートが高いほど画質は良くファイルは大きくなります。1080p では 4000–12000 kbps を推奨';

  @override
  String get frameRate => 'フレームレート';

  @override
  String get frameRateHint =>
      '通常は元のままが最適です。変更するとフレームの削除・複製が発生し、滑らかさに影響することがあります';

  @override
  String get audioTrack => '音声トラック';

  @override
  String get audioTrackHint => 'そのまま = 無劣化でコピー（最速）。AAC/MP3 は再エンコードします';

  @override
  String get trackKeep => 'そのまま維持';

  @override
  String get trackAac => 'AAC に再エンコード';

  @override
  String get trackMp3 => 'MP3 に再エンコード';

  @override
  String get trackNone => '音声を削除';

  @override
  String get audioBitrate => '音声ビットレート';

  @override
  String get compatMode => '互換モード (yuv420p)';

  @override
  String get compatModeHint => 'プレイヤーや編集ソフトで広く使えるピクセル形式を使用';

  @override
  String get muxInput => '多重化の入力';

  @override
  String get muxNoReencode => '純粋な多重化 · 再エンコードなし';

  @override
  String get videoFile => '動画ファイル';

  @override
  String get videoFileHint => '映像トラックの元（必須）';

  @override
  String get audioFiles => '音声ファイル';

  @override
  String get audioFilesHint => '音声トラックの元。複数可（任意。指定なしならコンテナ変更のみ）';

  @override
  String get container => 'コンテナ';

  @override
  String get muxInfo =>
      '多重化は -c copy で全トラックをそのままコピーするため高速かつ無劣化です。出力コンテナが元コーデックに対応している必要があります（例：MP4 は通常 H.264/H.265 + AAC）';

  @override
  String get select => '選択';

  @override
  String get clear => 'クリア';

  @override
  String get outputContainer => '出力コンテナ';

  @override
  String get autoContainer => '自動（入力と同形式）';

  @override
  String get compatReencode => '互換モード（再エンコード）';

  @override
  String get compatReencodeHint => 'コーデックや設定が異なる場合、H.265 + AAC に再エンコードしてから結合';

  @override
  String get concatKindVideo => '動画結合';

  @override
  String get concatKindAudio => '音声結合';

  @override
  String get concatAudioInfoCopy =>
      '音声結合は既定で音声ストリームを直接コピーします。セグメントの設定が異なる場合や結合に失敗する場合は互換モード（WAV出力）を有効にしてください';

  @override
  String get concatAudioInfoReencode =>
      '互換モード：各セグメントを WAV に変換してから結合。コーデック・サンプルレート・チャンネルが異なっても対応';

  @override
  String get compatReencodeAudioHint =>
      '各セグメントを WAV（PCM）に変換してから結合し、設定が異なる音源に対応';

  @override
  String get concatInfoCopy =>
      'コピーモード（既定）は再エンコードせず直接結合：高速・無劣化。ただし全セグメントのコーデック・サンプリングレート・フレームレートなどを揃える必要があります';

  @override
  String get concatInfoReencode =>
      '互換モードは全セグメントを再エンコード（H.265 + AAC 256k、最大解像度に統一）するため何でも結合できますが、品質と時間を犠牲にします';

  @override
  String get logTitle => 'ffmpeg ログ';

  @override
  String get copyLog => 'ログをコピー';

  @override
  String get logCopied => 'ログをクリップボードにコピーしました';

  @override
  String get noLog => 'ログはありません';

  @override
  String get settings => '設定';

  @override
  String get engineSettings => 'ffmpeg 設定';

  @override
  String get aboutTitle => 'FFCraft について';

  @override
  String get versionLabel => 'バージョン';

  @override
  String get currentStatus => '現在の状態';

  @override
  String get engineAvailable => 'ffmpeg 使用可';

  @override
  String get engineUnavailable => 'ffmpeg 使用不可';

  @override
  String get detecting => 'ffmpeg を検出中…';

  @override
  String get manualDirLabel => '手動でフォルダーを指定（空欄 = 自動検出）';

  @override
  String get manualDirHint => '例：/usr/bin または E:\\ffmpeg\\bin';

  @override
  String get manualSpecify => '手動指定…';

  @override
  String get clearManual => '手動指定を解除';

  @override
  String get autoFindOrder =>
      '検索順：手動指定 → アプリの隣の ffmpeg フォルダー\n→ システム PATH → 一般的な場所（例：/usr/bin、/opt/ffmpeg、C:\\ffmpeg）';

  @override
  String get restoreAuto => '自動に戻す';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String versionLine(String version) {
    return 'FFCraft · v$version';
  }

  @override
  String get copyrightLine => '著作権 © 2026 万能的乌沙科夫（@FyodorUshakov）';

  @override
  String get githubLine =>
      'GitHub：万能的乌沙科夫（@FyodorUshakov）\nhttps://github.com/FyodorUshakov';

  @override
  String get licenseTitle => 'オープンソースライセンス';

  @override
  String get licenseText =>
      '本プロジェクトは MIT ライセンスで公開され、自由な利用・改変・再配布を許可します。\nffmpeg は外部プログラムとして呼び出され、独自のオープンソースライセンス（GPL/LGPL 等）に従います。本プロジェクトの MIT ライセンスには含まれません。';

  @override
  String get thirdPartyTitle => 'サードパーティ製コンポーネント';

  @override
  String get thirdPartyText =>
      'ffmpeg（https://ffmpeg.org）— 音声・動画処理エンジン（外部呼び出し）';

  @override
  String get language => '言語';

  @override
  String manualDirValue(String dir) {
    return '手動指定：$dir';
  }

  @override
  String autoDirValue(String dir) {
    return '自動検出：$dir';
  }

  @override
  String get themeSettings => '配色';

  @override
  String get presetPalette => 'プリセットパレット';

  @override
  String get followWallpaper => '壁紙に合わせる';

  @override
  String get fromWallpaper => '壁紙から取得';

  @override
  String get extracting => '取得中…';

  @override
  String get wallpaperHint => '現在の壁紙の主色をテーマに使用。失敗時はシステムのアクセントカラーにフォールバック';

  @override
  String get wallpaperOnlyWindows => '壁紙からの色取得は Windows のみ対応';

  @override
  String get customColor => 'カスタムカラー';

  @override
  String get customColorHint => 'カラーホイールをドラッグするか Hex を入力。選択後すぐ反映';

  @override
  String get restoreDefault => '既定に戻す';

  @override
  String get close => '閉じる';

  @override
  String get wallpaperColorLabel => '壁紙から';

  @override
  String get wallpaperFailed => '壁紙から色を取得できませんでした。現在の配色を維持します';

  @override
  String get currentTheme => '現在のテーマ';

  @override
  String get sourcePreset => 'プリセット';

  @override
  String get sourceCustom => 'カスタム';

  @override
  String get sourceWallpaper => '壁紙';

  @override
  String get colorDefault => '既定 · ライトブルー';

  @override
  String get colorBlue => 'ブルー';

  @override
  String get colorCyan => 'シアン';

  @override
  String get colorTeal => 'ティール';

  @override
  String get colorGreen => 'グリーン';

  @override
  String get colorLime => 'ライム';

  @override
  String get colorAmber => 'アンバー';

  @override
  String get colorOrange => 'オレンジ';

  @override
  String get colorCoral => 'コーラル';

  @override
  String get colorPink => 'ピンク';

  @override
  String get colorPurple => 'パープル';

  @override
  String get colorViolet => 'バイオレット';

  @override
  String get colorIndigo => 'インディゴ';

  @override
  String get colorBlueGrey => 'ブルーグレー';

  @override
  String addedFiles(int n) {
    return '$n 個のファイルを追加しました';
  }

  @override
  String readDirFailed(String err) {
    return 'フォルダーを読み込めませんでした: $err';
  }

  @override
  String switchedMode(String mode) {
    return '「$mode」モードに切り替えました';
  }

  @override
  String startBatch(int n, String dir) {
    return '━━ 処理開始 ━━ タスク数 $n、ffmpeg：$dir';
  }

  @override
  String doneAll(int ok, int fail) {
    return 'すべて完了：成功 $ok 件、失敗 $fail 件';
  }

  @override
  String stoppedDone(int n) {
    return '停止しました（完了 $n 件）';
  }

  @override
  String get cancelled => 'キャンセルしました';

  @override
  String get stopping => '停止中…';

  @override
  String get decodeWarning => '⚠ デコードのエラー/警告が発生しました。元ファイルの完全性を確認してください';

  @override
  String get doneWithWarning => '完了（デコード警告あり）';

  @override
  String noOutput(String path) {
    return '出力ファイルが作成されませんでした：$path';
  }

  @override
  String engineDirMissing(String dir) {
    return '指定したフォルダーに ffmpeg が見つかりません：$dir';
  }

  @override
  String get engineNotFound => 'ffmpeg が見つかりません。設定でフォルダーを手動指定してください';

  @override
  String launchFailed(String err) {
    return '起動に失敗しました: $err';
  }

  @override
  String compatResolution(int w, int h) {
    return '互換モード：${w}x$h に統一（H.265 + AAC 256k）';
  }
}
