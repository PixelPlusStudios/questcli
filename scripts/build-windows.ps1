# Builds a standalone quest.exe + assets for Windows.
# Uses `dart build cli` (required when using sqlite3 with build hooks).
# Output: release\quest-<version>-windows-amd64.zip
# Run from project root: .\scripts\build-windows.ps1
# Note: First build needs network so sqlite3 can fetch native libs.

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..

$pubspec = Get-Content pubspec.yaml -Raw
if ($env:VERSION) { $VERSION = $env:VERSION } else {
  if ($pubspec -match 'version:\s*(\S+)') { $VERSION = $Matches[1].Trim() } else { $VERSION = "1.0.0" }
}

$ARCH = "amd64"
$STAGE = "quest-$VERSION-windows-$ARCH"

Write-Host "Building quest $VERSION for windows-$ARCH..."
dart build cli -o build

# dart build cli puts bundle in build\bundle\ with bin\<exe> and lib\
$binExe = Get-ChildItem -Path "build\bundle\bin" -File | Select-Object -First 1
if ($binExe -and $binExe.Name -ne "quest.exe") {
  Rename-Item -Path $binExe.FullName -NewName "quest.exe"
}

New-Item -ItemType Directory -Force -Path "release\$STAGE" | Out-Null
Copy-Item -Recurse -Force "build\bundle\bin" "release\$STAGE\"
if (Test-Path "build\bundle\lib") { Copy-Item -Recurse -Force "build\bundle\lib" "release\$STAGE\" }
Copy-Item -Recurse -Force assets "release\$STAGE\"

$zipPath = "release\$STAGE.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath }
Compress-Archive -Path "release\$STAGE" -DestinationPath $zipPath

Write-Host "Built $zipPath"
