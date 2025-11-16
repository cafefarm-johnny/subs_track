import 'package:logger/logger.dart';

class LogMessage {
  final Level level;
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  LogMessage(this.level, this.message, this.error, this.stackTrace);

  Map<String, dynamic> toMap() => {
    'level': level.name,
    'message': message,
    'error': error?.toString(),
    'stackTrace': stackTrace?.toString(),
  };

  factory LogMessage.fromMap(Map<String, dynamic> map) => LogMessage(
    Level.values.byName(map['level']),
    map['message'],
    map['error'],
    StackTrace.fromString(map['stackTrace']),
  );
}
