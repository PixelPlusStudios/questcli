import 'dart:io';
import 'package:path/path.dart' as path;

/// Resolves the app's data directory (e.g. ~/.quest or %USERPROFILE%\.quest on Windows).
String get _appDir {
  final home = Platform.environment['USERPROFILE'] ??
      Platform.environment['HOME'] ??
      '.';
  return path.join(home, '.quest');
}

/// Directory containing the running executable.
String get _execDir =>
    File(Platform.resolvedExecutable).parent.path;

/// Resolves an asset path. Tries, in order:
/// 1. assets/ next to the executable (for installed release)
/// 2. assets/ in the parent of the exe dir (for dart build cli: bin/quest + assets/)
/// 3. ~/.quest/assets/ (after copy on first run)
/// 4. assets/ in the current working directory (for `dart run` in development)
String resolveAssetPath(String name) {
  final p1 = path.join(_execDir, 'assets', name);
  if (File(p1).existsSync()) return p1;
  final p2 = path.join(path.dirname(_execDir), 'assets', name);
  if (File(p2).existsSync()) return p2;
  final p3 = path.join(_appDir, 'assets', name);
  if (File(p3).existsSync()) return p3;
  final p4 = path.join(Directory.current.path, 'assets', name);
  if (File(p4).existsSync()) return p4;
  return p1;
}

/// Copies assets from next-to-executable (or parent, for bin/ layout) into
/// ~/.quest/assets on first run, so the binary can be moved to PATH and still find assets.
void copyAssetsToAppDirIfNeeded() {
  var src = Directory(path.join(_execDir, 'assets'));
  if (!src.existsSync()) {
    src = Directory(path.join(path.dirname(_execDir), 'assets'));
  }
  if (!src.existsSync()) return;
  final destDir = path.join(_appDir, 'assets');
  final dest = Directory(destDir);
  if (dest.existsSync()) return;
  dest.createSync(recursive: true);
  for (final e in src.listSync(recursive: true)) {
    if (e is File) {
      final rel = path.relative(e.path, from: src.path);
      final destFile = File(path.join(destDir, rel));
      destFile.parent.createSync(recursive: true);
      e.copySync(destFile.path);
    }
  }
}
