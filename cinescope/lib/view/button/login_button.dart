import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton(
      {super.key,
      required this.pressedFunction,
      required this.childWidget,
      this.relevant = true});

  final void Function() pressedFunction;
  final Widget childWidget;
  final bool relevant;

  @override
  Widget build(BuildContext context) {
    if (relevant) {
      return TextButton(
          onPressed: pressedFunction,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  ((states) => const Color(0xFF2C666E))),
              shape: MaterialStateProperty.resolveWith((states) =>
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      side: BorderSide(color: Color(0xFF2C666E), width: 2)))),
          child: childWidget);
    } else {
      return TextButton(
          onPressed: pressedFunction,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  ((states) => const Color(0XFF07393C))),
              shape: MaterialStateProperty.resolveWith((states) =>
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      side: BorderSide(color: Color(0xFF2C666E), width: 2)))),
          child: childWidget);
    }
  }
}
