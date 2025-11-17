import 'package:logger/logger.dart';

class LogMessage {
  final Level level;
  final dynamic message;
  final Object? error;
  final StackTrace? stackTrace;

  LogMessage({
    required this.level,
    required this.message,
    this.error,
    this.stackTrace,
  });

  Map<String, dynamic> toMap() => {
    'level': level.name,
    'message': message.toString(),
    'error': error?.toString() ?? '',
    'stackTrace': stackTrace?.toString() ?? '',
  };

  factory LogMessage.fromMap(Map<String, dynamic> map) => LogMessage(
    level: Level.values.byName(map['level']),
    message: map['message'],
    error: map['error'],
    stackTrace:
        map['stackTrace'] != null
            ? StackTrace.fromString(map['stackTrace'])
            : null,
  );
}
