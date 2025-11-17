import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:subs_track/core/logger/console_logger.dart';
import 'package:subs_track/models/logger/log_message.dart';

/// LogUtils는 메인 아이솔레이트에서 로그를 처리하는 유틸리티 클래스입니다.
///
/// isolate-safe하게 설계되었기 때문에 멀티스레딩 상황에서도 안전하게 로그를 출력할 수 있습니다.
///
/// 반드시 다음과 같이 초기화해주세요.
/// ```dart
/// void main() {
///   LogUtils.initializeOnMainIsolate();
///
///   runApp(ProviderScope(child: const MyApp()));
/// }
/// ```
///
/// 기능은 다음과 같이 사용합니다.
/// Example:
/// ```dart
/// LogUtils.i("Hello, World!");
/// LogUtils.d("Hello, World!");
/// LogUtils.w("Hello, World!");
/// LogUtils.e("Hello, World!", error: Exception("test"));
/// ```
///
/// 멀티스레딩 상황에서 호출해도 안전하게 로그를 출력할 수 있습니다.
/// Example:
/// ```dart
/// for (int i = 0; i < 10; i++) {
///   compute(LogUtils.i, "message $i");
/// }
/// ```
class LogUtils {
  LogUtils._internal();

  static const _logPortName = 'log_send_port';

  static final _logger = ConsoleLogger();

  /// 메인 Isolate에서 초기화합니다.
  ///
  /// [ReceivePort]를 등록하고, 메시지를 수신하여 처리합니다.
  static void initializeOnMainIsolate() {
    final receivePort = ReceivePort(_logPortName);

    // (Hot Restart 상황에서) 이전에 등록된 Port를 제거합니다.
    IsolateNameServer.removePortNameMapping(_logPortName);

    IsolateNameServer.registerPortWithName(receivePort.sendPort, _logPortName);

    receivePort.listen((m) {
      if (m is Map<String, dynamic>) {
        _handleLog(LogMessage.fromMap(m));
        return;
      }

      debugPrint('LogUtils: 메시지의 타입을 알 수 없습니다.: $m');
    });
  }

  static void _handleLog(LogMessage message) {
    switch (message.level) {
      case Level.debug:
        _logger.d(message.message, stackTrace: message.stackTrace);
        break;
      case Level.info:
        _logger.i(message.message, stackTrace: message.stackTrace);
        break;
      case Level.warning:
        _logger.w(message.message, stackTrace: message.stackTrace);
        break;
      case Level.error:
        _logger.e(
          message.message,
          error: message.error,
          stackTrace: message.stackTrace,
        );
        break;
      default:
        debugPrint('LogUtils: 지원하지 않는 로그 레벨입니다.: ${message.level}');
        break;
    }
  }

  static void i(String message) {
    _send(
      LogMessage(
        level: Level.info,
        message: message,
        stackTrace: StackTrace.current,
      ),
    );
  }

  static void d(String message) {
    _send(
      LogMessage(
        level: Level.debug,
        message: message,
        stackTrace: StackTrace.current,
      ),
    );
  }

  static void w(String message) {
    _send(
      LogMessage(
        level: Level.warning,
        message: message,
        stackTrace: StackTrace.current,
      ),
    );
  }

  static void e(String message, {Object? error, StackTrace? stackTrace}) {
    _send(
      LogMessage(
        level: Level.error,
        message: message,
        error: error,
        stackTrace: stackTrace ?? StackTrace.current,
      ),
    );
  }

  /// 메인 Isolate로 로그를 전송합니다.
  /// Isolate로 전송할 데이터는 직렬화 가능한 객체여야 합니다.
  static void _send(LogMessage m) {
    final sendPort = IsolateNameServer.lookupPortByName(_logPortName);
    if (sendPort == null) {
      debugPrint('LogUtils: receivePort를 찾을 수 없습니다. 초기화를 해주세요.');
      return;
    }

    sendPort.send(m.toMap());
  }
}
