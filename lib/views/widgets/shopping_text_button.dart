import 'package:flutter/material.dart';

class shoppingTextButton extends StatelessWidget {
  final void Function() onPressed;
  final String buttonText;

  const shoppingTextButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
      ),
    );
  }
}
