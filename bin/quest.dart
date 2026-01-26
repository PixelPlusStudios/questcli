import 'package:args/args.dart';
import 'package:quest/animations.dart';
import 'package:quest/sounds.dart';
import 'package:quest/storage.dart';
import 'package:quest/colors.dart';

void main(List<String> arguments) async{
  // Setup app folder & DB
  createAppFolder();
  final db = initDatabase();
  createDefaultPlayer(db);

  // If no arguments, prompt user to begin
  if (arguments.isEmpty) {
    print(cyan('Type `quest begin` to start your adventure.'));
    return;
  }

  // ArgParser for flags & commands
  final parser = ArgParser(allowTrailingOptions: true,)
    ..addFlag('version', abbr: 'v', help: 'Show version info')
    ..addCommand('begin')
    ..addCommand('menu')
    ..addCommand('help')
    ..addCommand('add')
    ..addCommand('list')
    ..addCommand('complete')
    ..addCommand('stats')
    ..addCommand('map')
    ..addCommand('end')
    ..addCommand('water')
    ..addCommand('rest')
    ..addCommand('potion')
    ..addCommand('reset');

ArgResults results;
try {
  results = parser.parse(arguments);
} on FormatException catch (e) {
  print(boldRed('❌ Invalid command usage.'));
  print(yellow('Hint: Use `quest help` to see valid commands.'));
  return;
}

  // Version
  if (results['version'] == true) {
    print(boldCyan('Quest v0.1.0'));
    return;
  }

  // No command
  if (results.command == null) {
    print(boldCyan('Welcome to Quest CLI!'));
    print(cyan('Type `quest --help` to see commands.'));
    return;
  }

  final cmd = results.command!;

  switch (cmd.name) {
    // -------------------
    // BEGIN → Story Intro
    // -------------------
    case 'begin':
      if (isDayStarted(db)) {
        print(boldYellow('⚠️ You have already started your day!'));
        print(yellow('Type `quest add "<your tasks>"` to add tasks.'));
        return;
      }
      await playSound('lib/assets/begin.mp3');
      await slowprint(boldCyan('🧙 Welcome, Adventurer - Let your journey begin!'));
      await slowprint('Type `quest menu` to see your available actions.');
      await slowprint('Type `quest help` to see all commands.');
      startDay(db);
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
      print('${boldCyan('Quest CLI Commands:')}\n');
      print('${bold('quest begin')}     ${dim('→')} ${yellow('🐺 Let the games begin!')}');
      print('${bold('quest menu')}      ${dim('→')} ${cyan('📋 Show interactive menu')}');
      print('${bold('quest add')}       ${dim('→')} ${green('📝 Embark on a new quest')}');
      print('${bold('quest list')}      ${dim('→')} ${blue('📜 Journal view of your quests')}');
      print('${bold('quest complete')}  ${dim('→')} ${magenta('🏹 Conquer and complete a quest')}');
      print('${bold('quest stats')}     ${dim('→')} ${yellow('🛡️ Show your character stats')}');
      print('${bold('quest water')}     ${dim('→')} ${cyan('💧 Quench your thirst, gain XP')}');
      print('${bold('quest rest')}      ${dim('→')} ${blue('🛌 Meditate → recover, gain XP')}');
      print('${bold('quest potion')}    ${dim('→')} ${magenta('🧪 Elixir → use while defeating demons')}');
      print('${bold('quest map')}       ${dim('→')} ${brightCyan('🗺️ World, the realm, unlocked places')}');
      print('${bold('quest end')}       ${dim('→')} ${red('🌙 End the day, Nightfall is upon us')}');
      print('${bold('quest reset')}     ${dim('→')} ${yellow('🔄 Reset player stats to the beginning')}');
      break;

    // -------------------
    // DIRECT COMMANDS
    // -------------------
    case 'add':
      final args = cmd.arguments;
      if (args.isEmpty) {
        print('${yellow('Usage:')} ${bold('quest add "Task Name"')}');
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
        print('${yellow('Usage:')} ${bold('quest complete <task_id>')}');
        return;
      }
      final taskId = int.tryParse(args.first);
      if (taskId == null || taskId <= 0) {
        print(boldRed('Task ID must be a valid number!, Check `quest list` for IDs.'));
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

    case 'map':
      showMap(db);
      break;

    case 'end':
      // Check if day is started OR if end is already confirmed (which means day was started)
      if (!isDayStarted(db) && !isEndConfirmed(db)) {
        print(boldRed('❌ You haven\'t started your day yet, type `quest begin` to start.'));
        return;
      }
      await endDay(db);
      break;

    case 'reset':
      resetPlayerStats(db);
      break;

    default:
      print(boldYellow('Unknown command. Type `quest help` to see all commands.'));
  }
}
