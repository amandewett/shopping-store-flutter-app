import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_colors.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/controllers/orders/order_details_controller.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/cart_item_model.dart';
import 'package:shopping_store/models/order_list_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/utils/extension/date_format_extension.dart';
import 'package:shopping_store/utils/global_functions.dart';
import 'package:shopping_store/views/widgets/image_view_widget.dart';
import 'package:shopping_store/views/widgets/shopping_app_bar_with_search.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:shopping_store/views/widgets/shopping_network_image_widget.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderListModel orderDetails;

  const OrderDetailsPage({
    Key? key,
    required this.orderDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orderDetailsController = Get.put(OrderDetailsController(context, orderDetails));
    return GetBuilder<OrderDetailsController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              shoppingAppBarWithSearch(
                onBackButtonTapped: orderDetailsController.goBack,
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
                    "orderDetails".tr,
                    style: Theme.of(context).textTheme.titleLarge?.apply(
                          fontWeightDelta: 2,
                          fontSizeDelta: 2,
                        ),
                  ),
                ),
              ),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              orderDetails.createdAt.orderDetailsDateFormat,
                              style: Theme.of(context).textTheme.bodySmall?.apply(
                                    color: Colors.black54,
                                  ),
                            ),
                            const Text(" • "),
                            Text(
                              orderDetails.invoiceStatus == "Paid" ? orderDetails.orderStatus : "Canceled",
                              style: Theme.of(context).textTheme.bodySmall?.apply(
                                    color: Colors.black54,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height / 25),
                        EasyStepper(
                          activeStep: orderDetailsController.activeStepper,
                          enableStepTapping: false,
                          internalPadding: 0,
                          stepRadius: size.width / 20,
                          padding: const EdgeInsets.all(0),
                          lineStyle: LineStyle(
                            lineType: LineType.normal,
                            lineLength: size.width / 4,
                            unreachedLineType: LineType.dashed,
                            unreachedLineColor: Colors.black54,
                            activeLineColor: Colors.black54,
                          ),
                          steps: [
                            EasyStep(
                              icon: const Icon(
                                Icons.history,
                              ),
                              title: enumOrderStatus.Pending.name,
                            ),
                            EasyStep(
                              icon: const Icon(
                                Icons.local_shipping_outlined,
                              ),
                              title: enumOrderStatus.Shipped.name,
                            ),
                            EasyStep(
                              icon: const Icon(
                                Icons.check_circle_outline,
                              ),
                              title: enumOrderStatus.Delivered.name,
                            ),
                          ],
                        ),
                        Divider(
                          color: Theme.of(context).cardTheme.color,
                          thickness: 5.0,
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                            iconColor: Theme.of(context).colorScheme.primary,
                            childrenPadding: const EdgeInsets.all(10.0),
                            title: Row(
                              children: [
                                Text(
                                  "products".tr,
                                  style: Theme.of(context).textTheme.titleMedium?.apply(
                                        fontWeightDelta: 1,
                                      ),
                                ),
                                Text(
                                  " x ",
                                  style: Theme.of(context).textTheme.bodySmall?.apply(
                                        color: Colors.black54,
                                      ),
                                ),
                                Text(
                                  "${orderDetailsController.orderDetails.cartItems.length}",
                                  style: Theme.of(context).textTheme.bodySmall?.apply(
                                        color: Colors.black54,
                                      ),
                                ),
                              ],
                            ),
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: size.height / 3,
                                    child: ListView.builder(
                                      itemCount: orderDetailsController.orderDetails.cartItems.length,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (lvContext, lvIndex) {
                                        CartItemModel cartItem = orderDetailsController.orderDetails.cartItems[lvIndex];
                                        return Card(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                shoppingNetworkImageWidget(
                                                  imageUrl:
                                                      "${Api.fileBaseUrl}/${orderDetailsController.getImageFromProductMediaList(listMedia: cartItem.productId.arrMedia)}",
                                                  imageWidth: 50,
                                                  imageHeight: 50,
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          width: size.width / 2.5,
                                                          child: Text(
                                                            getRightTranslation(
                                                              cartItem.productId.englishName,
                                                              cartItem.productId.arabicName,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: Theme.of(context).textTheme.bodySmall?.apply(
                                                                  fontWeightDelta: 1,
                                                                ),
                                                          ),
                                                        ),
                                                        Text(
                                                          " x ",
                                                          style: Theme.of(context).textTheme.bodySmall?.apply(
                                                                color: Colors.black54,
                                                              ),
                                                        ),
                                                        Text(
                                                          "${cartItem.itemCount}",
                                                          style: Theme.of(context).textTheme.bodySmall?.apply(
                                                                color: Colors.black54,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: size.width / 4.5,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              orderDetails.isInternational == 0
                                                                  ? getRightTranslation(
                                                                      orderDetails.countryDetails!.currencyCode,
                                                                      orderDetails.countryDetails!.currencyCodeInArabic,
                                                                    )
                                                                  : "\$",
                                                              style: Theme.of(context).textTheme.bodySmall,
                                                            ),
                                                            Text(
                                                              " ${(cartItem.productId.price * cartItem.itemCount).toStringAsFixed(2)}",
                                                              style: Theme.of(context).textTheme.bodySmall,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).cardTheme.color,
                          thickness: 5.0,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "invoice".tr,
                              style: Theme.of(context).textTheme.bodySmall?.apply(
                                    color: Theme.of(context).hintColor,
                                  ),
                            ),
                            Text(
                              "${orderDetails.invoiceId}",
                              style: Theme.of(context).textTheme.bodySmall?.apply(
                                    color: Theme.of(context).hintColor,
                                  ),
                            ),
                          ],
                        ),
                        orderDetails.invoiceStatus == "Paid"
                            ? Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "reference".tr,
                                    style: Theme.of(context).textTheme.bodySmall?.apply(
                                          color: Theme.of(context).hintColor,
                                        ),
                                  ),
                                  Text(
                                    "${orderDetails.referenceId}",
                                    style: Theme.of(context).textTheme.bodySmall?.apply(
                                          color: Theme.of(context).hintColor,
                                        ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(height: 20),
                        _buildPriceItem(
                          ctx: context,
                          priceType: "itemTotal".tr,
                          priceValue: "${orderDetails.isInternational == 0 ? getRightTranslation(
                              orderDetails.countryDetails!.currencyCode,
                              orderDetails.countryDetails!.currencyCodeInArabic,
                            ) : '\$'} ${orderDetails.itemsTotal.toStringAsFixed(2)}",
                          onTap: () {},
                        ),
                        _buildPriceItem(
                          ctx: context,
                          priceType: "tax".tr,
                          priceValue: "${orderDetails.isInternational == 0 ? getRightTranslation(
                              orderDetails.countryDetails!.currencyCode,
                              orderDetails.countryDetails!.currencyCodeInArabic,
                            ) : '\$'} ${orderDetails.taxValue.toStringAsFixed(2)} (${orderDetails.taxPercent}%)",
                          onTap: () {},
                        ),
                        _buildPriceItem(
                            ctx: context,
                            priceType: "itemDiscount".tr,
                            priceValue: "${orderDetails.isInternational == 0 ? getRightTranslation(
                                orderDetails.countryDetails!.currencyCode,
                                orderDetails.countryDetails!.currencyCodeInArabic,
                              ) : '\$'} ${orderDetails.discountValue.toStringAsFixed(2)} (${orderDetails.discountPercent}%)",
                            onTap: () {},
                            priceTypeColor: Theme.of(context).colorScheme.primary),
                        _buildPriceItem(
                          ctx: context,
                          priceType: "shipmentFee".tr,
                          priceValue: "${orderDetails.isInternational == 0 ? getRightTranslation(
                              orderDetails.countryDetails!.currencyCode,
                              orderDetails.countryDetails!.currencyCodeInArabic,
                            ) : '\$'} ${orderDetails.shipmentPrice.toStringAsFixed(2)}",
                          onTap: () {},
                        ),
                        const Divider(color: Colors.black45),
                        _buildPriceItem(
                          ctx: context,
                          priceType: "total".tr,
                          priceValue: "${orderDetails.isInternational == 0 ? getRightTranslation(
                              orderDetails.countryDetails!.currencyCode,
                              orderDetails.countryDetails!.currencyCodeInArabic,
                            ) : '\$'} ${orderDetails.totalCartValue.toStringAsFixed(2)}",
                          onTap: () {},
                        ),
                        orderDetails.invoiceStatus == "Paid"
                            ? _buildPriceItem(
                                ctx: context,
                                priceType: "paid".tr,
                                priceValue:
                                    "${orderDetails.paidCurrency} ${double.parse(orderDetails.paidCurrencyValue!.replaceAll(",", "")).toStringAsFixed(2)}",
                                onTap: () {},
                              )
                            : const SizedBox(),
                        const Divider(color: Colors.black45),
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
}
