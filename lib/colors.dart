// ANSI Color Codes for terminal output
class Colors {
  // Reset
  static const String reset = '\x1B[0m';
  
  // Regular colors
  static const String black = '\x1B[30m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  static const String white = '\x1B[37m';
  
  // Bright colors
  static const String brightBlack = '\x1B[90m';
  static const String brightRed = '\x1B[91m';
  static const String brightGreen = '\x1B[92m';
  static const String brightYellow = '\x1B[93m';
  static const String brightBlue = '\x1B[94m';
  static const String brightMagenta = '\x1B[95m';
  static const String brightCyan = '\x1B[96m';
  static const String brightWhite = '\x1B[97m';
  
  // Styles
  static const String bold = '\x1B[1m';
  static const String dim = '\x1B[2m';
  static const String italic = '\x1B[3m';
  static const String underline = '\x1B[4m';
}

// Helper functions for colored output
String colorize(String text, String color) {
  return '$color$text${Colors.reset}';
}

// Convenience functions for common colors
String red(String text) => colorize(text, Colors.red);
String green(String text) => colorize(text, Colors.green);
String yellow(String text) => colorize(text, Colors.yellow);
String blue(String text) => colorize(text, Colors.blue);
String magenta(String text) => colorize(text, Colors.magenta);
String cyan(String text) => colorize(text, Colors.cyan);
String white(String text) => colorize(text, Colors.white);

String brightRed(String text) => colorize(text, Colors.brightRed);
String brightGreen(String text) => colorize(text, Colors.brightGreen);
String brightYellow(String text) => colorize(text, Colors.brightYellow);
String brightBlue(String text) => colorize(text, Colors.brightBlue);
String brightMagenta(String text) => colorize(text, Colors.brightMagenta);
String brightCyan(String text) => colorize(text, Colors.brightCyan);
String brightWhite(String text) => colorize(text, Colors.brightWhite);

String bold(String text) => colorize(text, Colors.bold);
String dim(String text) => colorize(text, Colors.dim);
String italic(String text) => colorize(text, Colors.italic);
String underline(String text) => colorize(text, Colors.underline);

// Combined styles
String boldRed(String text) => colorize(text, '${Colors.bold}${Colors.red}');
String boldGreen(String text) => colorize(text, '${Colors.bold}${Colors.green}');
String boldYellow(String text) => colorize(text, '${Colors.bold}${Colors.yellow}');
String boldBlue(String text) => colorize(text, '${Colors.bold}${Colors.blue}');
String boldCyan(String text) => colorize(text, '${Colors.bold}${Colors.cyan}');
String boldMagenta(String text) => colorize(text, '${Colors.bold}${Colors.magenta}');
