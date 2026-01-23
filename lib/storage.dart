import 'dart:io';
import 'package:quest/animations.dart';
import 'package:quest/sounds.dart';
import 'package:quest/colors.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as path;


// --------------------
// App Folder Setup
// --------------------
final homeDir = Platform.environment['HOME'] ?? '.';
final appDir = Directory(path.join(homeDir, '.quest'));
final dbPath = path.join(appDir.path, 'quest.db');

void createAppFolder() {
  if (!appDir.existsSync()) {
    appDir.createSync();
    print('${dim('Created app folder at')} ${cyan(appDir.path)}');
  }
}

// --------------------
// Database Initialization
// --------------------
Database initDatabase() {
  final db = sqlite3.open(dbPath);

  // Player table
  db.execute('''
    CREATE TABLE IF NOT EXISTS player (
      id INTEGER PRIMARY KEY,
      hp INTEGER,
      xp INTEGER,
      potions INTEGER,
      level INTEGER,
      place TEXT
    );
  ''');

  // Tasks table
  db.execute('''
    CREATE TABLE IF NOT EXISTS tasks (
      id INTEGER PRIMARY KEY,
      name TEXT,
      completed INTEGER
    );
  ''');

  // Day state table
  db.execute('''
    CREATE TABLE IF NOT EXISTS day_state (
      id INTEGER PRIMARY KEY,
      end_confirmed INTEGER,
      day_started INTEGER
    );
  ''');
  
  // Add day_started column if it doesn't exist (for existing databases)
  try {
    db.execute('ALTER TABLE day_state ADD COLUMN day_started INTEGER;');
  } catch (e) {
    // Column already exists, ignore error
  }

  //bosses defeated table
  db.execute('''
CREATE TABLE IF NOT EXISTS bosses (
  place TEXT PRIMARY KEY,
  defeated INTEGER
);
''');

  return db;
}

// --------------------
// Default Player
// --------------------
void createDefaultPlayer(Database db) {
  final result = db.select('SELECT COUNT(*) as count FROM player;');
  if (result.first['count'] == 0) {
    db.execute('''
      INSERT INTO player (hp, xp, potions, level, place)
      VALUES (100, 0, 0, 1, 'Village');
    ''');
  }
}

// --------------------
// Task Helpers
// --------------------

// Add a new task
void addTask(Database db, String name) {
  db.execute(
    'INSERT INTO tasks (name, completed) VALUES (?, ?);',
    [name, 0]
  );
  print('${green('✅ Task added:')} ${bold(name)}');
}

// List all tasks
void listTasks(Database db) {
  final tasks = db.select('SELECT id, name, completed FROM tasks;');
  if (tasks.isEmpty) {
    print(yellow('No tasks found. Add a quest using `add`.'));
    return;
  }

  print(boldCyan('📜 Tasks:'));
  for (final row in tasks) {
    final status = row['completed'] == 1 ? green('✅') : red('❌');
    print('${cyan('[')}${bold('${row['id']}')}${cyan(']')} ${row['name']} $status');
  }
}

// Complete a task
void completeTask(Database db, int taskId) {
  final result = db.select(
    'SELECT completed FROM tasks WHERE id = ?;',
    [taskId]
  );

  if (result.isEmpty) {
    print(boldRed('❌ Task not found!'));
    return;
  }

  if (result.first['completed'] == 1) {
    print(boldYellow('⚠️ Task already completed!'));
    return;
  }

  // Mark task as complete
  db.execute(
    'UPDATE tasks SET completed = 1 WHERE id = ?;',
    [taskId]
  );

  // Reward HP only
  db.execute('UPDATE player SET hp = hp + 10;'); // HP for task completion

  print('${boldGreen('✅ Task completed!')} ${green('HP +10')}');
}

// Use Potion
void usePotion(Database db) {
  final player = getPlayer(db);
  if (player.isEmpty) return;

  if (player['potions'] <= 0) {
    print(boldRed('❌ No potions available!'));
    return;
  }

  db.execute('UPDATE player SET hp = hp + 10, potions = potions - 1;'); // restores HP
  print('${boldMagenta('🧪 Potion used!')} ${green('HP +10')}');
}


// Gain Potion (water/rest)
void gainPotion(Database db, String type) {
  final player = getPlayer(db);
  if (player.isEmpty) return;

  // Step 1: Increase XP by 1 for water/rest
  db.execute('UPDATE player SET xp = xp + 1;');

  // Step 2: Check if XP >= 5, convert to potion
  final p = getPlayer(db); // get updated stats
  int xp = p['xp'];
  int potionsToAdd = xp ~/ 5; // integer division, how many full potions
  int remainingXP = xp % 5;

  if (potionsToAdd > 0) {
    // Add potions and reduce XP
    db.execute(
      'UPDATE player SET potions = potions + ?, xp = ?;',
      [potionsToAdd, remainingXP]
    );
    print('${boldYellow('🎉 You gained')} ${boldMagenta('$potionsToAdd potion(s)!')}');
  }

  final action = type == 'water' ? cyan('💧 Drank water') : blue('😴 Took a break');
  print('$action ${dim('→')} ${green('XP +1')} ${dim('(current XP:')} ${bold('$remainingXP')}${dim(')')}');
}



// --------------------
// Player Helpers
// --------------------

// Get current player stats
Map<String, dynamic> getPlayer(Database db) {
  final result = db.select('SELECT * FROM player LIMIT 1;');
  if (result.isEmpty) return {};
  final row = result.first;
  return {
    'hp': row['hp'],
    'xp': row['xp'],
    'potions': row['potions'],
    'level': row['level'],
    'place': row['place'],
  };
}

// Show player stats
void showPlayerStats(Database db) {
  final p = getPlayer(db);
  if (p.isEmpty) {
    print(boldRed('No player found!'));
    return;
  }

  print(boldCyan('🧙 Adventurer Stats:'));
  print('${red('❤️ HP:')} ${bold('${p['hp']}')}');
  print('${yellow('⭐ XP:')} ${bold('${p['xp']}')}');
  print('${magenta('🧪 Potions:')} ${bold('${p['potions']}')}');
  print('${blue('Days Survived(Level):')} ${bold('${p['level']}')}\n${cyan('Place:')} ${bold('${p['place']}')}');
}

// Reset player stats to initial values
void resetPlayerStats(Database db) {
  final result = db.select('SELECT id FROM player LIMIT 1;');
  if (result.isEmpty) {
    // If somehow no player exists, create the default one
    createDefaultPlayer(db);
    return;
  }

  final int id = result.first['id'];
  db.execute(
    'UPDATE player SET hp = 100, xp = 0, potions = 0, level = 1, place = ? WHERE id = ?;',
    ['Village', id],
  );
  print(boldYellow('🔄 Player stats have been reset to the beginning.'));
}

// -------------------
// Interactive Menu
// -------------------
void runMenu(Database db) {
  print('\n${boldCyan('Select an action:')}');
  print('${cyan('1️⃣')}  Add Task');
  print('${cyan('2️⃣')}  List Tasks');
  print('${cyan('3️⃣')}  Complete Task');
  print('${cyan('4️⃣')}  Show Stats');
  print('${cyan('5️⃣')}  Drink Water');
  print('${cyan('6️⃣')}  Take a Break');
  print('${cyan('7️⃣')}  Use Potion');
  print('${cyan('8️⃣')}  Map');
  print('${red('0️⃣')}  Exit');

  stdout.write('Enter choice: ');
  final input = stdin.readLineSync()?.trim();

  switch (input) {
    case '1':
      stdout.write('Enter task name: ');
      final taskName = stdin.readLineSync()?.trim();
      if (taskName != null && taskName.isNotEmpty) {
        addTask(db, taskName);
      }
      break;

    case '2':
      listTasks(db);
      break;

    case '3':
      stdout.write('Enter task ID to complete: ');
      final taskIdStr = stdin.readLineSync()?.trim();
      final taskId = int.tryParse(taskIdStr ?? '');
      if (taskId != null) completeTask(db, taskId);
      break;

    case '4':
      showPlayerStats(db);
      break;

    case '5':
      gainPotion(db, 'water');
      break;

    case '6':
      gainPotion(db, 'rest');
      break;

    case '7':
      usePotion(db);
      break;

      case '8':
  showMap(db);
  break;


    case '0':
      print(dim('Exiting menu...'));
      break;

    default:
      print(boldYellow('Invalid choice. Type `quest menu` to try again.'));
  }
}

// -------------------
//EOD
// -------------------
Future<void> endDay(Database db) async {
  final player = getPlayer(db);
  if (player.isEmpty) return;

  final int hp = player['hp'];
  final int level = player['level'];
  final String place = player['place'];

  // 1️⃣ Unfinished tasks check
  if (hasPendingTasks(db) && !isEndConfirmed(db)) {
    print(boldYellow('⚠️ You still have unfinished tasks!'));
    print(yellow('Run `quest end` again to ignore them and face the boss.'));
    confirmEnd(db);
    return;
  }

  // 2️⃣ Boss fight setup
  final boss = getBossForPlace(place);
  final scalingFactor = 2; // tweak difficulty growth
  final bossDifficulty = boss.baseDifficulty + (level * scalingFactor);

  await slowprint('\n👹 Boss Encounter Begins!');

  await slowprint('\n⚔️ Boss Rules:');
await slowprint('• Your HP acts as your power.');
await slowprint('• Boss difficulty adds risk.');
await slowprint('• 🔮 Your fate is drawn by a 🎲 roll.');
await slowprint('• If the roll is ≤ your HP → you WIN🏆');
await slowprint('• If the roll is > your HP → you LOSE👎\n');

  await playSound('lib/assets/demon.mp3');
  await slowprint('Boss: ${boss.emoji} ${boss.name} (Difficulty: $bossDifficulty)');
  await slowprint('❤️ Your HP: $hp');

  await printAsciiArt('lib/assets/${boss.name}.txt', delayMs: 30); 
  // 3️⃣ Boss roll
  // final rng = Random();
  // final roll = rng.nextInt(hp + bossDifficulty); // scaled roll
  final win = await animateBossFight(
  bossName: boss.name,
  bossEmoji: boss.emoji,
  playerHp: hp,
  bossDifficulty: bossDifficulty,
);
  // await slowprint('🎲 Boss Roll: $roll');

  if (win) {
    // 🏆 WIN
    final hpGain = (hp * 0.5).round();
    await slowprint('⚔️ The omen favors you...');
    print(boldGreen('🏆 VICTORY!'));
    print(boldYellow('⭐ XP +5'));
    print(boldRed('❤️ HP +$hpGain'));
 db.execute(
    'INSERT OR REPLACE INTO bosses (place, defeated) VALUES (?, 1);',
    [player['place']]
  );
    db.execute(
      'UPDATE player SET xp = xp + 5, hp = hp + ?;',
      [hpGain]
    );
  } else {
    // 💀 LOSE
    final hpLoss = (hp * 0.5).round();
    print(boldRed('💀 Defeat...'));
    print(red('❤️ HP -$hpLoss'));

    db.execute(
      'UPDATE player SET hp = hp - ?;',
      [hpLoss]
    );
  }

  // 4️⃣ Reset day
  clearTasks(db);
  resetDayState(db);

  // 5️⃣ Level up and place update
  final newLevel = level + 1;
  final newPlace = calculatePlace(newLevel);

  db.execute(
    'UPDATE player SET level = ?, place = ?;',
    [newLevel, newPlace]
  );

  await slowprint(brightGreen('\n📈 Level up!'));
  await slowprint('📆 Days Survived: $newLevel.');
  await slowprint('📍 Current Place: $newPlace');
  await slowprint(brightMagenta('🌙 Day ended & Night falls...'));
}

//Map
void showMap(Database db) {
  final player = getPlayer(db);
  if (player.isEmpty) return;

  final int level = player['level'];
  final places = ['Village', 'Forest', 'Hills', 'Mountains'];

  final currentPlaceIndex = (level - 1) ~/ 10;
  final localLevel = ((level - 1) % 10) + 1;

  print('\n${boldCyan('🗺️ World Map')}\n');

for (int i = 0; i < places.length; i++) {
  // Get boss defeated status
  final bossStatus = db.select('SELECT defeated FROM bosses WHERE place = ?;', [places[i]]);
  bool defeated = bossStatus.isNotEmpty && bossStatus.first['defeated'] == 1;
  String bossMark;

  if (i < currentPlaceIndex) {
    // Place fully completed
    bossMark = '🏁';
    print('${green(places[i].padRight(12))} ${green(bossMark)} ${green('[##########]')} ${boldGreen('10/10')}');
  } else if (i == currentPlaceIndex) {
    // Current place
    final progress = '#' * localLevel + '-' * (10 - localLevel);
    bossMark = defeated ? '⚔️ ' : '📍';
    final progressBar = progress.replaceAll('#', green('#')).replaceAll('-', dim('-'));
    print('${boldCyan(places[i].padRight(12))} ${cyan(bossMark)} [$progressBar] ${bold('$localLevel/10')}');
  } else {
    // Locked place
    bossMark = '🔒';
    print('${dim(places[i].padRight(12))} ${dim(bossMark)} ${dim('[----------]')} ${dim('Locked')}');
  }
}

  print('\n${blue('🌙 Days Survived:')} ${bold('$level')}');
  print('${cyan('📍 Current Place:')} ${boldCyan(places[currentPlaceIndex])}');
}

// --------------------
// Boss Helpers
// --------------------
class Boss {
  final String name;
  final String emoji;
  final int baseDifficulty;

  Boss(this.name, this.emoji, this.baseDifficulty);
}

/// Returns the boss for the current place
Boss getBossForPlace(String place) {
  switch (place) {
    case 'Village':
      return Boss('Lazy Goblin', '👺', 20);
    case 'Forest':
      return Boss('Shadow Wolf', '🐺', 40);
    case 'Hills':
      return Boss('Stone Golem', '🪨', 60);
    case 'Mountains':
      return Boss('Dragon', '🐉', 80);
    default:
      return Boss('Unknown Entity', '❓', 30);
  }
}

//helper functions

String calculatePlace(int level) {
  final places = ['Village', 'Forest', 'Hills', 'Mountains'];
  final index = (level - 1) ~/ 10;

  if (index < places.length) {
    return places[index];
  }
  return places.last; // stay at last place if levels exceed
}
bool hasPendingTasks(Database db) {
  final result = db.select('SELECT COUNT(*) as count FROM tasks WHERE completed = 0;');
  return result.first['count'] > 0;
}

bool isEndConfirmed(Database db) {
  final result = db.select('SELECT end_confirmed FROM day_state WHERE id = 1;');
  return result.isNotEmpty && result.first['end_confirmed'] == 1;
}

void confirmEnd(Database db) {
  // Read current day_started value to preserve it
  final current = db.select('SELECT day_started FROM day_state WHERE id = 1;');
  int dayStartedValue = 1; // Default to 1
  
  if (current.isNotEmpty) {
    final dayStarted = current.first['day_started'];
    dayStartedValue = (dayStarted != null && dayStarted != 0) ? 1 : 1; // Ensure it's 1
  }
  
  // Use INSERT OR REPLACE to set both values explicitly
  db.execute(
    'INSERT OR REPLACE INTO day_state (id, end_confirmed, day_started) VALUES (1, 1, ?);',
    [dayStartedValue]
  );
}

void resetDayState(Database db) {
  db.execute('UPDATE day_state SET end_confirmed = 0, day_started = 0 WHERE id = 1;');
}

// --------------------
// Day Start Helpers
// --------------------

bool isDayStarted(Database db) {
  final result = db.select('SELECT day_started FROM day_state WHERE id = 1;');
  if (result.isEmpty) return false;
  final dayStarted = result.first['day_started'];
  // Handle both int and potential NULL values
  return dayStarted != null && (dayStarted == 1 || dayStarted == '1');
}

void startDay(Database db) {
  db.execute('INSERT OR REPLACE INTO day_state (id, day_started, end_confirmed) VALUES (1, 1, 0);');
}

void clearTasks(Database db) {
  db.execute('DELETE FROM tasks;');
}