import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/controllers/select_country/select_country_controller.dart';
import 'package:shopping_store/services/api.dart';

class SelectCountryPage extends StatelessWidget {
  final bool isFromAppBar;
  const SelectCountryPage({
    Key? key,
    this.isFromAppBar = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final selectCountryController = Get.put(SelectCountryController(context, isFromAppBar));
    return GetBuilder<SelectCountryController>(builder: (gbContext) {
      return SafeArea(
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "selectLanguage".tr,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Visibility(
                      visible: isFromAppBar,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: selectCountryController.countriesList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext lvContext, int lvIndex) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () => selectCountryController.onLanguageClick(countriesListModel: selectCountryController.countriesList[lvIndex]),
                          child: ListTile(
                            minVerticalPadding: 0,
                            dense: true,
                            title: SizedBox(
                              width: size.width,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.network(
                                    "${Api.fileBaseUrl}/${selectCountryController.countriesList[lvIndex].image}",
                                    width: size.width / 10,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      selectCountryController.countriesList[lvIndex].countryName,
                                      style: Theme.of(context).textTheme.bodyMedium?.apply(
                                            fontWeightDelta: 2,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
