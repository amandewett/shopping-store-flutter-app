import 'package:flutter/material.dart';
import 'package:shopping_store/constants/app_colors.dart';

class HighlightItemWidget extends StatelessWidget {
  final String title;
  final String description;

  const HighlightItemWidget({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.apply(
                  fontWeightDelta: 2,
                ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.apply(
                    color: AppColors.lightHintColor,
                    fontSizeDelta: -2,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
