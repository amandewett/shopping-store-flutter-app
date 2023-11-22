import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_assets.dart';
import 'package:shopping_store/controllers/cart/cart_controller.dart';
import 'package:shopping_store/models/coupon_model.dart';
import 'package:shopping_store/utils/global_functions.dart';
import 'package:shopping_store/views/widgets/coupon_item_widget.dart';
import 'package:shopping_store/views/widgets/shopping_app_bar_with_search.dart';

class CartCouponListPage extends StatelessWidget {
  final List<CouponModel> listCoupons;

  CartCouponListPage({
    Key? key,
    required this.listCoupons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cartController = Get.put(CartController(context));
    return GetBuilder<CartController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              shoppingAppBarWithSearch(
                onBackButtonTapped: cartController.goBack,
                textEditingController: TextEditingController(),
                onChanged: (v) {},
                validator: (s, v) {},
                onSearchBarTapped: () {},
                focusNode: FocusNode(),
                cameFromSearch: true,
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: ListView.builder(
                  itemCount: listCoupons.length,
                  itemBuilder: (lvContext, lvIndex) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: size.width,
                            height: size.height / 7,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            child: CouponItemWidget(
                              size: size,
                              couponPercent: listCoupons[lvIndex].couponPercent,
                              couponName: getRightTranslation(
                                listCoupons[lvIndex].couponName,
                                listCoupons[lvIndex].couponNameInArabic,
                              ),
                              couponDescription: getRightTranslation(
                                listCoupons[lvIndex].couponDescription,
                                listCoupons[lvIndex].couponDescriptionInArabic,
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
            ],
          ),
        ),
      );
    });
  }
}
