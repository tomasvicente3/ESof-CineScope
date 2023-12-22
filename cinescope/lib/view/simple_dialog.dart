import 'package:flutter/material.dart';

class GenericDialog extends StatelessWidget {
  final String title;
  final String content;

  const GenericDialog({super.key, required this.title, required this.content});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  Text(title),
      content:  Text(
        content,
        textScaleFactor: 1.2,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok"))
      ],
    );
  }
}
