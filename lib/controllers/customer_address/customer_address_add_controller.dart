import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/models/countries_list.model.dart';
import 'package:shopping_store/models/international_country_model.dart';
import 'package:shopping_store/models/state_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';

class CustomerAddressAddController extends GetxController {
  final BuildContext context;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController addressLineTwoController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  final isInternationalSwitchController = ValueNotifier<bool>(false);
  bool isInternationalChecked = false;
  TextEditingController countryDropDownController = TextEditingController();
  TextEditingController stateDropDownController = TextEditingController();
  List<CountriesListModel> countriesList = [];
  List<InternationalCountryModel> internationalCountriesList = [];
  List<String> listCountries = [];
  List<StateModel> statesList = [];
  List<String> listStates = [];
  int countryId = 0;
  int countryIndex = 0;
  int internationalCountryId = 0;
  int internationalCountryIndex = 0;
  int stateIndex = 0;

  CustomerAddressAddController(this.context);

  @override
  void onInit() {
    initSwitch();
    getCountries();
    countryDropDownController.addListener(() {
      if (countryDropDownController.text.trim() != "") {
        if (isInternationalChecked) {
          int countryListIndex = listCountries.indexOf(countryDropDownController.text.trim());
          internationalCountryIndex = countryListIndex;
          internationalCountryId = internationalCountriesList[countryListIndex].id;
        } else {
          int countryListIndex = listCountries.indexOf(countryDropDownController.text.trim());
          countryIndex = countryListIndex + 1;
          countryId = countriesList[countryListIndex + 1].id;
          getStates(countryId);
        }
      }
    });

    stateDropDownController.addListener(() {
      if (stateDropDownController.text.trim() != "") {
        if (!isInternationalChecked) {
          stateIndex = listStates.indexOf(stateDropDownController.text.trim());
        }
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    countryDropDownController.removeListener(() {});
    isInternationalSwitchController.removeListener(() {});
    super.onClose();
  }

  goBack() => Get.back();

  initSwitch() {
    isInternationalSwitchController.addListener(() {
      listCountries = [];
      listStates = [];
      countryDropDownController.clear();
      stateDropDownController.clear();
      if (isInternationalSwitchController.value) {
        isInternationalChecked = true;
        getInternationalCountries();
      } else {
        isInternationalChecked = false;
        getCountries();
      }
      update();
    });
  }

  String? validator(BuildContext context, String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "textFieldEmptyError".tr;
      }
    }
    return null;
  }

  String? emailValidator(BuildContext context, String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "textFieldEmptyError".tr;
      } else if (!GetUtils.isEmail(value)) {
        return "textFieldInvalidEmailError".tr;
      }
    }
    return null;
  }

  String? nameValidator(BuildContext context, String? value) {
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z ]+$');
    if (value != null) {
      if (value.isEmpty) {
        return "textFieldEmptyError".tr;
      } else {
        if (value.length <= 2) {
          return "nameShouldBeMoreThan2Characters".tr;
        } else {
          if (nameRegExp.hasMatch(value)) {
            return null;
          } else {
            return "onlyAlphabetsAllowed".tr;
          }
        }
      }
    }
    return null;
  }

  String? phoneNumberValidator(BuildContext context, String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "textFieldEmptyError".tr;
      } else if (!GetUtils.isPhoneNumber(value)) {
        return "textFieldInvalidPhoneNumberError".tr;
      }
    }
    return null;
  }

  getCountries() async {
    Map<String, dynamic> apiResponse = await RemoteService().get(context: context, endpoint: Api.apiListCountries);
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      countriesList = countriesListModelFromJson(jsonEncode(apiResponse['result']));
      for (var country in countriesList) {
        if (!country.countryName.toLowerCase().contains("international")) {
          listCountries.add(country.countryName);
        }
      }
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  getInternationalCountries() async {
    Map<String, dynamic> apiResponse = await RemoteService().get(context: context, endpoint: Api.apiListInternationalCountries);
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      internationalCountriesList = internationalCountryListModelFromJson(jsonEncode(apiResponse['result']));
      for (var country in internationalCountriesList) {
        listCountries.add(country.countryName);
      }
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  getStates(int stateId) async {
    Map<String, dynamic> apiResponse = await RemoteService().get(context: context, endpoint: "${Api.apiListStates}/$stateId");
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      statesList = listStateModelFromJson(jsonEncode(apiResponse['result']));
      listStates.clear();
      for (var state in statesList) {
        listStates.add(state.stateName);
      }
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  saveAddress() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      if (isInternationalChecked) {
        var payload = jsonEncode(<String, dynamic>{
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phoneNumber": phoneNumberController.text.trim(),
          "isInternational": isInternationalChecked ? 1 : 0,
          "countryId": internationalCountriesList[internationalCountryIndex].id,
          "address": addressController.text.trim(),
          "address2": addressLineTwoController.text.trim(),
          "city": cityController.text.trim(),
          "postalCode": postalCodeController.text.trim(),
        });

        Map<String, dynamic> apiResponse = await RemoteService().post(
          context: context,
          endpoint: Api.apiAddCustomerAddresses,
          payloadObj: payload,
        );

        if (apiResponse.isNotEmpty && apiResponse['status']) {
          BotToast.showText(text: apiResponse['message']);
          Get.back();
        } else {
          BotToast.showText(text: apiResponse['message']);
        }
      } else {
        var payload = jsonEncode(<String, dynamic>{
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phoneNumber": phoneNumberController.text.trim(),
          "isInternational": isInternationalChecked ? 1 : 0,
          "countryId": countriesList[countryIndex].id,
          "stateId": statesList[stateIndex].id,
          "address": addressController.text.trim(),
          "address2": addressLineTwoController.text.trim(),
          "city": cityController.text.trim(),
          "postalCode": postalCodeController.text.trim(),
        });

        Map<String, dynamic> apiResponse = await RemoteService().post(
          context: context,
          endpoint: Api.apiAddCustomerAddresses,
          payloadObj: payload,
        );

        if (apiResponse.isNotEmpty && apiResponse['status']) {
          BotToast.showText(text: apiResponse['message']);
          Get.back();
        } else {
          BotToast.showText(text: apiResponse['message']);
        }
      }
    }
  }
}
