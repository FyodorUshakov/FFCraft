# ffmpeg 转换器（Flutter 版）一键打包脚本
# 用法：  .\build_release.ps1
# 产物：
#   dist\ffmpeg_GUI_Flutter\            便携版目录（exe + 数据，拷走即用）
#   dist\ffmpeg_GUI_v1.0.0_portable.zip 便携版压缩包

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$dist = Join-Path $root 'dist'
$appDir = Join-Path $dist 'FFCraft'
$version = 'v1.6.0'

Write-Host '==> 1/3 flutter build windows --release'
Push-Location $root
try {
  flutter build windows --release
} finally {
  Pop-Location
}

Write-Host '==> 2/3 组装便携目录'
$release = Join-Path $root 'build\windows\x64\runner\Release'
if (Test-Path $appDir) { Remove-Item $appDir -Recurse -Force }
New-Item -ItemType Directory -Path $appDir -Force | Out-Null
Copy-Item (Join-Path $release '*') $appDir -Recurse -Force

Write-Host '==> 3/3 生成便携 zip'
$zip = Join-Path $dist "FFCraft_${version}_portable.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }
$sevenZip = 'C:\Program Files\7-Zip\7z.exe'
if (Test-Path $sevenZip) {
  & $sevenZip a -tzip -mx=9 -y $zip (Join-Path $appDir '*') | Out-Null
} else {
  Compress-Archive -Path (Join-Path $appDir '*') -DestinationPath $zip -CompressionLevel Optimal
}

Write-Host '==> 完成'
Get-ChildItem $dist -Recurse -File | Select-Object FullName, Length
