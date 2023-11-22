import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/controllers/auth/reset_password_controller.dart';
import 'package:shopping_store/views/widgets/shopping_app_bar_with_search.dart';
import 'package:shopping_store/views/widgets/shopping_elevated_button.dart';
import 'package:shopping_store/views/widgets/shopping_text_form_field.dart';

class ResetPasswordPage extends StatelessWidget {
  final String userEmail;
  final String token;

  const ResetPasswordPage({
    Key? key,
    required this.userEmail,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final resetPasswordController = Get.put(ResetPasswordController(context, userEmail, token));
    return GetBuilder<ResetPasswordController>(builder: (gbContext) {
      return WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                shoppingAppBarWithSearch(
                  onBackButtonTapped: resetPasswordController.goBack,
                  textEditingController: TextEditingController(),
                  onChanged: (v) {},
                  validator: (c, v) {
                    return null;
                  },
                  onSearchBarTapped: () {},
                  focusNode: FocusNode(),
                  cameFromSearch: true,
                  heightFromTop: 15,
                  isBackButtonVisible: false,
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
                            "resetPAssword".tr,
                            style: Theme.of(context).textTheme.headlineMedium?.apply(
                                  fontWeightDelta: 1,
                                ),
                          ),
                          const SizedBox(height: 60),
                          Form(
                            key: resetPasswordController.formKey,
                            child: shoppingTextFormField(
                              textEditingController: resetPasswordController.passwordController,
                              textInputType: TextInputType.visiblePassword,
                              hintText: "password".tr,
                              labelText: "password".tr,
                              isSuffixIcon: false,
                              isObscure: true,
                              onTapSuffixIcon: () {},
                              validator: resetPasswordController.passwordValidator,
                              onChanged: (v) {},
                            ),
                          ),
                          const SizedBox(height: 50),
                          SizedBox(
                            width: size.width,
                            child: shoppingElevatedButton(
                              onPressed: resetPasswordController.onResetPasswordTapped,
                              buttonText: "resetPAssword".tr,
                              textStyle: Theme.of(context).textTheme.titleMedium!.apply(
                                    color: Colors.white,
                                    fontWeightDelta: 1,
                                    fontSizeDelta: 1,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
