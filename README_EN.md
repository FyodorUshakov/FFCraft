# FFCraft

[简体中文](README.md) | **English**

A lightweight audio & video toolkit (Built with Flutter) powered by ffmpeg:
audio/video conversion, lossless muxing, and concatenation — wrapped in a clean
Material 3 UI with light-blue theming, automatic dark mode, bundled MiSans &
Cascadia Mono fonts, and 6 UI languages.

Multi-language UI: 简体中文, 繁體中文, English, Русский, 日本語, 한국어.
Switch under Settings → Language (applies immediately and is remembered);
Settings → About FFCraft shows the version, copyright, MIT license and GitHub info.

## Features

### Audio conversion

- Output codecs: AAC, MP3, FLAC, ALAC, WAV (PCM), Opus, Vorbis (OGG)
- Sample rate: keep original / 44.1k / 48k / 88.2k / 96k / 192k
- Lossy encoding: CBR, VBR (quality), ABR
- Lossless encoding: 16 / 24 / 32-bit; FLAC compression level 0-8
- Optionally copy or drop metadata (title, artist, cover, etc.)

### Video conversion

- Codecs: H.264, H.265 (HEVC), AV1, VP9, MPEG-4, or copy the video track as-is
- Bitrate control: CRF quality, CBR, VBR (target + max), ABR
- Resolution: keep / 1080p / 720p / 480p / 360p / custom (aspect-kept)
- Frame rate: keep / 23.976 / 24 / 25 / 30 / 50 / 60
- Audio track: keep as-is (default), re-encode to AAC/MP3, or remove
- Presets (x264/x265/AV1), yuv420p compatibility mode, metadata toggle

### Muxing (no re-encoding)

- Pick one video file plus one or more audio files; all tracks are copied with `-c copy`
- Containers: MP4 / MKV / MOV / WebM / TS
- Single-file container change is also supported

### Concatenation

- Copy mode (default): `concat demuxer + -c copy`, lossless; segments must share
  the same codec and settings
- Compatibility mode: re-encode to H.265 + AAC before joining

## Requirements

`ffmpeg` must be installed (ffmpeg.exe on Windows, ffmpeg on Linux/macOS).
The app searches in this order:

1. Manual path (changeable in Settings)
2. An `ffmpeg` folder next to the app
3. System PATH (`where` / `which`)
4. Common locations (e.g. /usr/bin, /opt/ffmpeg, C:\ffmpeg)

## Installing ffmpeg

FFCraft invokes ffmpeg externally, so install it first.

### Downloads

- **Windows**: [gyan.dev builds](https://www.gyan.dev/ffmpeg/builds/) (release-full recommended)
  or [BtbN builds](https://github.com/BtbN/FFmpeg-Builds/releases)
- **Linux**: prefer your package manager (below), or
  [johnvansickle static builds](https://johnvansickle.com/ffmpeg/)
- **macOS**: prefer Homebrew (below), or [evermeet builds](https://evermeet.cx/ffmpeg/)

### Windows

1. Download `release-full.7z` and extract it (7-Zip)
2. Add the `bin` folder to your system PATH (e.g. `C:\ffmpeg\bin`)
3. Verify in a new terminal: `ffmpeg -version`

FFCraft finds it through PATH and also checks common locations like `C:\ffmpeg`.

### Linux

- Debian / Ubuntu: `sudo apt update && sudo apt install ffmpeg`
- Fedora / RHEL: `sudo dnf install ffmpeg`
- Arch: `sudo pacman -S ffmpeg`

Verify with `ffmpeg -version`; the app finds it via PATH (usually /usr/bin).

### macOS

1. Install [Homebrew](https://brew.sh/) and run: `brew install ffmpeg`
2. Apple Silicon: `/opt/homebrew/bin`; Intel: `/usr/local/bin` (usually on PATH)
3. Verify: `ffmpeg -version`

The app also checks `/opt/homebrew/bin`, `/usr/local/bin`, etc.

> Tip: you can also place the ffmpeg binary in an `ffmpeg` folder next to the app.

## Development (Windows / Linux / macOS)

```powershell
flutter pub get
flutter run -d windows
```

```bash
flutter pub get
flutter run -d linux    # or -d macos
```

## CI

The repository includes a GitHub Actions workflow (`.github/workflows/build.yml`)
that runs analyze, tests and release builds on Windows / Linux / macOS and uploads
the artifacts. Pushing a `v*` version tag automatically creates a GitHub Release.

## Packaging (Windows)

```powershell
.\build_release.ps1
```

Outputs under `dist\`:

| Artifact | Description |
| --- | --- |
| `ffmpeg_GUI_Flutter\` | Portable folder, copy and run |
| `ffmpeg_GUI_v1.5.0_portable.zip` | Portable archive; unzip and double-click `ffmpeg_GUI.exe` |

## License

This project is open source under the [MIT](LICENSE) License. ffmpeg is invoked
as an external program and is covered by its own licenses (e.g. GPL/LGPL); it is
not part of this project's MIT license.

## Notes

- Output files keep the source name and folder by default (extension follows the
  format); a `_out` suffix is added automatically on name collision.
- Batch jobs run 1-8 in parallel; muxing/concatenation run as a single job.
- Queue items show format, size, duration and bitrate metadata; newly added items
  show a format icon, running items show a progress ring/bar, and completed items
  turn into a green check.
- A dashed drop zone at the bottom of the list accepts more files or folders.
- The log expands automatically with highlighting (dim timestamps, red errors,
  orange warnings, blue progress), one-click copy, and a
  "done with decode warnings" hint when needed.
- Self-test: set `FFMPEG_SELFTEST=1`, `FFMPEG_SELFTEST_MODE=audio|video|mux|concat`,
  `FFMPEG_SELFTEST_FILES=<pipe-separated>`, `FFMPEG_SELFTEST_OUTDIR=<dir>` and
  `FFMPEG_SELFTEST_OUT=<file>`, then start the app to verify the flow.

## Project structure

```
ffmpeg_GUI_Flutter/
├── lib/
│   ├── models/          # per-mode settings & ffmpeg argument generation
│   ├── services/        # ffmpeg discovery, probing, job building
│   ├── state/           # global state & batch execution
│   ├── screens/         # main UI
│   └── widgets/         # queue/mux panels, forms, log, settings & about
├── assets/fonts/        # bundled MiSans + Cascadia Mono
├── windows/ linux/ macos/   # platform runners
├── tools/               # icon generation
├── test/                # argument & UI tests
├── build_release.ps1    # Windows packaging script
└── README.md / README_EN.md
```
