import 'package:logger/logger.dart';
import 'package:subs_track/core/logger/logger.dart';

class ConsoleLogger implements LoggerAdapter {
  ConsoleLogger._internal();

  static final _instance = ConsoleLogger._internal();
  static final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 3,
      errorMethodCount: 8,
      lineLength: 120,
      colors: false,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      excludePaths: [
        'package:subs_track/core/logger/console_logger.dart',
        'package:subs_track/core/utils/log_utils.dart',
      ],
    ),
  );

  factory ConsoleLogger() => _instance;

  @override
  void d(String message, {StackTrace? stackTrace}) {
    _logger.d(message, stackTrace: StackTrace.current);
  }

  @override
  void i(String message, {StackTrace? stackTrace}) {
    _logger.i(message, stackTrace: StackTrace.current);
  }

  @override
  void w(String message, {StackTrace? stackTrace}) {
    _logger.w(message, stackTrace: StackTrace.current);
  }

  @override
  void e(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
