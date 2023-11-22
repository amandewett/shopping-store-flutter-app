import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_colors.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/controllers/orders/orders_list_controller.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/cart_item_model.dart';
import 'package:shopping_store/models/order_list_model.dart';
import 'package:shopping_store/utils/extension/date_format_extension.dart';
import 'package:shopping_store/utils/global_functions.dart';
import 'package:shopping_store/views/widgets/shopping_app_bar_with_search.dart';

class OrdersListPage extends StatelessWidget {
  const OrdersListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orderListController = Get.put(OrdersListController(context));
    return GetBuilder<OrdersListController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.lightCardBackground,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppColors.lightBackgroundColor,
                child: shoppingAppBarWithSearch(
                  onBackButtonTapped: orderListController.goBack,
                  textEditingController: TextEditingController(),
                  onChanged: (v) {},
                  validator: (s, v) {
                    return null;
                  },
                  onSearchBarTapped: () {},
                  focusNode: FocusNode(),
                  cameFromSearch: true,
                  isLogoVisible: false,
                  widget: Container(
                    alignment: Alignment.center,
                    color: AppColors.lightBackgroundColor,
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "orders".tr,
                      style: Theme.of(context).textTheme.titleLarge?.apply(
                            fontWeightDelta: 2,
                            fontSizeDelta: 2,
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  itemCount: orderListController.listOrders.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (lvContext, lvIndex) {
                    OrderListModel orderItem = orderListController.listOrders[lvIndex];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => orderListController.openDetailsPage(orderItem),
                          child: Container(
                            color: AppColors.lightBackgroundColor,
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width,
                                  height: orderItem.cartItems.length > 3 ? size.height / 8 : size.height / 10,
                                  color: AppColors.lightBackgroundColor,
                                  child: _buildCartItems(
                                    context: context,
                                    size: size,
                                    cartItems: orderItem.cartItems,
                                    invoiceStatus: orderItem.invoiceStatus ?? "",
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      getRightTranslation(
                                        hiveBox.get(AppStorageKeys.selectedCurrencyCode),
                                        hiveBox.get(AppStorageKeys.selectedCurrencyCodeInArabic),
                                      ),
                                      style: Theme.of(context).textTheme.bodySmall?.apply(
                                            fontWeightDelta: 2,
                                          ),
                                    ),
                                    const SizedBox(width: 2.0),
                                    Text(
                                      orderItem.totalCartValue.toStringAsFixed(2),
                                      style: Theme.of(context).textTheme.bodySmall?.apply(
                                            fontWeightDelta: 2,
                                          ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "saved".tr,
                                          style: Theme.of(context).textTheme.bodySmall?.apply(
                                                fontWeightDelta: 1,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                        ),
                                        Text(
                                          getRightTranslation(
                                            hiveBox.get(AppStorageKeys.selectedCurrencyCode),
                                            hiveBox.get(AppStorageKeys.selectedCurrencyCodeInArabic),
                                          ),
                                          style: Theme.of(context).textTheme.bodySmall?.apply(
                                                fontWeightDelta: 1,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                        ),
                                        const SizedBox(width: 2.0),
                                        Text(
                                          "${orderItem.discountValue.toStringAsFixed(2)} (${orderItem.discountPercent.toStringAsFixed(0)}%)",
                                          style: Theme.of(context).textTheme.bodySmall?.apply(
                                                fontWeightDelta: 1,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Date: ${orderItem.createdAt.customDate}",
                                      style: Theme.of(context).textTheme.bodySmall?.apply(
                                            fontWeightDelta: 2,
                                            fontSizeDelta: -2,
                                            color: Colors.black45,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCartItems({required BuildContext context, required Size size, required List<CartItemModel> cartItems, required String invoiceStatus}) {
    return ListView.builder(
        itemCount: cartItems.length > 3 ? 3 : cartItems.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (lvContext, lvIndex) {
          return Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: size.width / 2,
                      child: Text(
                        getRightTranslation(
                          cartItems[lvIndex].productId.englishName,
                          cartItems[lvIndex].productId.arabicName,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.apply(
                              fontWeightDelta: 1,
                            ),
                      ),
                    ),
                    Text(
                      " x ",
                      style: Theme.of(context).textTheme.bodySmall?.apply(
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                    Text(
                      "${cartItems[lvIndex].itemCount}",
                      style: Theme.of(context).textTheme.bodySmall?.apply(
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                  ],
                ),
                lvIndex == 0
                    ? invoiceStatus != ""
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.greenAccent.withOpacity(0.3),
                              border: Border.all(
                                color: Colors.greenAccent.withOpacity(0.5),
                                width: 2.0,
                                style: BorderStyle.solid,
                              ),
                            ),
                            padding: const EdgeInsets.all(4),
                            alignment: Alignment.center,
                            width: size.width / 5.5,
                            height: size.height / 30,
                            child: Text(
                              invoiceStatus,
                              style: Theme.of(context).textTheme.bodySmall?.apply(
                                    fontWeightDelta: 2,
                                    fontSizeDelta: -2,
                                    color: Colors.black45,
                                  ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.redAccent.withOpacity(0.3),
                              border: Border.all(
                                color: Colors.redAccent.withOpacity(0.5),
                                width: 2.0,
                                style: BorderStyle.solid,
                              ),
                            ),
                            padding: const EdgeInsets.all(4),
                            alignment: Alignment.center,
                            width: size.width / 5.5,
                            height: size.height / 30,
                            child: Text(
                              "Cancelled",
                              style: Theme.of(context).textTheme.bodySmall?.apply(
                                    fontWeightDelta: 2,
                                    fontSizeDelta: -2,
                                    color: Colors.black45,
                                  ),
                            ),
                          )
                    : const SizedBox(),
              ],
            ),
          );
        });
  }
}
