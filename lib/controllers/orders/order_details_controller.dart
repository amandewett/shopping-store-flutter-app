import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/models/order_list_model.dart';

class OrderDetailsController extends GetxController {
  final BuildContext context;
  final OrderListModel orderDetails;
  int activeStepper = 0;

  OrderDetailsController(
    this.context,
    this.orderDetails,
  );

  @override
  void onInit() {
    initStepperValue();
    super.onInit();
  }

  goBack() => Get.back();

  initStepperValue() {
    activeStepper = orderDetails.orderStatus == enumOrderStatus.Pending.name
        ? 0
        : orderDetails.orderStatus == enumOrderStatus.Shipped.name
            ? 1
            : orderDetails.orderStatus == enumOrderStatus.Delivered.name
                ? 3
                : 3;
  }

  String getImageFromProductMediaList({required List<String> listMedia}) {
    if (listMedia.isNotEmpty) {
      for (String media in listMedia) {
        if (isImage(media)) {
          return media;
        }
      }
      return "";
    } else {
      return "";
    }
  }

  bool isImage(String url) {
    List<String> splitedPath = url.split(".");
    String ext = splitedPath[splitedPath.length - 1];
    List<String> listImageExt = ['jpg', 'jpeg', 'png'];
    return listImageExt.contains(ext);
  }
}
