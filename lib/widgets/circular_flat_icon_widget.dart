import 'package:flutter/material.dart';

typedef OnPressed = void Function();

class CircularFlatButton extends StatelessWidget {
  final double size;
  final Widget child;
  final String name;
  final VoidCallback? onPressed;

  const CircularFlatButton(
      {Key? key,
      required this.size,
      required this.name,
      required this.onPressed,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: size,
        width: size,
        child: ElevatedButton(
            onPressed: onPressed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                child,
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepPurpleAccent,
                  ),
                )
              ],
            )));
  }
}
