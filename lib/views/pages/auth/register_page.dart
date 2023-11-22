import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/controllers/auth/register_controller.dart';
import 'package:shopping_store/views/widgets/shopping_app_bar_with_search.dart';
import 'package:shopping_store/views/widgets/shopping_elevated_button.dart';
import 'package:shopping_store/views/widgets/shopping_text_form_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final registerController = Get.put(RegisterController(context));
    return GetBuilder<RegisterController>(
      builder: (gbContext) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                shoppingAppBarWithSearch(
                  onBackButtonTapped: registerController.goBack,
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
                      child: Form(
                        key: registerController.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "register".tr,
                              style: Theme.of(context).textTheme.headlineLarge?.apply(
                                    fontWeightDelta: 1,
                                  ),
                            ),
                            const SizedBox(height: 60),
                            shoppingTextFormField(
                              textEditingController: registerController.firstNameController,
                              textInputType: TextInputType.name,
                              hintText: "firstName".tr,
                              labelText: "firstName".tr,
                              isSuffixIcon: false,
                              onTapSuffixIcon: () {},
                              validator: registerController.nameValidator,
                              onChanged: (v) {},
                            ),
                            const SizedBox(height: 30),
                            shoppingTextFormField(
                              textEditingController: registerController.lastNameController,
                              textInputType: TextInputType.name,
                              hintText: "lastName".tr,
                              labelText: "lastName".tr,
                              isSuffixIcon: false,
                              onTapSuffixIcon: () {},
                              validator: registerController.nameValidator,
                              onChanged: (v) {},
                            ),
                            const SizedBox(height: 30),
                            shoppingTextFormField(
                              textEditingController: registerController.emailController,
                              textInputType: TextInputType.emailAddress,
                              hintText: "email".tr,
                              labelText: "email".tr,
                              isSuffixIcon: false,
                              onTapSuffixIcon: () {},
                              validator: registerController.emailValidator,
                              onChanged: (v) {},
                            ),
                            const SizedBox(height: 30),
                            shoppingTextFormField(
                              textEditingController: registerController.phoneController,
                              textInputType: TextInputType.phone,
                              hintText: "phoneNumber".tr,
                              labelText: "phoneNumber".tr,
                              isSuffixIcon: false,
                              onTapSuffixIcon: () {},
                              validator: registerController.phoneNumberValidator,
                              onChanged: (v) {},
                            ),
                            const SizedBox(height: 30),
                            shoppingTextFormField(
                              textEditingController: registerController.passwordController,
                              textInputType: TextInputType.visiblePassword,
                              hintText: "password".tr,
                              labelText: "password".tr,
                              isSuffixIcon: false,
                              onTapSuffixIcon: () {},
                              validator: registerController.passwordValidator,
                              onChanged: (v) {},
                            ),
                            const SizedBox(height: 50),
                            SizedBox(
                              width: size.width,
                              child: shoppingElevatedButton(
                                onPressed: registerController.registerByEmail,
                                buttonText: "register".tr,
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
