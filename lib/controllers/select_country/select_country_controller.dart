import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/controllers/language/language_controller.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/countries_list.model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/views/pages/bottom_navigation/bottom_navigation_page.dart';

class SelectCountryController extends GetxController {
  final BuildContext context;
  final bool isFromAppBar;
  List<CountriesListModel> countriesList = [];

  SelectCountryController(
    this.context,
    this.isFromAppBar,
  );

  @override
  void onInit() {
    _getCountries();
    super.onInit();
  }

  _getCountries() async {
    Map<String, dynamic> apiResponse = await RemoteService().get(context: context, endpoint: Api.apiListCountries);
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      countriesList = countriesListModelFromJson(jsonEncode(apiResponse['result']));
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  Future<bool> _registerGuestUser(int countryId) async {
    Map<String, dynamic> apiResponse = await RemoteService().get(context: context, endpoint: "${Api.apiRegisterGuest}/$countryId");
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      final userId = apiResponse['result']['id'];
      final jwtToken = apiResponse['result']['token'];

      await hiveBox.put(AppStorageKeys.userId, userId);
      await hiveBox.put(AppStorageKeys.userJwtToken, jwtToken);
      await hiveBox.put(AppStorageKeys.userRegistrationType, enumLoginType.normal.index);
      await hiveBox.put(AppStorageKeys.userCountryId, countryId);
      return true;
    } else {
      BotToast.showText(text: apiResponse['message']);
      return false;
    }
  }

  onLanguageClick({required CountriesListModel countriesListModel}) async {
    context.loaderOverlay.show();
    await hiveBox.put(AppStorageKeys.selectedLocale,
        countriesListModel.defaultLanguage == 'english' ? enumAppLanguage.english.index : enumAppLanguage.arabic.index);
    await hiveBox.put(AppStorageKeys.selectedDefaultLanguage, countriesListModel.defaultLanguage);
    await hiveBox.put(AppStorageKeys.selectedCountryId, countriesListModel.id);
    await hiveBox.put(AppStorageKeys.selectedCountryName, countriesListModel.countryName);
    await hiveBox.put(AppStorageKeys.selectedCountryCode, countriesListModel.countryCode);
    await hiveBox.put(AppStorageKeys.selectedCurrencyName, countriesListModel.currencyName);
    await hiveBox.put(AppStorageKeys.selectedCurrencyCode, countriesListModel.currencyCode);
    await hiveBox.put(AppStorageKeys.selectedCurrencyCodeInArabic, countriesListModel.currencyCodeInArabic);
    await hiveBox.put(AppStorageKeys.selectedCountryImage, countriesListModel.image);
    await hiveBox.put(AppStorageKeys.selectedCountryPhoneNumber, countriesListModel.phoneNumber);
    await hiveBox.put(AppStorageKeys.selectedCountryEmail, countriesListModel.email);
    await hiveBox.put(AppStorageKeys.selectedCountryAddress, countriesListModel.address);
    await hiveBox.put(AppStorageKeys.selectedCountryLatitude, countriesListModel.latitude);
    await hiveBox.put(AppStorageKeys.selectedCountryLongitude, countriesListModel.longitude);

    //assign local UUId
    if (hiveBox.get(AppStorageKeys.isFirstTime, defaultValue: true)) {
      hiveBox.put(AppStorageKeys.isFirstTime, false);
      hiveBox.put(AppStorageKeys.isUserLoggedIn, false);
      await _registerGuestUser(countriesListModel.id);
    }

    //clear cart
    _clearCart();

    //update app language
    LanguageController().changeLanguage(
      languageCode: countriesListModel.defaultLanguage == 'english' ? 'en' : 'ar',
      countryCode: countriesListModel.defaultLanguage == 'english' ? 'US' : 'AE',
    );
    context.loaderOverlay.hide();
    update();
    await Future.delayed(const Duration(seconds: 1));
    if (isFromAppBar) {
      Get.back();
    } else {
      Get.offAll(() => const BottomNavigationPage());
    }
  }

  _clearCart() async => await RemoteService().get(context: context, endpoint: Api.apiClearCart);
}
