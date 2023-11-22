import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/views/pages/auth/login_page.dart';

class AccountVerificationController extends GetxController {
  final BuildContext context;
  final String userEmail;
  final formKey = GlobalKey<FormState>();
  OtpFieldController otpFieldController = OtpFieldController();
  String sPin = "";

  AccountVerificationController(
    this.context,
    this.userEmail,
  );

  onVerifyTap() async {
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
        endpoint: Api.apiAccountVerification,
        payloadObj: payload,
      );

      if (apiResponse.isNotEmpty && apiResponse['status']) {
        BotToast.showText(text: apiResponse['message']);
        await Future.delayed(const Duration(seconds: 1));
        Get.offAll(
          () => const LoginPage(),
          transition: Transition.rightToLeft,
        );
        update();
      } else {
        BotToast.showText(text: apiResponse['message']);
      }
    }
  }

  onResendClicked() async {
    FocusScope.of(context).unfocus();
    var payload = jsonEncode(<String, dynamic>{
      "email": userEmail,
    });

    Map<String, dynamic> apiResponse = await RemoteService().post(
      context: context,
      endpoint: Api.apiResendVerificationOtp,
      payloadObj: payload,
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      BotToast.showText(text: apiResponse['message']);
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }
}
