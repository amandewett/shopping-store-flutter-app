import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/login_response_mode.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/views/pages/auth/login_page.dart';
import 'package:shopping_store/views/pages/bottom_navigation/bottom_navigation_page.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class WelcomeController extends GetxController {
  final BuildContext context;

  WelcomeController(this.context);

  goBack() => Get.back();

  gotoLoginPage() => Get.to(() => const LoginPage());

  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final gCredentials = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    var result = await FirebaseAuth.instance.signInWithCredential(gCredentials);
    String googleId = result.additionalUserInfo!.profile!['id'];
    String fName = result.user!.displayName!.split(" ")[0];
    String lName = result.user!.displayName!.split(" ")[1];

    await registerNewUser(
      userEmail: result.user!.email ?? "",
      firstName: fName,
      lastName: lName,
      googleId: googleId,
      facebookId: "",
      loginType: enumLoginType.google.index,
      profilePicture: result.user?.photoURL,
    );
  }

  signInWithFacebook() async {
    final LoginResult fbLoginResult = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
    if (fbLoginResult.status == LoginStatus.success) {
      //get fb user data
      final Map<String, dynamic> fbUserData = await FacebookAuth.instance.getUserData();
      String? fbProfilePicture = fbUserData['picture']['data']['url'];
      String fbId = fbUserData['id'];
      String fbEmail = fbUserData['email'] ?? "";
      String fbfirstName = fbUserData['name'].split(" ")[0];
      String fbLastName = fbUserData['name'].split(" ")[1];

      //get fb login token
      final String fbToken = fbLoginResult.accessToken!.token;
      final OAuthCredential oAuthCredential = FacebookAuthProvider.credential(fbToken);
      await FirebaseAuth.instance.signInWithCredential(oAuthCredential);

      await registerNewUser(
        userEmail: fbEmail,
        firstName: fbfirstName,
        lastName: fbLastName,
        googleId: "",
        facebookId: fbId,
        loginType: enumLoginType.facebook.index,
        profilePicture: fbProfilePicture,
      );
    } else {
      BotToast.showText(text: fbLoginResult.status.name.toString());
    }
  }

  signInWithApple() async {
    BotToast.showText(text: "Need apple developer account");
    /* final credentials = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],      
    );
    debugPrint("Apple credentials: ${credentials.email}");
    debugPrint("Apple credentials: ${credentials.givenName}");
    debugPrint("Apple credentials: ${credentials.familyName}");
    debugPrint("Apple credentials: ${credentials.identityToken}");
    debugPrint("Apple credentials: ${credentials.authorizationCode}"); */
  }

  registerNewUser({
    required String? userEmail,
    required String? firstName,
    required String? lastName,
    required String? googleId,
    required String? facebookId,
    required int loginType,
    String? profilePicture,
  }) async {
    var userId = hiveBox.get(AppStorageKeys.userId);
    if (userId != null) {
      String payload = jsonEncode(<String, dynamic>{
        "id": userId,
        "email": userEmail ?? "",
        "firstName": firstName ?? "",
        "lastName": lastName ?? "",
        "googleId": googleId ?? "",
        "facebookId": facebookId ?? "",
        "registrationType": loginType,
        "countryId": hiveBox.get(AppStorageKeys.selectedCountryId, defaultValue: 0),
      });

      debugPrint("payload: $payload");

      Map<String, dynamic> apiResponse = await RemoteService().post(
        context: context,
        endpoint: Api.apiRegister,
        payloadObj: payload,
      );

      if (apiResponse.isNotEmpty && apiResponse['status']) {
        LoginResponseModel userDetails = loginResponseModelFromJson(jsonEncode(apiResponse['result']));
        await _saveUserDataToLocalStorage(userData: userDetails, profilePicture: profilePicture);
        update();
        BotToast.showText(text: apiResponse['message']);
        await Future.delayed(const Duration(seconds: 1));
        Get.offAll(
          () => const BottomNavigationPage(),
          transition: Transition.rightToLeft,
        );
      } else {
        BotToast.showText(text: apiResponse['message']);
      }
    } else {
      BotToast.showText(text: "registrationError".tr);
    }
  }

  Future<bool> _saveUserDataToLocalStorage({required LoginResponseModel userData, String? profilePicture}) async {
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
    hiveBox.put(AppStorageKeys.userProfilePicture, profilePicture ?? "");
    hiveBox.put(AppStorageKeys.userRegistrationType, userData.registrationType);
    hiveBox.put(AppStorageKeys.userJwtToken, userData.token);
    return true;
  }
}
