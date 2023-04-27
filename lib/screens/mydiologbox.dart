import 'package:flutter/material.dart';
import 'button.dart';

class MyAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final Function? onButtonPressed;

  const MyAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.buttonText,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        MyButton(
          onPressed: () {
            if (onButtonPressed != null) {
              onButtonPressed!();
            } else {
              Navigator.pop(context);
            }
          },
          text: buttonText,
        ),
      ],
    );
  }
}
