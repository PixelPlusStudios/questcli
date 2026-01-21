import 'dart:io';
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
    print('Created app folder at ${appDir.path}');
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
      end_confirmed INTEGER
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
    print('Default player created!');
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
  print('✅ Task added: $name');
}

// List all tasks
void listTasks(Database db) {
  final tasks = db.select('SELECT id, name, completed FROM tasks;');
  if (tasks.isEmpty) {
    print('No tasks found. Add a quest using `add`.');
    return;
  }

  print('📜 Tasks:');
  for (final row in tasks) {
    final status = row['completed'] == 1 ? '✅' : '❌';
    print('[${row['id']}] ${row['name']} $status');
  }
}

// Complete a task
void completeTask(Database db, int taskId) {
  final result = db.select(
    'SELECT completed FROM tasks WHERE id = ?;',
    [taskId]
  );

  if (result.isEmpty) {
    print('❌ Task not found!');
    return;
  }

  if (result.first['completed'] == 1) {
    print('⚠️ Task already completed!');
    return;
  }

  // Mark task as complete
  db.execute(
    'UPDATE tasks SET completed = 1 WHERE id = ?;',
    [taskId]
  );

  // Reward HP only
  db.execute('UPDATE player SET hp = hp + 10;'); // HP for task completion

  print('✅ Task completed! HP +10');
}

// Use Potion
void usePotion(Database db) {
  final player = getPlayer(db);
  if (player.isEmpty) return;

  if (player['potions'] <= 0) {
    print('❌ No potions available!');
    return;
  }

  db.execute('UPDATE player SET hp = hp + 10, potions = potions - 1;'); // restores HP
  print('🧪 Potion used! HP +10');
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
    print('🎉 You gained $potionsToAdd potion(s)!');
  }

  final action = type == 'water' ? '💧 Drank water' : '😴 Took a break';
  print('$action → XP +1 (current XP: $remainingXP)');
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
    print('No player found!');
    return;
  }

  print('🧙 Adventurer Stats:');
  print('❤️ HP: ${p['hp']}');
  print('⭐ XP: ${p['xp']}');
  print('🧪 Potions: ${p['potions']}');
  print('Level: ${p['level']}, Place: ${p['place']}');
}

// -------------------
// Interactive Menu
// -------------------
void runMenu(Database db) {
  bool running = true;

  while (running) {
    print('\nSelect an action:');
    print('1️⃣  Add Task');
    print('2️⃣  List Tasks');
    print('3️⃣  Complete Task');
    print('4️⃣  Show Stats');
    print('5️⃣  Drink Water');
    print('6️⃣  Take a Break');
    print('7️⃣  Use Potion');
    print('0️⃣  Exit');

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

      case '0':
        running = false;
        print('Goodbye, adventurer!');
        break;

      default:
        print('Invalid choice. Try again.');
    }
  }
}
