/// Utility class for pagination calculations and logic
class PaginationUtils {
  static const int defaultItemsPerPage = 8;

  /// Calculate total pages based on items count
  static int calculateTotalPages(
    int itemCount, {
    int itemsPerPage = defaultItemsPerPage,
  }) {
    return (itemCount / itemsPerPage).ceil();
  }

  /// Get paginated items
  static List<T> getPaginatedItems<T>(
    List<T> items, {
    required int currentPage,
    int itemsPerPage = defaultItemsPerPage,
  }) {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, items.length);
    return items.sublist(startIndex, endIndex);
  }

  /// Validate current page
  static int validatePage(int currentPage, int totalPages) {
    if (totalPages == 0) return 1;
    return currentPage > totalPages ? totalPages : currentPage;
  }

  /// Check if can go to next page
  static bool canGoNext(int currentPage, int totalPages) {
    return currentPage < totalPages;
  }

  /// Check if can go to previous page
  static bool canGoPrevious(int currentPage) {
    return currentPage > 1;
  }
}
