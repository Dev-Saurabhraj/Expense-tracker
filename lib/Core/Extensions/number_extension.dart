// Extension methods for number types
extension NumberExtension on num {
  // Format as currency string
  String toCurrency({int decimalPlaces = 0}) {
    return '\$${toStringAsFixed(decimalPlaces)}';
  }

  // Format for display (rounds to appropriate decimal places)
  String toDisplayString({int decimalPlaces = 2}) {
    return toStringAsFixed(decimalPlaces);
  }
}
