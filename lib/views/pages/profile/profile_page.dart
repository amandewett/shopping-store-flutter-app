import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_assets.dart';
import 'package:shopping_store/constants/app_colors.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/controllers/profile/profile_controller.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/user_details_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/utils/global_functions.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  Widget buildProfileListItems({
    required BuildContext context,
    required Size size,
    required IconData iconData,
    required String title,
  }) {
    return Column(
      children: [
        Container(
          width: size.width,
          color: Colors.transparent,
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Icon(
                iconData,
                size: size.width / 12,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.apply(
                      color: Theme.of(context).hintColor,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final profileController = Get.put(ProfileController(context));
    profileController.popupMenu = PopupMenu(
      context: context,
      config: MenuConfig.forList(
        itemWidth: size.width / 4,
        border: BorderConfig(
          width: 1.0,
          color: Colors.grey.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.only(
          topLeft: hiveBox.get(AppStorageKeys.selectedLocale) == enumAppLanguage.english.index
              ? const Radius.circular(AppSizes.cardBorderRadius)
              : const Radius.circular(0),
          topRight: hiveBox.get(AppStorageKeys.selectedLocale) == enumAppLanguage.english.index
              ? const Radius.circular(0)
              : const Radius.circular(AppSizes.cardBorderRadius),
          bottomLeft: const Radius.circular(AppSizes.cardBorderRadius),
          bottomRight: const Radius.circular(AppSizes.cardBorderRadius),
        ),
      ),
      items: [
        PopUpMenuItem.forList(
          title: 'english'.tr,
          textStyle: Theme.of(context).textTheme.bodySmall!.apply(
                fontWeightDelta: 2,
              ),
        ),
        PopUpMenuItem.forList(
          title: 'arabic'.tr,
          textStyle: Theme.of(context).textTheme.bodySmall!.apply(
                fontWeightDelta: 2,
              ),
        ),
      ],
      onClickMenu: profileController.onMenuItemClicked,
      onDismiss: profileController.onDismiss,
    );
    return GetBuilder<ProfileController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.lightCardBackground,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                height: size.height / 15,
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.only(
                  left: AppSizes.pagePadding,
                  right: AppSizes.pagePadding,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: profileController.onFlagClicked,
                      child: Row(
                        children: [
                          SvgPicture.network(
                            "${Api.fileBaseUrl}/${hiveBox.get(AppStorageKeys.selectedCountryImage)}",
                            width: size.width / 12,
                          ),
                          Text(
                            " | ",
                            style: Theme.of(context).textTheme.bodySmall?.apply(
                                  color: Theme.of(context).hintColor.withOpacity(0.6),
                                  fontWeightDelta: 2,
                                  fontSizeDelta: 2,
                                ),
                          ),
                          Text(
                            getRightTranslation(
                              hiveBox.get(AppStorageKeys.selectedCurrencyCode),
                              hiveBox.get(
                                AppStorageKeys.selectedCurrencyCodeInArabic,
                              ),
                            ),
                            style: Theme.of(context).textTheme.bodySmall?.apply(
                                  fontWeightDelta: 2,
                                  fontSizeDelta: 2,
                                ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => profileController.openLanguageMenu(size: size),
                      key: profileController.languageChangeButtonKey,
                      child: Text(
                        hiveBox.get(AppStorageKeys.selectedLocale) == enumAppLanguage.english.index ? "En" : "Ar",
                        style: Theme.of(context).textTheme.bodySmall?.apply(
                              fontWeightDelta: 2,
                              fontSizeDelta: 2,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            profileController.isUserDetailsInit
                                ? hiveBox.get(AppStorageKeys.userRegistrationType) == enumLoginType.normal.index
                                    ? profileController.userDetails.profilePicture == ""
                                        ? ProfilePicture(
                                            name: profileController.userDetails.firstName == ""
                                                ? "user".tr
                                                : "${profileController.userDetails.firstName} ${profileController.userDetails.lastName}",
                                            radius: size.width / 10,
                                            fontsize: size.width / 15,
                                          )
                                        : ProfilePicture(
                                            name: profileController.userDetails.firstName == ""
                                                ? "user".tr
                                                : "${profileController.userDetails.firstName} ${profileController.userDetails.lastName}",
                                            radius: size.width / 10,
                                            fontsize: size.width / 15,
                                            img: profileController.getProfilePictureUrl(profileController.userDetails.profilePicture!),
                                          )
                                    : hiveBox.get(AppStorageKeys.userProfilePicture) == ""
                                        ? ProfilePicture(
                                            name: profileController.userDetails.firstName == ""
                                                ? "user".tr
                                                : "${profileController.userDetails.firstName} ${profileController.userDetails.lastName}",
                                            radius: size.width / 10,
                                            fontsize: size.width / 15,
                                          )
                                        : ProfilePicture(
                                            name: profileController.userDetails.firstName == ""
                                                ? "user".tr
                                                : "${profileController.userDetails.firstName} ${profileController.userDetails.lastName}",
                                            radius: size.width / 10,
                                            fontsize: size.width / 15,
                                            img: hiveBox.get(AppStorageKeys.userProfilePicture),
                                          )
                                : SizedBox(),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    profileController.isUserDetailsInit
                                        ? profileController.userDetails.firstName != ""
                                            ? "${profileController.userDetails.firstName} ${profileController.userDetails.lastName}"
                                            : "user".tr
                                        : "user".tr,
                                    style: Theme.of(context).textTheme.titleLarge?.apply(
                                          fontWeightDelta: 1,
                                        ),
                                  ),
                                  hiveBox.get(AppStorageKeys.isUserLoggedIn)
                                      ? GestureDetector(
                                          onTap: profileController.onEditTapped,
                                          child: Text(
                                            "edit".tr,
                                            style: Theme.of(context).textTheme.bodyLarge?.apply(
                                                  decoration: TextDecoration.underline,
                                                ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: profileController.openLoginPage,
                                          child: Text(
                                            "login".tr,
                                            style: Theme.of(context).textTheme.bodyLarge?.apply(
                                                  decoration: TextDecoration.underline,
                                                ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: size.width,
                        padding: const EdgeInsets.only(
                          top: AppSizes.pagePadding,
                          left: AppSizes.pagePadding,
                          right: AppSizes.pagePadding,
                          bottom: AppSizes.pagePadding,
                        ),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: profileController.openOrdersListPage,
                              child: buildProfileListItems(
                                context: context,
                                size: size,
                                iconData: Icons.view_list_outlined,
                                title: "myOrders".tr,
                              ),
                            ),
                            const Divider(thickness: 0.3),
                            GestureDetector(
                              onTap: profileController.openSavedAddresses,
                              child: buildProfileListItems(
                                context: context,
                                size: size,
                                iconData: Icons.import_contacts_outlined,
                                title: "savedAddresses".tr,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: size.width,
                        padding: const EdgeInsets.only(
                          top: AppSizes.pagePadding,
                          left: AppSizes.pagePadding,
                          right: AppSizes.pagePadding,
                          bottom: AppSizes.pagePadding,
                        ),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: profileController.onHelpCenter,
                              child: buildProfileListItems(
                                context: context,
                                size: size,
                                iconData: Icons.help_outline,
                                title: "helpCenter".tr,
                              ),
                            ),
                            const Divider(thickness: 0.3),
                            hiveBox.get(AppStorageKeys.isUserLoggedIn, defaultValue: false)
                                ? GestureDetector(
                                    onTap: () => RemoteService().logout(context),
                                    child: buildProfileListItems(
                                      context: context,
                                      size: size,
                                      iconData: Icons.logout,
                                      title: "signOut".tr,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: profileController.openLoginPage,
                                    child: buildProfileListItems(
                                      context: context,
                                      size: size,
                                      iconData: Icons.login_outlined,
                                      title: "login".tr,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
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
