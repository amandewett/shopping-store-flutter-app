import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_colors.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/controllers/auth/login_controller.dart';
import 'package:shopping_store/views/widgets/shopping_app_bar_with_search.dart';
import 'package:shopping_store/views/widgets/shopping_elevated_button.dart';
import 'package:shopping_store/views/widgets/shopping_text_button.dart';
import 'package:shopping_store/views/widgets/shopping_text_form_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loginController = Get.put(LoginController(context));
    return GetBuilder<LoginController>(
      builder: (gbContext) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                shoppingAppBarWithSearch(
                  onBackButtonTapped: loginController.goBack,
                  textEditingController: TextEditingController(),
                  onChanged: (v) {},
                  validator: (c, v) {
                    return null;
                  },
                  onSearchBarTapped: () {},
                  focusNode: FocusNode(),
                  cameFromSearch: true,
                  heightFromTop: 15,
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: size.width,
                      height: size.height,
                      padding: const EdgeInsets.only(
                        left: AppSizes.pagePadding + 10,
                        right: AppSizes.pagePadding + 10,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "welcomeBack".tr,
                            style: Theme.of(context).textTheme.headlineMedium?.apply(
                                  fontWeightDelta: 1,
                                ),
                          ),
                          const SizedBox(height: 60),
                          Form(
                            key: loginController.emailFormKey,
                            child: shoppingTextFormField(
                              textEditingController: loginController.emailController,
                              textInputType: TextInputType.emailAddress,
                              hintText: "email".tr,
                              labelText: "email".tr,
                              isSuffixIcon: false,
                              onTapSuffixIcon: () {},
                              validator: loginController.emailValidator,
                              onChanged: (v) {},
                            ),
                          ),
                          const SizedBox(height: 30),
                          Form(
                            key: loginController.formKey,
                            child: shoppingTextFormField(
                              textEditingController: loginController.passwordController,
                              textInputType: TextInputType.visiblePassword,
                              hintText: "password".tr,
                              labelText: "password".tr,
                              isSuffixIcon: false,
                              isObscure: true,
                              onTapSuffixIcon: () {},
                              validator: loginController.passwordValidator,
                              onChanged: (v) {},
                            ),
                          ),
                          const SizedBox(height: 0),
                          Container(
                            alignment: Alignment.centerRight,
                            child: shoppingTextButton(
                              onPressed: loginController.onForgotPasswordTapped,
                              buttonText: "forgotPassword".tr,
                            ),
                          ),
                          const SizedBox(height: 50),
                          SizedBox(
                            width: size.width,
                            child: shoppingElevatedButton(
                              onPressed: loginController.login,
                              buttonText: "login".tr,
                              textStyle: Theme.of(context).textTheme.titleMedium!.apply(
                                    color: Colors.white,
                                    fontWeightDelta: 1,
                                    fontSizeDelta: 1,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "dontHaveAccount".tr,
                                style: Theme.of(context).textTheme.bodySmall?.apply(
                                      color: AppColors.lightHintColor,
                                    ),
                              ),
                              shoppingTextButton(
                                onPressed: loginController.gotoRegister,
                                buttonText: "register".tr,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
