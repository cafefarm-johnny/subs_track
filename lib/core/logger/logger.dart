abstract class LoggerAdapter {
  void d(String message, {StackTrace? stackTrace});
  void i(String message, {StackTrace? stackTrace});
  void w(String message, {StackTrace? stackTrace});
  void e(String message, {Object? error, StackTrace? stackTrace});
}
