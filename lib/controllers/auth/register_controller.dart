import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/views/pages/auth/account_verification_page.dart';

class RegisterController extends GetxController {
  final BuildContext context;
  final emailFormKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RegisterController(this.context);

  goBack() => Get.back();

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

  String? validator(BuildContext context, String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "textFieldEmptyError".tr;
      }
    }
    return null;
  }

  String? passwordValidator(BuildContext context, String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "textFieldEmptyError".tr;
      } else if (value.length < 8) {
        return "passwordLengthError".tr;
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

  registerByEmail() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      var userId = await hiveBox.get(AppStorageKeys.userId);
      if (userId != null) {
        String payload = jsonEncode(<String, dynamic>{
          "id": userId,
          "email": emailController.text.trim(),
          "firstName": firstNameController.text.trim(),
          "lastName": lastNameController.text.trim(),
          "password": passwordController.text.trim(),
          "phone": phoneController.text.trim(),
          "registrationType": enumLoginType.normal.index,
          "countryId": hiveBox.get(AppStorageKeys.selectedCountryId, defaultValue: 0),
        });

        Map<String, dynamic> apiResponse = await RemoteService().post(
          context: context,
          endpoint: Api.apiRegister,
          payloadObj: payload,
        );

        if (apiResponse.isNotEmpty && apiResponse['status']) {
          emailController.clear();
          firstNameController.clear();
          lastNameController.clear();
          passwordController.clear();
          phoneController.clear();
          BotToast.showText(text: apiResponse['message']);

          Get.to(
            () => AccountVerificationPage(
              userEmail: jsonDecode(payload)['email'],
            ),
            transition: Transition.rightToLeft,
          );
          update();
        } else {
          BotToast.showText(text: apiResponse['message']);
        }
      } else {
        BotToast.showText(text: "registrationError".tr);
      }
    }
  }
}
