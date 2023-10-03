import 'package:flutter/material.dart';

class CustomMessageDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onPositivePressed;

  const CustomMessageDialog({super.key, 
    required this.title,
    required this.message,
    required this.onPositivePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed:onPositivePressed,
            
          child: const Text('OK'),
        ),
      ],
    );
  }
}