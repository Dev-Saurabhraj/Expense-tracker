import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation helper for managing app routes
class NavigationHelper {
  /// Navigate to route
  static void navigateTo(
    BuildContext context,
    String location, {
    Object? extra,
  }) {
    context.go(location, extra: extra);
  }

  /// Navigate to route and replace current
  static void navigateReplace(
    BuildContext context,
    String location, {
    Object? extra,
  }) {
    context.replace(location, extra: extra);
  }

  /// Navigate back
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  /// Check if can navigate back
  static bool canGoBack(BuildContext context) {
    return context.canPop();
  }
}
