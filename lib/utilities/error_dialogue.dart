import 'package:flutter/material.dart';

// ignore: prefer_void_to_null
Future<Null> showError(String errorMessage, BuildContext context, List<Widget> actions) {
  List<Widget> _actions = [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Dismiss"))];
  _actions = actions + _actions;
  // ignore: prefer_void_to_null
  return showDialog<Null>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(errorMessage),
          actions: _actions,
        );
      });
}
