// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'FFCraft · 가벼운 오디오·비디오 툴박스 | Built with Flutter';

  @override
  String get appName => 'FFCraft';

  @override
  String get appSubtitle => '가벼운 오디오·비디오 툴박스 | Built with Flutter';

  @override
  String get modeAudio => '오디오 변환';

  @override
  String get modeVideo => '비디오 변환';

  @override
  String get modeMux => '먹싱';

  @override
  String get modeConcat => '연결';

  @override
  String get hintAudio =>
      '오디오 파일을 AAC / MP3 / FLAC / ALAC / WAV / Opus / OGG 등으로 변환';

  @override
  String get hintVideo => '비디오 코덱·해상도·비트레이트 변경, 오디오는 유지하거나 재인코딩';

  @override
  String get hintMux => '비디오와 오디오 트랙을 재인코딩 없이 새 컨테이너에 그대로 합치기';

  @override
  String get hintConcat => '같은 코덱의 여러 구간을 하나의 파일로 끊김 없이 연결';

  @override
  String settingsTitle(String mode) {
    return '설정 · $mode';
  }

  @override
  String get engineReady => 'ffmpeg 사용 가능';

  @override
  String get engineMissing => 'ffmpeg를 찾을 수 없음';

  @override
  String get tooltipTheme => '색상 구성';

  @override
  String get tooltipEngine => '설정';

  @override
  String get queueTitle => '파일 대기열';

  @override
  String itemCount(int n) {
    return '$n개';
  }

  @override
  String get addFiles => '파일 추가';

  @override
  String get addFolder => '폴더 추가';

  @override
  String get clearQueue => '대기열 비우기';

  @override
  String get dragFiles => '파일을 여기에 놓으세요';

  @override
  String get dragHintAudio => '오디오 파일을 여기에 놓으세요\n또는 오른쪽 위의 「파일 추가 / 폴더 추가」 사용';

  @override
  String get dragHintVideo => '비디오 파일을 여기에 놓으세요\n또는 오른쪽 위의 「파일 추가 / 폴더 추가」 사용';

  @override
  String get dragHintConcat =>
      '여러 오디오/비디오 파일을 여기에 놓으세요\n(부드러운 연결을 위해 코덱과 설정이 같아야 합니다)';

  @override
  String get dropMore => '여기에 파일이나 폴더를 더 놓으세요';

  @override
  String get remove => '제거';

  @override
  String get statusQueued => '대기 중';

  @override
  String get statusRunning => '처리 중';

  @override
  String get statusDone => '완료';

  @override
  String get statusFailed => '실패';

  @override
  String get statusCancelled => '취소됨';

  @override
  String get processing => '처리 중…';

  @override
  String get starting => '시작 중…';

  @override
  String doneTo(String path) {
    return '완료 → $path';
  }

  @override
  String failedExit(int code) {
    return '실패 (exit=$code)';
  }

  @override
  String get outputDir => '출력 폴더';

  @override
  String get sameAsSource => '원본과 동일';

  @override
  String get customDir => '직접 지정';

  @override
  String get browse => '찾아보기…';

  @override
  String get clearOutDir => '출력 폴더 지우기';

  @override
  String get parallelTasks => '병렬 작업 수';

  @override
  String get singleTaskNote => '（먹싱/연결은 단일 작업）';

  @override
  String get startAudio => '변환 시작';

  @override
  String get startVideo => '변환 시작';

  @override
  String get startMux => '먹싱 시작';

  @override
  String get startConcat => '연결 시작';

  @override
  String get needVideoFile => '먼저 비디오 파일을 선택하세요';

  @override
  String get needAudioFile => '먼저 오디오 파일을 추가하세요';

  @override
  String get needVideoFiles => '먼저 비디오 파일을 추가하세요';

  @override
  String get needTwoFiles => '파일을 2개 이상 추가하세요';

  @override
  String get stop => '중지';

  @override
  String get tooltipLogShow => '로그 보기';

  @override
  String get tooltipLogHide => '로그 접기';

  @override
  String get outputCodec => '출력 코덱';

  @override
  String get sampleRate => '샘플 레이트';

  @override
  String get sampleRateKeep => '원본 유지';

  @override
  String get sampleRateHint => '원본 유지가 가장 안전합니다. 통일이 필요할 때만 변경하세요';

  @override
  String get copyMetadata => '메타데이터 복사';

  @override
  String get copyMetadataHint => '제목·아티스트·커버 등 태그를 함께 보존';

  @override
  String get losslessParams => '무손실 설정';

  @override
  String get bitDepth => '비트 심도';

  @override
  String get bitDepthHint =>
      '비트 심도가 높을수록 다이내믹 레인지가 넓고 파일도 커집니다. 16bit≈CD 음질, 24bit는 녹음·마스터링에서 일반적';

  @override
  String get flacCompression => 'FLAC 압축 레벨';

  @override
  String get flacCompressionHint =>
      '레벨이 높을수록 압축률이 높아지지만 느려집니다. 0=가장 빠름, 8=가장 작음(기본 5)';

  @override
  String get bitrateControl => '비트레이트 제어';

  @override
  String get bitrateModeHint =>
      'CBR: 크기 안정. VBR: 같은 비트레이트에서 더 나은 품질. ABR: 두 방식의 절충.';

  @override
  String get modeCbr => 'CBR';

  @override
  String get modeVbr => 'VBR';

  @override
  String get modeAbr => 'ABR';

  @override
  String get bitrate => '비트레이트';

  @override
  String get bitrateHint =>
      '비트레이트가 높을수록 음질은 좋아지고 파일은 커집니다. 대부분의 음악은 128–256 kbps면 충분';

  @override
  String get opusVbrHint => 'Opus는 기본적으로 VBR을 사용합니다. CBR을 선택하면 VBR이 꺼집니다';

  @override
  String get qualityRangeMp3 => '0-9（0이 최고）';

  @override
  String get qualityRangeVorbis => '0-10（높을수록 좋음）';

  @override
  String get vbrQuality => 'VBR 품질';

  @override
  String qualityRangeHint(String range) {
    return '값이 낮을수록 품질이 높고 파일이 커지며, 높을수록 파일이 작아집니다（범위 $range）';
  }

  @override
  String get videoCodec => '비디오 코덱';

  @override
  String get hardwareAccel => '하드웨어 가속';

  @override
  String get hardwareAccelHint =>
      'GPU/iGPU로 인코딩해 더 빠르게 처리합니다. 사용 가능 여부는 기기와 ffmpeg 빌드에 따라 다릅니다';

  @override
  String get hwEncoder => '하드웨어 인코더';

  @override
  String get hwEncoderHint =>
      '사용 가능한 하드웨어 인코더가 없습니다. GPU 드라이버 또는 ffmpeg 빌드를 확인하세요';

  @override
  String get codecCopy => '그대로 복사';

  @override
  String get preset => '프리셋';

  @override
  String get presetUltrafast => 'Ultrafast · 파일 최대';

  @override
  String get presetSuperfast => 'Superfast · 파일 매우 큼';

  @override
  String get presetVeryfast => 'Veryfast · 파일 큼';

  @override
  String get presetFaster => 'Faster';

  @override
  String get presetFast => 'Fast';

  @override
  String get presetMedium => 'Medium（기본）';

  @override
  String get presetSlow => 'Slow · 압축률 우수';

  @override
  String get presetSlower => 'Slower · 파일 작음';

  @override
  String get presetVeryslow => 'Veryslow · 파일 최소';

  @override
  String get presetAv1Slow => '매우 느림 · 압축률 최고';

  @override
  String get presetAv1MedSlow => '느림 · 높은 압축';

  @override
  String get presetAv1Balanced => '균형（기본）';

  @override
  String get presetAv1Fast => '빠름 · 파일 큼';

  @override
  String get presetAv1Fastest => '최고 속도 · 품질 손실';

  @override
  String get presetHintX264 =>
      '프리셋은 품질이 아니라 속도와 파일 크기에 영향을 줍니다: 빠를수록 커지고, 느릴수록 압축률이 높아집니다. medium이 기본 균형값';

  @override
  String get presetHintAv1 =>
      'preset 값이 낮을수록 인코딩이 느리고 압축률이 높으며(파일이 작고) 높을수록 빨라집니다. 기본 8이 균형점';

  @override
  String get resolution => '해상도';

  @override
  String get resolutionKeep => '원본 유지';

  @override
  String get customEllipsis => '사용자 지정…';

  @override
  String get resolutionHint => '너비에 맞춰 비율을 유지하며 크기가 조정됩니다（늘어지지 않음）';

  @override
  String get customWidth => '너비';

  @override
  String get customHeight => '높이';

  @override
  String get crfQuality => 'CRF 품질';

  @override
  String crfHint(String codec, int max) {
    return '값이 낮을수록 화질이 좋고 파일도 커집니다. $codec 범위 0-$max（기본 23；28을 넘으면 화질 저하가 눈에 띕니다）';
  }

  @override
  String get targetBitrate => '목표 비트레이트';

  @override
  String get maxBitrate => '최대 비트레이트';

  @override
  String get bitrateVideoHint =>
      '비트레이트가 높을수록 화질은 좋아지고 파일은 커집니다. 1080p에서는 4000–12000 kbps 권장';

  @override
  String get frameRate => '프레임 레이트';

  @override
  String get frameRateHint =>
      '보통 원본 유지가 가장 좋습니다. 변경하면 프레임이 버려지거나 중복되어 부드러움에 영향이 있을 수 있습니다';

  @override
  String get audioTrack => '오디오 트랙';

  @override
  String get audioTrackHint => '그대로 = 손실 없이 복사(가장 빠름). AAC/MP3는 재인코딩합니다';

  @override
  String get trackKeep => '그대로 유지';

  @override
  String get trackAac => 'AAC로 재인코딩';

  @override
  String get trackMp3 => 'MP3로 재인코딩';

  @override
  String get trackNone => '오디오 제거';

  @override
  String get audioBitrate => '오디오 비트레이트';

  @override
  String get compatMode => '호환 모드 (yuv420p)';

  @override
  String get compatModeHint => '플레이어와 편집 프로그램에서 널리 호환되는 픽셀 형식 사용';

  @override
  String get muxInput => '먹싱 입력';

  @override
  String get muxNoReencode => '순수 먹싱 · 재인코딩 없음';

  @override
  String get videoFile => '비디오 파일';

  @override
  String get videoFileHint => '비디오 트랙의 원본(필수)';

  @override
  String get audioFiles => '오디오 파일';

  @override
  String get audioFilesHint => '오디오 트랙의 원본. 여러 개 가능(선택. 없으면 컨테이너만 변경)';

  @override
  String get container => '컨테이너';

  @override
  String get muxInfo =>
      '먹싱은 -c copy로 모든 트랙을 그대로 복사하므로 매우 빠르고 무손실입니다. 출력 컨테이너가 원본 코덱을 지원해야 합니다（예: MP4는 보통 H.264/H.265 + AAC）';

  @override
  String get select => '선택';

  @override
  String get clear => '지우기';

  @override
  String get outputContainer => '출력 컨테이너';

  @override
  String get autoContainer => '자동（입력과 동일）';

  @override
  String get compatReencode => '호환 모드（재인코딩）';

  @override
  String get compatReencodeHint => '코덱이나 설정이 다르면 H.265 + AAC로 재인코딩한 뒤 연결';

  @override
  String get concatInfoCopy =>
      '복사 모드（기본）는 재인코딩 없이 직접 연결합니다: 빠르고 무손실이지만 모든 구간의 코덱·샘플 레이트·프레임 레이트 등이 같아야 합니다.';

  @override
  String get concatInfoReencode =>
      '호환 모드는 모든 구간을 재인코딩（H.265 + AAC 256k, 최고 해상도로 통일）하여 무엇이든 연결할 수 있지만 품질과 시간을 희생합니다.';

  @override
  String get logTitle => 'ffmpeg 로그';

  @override
  String get copyLog => '로그 복사';

  @override
  String get logCopied => '로그가 클립보드에 복사되었습니다';

  @override
  String get noLog => '로그 없음';

  @override
  String get settings => '설정';

  @override
  String get engineSettings => 'ffmpeg 설정';

  @override
  String get aboutTitle => 'FFCraft 정보';

  @override
  String get versionLabel => '버전';

  @override
  String get currentStatus => '현재 상태';

  @override
  String get engineAvailable => 'ffmpeg 사용 가능';

  @override
  String get engineUnavailable => 'ffmpeg 사용 불가';

  @override
  String get detecting => 'ffmpeg 감지 중…';

  @override
  String get manualDirLabel => '폴더 수동 지정（비워 두면 자동 검색）';

  @override
  String get manualDirHint => '예: /usr/bin 또는 E:\\ffmpeg\\bin';

  @override
  String get manualSpecify => '수동 지정…';

  @override
  String get clearManual => '수동 지정 해제';

  @override
  String get autoFindOrder =>
      '검색 순서: 수동 지정 → 프로그램 옆 ffmpeg 폴더\n→ 시스템 PATH → 일반적인 위치（예: /usr/bin, /opt/ffmpeg, C:\\ffmpeg）';

  @override
  String get restoreAuto => '자동으로 복원';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String versionLine(String version) {
    return 'FFCraft · v$version';
  }

  @override
  String get copyrightLine => '저작권 © 2026 万能的乌沙科夫（@FyodorUshakov）';

  @override
  String get githubLine =>
      'GitHub：万能的乌沙科夫（@FyodorUshakov）\nhttps://github.com/FyodorUshakov';

  @override
  String get licenseTitle => '오픈소스 라이선스';

  @override
  String get licenseText =>
      '이 프로젝트는 MIT 라이선스로 공개되어 자유로운 사용·수정·배포를 허용합니다.\nffmpeg는 외부 프로그램으로 호출되며 자체 오픈소스 라이선스(GPL/LGPL 등)를 따릅니다. 이 프로젝트의 MIT 라이선스에는 포함되지 않습니다.';

  @override
  String get thirdPartyTitle => '타사 구성 요소';

  @override
  String get thirdPartyText =>
      'ffmpeg（https://ffmpeg.org）— 오디오·비디오 처리 엔진（외부 호출）';

  @override
  String get language => '언어';

  @override
  String manualDirValue(String dir) {
    return '수동 지정: $dir';
  }

  @override
  String autoDirValue(String dir) {
    return '자동 감지: $dir';
  }

  @override
  String get themeSettings => '색상 구성';

  @override
  String get presetPalette => '프리셋 팔레트';

  @override
  String get followWallpaper => '배경화면 따르기';

  @override
  String get fromWallpaper => '배경화면에서 색 추출';

  @override
  String get extracting => '추출 중…';

  @override
  String get wallpaperHint => '현재 배경화면의 주 색상을 테마로 사용. 실패하면 시스템 강조색으로 대체';

  @override
  String get wallpaperOnlyWindows => '배경화면 색 추출은 Windows에서만 지원';

  @override
  String get customColor => '사용자 지정 색상';

  @override
  String get customColorHint => '컬러 휠을 드래그하거나 Hex 입력. 선택 즉시 적용';

  @override
  String get restoreDefault => '기본값 복원';

  @override
  String get close => '닫기';

  @override
  String get wallpaperColorLabel => '배경화면에서';

  @override
  String get wallpaperFailed => '배경화면에서 색을 추출하지 못했습니다. 현재 구성을 유지합니다';

  @override
  String get currentTheme => '현재 테마';

  @override
  String get sourcePreset => '프리셋';

  @override
  String get sourceCustom => '사용자 지정';

  @override
  String get sourceWallpaper => '배경화면';

  @override
  String get colorDefault => '기본 · 라이트 블루';

  @override
  String get colorBlue => '블루';

  @override
  String get colorCyan => '시안';

  @override
  String get colorTeal => '틸';

  @override
  String get colorGreen => '그린';

  @override
  String get colorLime => '라임';

  @override
  String get colorAmber => '앰버';

  @override
  String get colorOrange => '오렌지';

  @override
  String get colorCoral => '코랄';

  @override
  String get colorPink => '핑크';

  @override
  String get colorPurple => '퍼플';

  @override
  String get colorViolet => '바이올렛';

  @override
  String get colorIndigo => '인디고';

  @override
  String get colorBlueGrey => '블루 그레이';

  @override
  String addedFiles(int n) {
    return '파일 $n개를 추가했습니다';
  }

  @override
  String readDirFailed(String err) {
    return '폴더를 읽지 못했습니다: $err';
  }

  @override
  String switchedMode(String mode) {
    return '「$mode」모드로 전환했습니다';
  }

  @override
  String startBatch(int n, String dir) {
    return '━━ 처리 시작 ━━ 작업 $n개, ffmpeg: $dir';
  }

  @override
  String doneAll(int ok, int fail) {
    return '모두 완료: 성공 $ok개, 실패 $fail개';
  }

  @override
  String stoppedDone(int n) {
    return '중지됨（완료 $n개）';
  }

  @override
  String get cancelled => '취소됨';

  @override
  String get stopping => '중지 중…';

  @override
  String get decodeWarning => '⚠ 디코딩 오류/경고가 발생했습니다. 원본 파일이 온전한지 확인하세요';

  @override
  String get doneWithWarning => '완료（디코딩 경고 있음）';

  @override
  String noOutput(String path) {
    return '출력 파일이 생성되지 않았습니다: $path';
  }

  @override
  String engineDirMissing(String dir) {
    return '지정한 폴더에서 ffmpeg.exe를 찾을 수 없습니다: $dir';
  }

  @override
  String get engineNotFound => 'ffmpeg.exe를 찾을 수 없습니다. 설정에서 폴더를 수동 지정하세요';

  @override
  String launchFailed(String err) {
    return '시작 실패: $err';
  }

  @override
  String compatResolution(int w, int h) {
    return '호환 모드: ${w}x$h로 통일（H.265 + AAC 256k）';
  }
}
