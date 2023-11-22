import 'package:flutter/material.dart';

class AppBarMenuItemWidget extends StatelessWidget {
  final String title;

  const AppBarMenuItemWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
