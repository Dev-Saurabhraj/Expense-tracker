import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationHelper {

  static void navigateTo(
    BuildContext context,
    String location, {
    Object? extra,
  }) {
    context.go(location, extra: extra);
  }


  static void navigateReplace(
    BuildContext context,
    String location, {
    Object? extra,
  }) {
    context.replace(location, extra: extra);
  }


  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }


  static bool canGoBack(BuildContext context) {
    return context.canPop();
  }
}
