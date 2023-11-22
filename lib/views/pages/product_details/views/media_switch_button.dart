import 'package:flutter/material.dart';

class MediaSwitchButton extends StatelessWidget {
  final String buttonText;
  final Color backgroundColor;

  const MediaSwitchButton({
    Key? key,
    required this.buttonText,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 5,
      alignment: Alignment.center,
      padding: EdgeInsets.all(size.width / 100),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Text(
        buttonText,
        style: Theme.of(context).textTheme.labelSmall?.apply(
              fontWeightDelta: 2,
            ),
      ),
    );
  }
}
