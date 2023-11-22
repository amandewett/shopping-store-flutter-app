import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/controllers/shop/shop_controller.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/views/pages/home/views/featured_products_list_item.dart';
import 'package:shopping_store/views/pages/product_details/product_details_page.dart';
import 'package:shopping_store/views/widgets/shopping_app_bar_with_search.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shopController = Get.put(ShopController(context));
    return GetBuilder<ShopController>(
      builder: (gbContext) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Form(
                  key: shopController.formKey,
                  child: shoppingAppBarWithSearch(
                    onBackButtonTapped: shopController.goBack,
                    textEditingController: shopController.searchTextEditingController,
                    onChanged: shopController.searchFieldOnChanged,
                    validator: shopController.validator,
                    onSearchBarTapped: () {},
                    isSearchBarEnabled: true,
                    focusNode: shopController.searchFieldFocusNode,
                    isBackButtonVisible: false,
                    cameFromSearch: false,
                  ),
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification && notification.metrics.extentAfter == 0) {
                        shopController.loadMoreData(shopController.searchTextEditingController.text);
                      }
                      return false;
                    },
                    child: CustomRefreshIndicator(
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
                        () => shopController.getShopProducts(""),
                      ),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 2.9,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                        ),
                        padding: const EdgeInsets.all(10.0),
                        itemCount: shopController.productsList.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (gvContext, lvIndex) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => ProductDetailsPage(
                                  productDetails: shopController.productsList[lvIndex],
                                  videoUrl: shopController.getVideoFromProductMediaList(
                                    listMedia: shopController.productsList[lvIndex].arrMedia,
                                  ),
                                  cameFromSearch: true,
                                ),
                              );
                            },
                            child: FeaturedProductsListItem(
                              productName: hiveBox.get(AppStorageKeys.selectedLocale) == enumAppLanguage.english.index
                                  ? shopController.productsList[lvIndex].englishName
                                  : shopController.productsList[lvIndex].arabicName,
                              imageUrl:
                                  "${Api.fileBaseUrl}/${shopController.getImageFromProductMediaList(listMedia: shopController.productsList[lvIndex].arrMedia)}",
                              productPrice:
                                  "${hiveBox.get(AppStorageKeys.selectedCurrencyCode)} ${shopController.productsList[lvIndex].price.toString()}",
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
