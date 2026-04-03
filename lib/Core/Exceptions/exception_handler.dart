import 'app_exception.dart';

/// Exception handler utility class
class ExceptionHandler {
  /// Handle exceptions and return appropriate AppException
  static AppException handle(dynamic error, {String? message}) {
    if (error is AppException) {
      return error;
    }

    if (error is FormatException) {
      return ParseException(
        message: message ?? 'Failed to parse data: ${error.message}',
        originalException: error,
      );
    }

    if (error is Exception) {
      final errorString = error.toString();

      if (errorString.contains('SocketException') ||
          errorString.contains('HttpException')) {
        return NetworkException(
          message: message ?? 'Network error occurred',
          originalException: error as Exception,
        );
      }

      if (errorString.contains('404')) {
        return NotFoundException(
          message: message ?? 'Resource not found',
          originalException: error as Exception,
        );
      }

      if (errorString.contains('401') || errorString.contains('403')) {
        return UnauthorizedException(
          message: message ?? 'Unauthorized access',
          originalException: error as Exception,
        );
      }

      return UnknownException(
        message: message ?? error.toString(),
        originalException: error as Exception,
      );
    }

    return UnknownException(message: message ?? 'An unknown error occurred');
  }

  /// Get user-friendly error message
  static String getUserMessage(AppException exception) {
    if (exception is NetworkException) {
      return 'Network connection error. Please check your internet connection.';
    }
    if (exception is NotFoundException) {
      return 'The requested data was not found.';
    }
    if (exception is DatabaseException) {
      return 'Database error occurred. Please try again.';
    }
    if (exception is ParseException) {
      return 'Failed to process the data. Please try again.';
    }
    if (exception is UnauthorizedException) {
      return 'You are not authorized to perform this action.';
    }
    if (exception is ValidationException) {
      return exception.message;
    }
    return exception.message;
  }

  /// Log exception for debugging
  static void logException(AppException exception, {String? tag}) {
    final prefix = tag != null ? '[$tag]' : '[Exception]';
    print('$prefix ${exception.code}: ${exception.message}');
    if (exception.originalException != null) {
      print('  Original: ${exception.originalException}');
    }
  }
}
