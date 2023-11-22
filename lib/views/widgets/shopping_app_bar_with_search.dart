import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_assets.dart';
import 'package:shopping_store/views/widgets/shopping_search_bar.dart';

class shoppingAppBarWithSearch extends StatelessWidget {
  final void Function() onBackButtonTapped;
  final TextEditingController textEditingController;
  final void Function(String value) onChanged;
  final String? Function(BuildContext, String?) validator;
  final void Function() onSearchBarTapped;
  final bool isSearchBarEnabled;
  final FocusNode focusNode;
  final bool autoFocus;
  final bool cameFromSearch;
  final bool isBackButtonVisible;
  final int heightFromTop;
  final bool isLogoVisible;
  final Widget widget;

  const shoppingAppBarWithSearch({
    Key? key,
    required this.onBackButtonTapped,
    required this.textEditingController,
    required this.onChanged,
    required this.validator,
    required this.onSearchBarTapped,
    this.isSearchBarEnabled = false,
    required this.focusNode,
    this.autoFocus = false,
    required this.cameFromSearch,
    this.heightFromTop = 10,
    this.isBackButtonVisible = true,
    this.isLogoVisible = true,
    this.widget = const SizedBox(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Visibility(
          visible: cameFromSearch,
          child: isLogoVisible
              ? Container(
                  width: size.width,
                  height: size.height / heightFromTop,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Image.asset(
                    AppAssets.appBarLogoPng,
                    height: size.height / 27,
                  ),
                )
              : widget,
        ),
        Container(
          width: size.width,
          height: size.height / heightFromTop,
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Visibility(
                visible: isBackButtonVisible,
                child: GestureDetector(
                  onTap: onBackButtonTapped,
                  child: const Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: !cameFromSearch,
                  child: GestureDetector(
                    onTap: onSearchBarTapped,
                    child: shoppingSearchBar(
                      textEditingController: textEditingController,
                      onChanged: onChanged,
                      hintText: "searchProducts".tr,
                      labelText: "searchProducts".tr,
                      onTapSuffixIcon: () {},
                      validator: validator,
                      isEnabled: isSearchBarEnabled,
                      autoFocus: autoFocus,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15.0),
            ],
          ),
        ),
      ],
    );
  }
}
