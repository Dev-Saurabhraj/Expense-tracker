import 'package:flutter/material.dart';
import '../Utils/chart_constants.dart';


class ScrollHelper {

  static int calculateActiveIndex(ScrollController scrollController) {
    if (!scrollController.hasClients) return 5;

    int active = (scrollController.offset / ChartConstants.pointSpacing)
        .round();
    if (active < 0) active = 0;
    if (active > 5) active = 5;

    return active;
  }


  static void jumpToEnd(ScrollController scrollController) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }


  static void disposeScrollController(ScrollController scrollController) {
    scrollController.dispose();
  }
}
