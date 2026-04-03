import 'package:flutter/material.dart';
import '../Utils/chart_constants.dart';

/// Helper class for scroll-related operations
class ScrollHelper {
  /// Calculate active index from scroll controller
  static int calculateActiveIndex(ScrollController scrollController) {
    if (!scrollController.hasClients) return 5;

    int active = (scrollController.offset / ChartConstants.pointSpacing)
        .round();
    if (active < 0) active = 0;
    if (active > 5) active = 5;

    return active;
  }

  /// Jump to end of scroll
  static void jumpToEnd(ScrollController scrollController) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  /// Dispose scroll controller safely
  static void disposeScrollController(ScrollController scrollController) {
    scrollController.dispose();
  }
}
