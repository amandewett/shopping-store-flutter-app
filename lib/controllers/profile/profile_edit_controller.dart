import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/user_details_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';

class ProfileEditController extends GetxController {
  final BuildContext context;
  UserDetailsModel userDetails;
  final formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;

  ProfileEditController(
    this.context,
    this.userDetails,
  );

  @override
  void onInit() {
    _getUserDetails();
    initUserDetails();
    super.onInit();
  }

  goBack() => Get.back();

  initUserDetails() async {
    firstNameController.text = userDetails.firstName!;
    lastNameController.text = userDetails.lastName!;
    emailController.text = userDetails.email!;
    phoneController.text = userDetails.phone!;
    update();
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

  pickImage(ImageSource imageSource) async {
    goBack();
    pickedImage = await _picker.pickImage(
      source: imageSource,
      imageQuality: 60,
    );

    if (pickedImage != null) {
      String imagePath = pickedImage!.path;
      uploadImage(imagePath);
    }
  }

  uploadImage(String imagePath) async {
    Map<String, dynamic> apiResponse =
        await RemoteService().updateUserProfilePicture(context: context, endpoint: Api.apiUploadFile, profilePicture: imagePath);
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      hiveBox.put(AppStorageKeys.userProfilePicture, jsonEncode(apiResponse['result']));
      updateProfilePicture(jsonEncode(apiResponse['result'])).then((v) {
        _getUserDetails();
      });
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  _getUserDetails() async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: Api.apiUserDetails,
    );
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      userDetails = userDetailsModelFromJson(jsonEncode(apiResponse['result']));
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  Future<bool> updateProfilePicture(String filePath) async {
    var payload = jsonEncode(<String, dynamic>{
      "profilePicture": filePath,
    });

    Map<String, dynamic> apiResponse = await RemoteService().put(
      context: context,
      endpoint: Api.apiUpdateUser,
      payloadObj: payload,
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      return true;
    } else {
      BotToast.showText(text: apiResponse['message']);
      return false;
    }
  }

  Future<bool> updateUser() async {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      var payload = jsonEncode(
        <String, dynamic>{
          "firstName": firstNameController.text.trim(),
          "lastName": lastNameController.text.trim(),
          "phone": phoneController.text.trim(),
        },
      );

      Map<String, dynamic> apiResponse = await RemoteService().put(
        context: context,
        endpoint: Api.apiUpdateUser,
        payloadObj: payload,
      );

      if (apiResponse.isNotEmpty && apiResponse['status']) {
        goBack();
        return true;
      } else {
        BotToast.showText(text: apiResponse['message']);
        return false;
      }
    }
    return true;
  }

  String getProfilePictureUrl(String suffixUrl) {
    return "${Api.fileBaseUrl}/${suffixUrl.replaceAll('"', '')}";
  }
}
