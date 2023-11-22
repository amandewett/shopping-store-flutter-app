import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/views/pages/auth/reset_password_page.dart';

class ForgotPasswordController extends GetxController {
  final BuildContext context;
  final String userEmail;
  final formKey = GlobalKey<FormState>();
  OtpFieldController otpFieldController = OtpFieldController();
  String sPin = "";

  ForgotPasswordController(
    this.context,
    this.userEmail,
  );

  goBack() => Get.back();

  onResetTap() async {
    FocusScope.of(context).unfocus();
    if (sPin.length < 4) {
      BotToast.showText(text: "invalidPin".tr);
    } else {
      var payload = jsonEncode(<String, dynamic>{
        "email": userEmail,
        "otp": sPin,
      });

      Map<String, dynamic> apiResponse = await RemoteService().post(
        context: context,
        endpoint: Api.apiVerifyForgotPasswordOtp,
        payloadObj: payload,
      );

      if (apiResponse.isNotEmpty && apiResponse['status']) {
        BotToast.showText(text: apiResponse['message']);
        hiveBox.put(AppStorageKeys.userJwtToken, apiResponse['token']);
        Get.offAll(
          () => ResetPasswordPage(userEmail: userEmail, token: apiResponse['token']),
          transition: Transition.rightToLeft,
        );
        update();
      } else {
        BotToast.showText(text: apiResponse['message']);
      }
    }
  }
}
