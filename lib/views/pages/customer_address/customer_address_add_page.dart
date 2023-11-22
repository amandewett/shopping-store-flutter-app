import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_colors.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/controllers/customer_address/customer_address_add_controller.dart';
import 'package:shopping_store/views/widgets/shopping_app_bar_with_search.dart';
import 'package:shopping_store/views/widgets/shopping_elevated_button.dart';
import 'package:shopping_store/views/widgets/shopping_text_form_field.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class CustomerAddressAddPage extends StatelessWidget {
  final bool isUpdating;
  const CustomerAddressAddPage({
    Key? key,
    this.isUpdating = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final customerAddressAddController = Get.put(CustomerAddressAddController(context));
    return GetBuilder<CustomerAddressAddController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              shoppingAppBarWithSearch(
                onBackButtonTapped: customerAddressAddController.goBack,
                textEditingController: TextEditingController(),
                onChanged: (v) {},
                validator: (s, v) {},
                onSearchBarTapped: () {},
                focusNode: FocusNode(),
                cameFromSearch: true,
              ),
              const SizedBox(height: 0),
              Container(
                width: size.width,
                alignment: Alignment.center,
                child: Text(
                  isUpdating ? "updateAddress".tr : "addAddress".tr,
                  style: Theme.of(context).textTheme.titleLarge?.apply(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeightDelta: 2,
                      ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Form(
                    key: customerAddressAddController.formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: AppSizes.pagePadding,
                        right: AppSizes.pagePadding,
                      ),
                      child: Column(
                        children: [
                          shoppingTextFormField(
                            textEditingController: customerAddressAddController.nameController,
                            textInputType: TextInputType.name,
                            hintText: "fullName".tr,
                            labelText: "fullName".tr,
                            isSuffixIcon: false,
                            onTapSuffixIcon: () {},
                            validator: customerAddressAddController.nameValidator,
                            onChanged: (v) {},
                          ),
                          const SizedBox(height: 20),
                          shoppingTextFormField(
                            textEditingController: customerAddressAddController.emailController,
                            textInputType: TextInputType.emailAddress,
                            hintText: "email".tr,
                            labelText: "email".tr,
                            isSuffixIcon: false,
                            onTapSuffixIcon: () {},
                            validator: customerAddressAddController.emailValidator,
                            onChanged: (v) {},
                          ),
                          const SizedBox(height: 20),
                          shoppingTextFormField(
                            textEditingController: customerAddressAddController.phoneNumberController,
                            textInputType: TextInputType.phone,
                            hintText: "phoneNumber".tr,
                            labelText: "phoneNumber".tr,
                            isSuffixIcon: false,
                            onTapSuffixIcon: () {},
                            validator: customerAddressAddController.phoneNumberValidator,
                            onChanged: (v) {},
                          ),
                          const SizedBox(height: 20),
                          shoppingTextFormField(
                            textEditingController: customerAddressAddController.addressController,
                            textInputType: TextInputType.text,
                            hintText: "address".tr,
                            labelText: "address".tr,
                            maxLines: 4,
                            isSuffixIcon: false,
                            onTapSuffixIcon: () {},
                            validator: customerAddressAddController.validator,
                            onChanged: (v) {},
                          ),
                          const SizedBox(height: 20),
                          shoppingTextFormField(
                            textEditingController: customerAddressAddController.addressLineTwoController,
                            textInputType: TextInputType.text,
                            hintText: "address".tr,
                            labelText: "address2".tr,
                            isSuffixIcon: false,
                            maxLines: 4,
                            onTapSuffixIcon: () {},
                            validator: (a, v) {},
                            onChanged: (v) {},
                          ),
                          const SizedBox(height: 20),
                          shoppingTextFormField(
                            textEditingController: customerAddressAddController.cityController,
                            textInputType: TextInputType.text,
                            hintText: "city".tr,
                            labelText: "city".tr,
                            isSuffixIcon: false,
                            validator: customerAddressAddController.validator,
                            onTapSuffixIcon: () {},
                            onChanged: (v) {},
                          ),
                          const SizedBox(height: 20),
                          shoppingTextFormField(
                            textEditingController: customerAddressAddController.postalCodeController,
                            textInputType: TextInputType.text,
                            hintText: "postalCode".tr,
                            labelText: "postalCode".tr,
                            isSuffixIcon: false,
                            validator: customerAddressAddController.validator,
                            onTapSuffixIcon: () {},
                            onChanged: (v) {},
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "international".tr,
                                style: Theme.of(context).textTheme.titleLarge?.apply(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSizeDelta: -2,
                                    ),
                              ),
                              AdvancedSwitch(
                                controller: customerAddressAddController.isInternationalSwitchController,
                                activeColor: Theme.of(context).colorScheme.primary,
                                width: size.width / 8,
                                height: size.height / 30,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          customerAddressAddController.listCountries.isNotEmpty
                              ? CustomDropdown.search(
                                  hintText: "country".tr,
                                  errorText: "textFieldEmptyError".tr,
                                  items: customerAddressAddController.listCountries,
                                  controller: customerAddressAddController.countryDropDownController,
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.cardBorderRadius + 10,
                                  ),
                                  listItemStyle: Theme.of(context).textTheme.bodyMedium?.apply(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                  excludeSelected: false,
                                )
                              : SizedBox(),
                          const SizedBox(height: 20),
                          customerAddressAddController.listStates.isNotEmpty
                              ? CustomDropdown.search(
                                  hintText: "state".tr,
                                  errorText: "textFieldEmptyError".tr,
                                  items: customerAddressAddController.listStates,
                                  controller: customerAddressAddController.stateDropDownController,
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.cardBorderRadius + 10,
                                  ),
                                  listItemStyle: Theme.of(context).textTheme.bodyMedium?.apply(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                  excludeSelected: false,
                                )
                              : SizedBox(),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: size.width,
                            child: shoppingElevatedButton(
                              onPressed: customerAddressAddController.saveAddress,
                              buttonText: "saveAddress".tr,
                              textStyle: Theme.of(context).textTheme.bodyLarge!.apply(
                                    color: Colors.white,
                                    fontWeightDelta: 1,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 30),
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
