import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_colors.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/controllers/auth/account_verification_controller.dart';
import 'package:shopping_store/views/widgets/shopping_app_bar_with_search.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shopping_store/views/widgets/shopping_elevated_button.dart';
import 'package:shopping_store/views/widgets/shopping_text_button.dart';

class AccountVerificationPage extends StatelessWidget {
  final String userEmail;

  const AccountVerificationPage({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final accountVerificationController = Get.put(AccountVerificationController(context, userEmail));
    return GetBuilder<AccountVerificationController>(builder: (gbContext) {
      return WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                shoppingAppBarWithSearch(
                  onBackButtonTapped: () {},
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
                            "accountVerification".tr,
                            style: Theme.of(context).textTheme.headlineMedium?.apply(
                                  fontWeightDelta: 1,
                                ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            child: Text(
                              "accountVerificationNote".tr,
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
                            key: accountVerificationController.formKey,
                            child: OTPTextField(
                              length: 4,
                              width: size.width,
                              controller: accountVerificationController.otpFieldController,
                              style: Theme.of(context).textTheme.bodyLarge!,
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.underline,
                              onChanged: (String? pin) {
                                accountVerificationController.sPin = pin!;
                              },
                            ),
                          ),
                          const SizedBox(height: 50),
                          SizedBox(
                            width: size.width,
                            child: shoppingElevatedButton(
                              onPressed: accountVerificationController.onVerifyTap,
                              buttonText: "verify".tr,
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
                                "didNotGetTheCode".tr,
                                style: Theme.of(context).textTheme.bodySmall?.apply(
                                      color: AppColors.lightHintColor,
                                    ),
                              ),
                              shoppingTextButton(
                                onPressed: accountVerificationController.onResendClicked,
                                buttonText: "resendCode".tr,
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
        ),
      );
    });
  }
}
