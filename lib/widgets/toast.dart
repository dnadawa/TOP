import 'package:flutter/material.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class ToastBar {
  final String text;
  final Color color;

  ToastBar({required this.text, required this.color});

  void show() {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) {
      debugPrint('Toast skipped before ScaffoldMessenger was ready: $text');
      return;
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }
}
