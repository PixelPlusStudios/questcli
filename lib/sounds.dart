import 'dart:io';

/// Plays a sound file based on the current platform.
/// Supports .wav (recommended) and .mp3.
/// [filePath] → path to your audio file.
Future<void> playSound(String filePath) async {
  try {
    if (!File(filePath).existsSync()) {
      print('⚠️ Sound file not found: $filePath');
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
      // Windows: Media.SoundPlayer only supports .wav; .mp3 is skipped.
      if (filePath.toLowerCase().endsWith('.mp3')) return;
      final psCommand = r'''
        $player = New-Object Media.SoundPlayer "%FILE%";
        $player.PlaySync();
      '''.replaceAll('%FILE%', filePath.replaceAll(r'\', r'\\'));
      await Process.run('powershell', ['-Command', psCommand]);
    } else {
      print('⚠️ Unsupported platform for sound: ${Platform.operatingSystem}');
    }
  } catch (e) {
    print('⚠️ Failed to play sound: $e');
  }
}
