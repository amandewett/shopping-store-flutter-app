import 'package:flutter/material.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';

import '../../../../main.dart';

class HomeCategoryWidget extends StatelessWidget {
  final Color backgroundColor;
  final String categoryName;
  final IconData categoryIcon;
  const HomeCategoryWidget({
    Key? key,
    required this.backgroundColor,
    required this.categoryName,
    required this.categoryIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 2.7,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: backgroundColor,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSizes.cardBorderRadius),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            categoryName,
            style: Theme.of(context).textTheme.bodySmall?.apply(
                  color: Colors.white,
                  fontWeightDelta: 1,
                ),
          ),
          Expanded(
            child: Align(
              alignment: hiveBox.get(AppStorageKeys.selectedLocale) == enumAppLanguage.english.index ? Alignment.centerRight : Alignment.centerLeft,
              child: Icon(
                categoryIcon,
                color: Colors.white,
                size: size.height / 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
