import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/controllers/home/home_controller.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/views/pages/home/views/featured_products_list_item.dart';
import 'package:shopping_store/views/pages/home/views/home_category_widget.dart';
import 'package:shopping_store/views/pages/home/views/new_arrival_products_list_item.dart';
import 'package:shopping_store/views/pages/product_details/product_details_page.dart';
import 'package:shopping_store/views/widgets/shopping_outlined_button.dart';
import 'package:shopping_store/views/widgets/shopping_search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final homeController = Get.put(HomeController(context));
    return GetBuilder<HomeController>(builder: (gbContext) {
      return SafeArea(
        child: Scaffold(
          body: CustomRefreshIndicator(
            leadingScrollIndicatorVisible: false,
            trailingScrollIndicatorVisible: false,
            builder: MaterialIndicatorDelegate(
              builder: (context, controller) {
                return Icon(
                  Icons.autorenew,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                );
              },
              scrollableBuilder: (context, child, controller) {
                return Opacity(
                  opacity: 1.0 - controller.value.clamp(0.0, 1.0),
                  child: child,
                );
              },
            ),
            onRefresh: () => Future.delayed(
              const Duration(seconds: 2),
              () => homeController.initializePage(),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppSizes.pagePadding,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: homeController.onSearchBarTapped,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: AppSizes.pagePadding,
                          right: AppSizes.pagePadding,
                        ),
                        child: shoppingSearchBar(
                          textEditingController: homeController.searchTextEditingController,
                          onChanged: homeController.searchFieldOnChanged,
                          hintText: "searchProducts".tr,
                          labelText: "searchProducts".tr,
                          onTapSuffixIcon: () {},
                          validator: homeController.validator,
                          isEnabled: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        "welcome".tr,
                        style: Theme.of(context).textTheme.bodyLarge?.apply(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontWeightDelta: 1,
                              fontSizeDelta: 3,
                            ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: size.width,
                      height: size.height / 14,
                      child: ListView.builder(
                        itemCount: homeController.listProductCategories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (lvContext, lvIndex) {
                          return Row(
                            children: [
                              const SizedBox(width: 5),
                              InkWell(
                                onTap: () => homeController.onCategoryTapped(
                                  categoryId: homeController.listProductCategories[lvIndex].id,
                                  category: homeController.listProductCategories[lvIndex].englishName,
                                ),
                                child: HomeCategoryWidget(
                                  backgroundColor: homeController.listProductCategories[lvIndex].backgroundColor,
                                  categoryName: hiveBox.get(AppStorageKeys.selectedLocale) == enumAppLanguage.english.index
                                      ? homeController.listProductCategories[lvIndex].englishName
                                      : homeController.listProductCategories[lvIndex].arabicName,
                                  categoryIcon: homeController.listProductCategories[lvIndex].icon,
                                ),
                              ),
                              const SizedBox(width: 5)
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Visibility(
                      visible: !hiveBox.get(AppStorageKeys.isUserLoggedIn, defaultValue: false),
                      child: Column(
                        children: [
                          Container(
                            width: size.width,
                            padding: const EdgeInsets.only(
                              left: AppSizes.pagePadding,
                              right: AppSizes.pagePadding,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width: size.width / 1.6,
                                  child: Text(
                                    "homeLoginSentence".tr,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall?.apply(
                                          fontWeightDelta: 1,
                                          fontSizeDelta: 1,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: SizedBox(
                                    height: size.height / 27,
                                    child: shoppingOutlinedButton(
                                      onPressed: homeController.onLoginButtonClicked,
                                      buttonText: "login".tr,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: homeController.listFeaturedProducts.isEmpty ? false : true,
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: AppSizes.pagePadding,
                          right: AppSizes.pagePadding,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'featuredProducts'.tr,
                              style: Theme.of(context).textTheme.bodyLarge?.apply(
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                    fontWeightDelta: 1,
                                    fontSizeDelta: 3,
                                  ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: homeController.openFeaturedProducts,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: size.height / 30,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: homeController.listFeaturedProducts.isEmpty ? false : true,
                      child: SizedBox(
                        width: size.width,
                        height: size.height / 2.8,
                        child: ListView.builder(
                          itemCount: homeController.listFeaturedProducts.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (lvContext, lvIndex) {
                            return Row(
                              children: [
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => ProductDetailsPage(
                                        productDetails: homeController.listFeaturedProducts[lvIndex],
                                        videoUrl: homeController.getVideoFromProductMediaList(
                                          listMedia: homeController.listFeaturedProducts[lvIndex].arrMedia,
                                        ),
                                        cameFromSearch: false,
                                      ),
                                    );
                                  },
                                  child: FeaturedProductsListItem(
                                    productName: hiveBox.get(AppStorageKeys.selectedLocale) == enumAppLanguage.english.index
                                        ? homeController.listFeaturedProducts[lvIndex].englishName
                                        : homeController.listFeaturedProducts[lvIndex].arabicName,
                                    imageUrl:
                                        "${Api.fileBaseUrl}/${homeController.getImageFromProductMediaList(listMedia: homeController.listFeaturedProducts[lvIndex].arrMedia)}",
                                    productPrice:
                                        "${hiveBox.get(AppStorageKeys.selectedCurrencyCode)} ${homeController.listFeaturedProducts[lvIndex].price.toString()}",
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Visibility(
                      visible: homeController.listNewArrivalProducts.isEmpty ? false : true,
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: AppSizes.pagePadding,
                          right: AppSizes.pagePadding,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'newArrivals'.tr,
                              style: Theme.of(context).textTheme.bodyLarge?.apply(
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                    fontWeightDelta: 1,
                                    fontSizeDelta: 3,
                                  ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: homeController.openNewArrivalProducts,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: size.height / 30,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: homeController.listNewArrivalProducts.isEmpty ? false : true,
                      child: SizedBox(
                        width: size.width,
                        height: size.height / 2.8,
                        child: ListView.builder(
                          itemCount: homeController.listNewArrivalProducts.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (lvContext, lvIndex) {
                            return Row(
                              children: [
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => ProductDetailsPage(
                                        productDetails: homeController.listNewArrivalProducts[lvIndex],
                                        videoUrl: homeController.getVideoFromProductMediaList(
                                          listMedia: homeController.listNewArrivalProducts[lvIndex].arrMedia,
                                        ),
                                        cameFromSearch: false,
                                      ),
                                    );
                                  },
                                  child: NewArrivalProductsListItem(
                                    productName: hiveBox.get(AppStorageKeys.selectedLocale) == enumAppLanguage.english.index
                                        ? homeController.listNewArrivalProducts[lvIndex].englishName
                                        : homeController.listNewArrivalProducts[lvIndex].arabicName,
                                    imageUrl:
                                        "${Api.fileBaseUrl}/${homeController.getImageFromProductMediaList(listMedia: homeController.listNewArrivalProducts[lvIndex].arrMedia)}",
                                    productPrice:
                                        "${hiveBox.get(AppStorageKeys.selectedCurrencyCode)} ${homeController.listNewArrivalProducts[lvIndex].price.toString()}",
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Visibility(
                      visible: homeController.listPackagedProducts.isEmpty ? false : true,
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: AppSizes.pagePadding,
                          right: AppSizes.pagePadding,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'packages'.tr,
                              style: Theme.of(context).textTheme.bodyLarge?.apply(
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                    fontWeightDelta: 1,
                                    fontSizeDelta: 3,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: homeController.listPackagedProducts.isEmpty ? false : true,
                      child: SizedBox(
                        width: size.width,
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2 / 3.5,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                          ),
                          padding: const EdgeInsets.all(10.0),
                          itemCount: homeController.listPackagedProducts.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (gvContext, lvIndex) {
                            return InkWell(
                              onTap: () {
                                Get.to(
                                  () => ProductDetailsPage(
                                    productDetails: homeController.listPackagedProducts[lvIndex],
                                    videoUrl: homeController.getVideoFromProductMediaList(
                                      listMedia: homeController.listPackagedProducts[lvIndex].arrMedia,
                                    ),
                                    cameFromSearch: false,
                                  ),
                                );
                              },
                              child: FeaturedProductsListItem(
                                productName: hiveBox.get(AppStorageKeys.selectedLocale) == enumAppLanguage.english.index
                                    ? homeController.listPackagedProducts[lvIndex].englishName
                                    : homeController.listPackagedProducts[lvIndex].arabicName,
                                imageUrl:
                                    "${Api.fileBaseUrl}/${homeController.getImageFromProductMediaList(listMedia: homeController.listPackagedProducts[lvIndex].arrMedia)}",
                                productPrice:
                                    "${hiveBox.get(AppStorageKeys.selectedCurrencyCode)} ${homeController.listPackagedProducts[lvIndex].price.toString()}",
                                isPackage: true,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
