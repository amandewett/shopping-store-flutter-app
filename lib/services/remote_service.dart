import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/api_exceptions.dart';
import 'package:shopping_store/views/pages/bottom_navigation/bottom_navigation_page.dart';
import '../main.dart';

class RemoteService {
  static const int apiTimeOutDuration = 20;

  //GET
  Future<dynamic> get({BuildContext? context, required String endpoint, bool willFetchToken = true, bool willLoad = true}) async {
    try {
      if (willLoad) context?.loaderOverlay.show();
      http.Response response = await http
          .get(
            Uri.parse(endpoint),
            headers: Api().staticHeaders(
              isAuth: true,
              token: willFetchToken ? hiveBox.get(AppStorageKeys.userJwtToken) ?? "" : "",
            ),
          )
          .timeout(
            const Duration(
              seconds: apiTimeOutDuration,
            ),
          );
      if (willLoad) context?.loaderOverlay.hide();
      return _responseProcessor(response, context);
    } on SocketException {
      if (willLoad) context?.loaderOverlay.hide();
      BotToast.showText(text: "Please check your internet connection");

      // throw FetchDataException("No internet exception", endpoint);
    } on TimeoutException {
      if (willLoad) context?.loaderOverlay.hide();
      BotToast.showText(text: "API not responding, please contact the support.");

      // throw ApiNotRespondingException("API not responded on time", endpoint);
    }
  }

//POST
  Future<dynamic> post({BuildContext? context, required String endpoint, dynamic payloadObj, bool willLoad = true}) async {
    try {
      if (willLoad) context?.loaderOverlay.show();
      var response = await http
          .post(Uri.parse(endpoint),
              body: payloadObj, headers: Api().staticHeaders(isAuth: true, token: hiveBox.get(AppStorageKeys.userJwtToken) ?? ""))
          .timeout(
            const Duration(
              seconds: apiTimeOutDuration,
            ),
          );
      if (willLoad) context?.loaderOverlay.hide();
      return _responseProcessor(response, context);
    } on SocketException {
      if (willLoad) context?.loaderOverlay.hide();
      BotToast.showText(text: "Please check your internet connection");
      throw FetchDataException("No internet exception", endpoint);
    } on TimeoutException {
      if (willLoad) context?.loaderOverlay.hide();
      BotToast.showText(text: "API not responding, please contact the support.");
      throw ApiNotRespondingException("API not responded on time", endpoint);
    }
  }

  //PUT
  Future<dynamic> put({BuildContext? context, required String endpoint, dynamic payloadObj, bool willLoad = true}) async {
    try {
      if (willLoad) context?.loaderOverlay.show();
      var response = await http
          .put(Uri.parse(endpoint),
              body: payloadObj, headers: Api().staticHeaders(isAuth: true, token: hiveBox.get(AppStorageKeys.userJwtToken) ?? ""))
          .timeout(
            const Duration(
              seconds: apiTimeOutDuration,
            ),
          );
      if (willLoad) context?.loaderOverlay.hide();
      return _responseProcessor(response, context);
    } on SocketException {
      if (willLoad) context?.loaderOverlay.hide();
      BotToast.showText(text: "Please check your internet connection");
      throw FetchDataException("No internet exception", endpoint);
    } on TimeoutException {
      if (willLoad) context?.loaderOverlay.hide();
      BotToast.showText(text: "API not responding, please contact the support.");
      throw ApiNotRespondingException("API not responded on time", endpoint);
    }
  }

  //DELETE
  Future<dynamic> delete({BuildContext? context, required String endpoint, bool willLoad = true}) async {
    try {
      if (willLoad) context?.loaderOverlay.show();
      var response = await http
          .delete(Uri.parse(endpoint), headers: Api().staticHeaders(isAuth: true, token: hiveBox.get(AppStorageKeys.userJwtToken) ?? ""))
          .timeout(
            const Duration(
              seconds: apiTimeOutDuration,
            ),
          );
      if (willLoad) context?.loaderOverlay.hide();
      return _responseProcessor(response, context);
    } on SocketException {
      if (willLoad) context?.loaderOverlay.hide();
      BotToast.showText(text: "Please check your internet connection");
      throw FetchDataException("No internet exception", endpoint);
    } on TimeoutException {
      if (willLoad) context?.loaderOverlay.hide();
      BotToast.showText(text: "API not responding, please contact the support.");
      throw ApiNotRespondingException("API not responded on time", endpoint);
    }
  }

  //POST Multipart
  Future<dynamic> updateUserProfilePicture(
      {BuildContext? context, required String endpoint, String profilePicture = "", bool willLoad = true}) async {
    try {
      if (willLoad) context?.loaderOverlay.show();
      var request = http.MultipartRequest("POST", Uri.parse(endpoint));
      request.headers.addAll(Api().staticHeaders(isAuth: true, token: hiveBox.get(AppStorageKeys.userJwtToken)));
      if (profilePicture != "") request.files.add(await http.MultipartFile.fromPath('file', profilePicture));
      http.StreamedResponse streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (willLoad) context?.loaderOverlay.hide();
      return _responseProcessor(response, context);
    } on SocketException {
      if (willLoad) context?.loaderOverlay.hide();
      BotToast.showText(text: "Please check your internet connection");
      throw FetchDataException("No internet exception", endpoint);
    } on TimeoutException {
      if (willLoad) context?.loaderOverlay.hide();
      BotToast.showText(text: "API not responding, please contact the support.");
      throw ApiNotRespondingException("API not responded on time", endpoint);
    }
  }

  dynamic _responseProcessor(http.Response response, context) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    switch (response.statusCode) {
      case 200:
        return responseBody;
      case 201:
        return responseBody;
      case 400:
        BotToast.showText(text: responseBody['message'][0]);
        throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 401:
        logout(context);
        BotToast.showText(text: responseBody['message']);
        throw UnAuthorizedException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 403:
        BotToast.showText(text: "Error code: 403");
        throw UnAuthorizedException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 500:
        BotToast.showText(text: "Error code: 500");
        throw ApiNotRespondingException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      default:
        BotToast.showText(text: "Error code: ${response.statusCode}");
        throw FetchDataException("Error occurred with code: ${response.statusCode}", response.request!.url.toString());
    }
  }

  Future<bool> logout(BuildContext ctx) async {
    if (hiveBox.get(AppStorageKeys.isUserLoggedIn)) {
      await hiveBox.put(AppStorageKeys.isUserLoggedIn, false);
      await hiveBox.delete(AppStorageKeys.userId);
      await hiveBox.delete(AppStorageKeys.userJwtToken);
      if (hiveBox.get(AppStorageKeys.userRegistrationType) == enumLoginType.google.index) {
        await GoogleSignIn().signOut();
        hiveBox.delete(AppStorageKeys.userGoogleId);
        hiveBox.delete(AppStorageKeys.userProfilePicture);
      }

      if (hiveBox.get(AppStorageKeys.userRegistrationType) == enumLoginType.facebook.index) {
        await FacebookAuth.instance.logOut();
        hiveBox.delete(AppStorageKeys.userFacebookId);
        hiveBox.delete(AppStorageKeys.userProfilePicture);
      }
      _registerGuestUser(hiveBox.get(AppStorageKeys.selectedCountryId), ctx).then((value) {
        Get.offAll(
          () => const BottomNavigationPage(),
          transition: Transition.rightToLeftWithFade,
        );
      });
      return true;
    } else {
      BotToast.showText(text: "User not logged in");
      return false;
    }
  }

  Future<bool> _registerGuestUser(int countryId, BuildContext context) async {
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

  _clearCart(context) async => await RemoteService().get(context: context, endpoint: Api.apiClearCart);
}
