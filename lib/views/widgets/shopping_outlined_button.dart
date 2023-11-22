import 'package:flutter/material.dart';

class shoppingOutlinedButton extends StatelessWidget {
  final void Function() onPressed;
  final String buttonText;
  final TextStyle textStyle;

  const shoppingOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.textStyle = const TextStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: textStyle,
      ),
    );
  }
}
