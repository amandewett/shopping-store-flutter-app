import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/customer_address_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/views/pages/customer_address/customer_address_add_page.dart';

class CustomerAddressListController extends GetxController {
  final BuildContext context;
  List<CustomerAddressModel> customerAddressesList = [];
  late CustomerAddressModel defaultAddress;

  CustomerAddressListController(this.context);

  @override
  void onInit() {
    getAddresses();
    super.onInit();
  }

  goBack() => Get.back();

  Future<bool> getAddresses() async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiListCustomerAddresses}/${hiveBox.get(AppStorageKeys.userCountryId)}",
    );
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      //add country, state and international country details details
      for (var obj in apiResponse['result']) {
        if (obj['isInternational'] == 0) {
          Map<String, dynamic>? countryDetails = await getCountryDetails(obj['countryId']);
          obj['countryDetails'] = countryDetails;
          Map<String, dynamic>? stateDetails = await getStateDetails(obj['stateId']);
          obj['stateDetails'] = stateDetails;
        } else {
          Map<String, dynamic>? countryDetails = await getInternationalCountryDetails(obj['countryId']);
          obj['internationalCountryDetails'] = countryDetails;
        }
      }

      customerAddressesList = customerAddressModelFromJson(jsonEncode(apiResponse['result']));

      if (customerAddressesList.isNotEmpty) {
        //set default address
        defaultAddress = customerAddressesList[0];
        for (var address in customerAddressesList) {
          if (address.isDefault == 1) {
            defaultAddress = address;
          }
        }
      }

      update();
      return true;
    } else {
      BotToast.showText(text: apiResponse['message']);
      return false;
    }
  }

  Future<Map<String, dynamic>?> getCountryDetails(int countryId) async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiCountryDetails}/$countryId",
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      return apiResponse['result'];
    } else {
      BotToast.showText(text: apiResponse['message']);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getStateDetails(int stateId) async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiStateDetails}/$stateId",
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      return apiResponse['result'];
    } else {
      BotToast.showText(text: apiResponse['message']);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getInternationalCountryDetails(int countryId) async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiDetailsInternationalCountry}/$countryId",
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      return apiResponse['result'];
    } else {
      BotToast.showText(text: apiResponse['message']);
      return null;
    }
  }

  setDefaultAddress(int addressId) async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiSetDefaultAddress}/$addressId",
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      await getAddresses();
      goBack();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  deleteAddress(int addressId) async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiDeleteAddress}/$addressId",
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      await getAddresses();
      goBack();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  addNewAddress() {
    Get.to(() => const CustomerAddressAddPage())!.then((value) {
      getAddresses();
    });
  }
}
