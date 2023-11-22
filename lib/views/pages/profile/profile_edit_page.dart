import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_store/constants/app_colors.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/controllers/profile/profile_edit_controller.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/user_details_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/views/widgets/shopping_app_bar_with_search.dart';
import 'package:shopping_store/views/widgets/shopping_elevated_button.dart';
import 'package:shopping_store/views/widgets/shopping_text_form_field.dart';

class ProfileEditPage extends StatelessWidget {
  final UserDetailsModel userDetails;

  const ProfileEditPage({
    Key? key,
    required this.userDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final profileEditController = Get.put(ProfileEditController(context, userDetails));
    return GetBuilder<ProfileEditController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              shoppingAppBarWithSearch(
                onBackButtonTapped: profileEditController.goBack,
                textEditingController: TextEditingController(),
                onChanged: (v) {},
                validator: (s, v) {
                  return null;
                },
                onSearchBarTapped: () {},
                focusNode: FocusNode(),
                cameFromSearch: true,
                isLogoVisible: false,
                widget: Container(
                  alignment: Alignment.center,
                  color: AppColors.lightBackgroundColor,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "profile".tr,
                    style: Theme.of(context).textTheme.titleLarge?.apply(
                          fontWeightDelta: 2,
                          fontSizeDelta: 2,
                        ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: profileEditController.formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: AppSizes.pagePadding + 10,
                        right: AppSizes.pagePadding + 10,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.width / 3,
                            width: size.width / 3,
                            child: Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.expand,
                              children: [
                                hiveBox.get(AppStorageKeys.userRegistrationType) == enumLoginType.normal.index
                                    ? profileEditController.userDetails.profilePicture == ""
                                        ? ProfilePicture(
                                            name: profileEditController.userDetails.firstName == ""
                                                ? "user".tr
                                                : "${profileEditController.userDetails.firstName} ${profileEditController.userDetails.lastName}",
                                            radius: size.width / 10,
                                            fontsize: size.width / 15,
                                          )
                                        : ProfilePicture(
                                            name: profileEditController.userDetails.firstName == ""
                                                ? "user".tr
                                                : "${profileEditController.userDetails.firstName} ${profileEditController.userDetails.lastName}",
                                            radius: size.width / 8,
                                            fontsize: size.width / 15,
                                            img: profileEditController.getProfilePictureUrl(profileEditController.userDetails.profilePicture!),
                                          )
                                    : hiveBox.get(AppStorageKeys.userProfilePicture) == ""
                                        ? ProfilePicture(
                                            name: profileEditController.userDetails.firstName == ""
                                                ? "user".tr
                                                : "${profileEditController.userDetails.firstName} ${profileEditController.userDetails.lastName}",
                                            radius: size.width / 10,
                                            fontsize: size.width / 15,
                                          )
                                        : ProfilePicture(
                                            name: profileEditController.userDetails.firstName == ""
                                                ? "user".tr
                                                : "${profileEditController.userDetails.firstName} ${profileEditController.userDetails.lastName}",
                                            radius: size.width / 8,
                                            fontsize: size.width / 15,
                                            img: hiveBox.get(AppStorageKeys.userProfilePicture),
                                          ),
                                Positioned(
                                    bottom: 0,
                                    right: -30,
                                    child: Visibility(
                                      visible: hiveBox.get(AppStorageKeys.userRegistrationType) == enumLoginType.normal.index ? true : false,
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          showCupertinoModalPopup(
                                            context: context,
                                            builder: (BuildContext ctx) {
                                              return CupertinoActionSheet(
                                                actions: [
                                                  CupertinoActionSheetAction(
                                                    isDestructiveAction: true,
                                                    onPressed: () => profileEditController.pickImage(
                                                      ImageSource.gallery,
                                                    ),
                                                    child: Text(
                                                      "gallery".tr,
                                                    ),
                                                  ),
                                                  CupertinoActionSheetAction(
                                                    isDestructiveAction: true,
                                                    onPressed: () => profileEditController.pickImage(
                                                      ImageSource.camera,
                                                    ),
                                                    child: Text(
                                                      "camera".tr,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        elevation: 2.0,
                                        fillColor: AppColors.lightCardBackground,
                                        padding: const EdgeInsets.all(10.0),
                                        shape: const CircleBorder(),
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          shoppingTextFormField(
                            textEditingController: profileEditController.firstNameController,
                            textInputType: TextInputType.name,
                            hintText: "firstName".tr,
                            labelText: "firstName".tr,
                            isSuffixIcon: false,
                            onTapSuffixIcon: () {},
                            validator: profileEditController.nameValidator,
                            onChanged: (v) {},
                          ),
                          const SizedBox(height: 30),
                          shoppingTextFormField(
                            textEditingController: profileEditController.lastNameController,
                            textInputType: TextInputType.name,
                            hintText: "lastName".tr,
                            labelText: "lastName".tr,
                            isSuffixIcon: false,
                            onTapSuffixIcon: () {},
                            validator: profileEditController.nameValidator,
                            onChanged: (v) {},
                          ),
                          const SizedBox(height: 30),
                          shoppingTextFormField(
                            textEditingController: profileEditController.emailController,
                            textInputType: TextInputType.emailAddress,
                            hintText: "email".tr,
                            labelText: "email".tr,
                            isSuffixIcon: false,
                            onTapSuffixIcon: () {},
                            isEnabled: false,
                            validator: profileEditController.emailValidator,
                            onChanged: (v) {},
                          ),
                          const SizedBox(height: 30),
                          shoppingTextFormField(
                            textEditingController: profileEditController.phoneController,
                            textInputType: TextInputType.phone,
                            hintText: "phoneNumber".tr,
                            labelText: "phoneNumber".tr,
                            isSuffixIcon: false,
                            onTapSuffixIcon: () {},
                            validator: profileEditController.phoneNumberValidator,
                            onChanged: (v) {},
                          ),
                          const SizedBox(height: 50),
                          SizedBox(
                            width: size.width,
                            child: shoppingElevatedButton(
                              onPressed: profileEditController.updateUser,
                              buttonText: "update".tr,
                              textStyle: Theme.of(context).textTheme.bodyLarge!.apply(
                                    color: Theme.of(context).scaffoldBackgroundColor,
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
    });
  }
}
