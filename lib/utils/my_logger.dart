import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

MyLogger logger = MyLogger();

class MyLogger {
  static final logger = Logger(
    printer: PrettyPrinter(
      noBoxingByDefault: false,
      printTime: false,
      levelColors: {
        Level.trace: AnsiColor.fg(AnsiColor.grey(0.5)),
        Level.debug: const AnsiColor.none(),
        Level.info: const AnsiColor.fg(12),
        Level.warning: const AnsiColor.fg(208),
        Level.error: const AnsiColor.fg(196),
        Level.fatal: const AnsiColor.fg(80),
      },
      levelEmojis: {
        Level.trace: '🔍',
        Level.debug: '🐞',
        Level.info: '📢',
        Level.warning: '👋',
        Level.error: '🚨',
        Level.fatal: '✅',
      },
    ),
  );

  var loggerNoStack = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  //d,e,f,i,t,w

  //d
  void d(
    dynamic message, {
    String? tag,
    DateTime? time,
    Object? error,
    bool reverse = false,
    StackTrace? stackTrace,
  }) {
    logger.d(
      message,
      time: time,
      error: reverse ? error : tag,
      stackTrace: stackTrace ??
          StackTrace.fromString(
              reverse ? (tag ?? '') : (error != null ? error.toString() : '')),
    );
  }

  //e
  void e(
    dynamic message, {
    String? tag,
    DateTime? time,
    Object? error,
    bool reverse = false,
    StackTrace? stackTrace,
  }) {
    logger.e(
      message,
      time: time ?? DateTime.now(),
      error: reverse ? error : tag,
      stackTrace: stackTrace ??
          StackTrace.fromString(
              reverse ? (tag ?? '') : (error != null ? error.toString() : '')),
    );
  }

  //f
  void f(
    dynamic message, {
    String? tag,
    DateTime? time,
    Object? error,
    bool reverse = false,
    StackTrace? stackTrace,
  }) {
    logger.f(
      message,
      time: time ?? DateTime.now(),
      error: reverse ? error : tag,
      stackTrace: stackTrace ??
          StackTrace.fromString(
              reverse ? (tag ?? '') : (error != null ? error.toString() : '')),
    );
  }

  //i
  void i(
    dynamic message, {
    String? tag,
    DateTime? time,
    Object? error,
    bool reverse = false,
    StackTrace? stackTrace,
  }) {
    logger.i(
      message,
      time: time ?? DateTime.now(),
      error: reverse ? error : tag,
      stackTrace: stackTrace ??
          StackTrace.fromString(
              reverse ? (tag ?? '') : (error != null ? error.toString() : '')),
    );
  }

  //t
  void t(
    dynamic message, {
    String? tag,
    DateTime? time,
    Object? error,
    bool reverse = false,
    StackTrace? stackTrace,
  }) {
    logger.t(
      message,
      time: time ?? DateTime.now(),
      error: reverse ? error : tag,
      stackTrace: stackTrace ??
          StackTrace.fromString(
              reverse ? (tag ?? '') : (error != null ? error.toString() : '')),
    );
  }

  //w
  void w(
    dynamic message, {
    String? tag,
    DateTime? time,
    Object? error,
    bool reverse = false,
    StackTrace? stackTrace,
  }) {
    logger.w(
      message,
      time: time ?? DateTime.now(),
      error: reverse ? error : tag,
      stackTrace: stackTrace ??
          StackTrace.fromString(
              reverse ? (tag ?? '') : (error != null ? error.toString() : '')),
    );
  }

  static void demo() {
    MyLogger().d('debug message', tag: 'this is tag');
    MyLogger().e('error message', error: 'error', tag: 'tag', reverse: false);
    MyLogger().f('fetal message', tag: 'fetal');
    MyLogger().i('info message');
    MyLogger().t('trace tmessage');
    MyLogger().w('warning message');

    MyLogger().f("<-- END HTTP",
        tag: "--> options.uri {options.method options.path}",
        error: 'options.headers.toString()');
  }
}

void p(dynamic message) {
  if (kDebugMode) {
    print(message);
  }
}

void pl(dynamic message, [String? tag]) =>
    log(message.toString(), name: tag ?? 'MyLogger');

Future<T?> tryAsync<T>(Future<T?> Function() method,
    [String tag = '', T? defaultValue]) async {
  try {
    await method;
  } catch (e) {
    logger.e(e, tag: tag);
    return defaultValue;
  }
  return null;
}

///with return type T
T? tryCatch<T>(T? Function() method, [String tag = '', T? defaultValue]) {
  try {
    return method();
  } catch (e) {
    logger.e(e, tag: tag.isEmpty ? method.toString() : tag);
    return defaultValue;
  }
}
