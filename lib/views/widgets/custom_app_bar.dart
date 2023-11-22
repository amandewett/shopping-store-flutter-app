import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:shopping_store/constants/app_assets.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class CustomAppBar extends StatelessWidget {
  final ExpandedTileController expandedTileController;
  final String title;

  const CustomAppBar({
    Key? key,
    required this.expandedTileController,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            color: Colors.transparent,
            child: ClipPath(
              clipper: ProsteBezierCurve(
                position: ClipPosition.bottom,
                list: [
                  BezierCurveSection(
                    start: Offset(0, size.height / 20),
                    top: Offset(size.width / 2, size.height / 15),
                    end: Offset(size.width, size.height / 20),
                  ),
                ],
              ),
              child: Container(
                height: size.height / 15,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Container(
            width: size.width,
            padding: const EdgeInsets.all(4.0),
            color: Colors.transparent,
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              AppAssets.appBarLogoPng,
              height: size.height / 50,
            ),
          ),
          /* ExpandedTile(
            controller: expandedTileController,
            trailing: Icon(
              Icons.menu,
              color: Theme.of(context).colorScheme.background,
              size: size.height / 40,
            ),
            contentseparator: 20,
            theme: const ExpandedTileThemeData(
              headerColor: Colors.transparent,
              headerRadius: 0,
              headerSplashColor: Colors.transparent,
              trailingPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.all(0),
              headerPadding: EdgeInsets.all(6.0),
              contentBackgroundColor: Colors.transparent,
            ),
            leading: SizedBox(
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.apply(
                      color: Theme.of(context).colorScheme.background,
                      fontSizeDelta: 3,
                    ),
              ),
            ),
            title: const SizedBox(),
            content: Container(
              color: Colors.transparent,
              width: size.width,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const SelectCountryPage());
                    },
                    child: Container(
                      width: size.width,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "selectLanguage".tr,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Expanded(
                            child: Align(
                              alignment: hiveBox.get(AppStorageKeys.selectedLocale) == enumAppLanguage.english.index
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: SvgPicture.network(
                                "${Api.fileBaseUrl}/${hiveBox.get(AppStorageKeys.selectedCountryImage)}",
                                width: size.width / 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ), */
        ],
      ),
    );
  }
}
