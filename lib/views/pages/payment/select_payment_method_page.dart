import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/controllers/payment/select_payment_method_controller.dart';
import 'package:shopping_store/models/my_fatoorah_payment_method_list_model.dart';
import 'package:shopping_store/utils/global_functions.dart';
import 'package:shopping_store/views/widgets/shopping_app_bar_with_search.dart';
import 'package:shopping_store/views/widgets/shopping_network_image_widget.dart';

class SelectPaymentMethodPage extends StatelessWidget {
  final List<MyFatoorahPaymentMethodListModel> listPaymentMethods;
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
  final int addressId;
  final int billingAddressId;
  final int isInternational;
  final double shipmentFee;

  const SelectPaymentMethodPage({
    Key? key,
    required this.listPaymentMethods,
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
    required this.addressId,
    required this.billingAddressId,
    required this.isInternational,
    required this.shipmentFee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final selectPaymentMethodController = Get.put(SelectPaymentMethodController(
      context,
      listPaymentMethods,
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
      addressId,
      billingAddressId,
      isInternational,
      shipmentFee,
    ));
    return GetBuilder<SelectPaymentMethodController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              shoppingAppBarWithSearch(
                onBackButtonTapped: selectPaymentMethodController.goBack,
                textEditingController: TextEditingController(),
                onChanged: (v) {},
                validator: (s, v) {},
                onSearchBarTapped: () {},
                focusNode: FocusNode(),
                cameFromSearch: true,
              ),
              const SizedBox(height: 0.0),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "selectPaymentMethod".tr,
                  style: Theme.of(context).textTheme.titleLarge?.apply(
                        fontWeightDelta: 1,
                        fontSizeDelta: -1,
                      ),
                ),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: AppSizes.pagePadding,
                    right: AppSizes.pagePadding,
                  ),
                  child: ListView.builder(
                    itemCount: selectPaymentMethodController.listPaymentMethods.length,
                    itemBuilder: (lvContext, lvIndex) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () => selectPaymentMethodController.onPaymentMethodTap(
                              selectPaymentMethodController.listPaymentMethods[lvIndex],
                            ),
                            child: Card(
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                height: 100,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getRightTranslation(
                                              selectPaymentMethodController.listPaymentMethods[lvIndex].paymentMethodEn,
                                              selectPaymentMethodController.listPaymentMethods[lvIndex].paymentMethodAr,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.titleMedium?.apply(
                                                  fontWeightDelta: 1,
                                                  fontSizeDelta: -1,
                                                ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                "serviceCharge".tr,
                                                style: Theme.of(context).textTheme.titleSmall?.apply(
                                                      fontSizeDelta: -3,
                                                      color: Theme.of(context).hintColor,
                                                    ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "${selectPaymentMethodController.listPaymentMethods[lvIndex].currencyIso} ${selectPaymentMethodController.listPaymentMethods[lvIndex].serviceCharge}",
                                                  style: Theme.of(context).textTheme.titleSmall?.apply(
                                                        fontSizeDelta: -3,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2.0),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "paymentCurrency".tr,
                                                    style: Theme.of(context).textTheme.titleSmall?.apply(
                                                          fontSizeDelta: -3,
                                                          color: Theme.of(context).hintColor,
                                                        ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      "${selectPaymentMethodController.listPaymentMethods[lvIndex].paymentCurrencyIso} $totalCartValue",
                                                      style: Theme.of(context).textTheme.titleSmall?.apply(
                                                            fontSizeDelta: -3,
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
                                    // const SizedBox(width: 40),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: shoppingNetworkImageWidget(
                                        imageUrl: selectPaymentMethodController.listPaymentMethods[lvIndex].imageUrl,
                                        boxFit: BoxFit.contain,
                                        imageWidth: size.width / 4,
                                        imageHeight: size.width / 4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
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
