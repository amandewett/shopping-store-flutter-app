import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/views/pages/auth/login_page.dart';

class ResetPasswordController extends GetxController {
  final BuildContext context;
  final String userEmail;
  final String token;
  final formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();

  ResetPasswordController(
    this.context,
    this.userEmail,
    this.token,
  );

  goBack() => Get.back();

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

  onResetPasswordTapped() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      var payload = jsonEncode(<String, dynamic>{
        "password": passwordController.text.trim(),
      });

      Map<String, dynamic> apiResponse = await RemoteService().post(
        context: context,
        endpoint: Api.apiResetPassword,
        payloadObj: payload,
      );

      if (apiResponse.isNotEmpty && apiResponse['status']) {
        passwordController.clear();

        BotToast.showText(text: apiResponse['message']);
        await Future.delayed(const Duration(seconds: 1));
        Get.offAll(
          () => const LoginPage(),
          transition: Transition.rightToLeft,
        );
      } else {
        BotToast.showText(text: apiResponse['message']);
      }
    }
  }
}
