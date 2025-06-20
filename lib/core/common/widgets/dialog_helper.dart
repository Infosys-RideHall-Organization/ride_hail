import 'package:flutter/material.dart';

class DialogHelper {
  static Future<bool> showLocationErrorDialog(
    BuildContext context,
    String message,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Location Access Required'),
                content: Text(
                  '$message\n\nWould you like to open settings?',
                  style: TextStyle(fontSize: 18.0),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Open Settings',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
