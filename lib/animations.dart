import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:quest/asset_path.dart';
import 'package:quest/sounds.dart';

Future<void> slowprint(String text, {int delayMs = 25}) async {
  final bytes = utf8.encode(text);

  for (final byte in bytes) {
    stdout.add([byte]);   // write RAW byte
    stdout.flush();
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  stdout.add(utf8.encode('\n'));
}

String coloredHpBar(int currentHp, int maxHp, {int length = 20}) {
  final filledLength = ((currentHp / maxHp) * length).round().clamp(0, length);
  final emptyLength = length - filledLength;

  final filledBar = '\x1B[95m' + '█' * filledLength + '\x1B[0m'; // pink
  final emptyBar = '\x1B[97m' + '░' * emptyLength + '\x1B[0m';   // grey
  return filledBar + emptyBar;
}


Future<bool> animateBossFight({
  required String bossName,
  required String bossEmoji,
  required int playerHp,
  required int bossDifficulty,
}) async {
  stdout.write('\x1B[2J\x1B[0;0H'); // clear screen
  final maxBarHp = max(playerHp, bossDifficulty);

  await slowprint("🌑 Night falls...");
  await Future.delayed(Duration(milliseconds: 400));

  await slowprint("A presence stirs...");
  await Future.delayed(Duration(milliseconds: 500));

  await slowprint("\n$bossEmoji $bossName appears!");
  await Future.delayed(Duration(milliseconds: 400));

  print("━━━━━━━━━━━━━━━━━━━━━━");
  print("$bossEmoji $bossName  ${coloredHpBar(bossDifficulty, maxBarHp)}");
  await Future.delayed(Duration(milliseconds: 400));
  print("\n🧙 You        ${coloredHpBar(playerHp, maxBarHp)}");
  print("━━━━━━━━━━━━━━━━━━━━━━\n");

  await slowprint("⚔️ You attack!");
  await playSound(resolveAssetPath('sword.mp3'));
  await slowprint("💥 SLASH!!");
  await Future.delayed(Duration(milliseconds: 400));

  final roll = Random().nextInt(playerHp + bossDifficulty);

  await slowprint("🎲 Fate decides...");
  await Future.delayed(Duration(milliseconds: 300));

  await slowprint("🎯 Roll: $roll vs Your Power: $playerHp\n\n");
await Future.delayed(Duration(milliseconds: 500));
  return roll <= playerHp;
}

/// Loads an ASCII art file and prints it with optional slow print
Future<void> printAsciiArt(String filePath, {int delayMs = 0}) async {
  final file = File(filePath);
  if (!file.existsSync()) {
    print('⚠️ ASCII art file not found: $filePath');
    return;
  }

  final lines = await file.readAsLines();

  for (final line in lines) {
    stdout.writeln(line);
    if (delayMs > 0) {
      await Future.delayed(Duration(milliseconds: delayMs));
    }
  }
}