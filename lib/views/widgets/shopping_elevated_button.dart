import 'package:flutter/material.dart';

class shoppingElevatedButton extends StatelessWidget {
  final dynamic Function() onPressed;
  final String buttonText;
  final TextStyle textStyle;

  const shoppingElevatedButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.textStyle = const TextStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: textStyle,
      ),
    );
  }
}
