// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle =>
      'FFCraft · Лёгкий аудио-видео инструментарий | Built with Flutter';

  @override
  String get appName => 'FFCraft';

  @override
  String get appSubtitle =>
      'Лёгкий аудио-видео инструментарий | Built with Flutter';

  @override
  String get modeAudio => 'Аудио';

  @override
  String get modeVideo => 'Видео';

  @override
  String get modeMux => 'Муксинг';

  @override
  String get modeConcat => 'Склейка';

  @override
  String get hintAudio =>
      'Конвертация аудиофайлов в AAC / MP3 / FLAC / ALAC / WAV / Opus / OGG и другие форматы';

  @override
  String get hintVideo =>
      'Изменение кодека, разрешения и битрейта видео; звук можно сохранить или перекодировать';

  @override
  String get hintMux =>
      'Объединение видео- и аудиодорожек в новый контейнер без перекодирования';

  @override
  String get hintConcat =>
      'Бесшовное объединение нескольких сегментов с одинаковым кодеком в один файл';

  @override
  String settingsTitle(String mode) {
    return 'Настройки · $mode';
  }

  @override
  String get engineReady => 'ffmpeg готов';

  @override
  String get engineMissing => 'ffmpeg не найден';

  @override
  String get tooltipTheme => 'Цветовая схема';

  @override
  String get tooltipEngine => 'Настройки';

  @override
  String get queueTitle => 'Очередь файлов';

  @override
  String itemCount(int n) {
    return '$n';
  }

  @override
  String get addFiles => 'Добавить файлы';

  @override
  String get addFolder => 'Добавить папку';

  @override
  String get clearQueue => 'Очистить очередь';

  @override
  String get dragFiles => 'Перетащите файлы сюда';

  @override
  String get dragHintAudio =>
      'Перетащите аудиофайлы сюда\nили используйте «Добавить файлы / Добавить папку» справа вверху';

  @override
  String get dragHintVideo =>
      'Перетащите видеофайлы сюда\nили используйте «Добавить файлы / Добавить папку» справа вверху';

  @override
  String get dragHintConcat =>
      'Перетащите несколько аудио/видеофайлов сюда\n(сегменты должны иметь одинаковый кодек и параметры для плавной склейки)';

  @override
  String get dropMore => 'Перетащите сюда больше файлов или папок';

  @override
  String get remove => 'Удалить';

  @override
  String get statusQueued => 'В очереди';

  @override
  String get statusRunning => 'Обработка';

  @override
  String get statusDone => 'Готово';

  @override
  String get statusFailed => 'Ошибка';

  @override
  String get statusCancelled => 'Отменено';

  @override
  String get processing => 'Обработка…';

  @override
  String get starting => 'Запуск…';

  @override
  String doneTo(String path) {
    return 'Готово → $path';
  }

  @override
  String failedExit(int code) {
    return 'Ошибка (exit=$code)';
  }

  @override
  String get outputDir => 'Папка вывода';

  @override
  String get sameAsSource => 'Как у источника';

  @override
  String get customDir => 'Своя папка';

  @override
  String get browse => 'Обзор…';

  @override
  String get clearOutDir => 'Очистить папку вывода';

  @override
  String get parallelTasks => 'Параллельных задач';

  @override
  String get singleTaskNote => '(муксинг/склейка — одна задача)';

  @override
  String get startAudio => 'Начать';

  @override
  String get startVideo => 'Начать';

  @override
  String get startMux => 'Начать муксинг';

  @override
  String get startConcat => 'Начать склейку';

  @override
  String get needVideoFile => 'Сначала выберите видеофайл';

  @override
  String get needAudioFile => 'Сначала добавьте аудиофайлы';

  @override
  String get needVideoFiles => 'Сначала добавьте видеофайлы';

  @override
  String get needTwoFiles => 'Добавьте минимум 2 файла';

  @override
  String get stop => 'Стоп';

  @override
  String get tooltipLogShow => 'Показать журнал';

  @override
  String get tooltipLogHide => 'Скрыть журнал';

  @override
  String get outputCodec => 'Выходной кодек';

  @override
  String get sampleRate => 'Частота дискретизации';

  @override
  String get sampleRateKeep => 'Как у источника';

  @override
  String get sampleRateHint =>
      'Оставлять исходную — надёжнее; меняйте только при необходимости единой частоты';

  @override
  String get copyMetadata => 'Копировать метаданные';

  @override
  String get copyMetadataHint =>
      'Сохранять теги: название, исполнитель, обложка и др.';

  @override
  String get losslessParams => 'Параметры без потерь';

  @override
  String get bitDepth => 'Битовая глубина';

  @override
  String get bitDepthHint =>
      'Больше бит — шире динамический диапазон и крупнее файл; 16 бит ≈ качество CD, 24 бита — стандарт записи и мастеринга';

  @override
  String get flacCompression => 'Уровень сжатия FLAC';

  @override
  String get flacCompressionHint =>
      'Выше уровень — сильнее сжатие, но медленнее; 0 — быстрее всего, 8 — меньше всего (по умолчанию 5)';

  @override
  String get bitrateControl => 'Контроль битрейта';

  @override
  String get bitrateModeHint =>
      'CBR: стабильный размер. VBR: лучшее качество при том же битрейте. ABR: компромисс между ними.';

  @override
  String get modeCbr => 'CBR';

  @override
  String get modeVbr => 'VBR';

  @override
  String get modeAbr => 'ABR';

  @override
  String get bitrate => 'Битрейт';

  @override
  String get bitrateHint =>
      'Выше битрейт — лучше качество и крупнее файл; для большинства музыки достаточно 128–256 кбит/с';

  @override
  String get opusVbrHint =>
      'Opus по умолчанию использует VBR; выбор CBR отключит его';

  @override
  String get qualityRangeMp3 => '0-9 (0 — максимум)';

  @override
  String get qualityRangeVorbis => '0-10 (больше — лучше)';

  @override
  String get vbrQuality => 'Качество VBR';

  @override
  String qualityRangeHint(String range) {
    return 'Меньше значение — выше качество и крупнее файл; больше — файл меньше (диапазон $range)';
  }

  @override
  String get coverNotSupportedHint =>
      'Контейнеры OGG/Opus/WAV не поддерживают встроенные обложки — при конвертации обложка будет пропущена';

  @override
  String get decodeTailInfo =>
      'Вывод полный и нормально воспроизводится; дополнительные данные в конце исходного файла (часто бывают во FLAC, скачанных из NetEase Cloud Music) были проигнорированы';

  @override
  String get videoCodec => 'Видеокодек';

  @override
  String get hardwareAccel => 'Аппаратное ускорение';

  @override
  String get hardwareAccelHint =>
      'Кодирование на GPU/iGPU для большей скорости; доступность зависит от устройства и сборки ffmpeg';

  @override
  String get hwEncoder => 'Аппаратный кодировщик';

  @override
  String get hwEncoderHint =>
      'Аппаратные кодировщики не найдены; проверьте драйвер GPU или сборку ffmpeg';

  @override
  String get codecCopy => 'Как есть';

  @override
  String get preset => 'Пресет';

  @override
  String get presetUltrafast => 'Ultrafast · файлы крупнее';

  @override
  String get presetSuperfast => 'Superfast · очень крупные';

  @override
  String get presetVeryfast => 'Veryfast · крупные';

  @override
  String get presetFaster => 'Faster';

  @override
  String get presetFast => 'Fast';

  @override
  String get presetMedium => 'Medium (по умолчанию)';

  @override
  String get presetSlow => 'Slow · лучше сжатие';

  @override
  String get presetSlower => 'Slower · файлы меньше';

  @override
  String get presetVeryslow => 'Veryslow · самые маленькие';

  @override
  String get presetAv1Slow => 'Очень медленно · лучшее сжатие';

  @override
  String get presetAv1MedSlow => 'Медленно · высокое сжатие';

  @override
  String get presetAv1Balanced => 'Баланс (по умолчанию)';

  @override
  String get presetAv1Fast => 'Быстро · файлы крупнее';

  @override
  String get presetAv1Fastest => 'Очень быстро · больше потерь';

  @override
  String get presetHintX264 =>
      'Пресет влияет только на скорость и размер файла, не на качество: быстрее → крупнее, медленнее → лучше сжатие. medium — сбалансированный вариант.';

  @override
  String get presetHintAv1 =>
      'Меньше значение — медленнее кодирование и лучше сжатие (файл меньше); больше — быстрее, но файл крупнее. По умолчанию 8 — баланс.';

  @override
  String get resolution => 'Разрешение';

  @override
  String get resolutionKeep => 'Как у источника';

  @override
  String get customEllipsis => 'Своё…';

  @override
  String get resolutionHint =>
      'Масштабирование пропорционально по ширине, высота автоматически; без искажений';

  @override
  String get customWidth => 'Ширина';

  @override
  String get customHeight => 'Высота';

  @override
  String get crfQuality => 'Качество CRF';

  @override
  String crfHint(String codec, int max) {
    return 'Меньше значение — выше качество и крупнее файл; $codec диапазон 0-$max (по умолчанию 23; выше 28 качество заметно падает)';
  }

  @override
  String get targetBitrate => 'Целевой битрейт';

  @override
  String get maxBitrate => 'Максимальный битрейт';

  @override
  String get bitrateVideoHint =>
      'Выше битрейт — лучше качество и крупнее файл; для 1080p рекомендуется 4000–12000 кбит/с';

  @override
  String get frameRate => 'Частота кадров';

  @override
  String get frameRateHint =>
      'Обычно лучше оставить как есть; изменение отбрасывает или дублирует кадры и может повлиять на плавность';

  @override
  String get audioTrack => 'Аудиодорожка';

  @override
  String get audioTrackHint =>
      'Как есть = копировать без изменений (быстро и без потерь); AAC/MP3 — перекодировать';

  @override
  String get trackKeep => 'Как есть';

  @override
  String get trackAac => 'Перекодировать в AAC';

  @override
  String get trackMp3 => 'Перекодировать в MP3';

  @override
  String get trackNone => 'Убрать звук';

  @override
  String get audioBitrate => 'Битрейт аудио';

  @override
  String get compatMode => 'Режим совместимости (yuv420p)';

  @override
  String get compatModeHint =>
      'Широко совместимый формат пикселей для плееров и редакторов';

  @override
  String get muxInput => 'Входные файлы';

  @override
  String get muxNoReencode => 'Чистый муксинг · без перекодирования';

  @override
  String get videoFile => 'Видеофайл';

  @override
  String get videoFileHint => 'Источник видеодорожки (обязательно)';

  @override
  String get audioFiles => 'Аудиофайлы';

  @override
  String get audioFilesHint =>
      'Источник аудиодорожек; можно несколько (необязательно — без них только смена контейнера)';

  @override
  String get container => 'Контейнер';

  @override
  String get muxInfo =>
      'Муксинг копирует все дорожки как есть (-c copy): очень быстро и без потерь. Контейнер должен поддерживать исходные кодеки (например, MP4 обычно содержит H.264/H.265 + AAC).';

  @override
  String get select => 'Выбрать';

  @override
  String get clear => 'Очистить';

  @override
  String get outputContainer => 'Выходной контейнер';

  @override
  String get autoContainer => 'Авто (как у входа)';

  @override
  String get compatReencode => 'Режим совместимости (перекодирование)';

  @override
  String get compatReencodeHint =>
      'Если сегменты различаются кодеком или параметрами, перед склейкой выполняется перекодирование в H.265 + AAC';

  @override
  String get concatInfoCopy =>
      'Режим копирования (по умолчанию) склеивает напрямую без перекодирования: быстро и без потерь, но сегменты должны совпадать по кодеку, частоте дискретизации, кадрам и т.д.';

  @override
  String get concatInfoReencode =>
      'Режим совместимости перекодирует все сегменты (H.265 + AAC 256k, единое максимальное разрешение), чтобы склеить что угодно — ценой качества и времени.';

  @override
  String get logTitle => 'Журнал ffmpeg';

  @override
  String get copyLog => 'Копировать журнал';

  @override
  String get logCopied => 'Журнал скопирован в буфер обмена';

  @override
  String get noLog => 'Журнал пуст';

  @override
  String get settings => 'Настройки';

  @override
  String get engineSettings => 'Настройки ffmpeg';

  @override
  String get aboutTitle => 'О FFCraft';

  @override
  String get versionLabel => 'Версия';

  @override
  String get currentStatus => 'Текущее состояние';

  @override
  String get engineAvailable => 'ffmpeg доступен';

  @override
  String get engineUnavailable => 'ffmpeg недоступен';

  @override
  String get detecting => 'Поиск ffmpeg…';

  @override
  String get manualDirLabel => 'Папка вручную (пусто = автоопределение)';

  @override
  String get manualDirHint => 'например /usr/bin или E:\\ffmpeg\\bin';

  @override
  String get manualSpecify => 'Указать вручную…';

  @override
  String get clearManual => 'Убрать ручной путь';

  @override
  String get autoFindOrder =>
      'Порядок поиска: ручной путь → папка ffmpeg рядом с программой\n→ системный PATH → частые места (например /usr/bin, /opt/ffmpeg, C:\\ffmpeg)';

  @override
  String get restoreAuto => 'Вернуть авто';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String versionLine(String version) {
    return 'FFCraft · v$version';
  }

  @override
  String get copyrightLine => 'Авторские права © 2026 万能的乌沙科夫 (@FyodorUshakov)';

  @override
  String get githubLine =>
      'GitHub: 万能的乌沙科夫 (@FyodorUshakov)\nhttps://github.com/FyodorUshakov';

  @override
  String get licenseTitle => 'Открытая лицензия';

  @override
  String get licenseText =>
      'Проект распространяется по лицензии MIT: свободное использование, изменение и распространение.\nffmpeg вызывается как внешняя программа и подчиняется собственным открытым лицензиям (например GPL/LGPL); в MIT-лицензию проекта не входит.';

  @override
  String get thirdPartyTitle => 'Сторонние компоненты';

  @override
  String get thirdPartyText =>
      'ffmpeg (https://ffmpeg.org) — движок обработки аудио/видео, вызывается извне.';

  @override
  String get language => 'Язык';

  @override
  String manualDirValue(String dir) {
    return 'Вручную: $dir';
  }

  @override
  String autoDirValue(String dir) {
    return 'Авто: $dir';
  }

  @override
  String get themeSettings => 'Цветовая схема';

  @override
  String get presetPalette => 'Палитра';

  @override
  String get followWallpaper => 'По обои';

  @override
  String get fromWallpaper => 'Взять из обоев';

  @override
  String get extracting => 'Извлечение…';

  @override
  String get wallpaperHint =>
      'Использовать основной цвет текущих обоев; при неудаче — системный акцентный цвет';

  @override
  String get wallpaperOnlyWindows =>
      'Цвет обоев поддерживается только в Windows';

  @override
  String get customColor => 'Свой цвет';

  @override
  String get customColorHint =>
      'Перетащите на цветовом круге или введите Hex; применяется сразу';

  @override
  String get restoreDefault => 'Вернуть по умолчанию';

  @override
  String get close => 'Закрыть';

  @override
  String get wallpaperColorLabel => 'Из обоев';

  @override
  String get wallpaperFailed =>
      'Не удалось взять цвет из обоев; схема сохранена';

  @override
  String get currentTheme => 'Текущая тема';

  @override
  String get sourcePreset => 'Пресет';

  @override
  String get sourceCustom => 'Свой';

  @override
  String get sourceWallpaper => 'Обои';

  @override
  String get colorDefault => 'По умолчанию · голубой';

  @override
  String get colorBlue => 'Синий';

  @override
  String get colorCyan => 'Циан';

  @override
  String get colorTeal => 'Бирюзовый';

  @override
  String get colorGreen => 'Зелёный';

  @override
  String get colorLime => 'Лаймовый';

  @override
  String get colorAmber => 'Янтарный';

  @override
  String get colorOrange => 'Оранжевый';

  @override
  String get colorCoral => 'Коралловый';

  @override
  String get colorPink => 'Розовый';

  @override
  String get colorPurple => 'Фиолетовый';

  @override
  String get colorViolet => 'Лиловый';

  @override
  String get colorIndigo => 'Индиго';

  @override
  String get colorBlueGrey => 'Серо-синий';

  @override
  String addedFiles(int n) {
    return 'Добавлено файлов: $n';
  }

  @override
  String readDirFailed(String err) {
    return 'Не удалось прочитать папку: $err';
  }

  @override
  String switchedMode(String mode) {
    return 'Режим: $mode';
  }

  @override
  String startBatch(int n, String dir) {
    return '━━ Начало обработки ━━ задач: $n, ffmpeg: $dir';
  }

  @override
  String doneAll(int ok, int fail) {
    return 'Готово: успешно $ok, ошибок $fail';
  }

  @override
  String stoppedDone(int n) {
    return 'Остановлено; выполнено: $n';
  }

  @override
  String get cancelled => 'Отменено';

  @override
  String get stopping => 'Остановка…';

  @override
  String get decodeWarning =>
      '⚠ Обнаружены ошибки/предупреждения декодирования; проверьте целостность исходного файла';

  @override
  String get doneWithWarning => 'Готово (с предупреждениями декодирования)';

  @override
  String noOutput(String path) {
    return 'Выходной файл не создан: $path';
  }

  @override
  String engineDirMissing(String dir) {
    return 'ffmpeg.exe не найден в указанной папке: $dir';
  }

  @override
  String get engineNotFound =>
      'ffmpeg.exe не найден. Укажите его папку вручную в настройках.';

  @override
  String launchFailed(String err) {
    return 'Не удалось запустить: $err';
  }

  @override
  String compatResolution(int w, int h) {
    return 'Режим совместимости: единый вывод ${w}x$h (H.265 + AAC 256k)';
  }
}
