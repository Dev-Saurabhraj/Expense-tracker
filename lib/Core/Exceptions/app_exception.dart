// custom exception
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final Exception? originalException;

  AppException({required this.message, this.code, this.originalException});

  @override
  String toString() => message;
}

// no data exception
class NotFoundException extends AppException {
  NotFoundException({
    required super.message,
    String? code,
    super.originalException,
  }) : super(
         code: code ?? 'NOT_FOUND',
       );
}

// network error
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

//parse error
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

//database error
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

//authentication error
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

// invalid input
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

//unknown exception
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
