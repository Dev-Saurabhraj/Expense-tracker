/// Input validation utilities
class ValidationUtils {
  /// Validate if amount is positive
  static bool isValidAmount(double amount) {
    return amount > 0;
  }

  /// Validate if string is not empty
  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }

  /// Validate if string has minimum length
  static bool hasMinLength(String value, int minLength) {
    return value.length >= minLength;
  }

  /// Validate if email format is correct
  static bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Parse string to double safely
  static double? parseDouble(String value) {
    try {
      return double.parse(value);
    } catch (_) {
      return null;
    }
  }

  /// Parse string to int safely
  static int? parseInt(String value) {
    try {
      return int.parse(value);
    } catch (_) {
      return null;
    }
  }
}
