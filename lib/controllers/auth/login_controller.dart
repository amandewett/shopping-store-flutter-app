import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/login_response_mode.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/views/pages/auth/account_verification_page.dart';
import 'package:shopping_store/views/pages/auth/forgot_password_page.dart';
import 'package:shopping_store/views/pages/auth/register_page.dart';
import 'package:shopping_store/views/pages/bottom_navigation/bottom_navigation_page.dart';

import '../../constants/app_storage_keys.dart';

class LoginController extends GetxController {
  final BuildContext context;
  final emailFormKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginController(this.context);

  goBack() => Get.back();

  gotoRegister() => Get.to(() => const RegisterPage());

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

  String? validator(BuildContext context, String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "textFieldEmptyError".tr;
      }
    }
    return null;
  }

  login() async {
    FocusScope.of(context).unfocus();
    if (emailFormKey.currentState!.validate() && formKey.currentState!.validate()) {
      var payload = jsonEncode(<String, dynamic>{
        "email": emailController.text.trim().toString(),
        "password": passwordController.text.trim().toString(),
      });

      Map<String, dynamic> apiResponse = await RemoteService().post(
        context: context,
        endpoint: Api.apiLogin,
        payloadObj: payload,
      );

      if (apiResponse.isNotEmpty && apiResponse['status']) {
        emailController.clear();
        passwordController.clear();

        LoginResponseModel userDetails = loginResponseModelFromJson(jsonEncode(apiResponse['result']));

        await _saveUserDataToLocalStorage(userData: userDetails);
        BotToast.showText(text: apiResponse['message']);
        await Future.delayed(const Duration(seconds: 1));
        Get.offAll(
          () => const BottomNavigationPage(),
          transition: Transition.rightToLeft,
        );
        update();
      } else {
        BotToast.showText(text: apiResponse['message']);
        await Future.delayed(const Duration(seconds: 2));
        if (!apiResponse['isVerified']) {
          Get.to(
            () => AccountVerificationPage(
              userEmail: emailController.text.trim().toString(),
            ),
            transition: Transition.rightToLeft,
          );
        } else {
          BotToast.showText(text: apiResponse['message']);
        }
      }
    }
  }

  Future<bool> _saveUserDataToLocalStorage({required LoginResponseModel userData}) async {
    hiveBox.put(AppStorageKeys.isUserLoggedIn, true);
    hiveBox.put(AppStorageKeys.userId, userData.id);
    hiveBox.put(AppStorageKeys.userEmail, userData.email);
    hiveBox.put(AppStorageKeys.userGoogleId, userData.googleId);
    hiveBox.put(AppStorageKeys.userFacebookId, userData.facebookId);
    hiveBox.put(AppStorageKeys.userAppleId, userData.appleId);
    hiveBox.put(AppStorageKeys.userFirstName, userData.firstName);
    hiveBox.put(AppStorageKeys.userLastName, userData.lastName);
    hiveBox.put(AppStorageKeys.userPhone, userData.phone);
    hiveBox.put(AppStorageKeys.userCountryId, userData.countryId);
    hiveBox.put(AppStorageKeys.userRole, userData.role);
    hiveBox.put(AppStorageKeys.userProfilePicture, userData.profilePicture);
    hiveBox.put(AppStorageKeys.userRegistrationType, userData.registrationType);
    hiveBox.put(AppStorageKeys.userJwtToken, userData.token);
    return true;
  }

  onForgotPasswordTapped() async {
    FocusScope.of(context).unfocus();
    if (emailFormKey.currentState!.validate()) {
      var payload = jsonEncode(<String, dynamic>{
        "email": emailController.text.trim(),
      });

      Map<String, dynamic> apiResponse = await RemoteService().post(
        context: context,
        endpoint: Api.apiForgotPassword,
        payloadObj: payload,
      );

      if (apiResponse.isNotEmpty && apiResponse['status']) {
        emailController.clear();

        BotToast.showText(text: apiResponse['message']);
        await Future.delayed(const Duration(seconds: 1));
        Get.to(
          () => ForgotPasswordPage(
            userEmail: jsonDecode(payload)['email'],
          ),
          transition: Transition.rightToLeft,
        );
      } else {
        BotToast.showText(text: apiResponse['message']);
      }
    }
  }
}
