import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final Text returnCallbackText;
  final Text confirmCallbackText;
  final VoidCallback? returnCallback;
  final VoidCallback confirmCallback;
  final bool isMultipleChoice;
  const CustomAlertDialog({
    Key? key,
    required this.confirmCallback,
    required this.content,
    required this.returnCallback,
    required this.title,
    required this.confirmCallbackText,
    required this.returnCallbackText,
    required this.isMultipleChoice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        Visibility(
          visible: isMultipleChoice ? true : false,
          child: TextButton(
            onPressed: confirmCallback,
            child: confirmCallbackText,
          ),
        ),
        TextButton(
          onPressed: returnCallback,
          child: returnCallbackText,
        ),
      ],
    );
  }
}
