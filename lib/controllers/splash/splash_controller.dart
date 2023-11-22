import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/views/pages/auth/welcome_page.dart';
import 'package:shopping_store/views/pages/bottom_navigation/bottom_navigation_page.dart';
import 'package:shopping_store/views/pages/select_country/select_country_page.dart';

class SplashController extends GetxController {
  BuildContext context;

  SplashController(this.context);
  @override
  void onInit() {
    _startTime();
    super.onInit();
  }

  _startTime() {
    var duration = const Duration(seconds: 1);
    return Timer(duration, _navigationPage);
  }

  void _navigationPage() async {
    if (hiveBox.get(AppStorageKeys.selectedCountryName) == null) {
      Get.offAll(() => const SelectCountryPage());
    } else {
      Get.offAll(() => const BottomNavigationPage());
    }
  }
}
