/// Custom exception classes for the application
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final Exception? originalException;

  AppException({required this.message, this.code, this.originalException});

  @override
  String toString() => message;
}

/// Exception thrown when data is not found
class NotFoundException extends AppException {
  NotFoundException({
    required String message,
    String? code,
    Exception? originalException,
  }) : super(
         message: message,
         code: code ?? 'NOT_FOUND',
         originalException: originalException,
       );
}

/// Exception thrown due to network errors
class NetworkException extends AppException {
  NetworkException({
    required String message,
    String? code,
    Exception? originalException,
  }) : super(
         message: message,
         code: code ?? 'NETWORK_ERROR',
         originalException: originalException,
       );
}

/// Exception thrown due to parsing errors
class ParseException extends AppException {
  ParseException({
    required String message,
    String? code,
    Exception? originalException,
  }) : super(
         message: message,
         code: code ?? 'PARSE_ERROR',
         originalException: originalException,
       );
}

/// Exception thrown due to database errors
class DatabaseException extends AppException {
  DatabaseException({
    required String message,
    String? code,
    Exception? originalException,
  }) : super(
         message: message,
         code: code ?? 'DATABASE_ERROR',
         originalException: originalException,
       );
}

/// Exception thrown for unauthorized access
class UnauthorizedException extends AppException {
  UnauthorizedException({
    required String message,
    String? code,
    Exception? originalException,
  }) : super(
         message: message,
         code: code ?? 'UNAUTHORIZED',
         originalException: originalException,
       );
}

/// Exception thrown for invalid input
class ValidationException extends AppException {
  ValidationException({
    required String message,
    String? code,
    Exception? originalException,
  }) : super(
         message: message,
         code: code ?? 'VALIDATION_ERROR',
         originalException: originalException,
       );
}

/// Generic exception for unknown errors
class UnknownException extends AppException {
  UnknownException({
    required String message,
    String? code,
    Exception? originalException,
  }) : super(
         message: message,
         code: code ?? 'UNKNOWN_ERROR',
         originalException: originalException,
       );
}
