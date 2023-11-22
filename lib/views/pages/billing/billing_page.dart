import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_colors.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/controllers/billing/billing_controller.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/utils/global_functions.dart';
import 'package:shopping_store/views/widgets/shopping_app_bar_with_search.dart';
import 'package:shopping_store/views/widgets/shopping_elevated_button.dart';
import 'package:shopping_store/views/widgets/shopping_outlined_button.dart';
import 'package:shopping_store/views/widgets/shopping_text_button.dart';

class BillingPage extends StatelessWidget {
  final double itemTotal;
  final double taxValue;
  final double taxPercent;
  final double discountValue;
  final double discountPercent;
  final double totalCartValue;
  final double totalCartWeight;
  final List<dynamic> cartItems;
  final int taxId;
  final int couponId;
  final int countryId;

  const BillingPage({
    Key? key,
    required this.itemTotal,
    required this.taxValue,
    required this.taxPercent,
    required this.discountValue,
    required this.discountPercent,
    required this.totalCartValue,
    required this.totalCartWeight,
    required this.cartItems,
    required this.taxId,
    this.couponId = 0,
    required this.countryId,
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
    final billingController = Get.put(BillingController(
      context,
      itemTotal,
      taxValue,
      taxPercent,
      discountValue,
      discountPercent,
      totalCartValue,
      totalCartWeight,
      cartItems,
      taxId,
      couponId,
      countryId,
    ));
    return GetBuilder<BillingController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              shoppingAppBarWithSearch(
                onBackButtonTapped: billingController.goBack,
                textEditingController: TextEditingController(),
                onChanged: (v) {},
                validator: (s, v) {
                  return null;
                },
                onSearchBarTapped: () {},
                focusNode: FocusNode(),
                cameFromSearch: true,
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.only(
                      left: AppSizes.pagePadding,
                      right: AppSizes.pagePadding,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(
                            left: 15.0,
                          ),
                          child: Text(
                            "shippingAddress".tr,
                            style: Theme.of(context).textTheme.bodyLarge?.apply(
                                  fontWeightDelta: 2,
                                ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        billingController.listAddresses.isNotEmpty && billingController.isDefaultAddressInit
                            ? Card(
                                child: Container(
                                  width: size.width,
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        billingController.shippingDefaultAddress.name,
                                        style: Theme.of(context).textTheme.titleMedium?.apply(
                                              fontWeightDelta: 2,
                                              fontSizeDelta: 2,
                                            ),
                                      ),
                                      Text(
                                        billingController.shippingDefaultAddress.email,
                                        style: Theme.of(context).textTheme.bodySmall?.apply(
                                              fontWeightDelta: 1,
                                            ),
                                      ),
                                      Text(
                                        billingController.shippingDefaultAddress.address2 == ""
                                            ? "${billingController.shippingDefaultAddress.address}, ${billingController.shippingDefaultAddress.city}"
                                            : "${billingController.shippingDefaultAddress.address}, ${billingController.shippingDefaultAddress.address2}, ${billingController.shippingDefaultAddress.city}",
                                        style: Theme.of(context).textTheme.titleSmall?.apply(),
                                      ),
                                      billingController.shippingDefaultAddress.isInternational == 0
                                          ? Text(
                                              "${billingController.shippingDefaultAddress.stateDetails!.stateName}, ${billingController.shippingDefaultAddress.countryDetails!.countryName} - ${billingController.shippingDefaultAddress.postalCode}",
                                              style: Theme.of(context).textTheme.titleSmall?.apply(),
                                            )
                                          : Text(
                                              "${billingController.shippingDefaultAddress.internationalCountryDetails!.countryName} - ${billingController.shippingDefaultAddress.postalCode}",
                                              style: Theme.of(context).textTheme.titleSmall?.apply(),
                                            ),
                                      Text(
                                        billingController.shippingDefaultAddress.phoneNumber,
                                        style: Theme.of(context).textTheme.titleSmall?.apply(),
                                      ),
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        child: shoppingTextButton(
                                          onPressed: () => billingController.changeAddress(size: size),
                                          buttonText: "change".tr,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: billingController.isDefaultAddressInit,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(
                              left: 15.0,
                            ),
                            child: Text(
                              "billingAddress".tr,
                              style: Theme.of(context).textTheme.bodyLarge?.apply(
                                    fontWeightDelta: 2,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Visibility(
                          visible: billingController.isDefaultAddressInit,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "sameAsShipping".tr,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.titleSmall?.apply(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSizeDelta: -2,
                                      ),
                                ),
                                AdvancedSwitch(
                                  controller: billingController.billingAddressSwitchController,
                                  activeColor: Theme.of(context).colorScheme.primary,
                                  width: size.width / 8,
                                  height: size.height / 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        billingController.listAddresses.isNotEmpty && billingController.isDefaultBillingAddressInit
                            ? Card(
                                child: Container(
                                  width: size.width,
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        billingController.billingDefaultAddress.name,
                                        style: Theme.of(context).textTheme.titleMedium?.apply(
                                              fontWeightDelta: 2,
                                              fontSizeDelta: 2,
                                            ),
                                      ),
                                      Text(
                                        billingController.billingDefaultAddress.email,
                                        style: Theme.of(context).textTheme.bodySmall?.apply(
                                              fontWeightDelta: 1,
                                            ),
                                      ),
                                      Text(
                                        billingController.billingDefaultAddress.address2 == ""
                                            ? "${billingController.billingDefaultAddress.address}, ${billingController.billingDefaultAddress.city}"
                                            : "${billingController.billingDefaultAddress.address}, ${billingController.billingDefaultAddress.address2}, ${billingController.billingDefaultAddress.city}",
                                        style: Theme.of(context).textTheme.titleSmall?.apply(),
                                      ),
                                      billingController.billingDefaultAddress.isInternational == 0
                                          ? Text(
                                              "${billingController.billingDefaultAddress.stateDetails!.stateName}, ${billingController.billingDefaultAddress.countryDetails!.countryName} - ${billingController.billingDefaultAddress.postalCode}",
                                              style: Theme.of(context).textTheme.titleSmall?.apply(),
                                            )
                                          : Text(
                                              "${billingController.billingDefaultAddress.internationalCountryDetails!.countryName} - ${billingController.billingDefaultAddress.postalCode}",
                                              style: Theme.of(context).textTheme.titleSmall?.apply(),
                                            ),
                                      Text(
                                        billingController.billingDefaultAddress.phoneNumber,
                                        style: Theme.of(context).textTheme.titleSmall?.apply(),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: !billingController.isBillingAddressSameAsShipping && billingController.isDefaultAddressInit ? true : false,
                          child: Container(
                            width: size.width,
                            alignment: Alignment.centerRight,
                            child: shoppingOutlinedButton(
                              onPressed: () => billingController.changeAddress(size: size, isForBilling: true),
                              buttonText: "selectBillingAddress".tr,
                              textStyle: Theme.of(context).textTheme.bodyLarge!.apply(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeightDelta: 1,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: size.width,
                          alignment: Alignment.centerRight,
                          child: shoppingOutlinedButton(
                            onPressed: billingController.onAddNewAddressTap,
                            buttonText: "addNewAddress".tr,
                            textStyle: Theme.of(context).textTheme.bodyLarge!.apply(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeightDelta: 1,
                                ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: size.width,
                          child: Text(
                            "priceDetails".tr,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.titleLarge?.apply(
                                  fontWeightDelta: 2,
                                ),
                          ),
                        ),
                        const Divider(),
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            _buildPriceItem(
                              ctx: context,
                              priceType: "itemTotal".tr,
                              priceValue:
                                  "${getRightTranslation(hiveBox.get(AppStorageKeys.selectedCurrencyCode), hiveBox.get(AppStorageKeys.selectedCurrencyCodeInArabic))} ${billingController.itemTotal.toStringAsFixed(2)}",
                              onTap: () {},
                            ),
                            _buildPriceItem(
                              ctx: context,
                              priceType: "tax".tr,
                              priceValue:
                                  "${getRightTranslation(hiveBox.get(AppStorageKeys.selectedCurrencyCode), hiveBox.get(AppStorageKeys.selectedCurrencyCodeInArabic))} ${billingController.taxValue.toStringAsFixed(2)} (${billingController.taxPercent.toStringAsFixed(0)}%)",
                              onTap: () {},
                            ),
                            _buildPriceItem(
                              ctx: context,
                              priceType: "itemDiscount".tr,
                              isButton: true,
                              priceValue:
                                  "- ${getRightTranslation(hiveBox.get(AppStorageKeys.selectedCurrencyCode), hiveBox.get(AppStorageKeys.selectedCurrencyCodeInArabic))} ${billingController.discountValue.toStringAsFixed(2)} (${billingController.discountPercent.toStringAsFixed(0)}%)",
                              onTap: () {},
                              priceTypeColor: Theme.of(context).colorScheme.primary,
                            ),
                            _buildPriceItem(
                              ctx: context,
                              priceType: "shippingFee".tr,
                              priceValue:
                                  "${getRightTranslation(hiveBox.get(AppStorageKeys.selectedCurrencyCode), hiveBox.get(AppStorageKeys.selectedCurrencyCodeInArabic))} ${billingController.shippingFee.toStringAsFixed(2)}",
                              onTap: () {},
                            ),
                            _buildPriceItem(
                              ctx: context,
                              priceType: "total".tr,
                              priceValue:
                                  "${getRightTranslation(hiveBox.get(AppStorageKeys.selectedCurrencyCode), hiveBox.get(AppStorageKeys.selectedCurrencyCodeInArabic))} ${billingController.totalCartValue.toStringAsFixed(2)}",
                              onTap: () {},
                              priceTypeColor: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: size.width,
                          child: shoppingElevatedButton(
                            onPressed: billingController.onMakePaymentClicked,
                            buttonText: "makePayment".tr,
                            textStyle: Theme.of(context).textTheme.bodyLarge!.apply(
                                  color: Colors.white,
                                  fontWeightDelta: 1,
                                ),
                          ),
                        ),
                      ],
                    ),
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
