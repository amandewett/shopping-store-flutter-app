import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_assets.dart';
import 'package:shopping_store/constants/app_colors.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/controllers/cart/cart_controller.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/cart_item_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/utils/global_functions.dart';
import 'package:shopping_store/views/widgets/shopping_elevated_button.dart';
import 'package:shopping_store/views/widgets/shopping_network_image_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CartPage extends StatelessWidget {
  const CartPage({
    Key? key,
  }) : super(key: key);

  Widget _buildPriceItem({
    required BuildContext ctx,
    required String priceType,
    required String priceValue,
    bool isButton = false,
    required void Function() onTap,
    Color priceTypeColor = AppColors.lightTextColor,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              priceType,
              style: Theme.of(ctx).textTheme.bodyMedium?.apply(),
            ),
            GestureDetector(
              onTap: onTap,
              child: Text(
                priceValue,
                style: Theme.of(ctx).textTheme.bodyMedium?.apply(
                      fontWeightDelta: 2,
                      color: priceTypeColor,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cartController = Get.put(CartController(context));
    return GetBuilder<CartController>(builder: (gbContext) {
      return VisibilityDetector(
        key: cartController.visibilityKey,
        onVisibilityChanged: cartController.onVisibilityChange,
        child: SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: AppSizes.pagePadding,
                          right: AppSizes.pagePadding,
                        ),
                        child: Stack(
                          children: [
                            Visibility(
                              visible: cartController.listCartItems.isNotEmpty,
                              child: ListView.builder(
                                  itemCount: cartController.listCartItems.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (lvContext, lvIndex) {
                                    final CartItemModel cartItem = cartController.listCartItems[lvIndex];
                                    return Column(
                                      children: [
                                        SizedBox(
                                          width: size.width,
                                          height: size.height / 7,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Align(
                                                alignment: Alignment.topCenter,
                                                child: ClipRRect(
                                                  borderRadius: const BorderRadius.all(
                                                    Radius.circular(
                                                      AppSizes.cardBorderRadius,
                                                    ),
                                                  ),
                                                  child: shoppingNetworkImageWidget(
                                                    imageUrl:
                                                        "${Api.fileBaseUrl}/${cartController.getImageFromProductMediaList(listMedia: cartItem.productId.arrMedia)}",
                                                    imageWidth: size.width / 5,
                                                    imageHeight: size.width / 5,
                                                    boxFit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    bottom: 10.0,
                                                    right: 10.0,
                                                    left: 10.0,
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        hiveBox.get(
                                                                  AppStorageKeys.selectedLocale,
                                                                  defaultValue: enumAppLanguage.english.index,
                                                                ) ==
                                                                enumAppLanguage.english.index
                                                            ? cartItem.productId.categoryId.englishName
                                                            : cartItem.productId.categoryId.arabicName,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.start,
                                                        style: Theme.of(context).textTheme.bodySmall?.apply(
                                                              color: Theme.of(context).hintColor,
                                                            ),
                                                      ),
                                                      Text(
                                                        hiveBox.get(
                                                                  AppStorageKeys.selectedLocale,
                                                                  defaultValue: enumAppLanguage.english.index,
                                                                ) ==
                                                                enumAppLanguage.english.index
                                                            ? cartItem.productId.englishName
                                                            : cartItem.productId.arabicName,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: Theme.of(context).textTheme.titleMedium,
                                                      ),
                                                      const SizedBox(height: 10),
                                                      SizedBox(
                                                        width: size.width,
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "${hiveBox.get(
                                                                        AppStorageKeys.selectedLocale,
                                                                        defaultValue: enumAppLanguage.english.index,
                                                                      ) == enumAppLanguage.english.index ? hiveBox.get(AppStorageKeys.selectedCurrencyCode) : hiveBox.get(AppStorageKeys.selectedCurrencyCodeInArabic)} ${cartItem.productId.price}",
                                                                  style: Theme.of(context).textTheme.bodyMedium?.apply(
                                                                        fontWeightDelta: 5,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  "item".tr,
                                                                  style: Theme.of(context).textTheme.bodyMedium?.apply(
                                                                        color: Theme.of(context).hintColor,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  Opacity(
                                                                    opacity: cartController.isRemovingFromCart ? 0 : 1.0,
                                                                    child: InkWell(
                                                                      onTap: () => cartController.deleteFromCart(productId: cartItem.productId.id),
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                            color: Colors.grey,
                                                                          ),
                                                                          borderRadius: const BorderRadius.all(
                                                                            Radius.circular(20),
                                                                          ),
                                                                        ),
                                                                        child: Icon(
                                                                          Icons.remove,
                                                                          size: size.width / 17,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    color: Colors.white,
                                                                    padding: const EdgeInsets.all(
                                                                      10.0,
                                                                    ),
                                                                    alignment: Alignment.center,
                                                                    child: Text(
                                                                      "${cartItem.itemCount}",
                                                                      style: Theme.of(context).textTheme.bodySmall?.apply(
                                                                            color: Theme.of(context).colorScheme.primary,
                                                                            fontSizeDelta: 4,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  Opacity(
                                                                    opacity: cartController.isAddingToCart ? 0 : 1.0,
                                                                    child: InkWell(
                                                                      onTap: () => cartController.addToCart(productId: cartItem.productId.id),
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                            color: Colors.grey,
                                                                          ),
                                                                          borderRadius: const BorderRadius.all(
                                                                            Radius.circular(20),
                                                                          ),
                                                                        ),
                                                                        child: Icon(
                                                                          Icons.add,
                                                                          size: size.width / 17,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(height: 1.0),
                                        const SizedBox(height: 10),
                                      ],
                                    );
                                  }),
                            ),
                            Visibility(
                              visible: cartController.listCartItems.isEmpty,
                              child: Center(
                                child: Image.asset(
                                  AppAssets.appEmptyCartBg,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: cartController.listCartItems.isNotEmpty,
                      child: GestureDetector(
                        onTap: cartController.toggleBottom,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: cartController.isBottomExpanded ? Colors.white : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(cartController.isBottomExpanded ? 20 : 0),
                              topRight: Radius.circular(cartController.isBottomExpanded ? 20 : 0),
                            ),
                          ),
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            bottom: 10.0,
                            left: 10.0,
                            right: 10.0,
                          ),
                          height: cartController.isBottomExpanded ? size.height / 2.7 : size.height / 10,
                          onEnd: cartController.onAnimationCompleted,
                          child: Column(
                            children: [
                              Expanded(
                                child: cartController.isBottomExpanded && cartController.isBottomExpandedCompletely
                                    ? SizedBox(
                                        width: size.width,
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "priceDetails".tr,
                                                    style: Theme.of(context).textTheme.labelLarge?.apply(
                                                          fontWeightDelta: 2,
                                                          fontSizeDelta: 2,
                                                        ),
                                                  ),
                                                ),
                                                const Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Icon(
                                                    Icons.cancel,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            _buildPriceItem(
                                              ctx: context,
                                              priceType: "itemTotal".tr,
                                              priceValue:
                                                  "${getRightTranslation(hiveBox.get(AppStorageKeys.selectedCurrencyCode), hiveBox.get(AppStorageKeys.selectedCurrencyCodeInArabic))} ${cartController.itemTotal.toStringAsFixed(2)}",
                                              onTap: () {},
                                            ),
                                            _buildPriceItem(
                                              ctx: context,
                                              priceType: "tax".tr,
                                              priceValue:
                                                  "${getRightTranslation(hiveBox.get(AppStorageKeys.selectedCurrencyCode), hiveBox.get(AppStorageKeys.selectedCurrencyCodeInArabic))} ${cartController.taxValue.toStringAsFixed(2)} (${cartController.taxPercent.toStringAsFixed(0)}%)",
                                              onTap: () {},
                                            ),
                                            _buildPriceItem(
                                              ctx: context,
                                              priceType: "itemDiscount".tr,
                                              isButton: true,
                                              priceValue:
                                                  "- ${getRightTranslation(hiveBox.get(AppStorageKeys.selectedCurrencyCode), hiveBox.get(AppStorageKeys.selectedCurrencyCodeInArabic))} ${cartController.totalDiscountValue.toStringAsFixed(2)} (${cartController.totalDiscountPercent.toStringAsFixed(0)}%)",
                                              onTap: () {},
                                              priceTypeColor: Theme.of(context).colorScheme.primary,
                                            ),
                                            _buildPriceItem(
                                              ctx: context,
                                              priceType: "coupon".tr,
                                              priceValue: cartController.isCouponApplied ? "removeCoupon".tr : "applyCoupon".tr,
                                              onTap: cartController.isCouponApplied ? cartController.removeCoupon : cartController.openCouponDialog,
                                              isButton: true,
                                              priceTypeColor: Theme.of(context).colorScheme.primary,
                                            ),
                                            _buildPriceItem(
                                              ctx: context,
                                              priceType: "shippingFee".tr,
                                              priceValue:
                                                  "${getRightTranslation(hiveBox.get(AppStorageKeys.selectedCurrencyCode), hiveBox.get(AppStorageKeys.selectedCurrencyCodeInArabic))} ${cartController.shippingFee.toStringAsFixed(2)}",
                                              onTap: () {},
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: size.width / 3,
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${hiveBox.get(
                                                    AppStorageKeys.selectedLocale,
                                                    defaultValue: enumAppLanguage.english.index,
                                                  ) == enumAppLanguage.english.index ? hiveBox.get(AppStorageKeys.selectedCurrencyCode) : hiveBox.get(AppStorageKeys.selectedCurrencyCodeInArabic)} ${cartController.totalCartValue.toStringAsFixed(2)}",
                                              style: Theme.of(context).textTheme.bodyMedium?.apply(
                                                    fontWeightDelta: 2,
                                                  ),
                                            ),
                                            const Icon(Icons.expand_less),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Text(
                                              "saved".tr,
                                              style: Theme.of(context).textTheme.bodySmall?.apply(
                                                    color: Theme.of(context).colorScheme.primary,
                                                  ),
                                            ),
                                            Text(
                                              "${hiveBox.get(
                                                    AppStorageKeys.selectedLocale,
                                                    defaultValue: enumAppLanguage.english.index,
                                                  ) == enumAppLanguage.english.index ? hiveBox.get(AppStorageKeys.selectedCurrencyCode) : hiveBox.get(AppStorageKeys.selectedCurrencyCodeInArabic)} ${cartController.totalDiscountValue.toStringAsFixed(2)}",
                                              style: Theme.of(context).textTheme.bodySmall?.apply(
                                                    color: Theme.of(context).colorScheme.primary,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        // const SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width / 3,
                                    height: size.height / 22,
                                    child: shoppingElevatedButton(
                                      onPressed: cartController.onCheckoutTapped,
                                      buttonText: "selectAddress".tr,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
