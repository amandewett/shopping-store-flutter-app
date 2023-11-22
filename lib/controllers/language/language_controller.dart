import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import '../../main.dart';

class LanguageController extends GetxController {
  var _currentLocale = hiveBox.get(AppStorageKeys.selectedLocale) == null
      ? const Locale("en", "US")
      : hiveBox.get(AppStorageKeys.selectedLocale) == enumAppLanguage.english.index
          ? const Locale("en", "US")
          : const Locale("ar", "AE");

  Locale get currentLocale => _currentLocale;

  void changeLanguage({required String languageCode, required String countryCode}) {
    _currentLocale = Locale(languageCode, countryCode);
    Get.updateLocale(_currentLocale);
  }
}
