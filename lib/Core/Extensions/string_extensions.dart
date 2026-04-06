
extension StringExtensions on String {

  bool get isEmpty => trim().isEmpty;


  bool get isNotEmpty => trim().isNotEmpty;


  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }


  String get capitalizeWords {
    return split(' ')
        .map(
          (word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }


  String get toCamelCase {
    List<String> parts = split(RegExp(r'[\s_-]'));
    if (parts.isEmpty) return this;

    return parts[0].toLowerCase() +
        parts.skip(1).map((part) => part.capitalize).join('');
  }


  bool get isNumeric {
    return RegExp(r'^\d+$').hasMatch(this);
  }


  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }


  String truncate(int length, {String ellipsis = '...'}) {
    if (this.length <= length) return this;
    return substring(0, length) + ellipsis;
  }
}
