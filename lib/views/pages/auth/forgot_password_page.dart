import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/controllers/auth/forgot_password_controller.dart';
import 'package:shopping_store/views/widgets/shopping_app_bar_with_search.dart';
import 'package:shopping_store/views/widgets/shopping_elevated_button.dart';

class ForgotPasswordPage extends StatelessWidget {
  final String userEmail;

  const ForgotPasswordPage({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final forgotPasswordController = Get.put(ForgotPasswordController(context, userEmail));
    return GetBuilder<ForgotPasswordController>(
      builder: (gbContext) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                shoppingAppBarWithSearch(
                  onBackButtonTapped: forgotPasswordController.goBack,
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
                            "resetPAssword".tr,
                            style: Theme.of(context).textTheme.headlineMedium?.apply(
                                  fontWeightDelta: 1,
                                ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            child: Text(
                              "forgotPasswordNote".tr,
                              style: Theme.of(context).textTheme.bodyMedium?.apply(
                                    color: Theme.of(context).hintColor,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            child: Text(
                              userEmail,
                              style: Theme.of(context).textTheme.bodyLarge?.apply(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeightDelta: 2,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 60),
                          Form(
                            key: forgotPasswordController.formKey,
                            child: OTPTextField(
                              length: 4,
                              width: size.width,
                              controller: forgotPasswordController.otpFieldController,
                              style: Theme.of(context).textTheme.bodyLarge!,
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.underline,
                              onChanged: (String? pin) {
                                forgotPasswordController.sPin = pin!;
                              },
                            ),
                          ),
                          const SizedBox(height: 50),
                          SizedBox(
                            width: size.width,
                            child: shoppingElevatedButton(
                              onPressed: forgotPasswordController.onResetTap,
                              buttonText: "reset".tr,
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
        );
      },
    );
  }
}
