import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/controllers/search_products/search_products_controller.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/views/pages/home/views/featured_products_list_item.dart';
import 'package:shopping_store/views/pages/product_details/product_details_page.dart';
import 'package:shopping_store/views/widgets/shopping_app_bar_with_search.dart';

class SearchProductsPage extends StatelessWidget {
  final int categoryId;
  final String category;
  final bool autoFocus;
  final bool cameFromSearch;
  final bool isFeatured;
  final bool isNewArrival;

  const SearchProductsPage({
    Key? key,
    this.categoryId = 0,
    this.category = "",
    this.autoFocus = false,
    required this.cameFromSearch,
    this.isFeatured = false,
    this.isNewArrival = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchProductsController = Get.put(
      SearchProductsController(
        context,
        categoryId,
        category,
        isFeatured,
        isNewArrival,
      ),
    );
    return GetBuilder<SearchProductsController>(builder: (gbContext) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Form(
                key: searchProductsController.formKey,
                child: shoppingAppBarWithSearch(
                  onBackButtonTapped: searchProductsController.goBack,
                  textEditingController: searchProductsController.searchTextEditingController,
                  onChanged: searchProductsController.searchFieldOnChanged,
                  validator: searchProductsController.validator,
                  onSearchBarTapped: () {},
                  isSearchBarEnabled: true,
                  focusNode: searchProductsController.searchFieldFocusNode,
                  cameFromSearch: cameFromSearch,
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification && notification.metrics.extentAfter == 0) {
                      searchProductsController.loadMoreData();
                    }
                    return false;
                  },
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 2.9,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    itemCount: searchProductsController.productsList.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (gvContext, lvIndex) {
                      return InkWell(
                        onTap: () {
                          Get.to(
                            () => ProductDetailsPage(
                              productDetails: searchProductsController.productsList[lvIndex],
                              videoUrl: searchProductsController.getVideoFromProductMediaList(
                                listMedia: searchProductsController.productsList[lvIndex].arrMedia,
                              ),
                              cameFromSearch: true,
                            ),
                          );
                        },
                        child: FeaturedProductsListItem(
                          productName: hiveBox.get(AppStorageKeys.selectedLocale) == enumAppLanguage.english.index
                              ? searchProductsController.productsList[lvIndex].englishName
                              : searchProductsController.productsList[lvIndex].arabicName,
                          imageUrl:
                              "${Api.fileBaseUrl}/${searchProductsController.getImageFromProductMediaList(listMedia: searchProductsController.productsList[lvIndex].arrMedia)}",
                          productPrice:
                              "${hiveBox.get(AppStorageKeys.selectedCurrencyCode)} ${searchProductsController.productsList[lvIndex].price.toString()}",
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
