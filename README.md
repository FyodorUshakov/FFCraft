# FFCraft

**简体中文** | [English](README_EN.md)

轻量影音工具箱（Built with Flutter）：基于 ffmpeg 的音视频图形化工具，支持音频转码、
视频转码、无损合流封装、音视频拼接。使用 Flutter / Material 3 开发，淡蓝主题并跟随系统
自动切换深色 / 浅色，全局内嵌 MiSans 字体保证中文渲染粗细均匀；日志使用内嵌
Cascadia Mono 等宽字体。

支持多语言：简体中文、繁體中文、English、Русский、日本語、한국어，
在「设置 → 语言」中切换，选择即时生效并自动记忆；「设置 → 关于 FFCraft」可查看
版本、版权、MIT 开源许可与 GitHub 信息。

## 功能

### 音频转码

- 输出编码：AAC、MP3、FLAC、ALAC、WAV (PCM)、Opus、Vorbis (OGG)
- 采样率：保持原样 / 44.1k / 48k / 88.2k / 96k / 192k
- 有损编码：固定码率（CBR）、可变码率（VBR 质量）、平均码率（ABR）
- 无损编码：位深 16 / 24 / 32 bit，FLAC 支持压缩等级 0-8
- 可选复制 / 丢弃元数据（标题、艺术家、封面等）

### 视频转码

- 输出编码：H.264、H.265 (HEVC)、AV1、VP9、MPEG-4，或原样复制视频轨
- 码率控制：CRF 质量（0-51 / 0-63）、固定码率、可变码率（目标+最大）、平均码率
- 分辨率：保持原样 / 1080p / 720p / 480p / 360p / 自定义（等比缩放）
- 帧率：保持 / 23.976 / 24 / 25 / 30 / 50 / 60
- 音轨：默认保持不变，也可转 AAC / MP3 或移除
- 编码预设（x264/x265/AV1）、yuv420p 兼容模式、元数据开关

### 合流封装（不重编码）

- 选择一个视频文件 + 一个或多个音频文件，所有轨道用 `-c copy` 原样封装
- 容器：MP4 / MKV / MOV / WebM / TS
- 也支持单个文件直接更换容器

### 拼接

- 复制模式（默认）：`concat demuxer + -c copy`，无质量损失，要求各段编码参数一致
- 兼容模式：重新编码为 H.265 + AAC 后再拼接，不同编码也能拼

## 环境要求

需要系统中存在 `ffmpeg`（Windows 为 `ffmpeg.exe`，Linux/macOS 为 `ffmpeg`）。
程序自动查找顺序：

1. 手动指定目录（设置中可改）
2. 程序旁的 `ffmpeg` 文件夹
3. 系统 PATH（`where` / `which`）
4. 常见安装位置（如 `/usr/bin`、`/opt/ffmpeg`、`C:\ffmpeg` 等）

## ffmpeg 安装与配置

FFCraft 通过外部调用 ffmpeg 工作，使用前需要先装好 ffmpeg（Windows 为 `ffmpeg.exe`）。

### 下载地址

- **Windows**：[gyan.dev 构建](https://www.gyan.dev/ffmpeg/builds/)（推荐 release-full）
  或 [BtbN 构建](https://github.com/BtbN/FFmpeg-Builds/releases)
- **Linux**：优先用系统包管理器（见下），或 [johnvansickle 静态构建](https://johnvansickle.com/ffmpeg/)
- **macOS**：优先 Homebrew（见下），或 [evermeet 构建](https://evermeet.cx/ffmpeg/)

### Windows

1. 下载 `release-full.7z` 并用 7-Zip 解压
2. 把解压出的 `bin` 目录加入系统 PATH（例如 `C:\ffmpeg\bin`）
3. 新开终端验证：`ffmpeg -version`

FFCraft 会通过 PATH 自动找到，也会检查 `C:\ffmpeg`、`E:\ffmpeg` 等常见目录。

### Linux

- Debian / Ubuntu：`sudo apt update && sudo apt install ffmpeg`
- Fedora / RHEL：`sudo dnf install ffmpeg`
- Arch：`sudo pacman -S ffmpeg`

装完后 `ffmpeg -version` 验证；程序通过 PATH 自动找到（通常位于 `/usr/bin`）。

### macOS

1. 安装 [Homebrew](https://brew.sh/) 后执行：`brew install ffmpeg`
2. Apple Silicon 装到 `/opt/homebrew/bin`，Intel 装到 `/usr/local/bin`，通常已在 PATH
3. 验证：`ffmpeg -version`

程序也会检查 `/opt/homebrew/bin`、`/usr/local/bin` 等常见位置。

> 简便替代：把 ffmpeg 可执行文件放到程序旁边的 `ffmpeg` 文件夹里，程序启动时同样能找到。

## 开发运行（Windows / Linux / macOS）

```powershell
flutter pub get
flutter run -d windows
```

```bash
flutter pub get
flutter run -d linux    # 或 -d macos
```

## CI 构建

仓库内置 GitHub Actions 工作流（`.github/workflows/build.yml`），推送后会自动在
Windows / Linux / macOS 三平台执行分析、测试与 Release 构建，并上传构建产物；
推送 `v*` 版本标签时还会自动创建 GitHub Release。

## 打包发布版（Windows）

```powershell
.\build_release.ps1
```

产物在 `dist\`：

| 产物 | 说明 |
| --- | --- |
| `FFCraft\` | 便携目录，拷走即用 |
| `FFCraft_v1.6.0_portable.zip` | 便携版压缩包，解压后双击 `FFCraft.exe` 即可 |

## 许可

本项目以 [MIT](LICENSE) 协议开源。ffmpeg 为外部调用程序，遵循其自身的开源许可
（如 GPL/LGPL），不在本项目的 MIT 许可范围内。

## 说明

- 输出文件默认与源文件同名、同目录（扩展名随格式变化）；同名时自动加 `_out` 后缀。
- 批量转码支持并行任务 1-8；合流 / 拼接为单任务。
- 队列项显示原格式、大小、时长、码率等元数据；刚添加显示格式图标，
  转码中显示进度环 / 进度条，完成变绿色对勾。
- 列表底部有虚线拖放区，可继续拖入更多文件或文件夹。
- 日志自动展开，并带高亮规则：时间戳淡化、错误红色、警告橙黄、
  进度指标淡蓝；可一键复制日志；转码中出现解码错误会提示“完成（有解码警告）”。
- 自检模式：设置环境变量 `FFMPEG_SELFTEST=1`、
  `FFMPEG_SELFTEST_MODE=audio|video|mux|concat`、
  `FFMPEG_SELFTEST_FILES=<用 | 分隔>`、`FFMPEG_SELFTEST_OUTDIR=<目录>`、
  `FFMPEG_SELFTEST_OUT=<结果文件>` 后启动程序即可验证对应流程。

## 目录结构

```
FFCraft/
├── lib/
│   ├── models/          # 各模式设置与 ffmpeg 参数生成
│   ├── services/        # ffmpeg 查找、时长探测、任务构建
│   ├── state/           # 全局状态与批量执行
│   ├── screens/         # 主界面
│   └── widgets/         # 队列 / 合流面板、参数表单、日志、设置与关于
├── assets/fonts/        # 内嵌 MiSans + Cascadia Mono
├── windows/ linux/ macos/   # 三平台 runner
├── tools/               # 图标生成
├── test/                # 参数生成与界面测试
├── build_release.ps1    # Windows 一键打包脚本
└── README.md / README_EN.md
```
