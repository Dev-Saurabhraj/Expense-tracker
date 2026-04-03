import '../Utils/logger_utils.dart';

/// Custom exception classes for better error handling
class AppException implements Exception {
  final String message;
  final String? code;
  final Exception? originalException;

  AppException({required this.message, this.code, this.originalException});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException({required String message})
    : super(message: message, code: 'NETWORK_ERROR');
}

class DataException extends AppException {
  DataException({required String message})
    : super(message: message, code: 'DATA_ERROR');
}

class ValidationException extends AppException {
  ValidationException({required String message})
    : super(message: message, code: 'VALIDATION_ERROR');
}

/// Error handler for managing exceptions across the app
class ErrorHandler {
  static const String _tag = 'ErrorHandler';

  /// Handle exception and return user-friendly message
  static String handleException(dynamic exception) {
    LoggerUtils.logError('Exception caught', tag: _tag, error: exception);

    if (exception is AppException) {
      return exception.message;
    } else if (exception is FormatException) {
      return 'Invalid data format. Please try again.';
    } else if (exception is TypeError) {
      return 'An unexpected error occurred. Please try again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Log exception with context
  static void logException(
    Object exception,
    StackTrace? stackTrace, {
    String? context,
  }) {
    final message = context != null
        ? '$context: $exception'
        : exception.toString();
    LoggerUtils.logException(exception, stackTrace, tag: _tag);
  }
}
