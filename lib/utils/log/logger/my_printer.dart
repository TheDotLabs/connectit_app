import 'dart:convert';

import 'package:logger/logger.dart';

import 'ansi_color.dart';

/// Default implementation of [LogPrinter].
///
/// Outut looks like this:
/// ```
/// ┌──────────────────────────
/// │ Error info
/// ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
/// │ Method stack history
/// ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
/// │ Log message
/// └──────────────────────────
/// ```
class MyPrinter extends LogPrinter {
  static const topLeftCorner = '┌';
  static const bottomLeftCorner = '└';
  static const middleCorner = '├';
  static const verticalLine = '│';
  static const doubleDivider = "─";
  static const singleDivider = "┄";

  static final levelColors = {
    Level.verbose: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: AnsiColor.none(),
    Level.info: AnsiColor.fg(12),
    Level.warning: AnsiColor.fg(208),
    Level.error: AnsiColor.fg(196),
    Level.wtf: AnsiColor.fg(199),
  };

  static final _levelEmojis = {
    Level.verbose: 'ℹ️ ',
    Level.debug: '🐛 ',
    Level.info: '💡 ',
    Level.warning: '⚠️ ',
    Level.error: '⛔ ',
    Level.wtf: '👾 ',
  };

  static final stackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');

  static DateTime _startTime;

  final int methodCount;
  final int errorMethodCount;
  final int lineLength;
  final bool colors;
  final bool printTime;

  MyPrinter({
    this.methodCount = 2,
    this.errorMethodCount = 8,
    this.lineLength = 120,
    this.colors = true,
    this.printTime = false,
  }) {
    if (_startTime == null) {
      _startTime = DateTime.now();
    }

    var doubleDividerLine = StringBuffer();
    var singleDividerLine = StringBuffer();
    for (int i = 0; i < lineLength - 1; i++) {
      doubleDividerLine.write(doubleDivider);
      singleDividerLine.write(singleDivider);
    }
  }

  @override
  void log(LogEvent event) {
    var messageStr = stringifyMessage(event.message);

    String stackTraceStr;
    if (event.stackTrace == null) {
      if (methodCount > 0) {
        stackTraceStr = formatStackTrace(StackTrace.current, methodCount);
      }
    } else if (errorMethodCount > 0) {
      stackTraceStr = formatStackTrace(event.stackTrace, errorMethodCount);
    }

    var errorStr = event.error?.toString();

    String timeStr;
    if (printTime) {
      timeStr = getTime();
    }

    formatAndPrint(event.level, messageStr, timeStr, errorStr, stackTraceStr);
  }

  String formatStackTrace(StackTrace stackTrace, int methodCount) {
    var lines = stackTrace.toString().split("\n");

    var formatted = <String>[];
    var count = 0;
    for (var line in lines) {
      var match = stackTraceRegex.matchAsPrefix(line);
      if (match != null) {
        if (match.group(2).startsWith('package:logger')) {
          continue;
        }
        var newLine = ("#$count   ${match.group(1)} (${match.group(2)})");
        formatted.add(newLine.replaceAll('<anonymous closure>', '()'));
        if (++count == methodCount) {
          break;
        }
      } else {
        formatted.add(line);
      }
    }

    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }

  String getTime() {
    String _threeDigits(int n) {
      if (n >= 100) return "${n}";
      if (n >= 10) return "0${n}";
      return "00${n}";
    }

    String _twoDigits(int n) {
      if (n >= 10) return "${n}";
      return "0${n}";
    }

    var now = DateTime.now();
    String h = _twoDigits(now.hour);
    String min = _twoDigits(now.minute);
    String sec = _twoDigits(now.second);
    String ms = _threeDigits(now.millisecond);
    var timeSinceStart = now.difference(_startTime).toString();
    return "$h:$min:$sec.$ms (+$timeSinceStart)";
  }

  String stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      var encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }

  AnsiColor _getLevelColor(Level level) {
    if (colors) {
      return levelColors[level];
    } else {
      return AnsiColor.none();
    }
  }

  AnsiColor _getErrorColor(Level level) {
    if (colors) {
      if (level == Level.wtf) {
        return levelColors[Level.wtf].toBg();
      } else {
        return levelColors[Level.error].toBg();
      }
    } else {
      return AnsiColor.none();
    }
  }

  String _getEmoji(Level level) {
    return _levelEmojis[level];
  }

  void formatAndPrint(Level level, String message, String time, String error, String stacktrace) {
    var color = _getLevelColor(level);

    var emoji = _getEmoji(level);

    if (level == Level.error) {
      println('------EXCEPTION-------');
    }

    //message
    for (var line in message.split('\n')) {
      println(color('$emoji$line'));
    }
    //error
    if (error != null) {
      var errorColor = _getErrorColor(level);
      for (var line in error.split('\n')) {
        println(
          color('$verticalLine ') + errorColor.resetForeground + errorColor(line) + errorColor.resetBackground,
        );
      }
    }

    //stackTrace
    if (stacktrace != null) {
      for (var line in stacktrace.split('\n')) {
        println('${color}$line');
      }
    }
    //time
    if (time != null) {
      println(color('$time'));
    }
    if (level == Level.error) {
      println('----------------------');
    }
  }
}
