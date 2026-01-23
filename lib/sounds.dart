import 'dart:io';
import 'package:quest/colors.dart';

/// Plays a sound file based on the current platform.
/// Supports .wav (recommended) and .mp3.
/// [filePath] → path to your audio file.
Future<void> playSound(String filePath) async {
  try {
    if (!File(filePath).existsSync()) {
      print('${boldYellow('⚠️ Sound file not found:')} ${dim(filePath)}');
      return;
    }

    if (Platform.isMacOS) {
      // macOS → afplay
      await Process.run('afplay', [filePath]);
    } else if (Platform.isLinux) {
      // Linux → aplay for wav, mpg123 for mp3
      if (filePath.endsWith('.wav')) {
        await Process.run('aplay', [filePath]);
      } else if (filePath.endsWith('.mp3')) {
        await Process.run('mpg123', [filePath]);
      }
    } else if (Platform.isWindows) {
      // Windows → PowerShell Media.SoundPlayer
      final psCommand = r'''
        $player = New-Object Media.SoundPlayer "%FILE%";
        $player.PlaySync();
      '''.replaceAll('%FILE%', filePath.replaceAll(r'\', r'\\'));
      await Process.run('powershell', ['-Command', psCommand]);
    } else {
      print('${boldYellow('⚠️ Unsupported platform for sound:')} ${dim(Platform.operatingSystem)}');
    }
  } catch (e) {
    print('${boldYellow('⚠️ Failed to play sound:')} ${dim('$e')}');
  }
}
