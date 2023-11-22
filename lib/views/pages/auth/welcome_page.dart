import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_assets.dart';
import 'package:shopping_store/controllers/auth/welcome_controller.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final welcomeController = Get.put(WelcomeController(context));
    return GetBuilder<WelcomeController>(
      builder: (gbContext) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary.withOpacity(0.4),
                      BlendMode.dstATop,
                    ),
                    image: const AssetImage(
                      AppAssets.appLoginBackground,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: size.width,
                      height: size.height / 6,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: welcomeController.goBack,
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: size.width,
                              child: Image.asset(
                                AppAssets.appLogoPng,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height / 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: size.width,
                          height: size.height,
                          child: Column(
                            children: [
                              SignInButton(
                                buttonType: ButtonType.google,
                                onPressed: welcomeController.signInWithGoogle,
                              ),
                              SignInButton(
                                buttonType: ButtonType.facebook,
                                onPressed: welcomeController.signInWithFacebook,
                              ),
                              Platform.isIOS
                                  ? SignInButton(
                                      buttonType: ButtonType.apple,
                                      onPressed: welcomeController.signInWithApple,
                                    )
                                  : const SizedBox(),
                              const SizedBox(height: 20.0),
                              SignInButton(
                                buttonType: ButtonType.mail,
                                onPressed: welcomeController.gotoLoginPage,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
