import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/order_list_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/views/pages/orders/order_details_page.dart';

class OrdersListController extends GetxController {
  final BuildContext context;
  List<OrderListModel> listOrders = [];

  OrdersListController(
    this.context,
  );

  @override
  void onInit() {
    getOrders();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  goBack() => Get.back();

  getOrders() async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: Api.apiOrderList,
    );
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      listOrders = orderListModelFromJson(jsonEncode(apiResponse['result']));
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  openDetailsPage(OrderListModel orderDetails) {
    Get.to(() => OrderDetailsPage(orderDetails: orderDetails));
  }
}
