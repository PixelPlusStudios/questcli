import 'package:args/args.dart';
import 'package:quest/storage.dart';

void main(List<String> arguments) {
  // Setup app folder & DB
  createAppFolder();
  final db = initDatabase();
  createDefaultPlayer(db);

  // If no arguments, prompt user to begin
  if (arguments.isEmpty) {
    print('Type `quest begin` to start your adventure.');
    return;
  }

  // ArgParser for flags & commands
  final parser = ArgParser()
    ..addFlag('version', abbr: 'v', help: 'Show version info')
    ..addCommand('begin')
    ..addCommand('menu')
    ..addCommand('help')
    ..addCommand('add')
    ..addCommand('list')
    ..addCommand('complete')
    ..addCommand('stats')
    ..addCommand('map')     // optional future feature
    ..addCommand('end')     // optional future feature
    ..addCommand('water')
    ..addCommand('rest')
    ..addCommand('potion');

  final results = parser.parse(arguments);

  // Version
  if (results['version'] == true) {
    print('Quest v0.1.0');
    return;
  }

  // No command
  if (results.command == null) {
    print('Welcome to Quest CLI!');
    print('Type `quest --help` to see commands.');
    return;
  }

  final cmd = results.command!;

  switch (cmd.name) {
    // -------------------
    // BEGIN → Story Intro
    // -------------------
    case 'begin':
      print('🧙 Welcome, adventurer, to Quest CLI!');
      print('Your journey begins in the Village.');
      print('Type `quest menu` to see your available actions.');
      print('Type `quest help` to see all commands.');
      break;

    // -------------------
    // MENU → Interactive Menu
    // -------------------
    case 'menu':
      runMenu(db);
      break;

    // -------------------
    // HELP → Show all commands
    // -------------------
    case 'help':
      print('''
Quest CLI Commands:

quest begin     → Start your adventure
quest menu      → Show interactive menu
quest add       → Add a new task
quest list      → List all tasks
quest complete  → Complete a task
quest stats     → Show your stats
quest water     → Drink water (+1 potion)
quest rest      → Take a break (+1 potion)
quest potion    → Use a potion (+HP)
quest map       → Show your map (future)
quest end       → End the day / boss fight (future)
''');
      break;

    // -------------------
    // DIRECT COMMANDS
    // -------------------
    case 'add':
      final args = cmd.arguments;
      if (args.isEmpty) {
        print('Usage: quest add "Task Name"');
        return;
      }
      addTask(db, args.join(' '));
      break;

    case 'list':
      listTasks(db);
      break;

    case 'complete':
      final args = cmd.arguments;
      if (args.isEmpty) {
        print('Usage: quest complete <task_id>');
        return;
      }
      final taskId = int.tryParse(args.first);
      if (taskId == null) {
        print('Task ID must be a number!');
        return;
      }
      completeTask(db, taskId);
      break;

    case 'stats':
      showPlayerStats(db);
      break;

    case 'potion':
      usePotion(db);
      break;

    case 'water':
      gainPotion(db, 'water');
      break;

    case 'rest':
      gainPotion(db, 'rest');
      break;

    default:
      print('Unknown command. Type `quest help` to see all commands.');
  }
}
