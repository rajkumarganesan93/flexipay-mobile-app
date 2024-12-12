import 'package:flutter/material.dart';

class ExceptionHandler {
  static void handleException(dynamic exception, StackTrace stackTrace) {
    // You can log the exception or show an alert dialog
    print('Exception: $exception\nStackTrace: $stackTrace');
    // Show user-friendly error messages
    // Example: Using a Flutter Toast or Dialog to show error messages
    final snackBar = SnackBar(content: Text('An error occurred. Please try again.'));
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(snackBar);
  }
}
