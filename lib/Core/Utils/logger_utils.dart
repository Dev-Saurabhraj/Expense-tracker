/// Logging utilities for debugging and monitoring
class LoggerUtils {
  static const String _tag = '[ExpenseTracker]';

  /// Log info message
  static void logInfo(String message, {String? tag}) {
    final prefix = tag != null ? '[$tag]' : _tag;
    print('$prefix [INFO] $message');
  }

  /// Log debug message
  static void logDebug(String message, {String? tag}) {
    final prefix = tag != null ? '[$tag]' : _tag;
    print('$prefix [DEBUG] $message');
  }

  /// Log warning message
  static void logWarning(String message, {String? tag}) {
    final prefix = tag != null ? '[$tag]' : _tag;
    print('$prefix [WARNING] $message');
  }

  /// Log error message
  static void logError(String message, {String? tag, Object? error}) {
    final prefix = tag != null ? '[$tag]' : _tag;
    print('$prefix [ERROR] $message');
    if (error != null) {
      print('$prefix Error Details: $error');
    }
  }

  /// Log exception with stack trace
  static void logException(
    Object exception,
    StackTrace? stackTrace, {
    String? tag,
  }) {
    final prefix = tag != null ? '[$tag]' : _tag;
    print('$prefix [EXCEPTION] $exception');
    if (stackTrace != null) {
      print('$prefix StackTrace: $stackTrace');
    }
  }
}
