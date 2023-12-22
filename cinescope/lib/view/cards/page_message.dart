import 'package:flutter/material.dart';

class PageMessage extends StatelessWidget {
  final String text;

  const PageMessage(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 500,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ));
  }
}
