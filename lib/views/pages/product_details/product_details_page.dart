import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_assets.dart';
import 'package:shopping_store/constants/app_colors.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/controllers/product_details/product_details_controller.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/product_list_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/utils/global_functions.dart';
import 'package:shopping_store/views/pages/product_details/views/highlight_item.dart';
import 'package:shopping_store/views/pages/product_details/views/media_switch_button.dart';
import 'package:shopping_store/views/widgets/coupon_item_widget.dart';
import 'package:shopping_store/views/widgets/shopping_app_bar_with_search.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:shopping_store/views/widgets/shopping_elevated_button.dart';
import 'package:shopping_store/views/widgets/shopping_network_image_widget.dart';
import 'package:shopping_store/views/widgets/shopping_outlined_button.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductListModel productDetails;
  final String videoUrl;
  final bool cameFromSearch;

  const ProductDetailsPage({
    Key? key,
    required this.productDetails,
    this.videoUrl = "",
    required this.cameFromSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final productDetailsController = Get.put(ProductDetailsController(
      context: context,
      videoUrl: videoUrl,
      productDetails: productDetails,
    ));
    return GetBuilder<ProductDetailsController>(builder: (gbContext) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              shoppingAppBarWithSearch(
                onBackButtonTapped: productDetailsController.goBack,
                textEditingController: productDetailsController.searchTextEditingController,
                onChanged: productDetailsController.searchFieldOnChanged,
                validator: productDetailsController.validator,
                onSearchBarTapped: productDetailsController.onSearchBarTapped,
                focusNode: FocusNode(),
                cameFromSearch: cameFromSearch,
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height / 2.7,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: AppSizes.pagePadding,
                            right: AppSizes.pagePadding,
                          ),
                          child: Stack(
                            children: [
                              Visibility(
                                visible: productDetailsController.isMediaActive,
                                child: Swiper(
                                  itemCount: productDetails.arrMedia.isEmpty ? 0 : productDetails.arrMedia.length,
                                  pagination: const SwiperPagination(),
                                  control: const SwiperControl(),
                                  layout: SwiperLayout.DEFAULT,
                                  itemWidth: size.width,
                                  itemBuilder: (BuildContext swiperContext, int swipperIndex) {
                                    List<String> arrImageMediaOnly = productDetailsController.removeVideoUrl(productDetails.arrMedia);
                                    return productDetailsController.isImage(productDetails.arrMedia[swipperIndex])
                                        ? GestureDetector(
                                            onTap: () => productDetailsController.onPhotoTap(
                                              "${Api.fileBaseUrl}/${productDetails.arrMedia[swipperIndex]}",
                                              arrImageMediaOnly,
                                            ),
                                            child: shoppingNetworkImageWidget(
                                              imageUrl: "${Api.fileBaseUrl}/${productDetails.arrMedia[swipperIndex]}",
                                              boxFit: BoxFit.contain,
                                            ),
                                          )
                                        : Chewie(
                                            controller: productDetailsController.chewieController,
                                          );
                                  },
                                ),
                              ),
                              Visibility(
                                visible: !productDetailsController.isMediaActive,
                                child: SizedBox(
                                  width: size.width,
                                  child: Card(
                                    elevation: 2,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        left: AppSizes.pagePadding,
                                        right: AppSizes.pagePadding,
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: HighlightItemWidget(
                                              title: "highlightItemOneTitle".tr,
                                              description: "highlightItemOneDescription".tr,
                                            ),
                                          ),
                                          const Divider(),
                                          Expanded(
                                            child: HighlightItemWidget(
                                              title: "highlightItemTwoTitle".tr,
                                              description: "highlightItemTwoDescription".tr,
                                            ),
                                          ),
                                          const Divider(),
                                          Expanded(
                                            child: HighlightItemWidget(
                                              title: "highlightItemThreeTitle".tr,
                                              description: "highlightItemThreeDescription".tr,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        width: size.width / 2.2,
                        height: size.height / 22,
                        alignment: Alignment.center,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: productDetailsController.onMediaButtonClick,
                                child: MediaSwitchButton(
                                  buttonText: "media".tr,
                                  backgroundColor: productDetailsController.isMediaActive ? AppColors.lightBackgroundColor : Colors.transparent,
                                ),
                              ),
                              GestureDetector(
                                onTap: productDetailsController.onHighlightButtonClick,
                                child: MediaSwitchButton(
                                  buttonText: "highlights".tr,
                                  backgroundColor: !productDetailsController.isMediaActive ? AppColors.lightBackgroundColor : Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      productDetailsController.listCoupons.isNotEmpty && productDetailsController.isCouponVisible
                          ? Container(
                              width: size.width,
                              height: size.height / 10,
                              color: AppColors.logoColor2,
                              child: Stack(
                                children: [
                                  PageView.builder(
                                    controller: productDetailsController.pageController,
                                    itemCount: productDetailsController.listCoupons.length,
                                    onPageChanged: productDetailsController.onPageChanges,
                                    itemBuilder: (pvContext, pvIndex) {
                                      return CouponItemWidget(
                                        size: size,
                                        couponPercent: productDetailsController.listCoupons[pvIndex].couponPercent,
                                        couponName: getRightTranslation(
                                          productDetailsController.listCoupons[pvIndex].couponName,
                                          productDetailsController.listCoupons[pvIndex].couponNameInArabic,
                                        ),
                                        couponDescription: getRightTranslation(
                                          productDetailsController.listCoupons[pvIndex].couponDescription,
                                          productDetailsController.listCoupons[pvIndex].couponDescriptionInArabic,
                                        ),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: PageViewDotIndicator(
                                      currentItem: productDetailsController.selectedCouponIndex,
                                      count: productDetailsController.listCoupons.length,
                                      unselectedColor: Theme.of(context).hintColor,
                                      selectedColor: Theme.of(context).colorScheme.primary,
                                      duration: const Duration(milliseconds: 200),
                                      boxShape: BoxShape.circle,
                                      padding: const EdgeInsets.only(bottom: 2.0),
                                      size: Size(size.width / 30, size.width / 30),
                                      unselectedSize: Size(size.width / 50, size.width / 50),
                                      onItemClicked: productDetailsController.onIndicatorClicked,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 10.0),
                      Container(
                        width: size.width,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          left: AppSizes.pagePadding,
                          right: AppSizes.pagePadding,
                        ),
                        child: Text(
                          hiveBox.get(AppStorageKeys.selectedLocale) == enumAppLanguage.english.index
                              ? "${hiveBox.get(AppStorageKeys.selectedCurrencyCode)} ${productDetails.price.toString()}"
                              : "${hiveBox.get(AppStorageKeys.selectedCurrencyCodeInArabic)} ${productDetails.price.toString()}",
                          style: Theme.of(context).textTheme.headlineSmall?.apply(
                                fontWeightDelta: 1,
                                fontSizeDelta: -2,
                              ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        width: size.width,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          left: AppSizes.pagePadding,
                          right: AppSizes.pagePadding,
                        ),
                        child: Text(
                          hiveBox.get(AppStorageKeys.selectedLocale) == enumAppLanguage.english.index
                              ? productDetails.englishName
                              : productDetails.arabicName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.apply(
                                fontWeightDelta: 1,
                              ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        width: size.width,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          left: AppSizes.pagePadding,
                          right: AppSizes.pagePadding,
                        ),
                        child: Text(
                          hiveBox.get(AppStorageKeys.selectedLocale) == enumAppLanguage.english.index
                              ? productDetails.englishDescription
                              : productDetails.arabicDescription,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: size.width,
                alignment: Alignment.bottomCenter,
                height: size.height / 13,
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => productDetailsController.onStoreIconTapped(),
                      child: Icon(
                        Icons.store_outlined,
                        size: size.width / 12,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: SizedBox(
                        width: size.width,
                        child: shoppingOutlinedButton(
                          onPressed: productDetailsController.onChatButtonTapped,
                          buttonText: "chatNow".tr,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: SizedBox(
                        width: size.width,
                        child: shoppingElevatedButton(
                          onPressed: productDetailsController.addToCart,
                          buttonText: productDetailsController.isCartButtonEnabled ? "addToCard".tr : "viewCart".tr,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
