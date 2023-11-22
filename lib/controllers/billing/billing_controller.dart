import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_assets.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/customer_address_model.dart';
import 'package:shopping_store/models/my_fatoorah_payment_method_list_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/views/pages/customer_address/customer_address_add_page.dart';
import 'package:shopping_store/views/pages/payment/select_payment_method_page.dart';
import 'package:shopping_store/views/widgets/shopping_text_button.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';

class BillingController extends GetxController {
  final BuildContext context;
  double itemTotal;
  double taxValue;
  double taxPercent;
  double discountValue;
  double discountPercent;
  double totalCartValue;
  double totalCartWeight;
  List<dynamic> cartItems;
  int taxId;
  int couponId;
  int countryId;
  double shippingFee = 0;
  List<CustomerAddressModel> listAddresses = [];
  late CustomerAddressModel shippingDefaultAddress;
  late CustomerAddressModel billingDefaultAddress;
  bool isDefaultAddressInit = false;
  bool isDefaultBillingAddressInit = false;
  List<MyFatoorahPaymentMethodListModel> myFatoorahPaymentMethodList = [];
  final billingAddressSwitchController = ValueNotifier<bool>(false);
  bool isBillingAddressSameAsShipping = false;

  BillingController(
    this.context,
    this.itemTotal,
    this.taxValue,
    this.taxPercent,
    this.discountValue,
    this.discountPercent,
    this.totalCartValue,
    this.totalCartWeight,
    this.cartItems,
    this.taxId,
    this.couponId,
    this.countryId,
  );

  @override
  void onInit() {
    initSwitch();
    getAddresses();
    MFSDK.init(AppAssets.appMyFatoorahApiToken, MFCountry.UAE, MFEnvironment.TEST);
    MFSDK.setUpActionBar(toolBarTitle: AppAssets.appName, toolBarTitleColor: "#FFFFFF", toolBarBackgroundColor: '#EE6825', isShowToolBar: true);
    super.onInit();
  }

  @override
  void onClose() {
    billingAddressSwitchController.removeListener(() {});
    super.onClose();
  }

  goBack() => Get.back();

  Future<bool> getAddresses() async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiListCustomerAddresses}/${hiveBox.get(AppStorageKeys.selectedCountryId)}",
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      //add country, state and international country details details
      for (var obj in apiResponse['result']) {
        if (obj['isInternational'] == 0) {
          Map<String, dynamic>? countryDetails = await getCountryDetails(obj['countryId']);
          obj['countryDetails'] = countryDetails;
          Map<String, dynamic>? stateDetails = await getStateDetails(obj['stateId']);
          obj['stateDetails'] = stateDetails;
        } else {
          Map<String, dynamic>? countryDetails = await getInternationalCountryDetails(obj['countryId']);
          obj['internationalCountryDetails'] = countryDetails;
        }
      }

      listAddresses = customerAddressModelFromJson(jsonEncode(apiResponse['result']));

      if (listAddresses.isNotEmpty) {
        //set default address
        shippingDefaultAddress = listAddresses[0];
        isDefaultAddressInit = true;

        for (var address in listAddresses) {
          if (address.isDefault == 1) {
            shippingDefaultAddress = address;
            isDefaultAddressInit = true;
          }
        }

        if (isDefaultAddressInit) {
          if (shippingDefaultAddress.isInternational == 0) {
            //set shipment price
            shippingFee = shippingDefaultAddress.stateDetails!.shipmentPrice;
            totalCartValue = totalCartValue + shippingFee;
          } else {
            shippingFee = totalCartWeight < 451
                ? shippingDefaultAddress.internationalCountryDetails!.priceOne
                : shippingDefaultAddress.internationalCountryDetails!.priceTwo;
            totalCartValue = totalCartValue + shippingFee;
          }
        }
      }

      update();
      return true;
    } else {
      BotToast.showText(text: apiResponse['message']);
      return false;
    }
  }

  Future<Map<String, dynamic>?> getCountryDetails(int countryId) async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiCountryDetails}/$countryId",
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      return apiResponse['result'];
    } else {
      BotToast.showText(text: apiResponse['message']);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getStateDetails(int stateId) async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiStateDetails}/$stateId",
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      return apiResponse['result'];
    } else {
      BotToast.showText(text: apiResponse['message']);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getInternationalCountryDetails(int countryId) async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiDetailsInternationalCountry}/$countryId",
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      return apiResponse['result'];
    } else {
      BotToast.showText(text: apiResponse['message']);
      return null;
    }
  }

  setDefaultAddress(int addressId) async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiSetDefaultAddress}/$addressId",
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      getAddresses();
      BotToast.showText(text: apiResponse['message']);
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  changeAddress({required Size size, bool isForBilling = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                AppSizes.cardBorderRadius,
              ),
              topRight: Radius.circular(
                AppSizes.cardBorderRadius,
              ),
            ),
          ),
          padding: const EdgeInsets.only(
            top: 20.0,
            left: AppSizes.pagePadding,
            right: AppSizes.pagePadding,
          ),
          height: size.height / 1.2,
          child: ListView.builder(
            itemCount: listAddresses.length,
            itemBuilder: (lvContext, lvIndex) {
              return Column(
                children: [
                  Card(
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listAddresses[lvIndex].name,
                            style: Theme.of(context).textTheme.titleMedium?.apply(
                                  fontWeightDelta: 2,
                                  fontSizeDelta: 2,
                                ),
                          ),
                          Text(
                            listAddresses[lvIndex].email,
                            style: Theme.of(context).textTheme.bodySmall?.apply(
                                  fontWeightDelta: 1,
                                ),
                          ),
                          Text(
                            listAddresses[lvIndex].address2 == ""
                                ? "${listAddresses[lvIndex].address}, ${listAddresses[lvIndex].city}"
                                : "${listAddresses[lvIndex].address}, ${listAddresses[lvIndex].address2}, ${listAddresses[lvIndex].city}",
                            style: Theme.of(context).textTheme.titleSmall?.apply(),
                          ),
                          listAddresses[lvIndex].isInternational == 0
                              ? Text(
                                  "${listAddresses[lvIndex].stateDetails!.stateName}, ${listAddresses[lvIndex].countryDetails!.countryName} - ${listAddresses[lvIndex].postalCode}",
                                  style: Theme.of(context).textTheme.titleSmall?.apply(),
                                )
                              : Text(
                                  "${listAddresses[lvIndex].internationalCountryDetails!.countryName} - ${listAddresses[lvIndex].postalCode}",
                                  style: Theme.of(context).textTheme.titleSmall?.apply(),
                                ),
                          Text(
                            listAddresses[lvIndex].phoneNumber,
                            style: Theme.of(context).textTheme.titleSmall?.apply(),
                          ),
                          listAddresses[lvIndex].isDefault == 0
                              ? Container(
                                  alignment: Alignment.bottomRight,
                                  child: shoppingTextButton(
                                    onPressed: () {
                                      if (isForBilling) {
                                        isDefaultBillingAddressInit = true;
                                        billingDefaultAddress = listAddresses[lvIndex];
                                      } else {
                                        if (listAddresses[lvIndex].isInternational == 1) {
                                          totalCartValue = totalCartValue - shippingFee;
                                          shippingDefaultAddress = listAddresses[lvIndex];
                                          isDefaultAddressInit = true;

                                          if (isBillingAddressSameAsShipping) {
                                            isDefaultBillingAddressInit = true;
                                            billingDefaultAddress = listAddresses[lvIndex];
                                          }

                                          //set shipment price
                                          shippingFee = totalCartWeight < 451
                                              ? shippingDefaultAddress.internationalCountryDetails!.priceOne
                                              : shippingDefaultAddress.internationalCountryDetails!.priceTwo;
                                          totalCartValue = totalCartValue + shippingFee;

                                          //set default address
                                          setDefaultAddress(listAddresses[lvIndex].id);
                                        } else {
                                          totalCartValue = totalCartValue - shippingFee;
                                          shippingDefaultAddress = listAddresses[lvIndex];
                                          isDefaultAddressInit = true;

                                          if (isBillingAddressSameAsShipping) {
                                            isDefaultBillingAddressInit = true;
                                            billingDefaultAddress = listAddresses[lvIndex];
                                          }

                                          //set shipment price
                                          shippingFee = shippingDefaultAddress.stateDetails!.shipmentPrice;
                                          totalCartValue = totalCartValue + shippingFee;

                                          //set default address
                                          setDefaultAddress(listAddresses[lvIndex].id);
                                        }
                                      }
                                      update();
                                      Get.back();
                                    },
                                    buttonText: isForBilling ? "select".tr : "setDefault".tr,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
    );
  }

  onAddNewAddressTap() {
    Get.to(() => const CustomerAddressAddPage())!.then((value) {
      getAddresses();
    });
  }

  onMakePaymentClicked() async {
    if (isDefaultAddressInit && isDefaultBillingAddressInit) {
      MFInitiatePaymentRequest request = MFInitiatePaymentRequest(invoiceAmount: totalCartValue, currencyIso: MFCurrencyISO.UAE_AED);
      await MFSDK.initiatePayment(request, MFLanguage.ENGLISH).then((value) {
        if (value.paymentMethods != null) {
          if (value.paymentMethods!.isNotEmpty) {
            myFatoorahPaymentMethodList = myFatoorahPaymentMethodListFromJson(jsonEncode(value.paymentMethods));
            Get.to(
              () => SelectPaymentMethodPage(
                listPaymentMethods: myFatoorahPaymentMethodList,
                itemTotal: itemTotal,
                taxValue: taxValue,
                taxPercent: taxPercent,
                discountValue: discountValue,
                discountPercent: discountPercent,
                totalCartValue: totalCartValue,
                totalCartWeight: totalCartWeight,
                cartItems: cartItems,
                taxId: taxId,
                couponId: couponId,
                countryId: shippingDefaultAddress.countryId,
                addressId: shippingDefaultAddress.id,
                billingAddressId: billingDefaultAddress.id,
                isInternational: shippingDefaultAddress.isInternational,
                shipmentFee: shippingFee,
              ),
            );
          }
        }
      }).catchError((error) {
        BotToast.showText(text: error.message);
      });
    } else {
      BotToast.showText(text: "addressRequiredNote".tr);
    }
  }

  initSwitch() {
    billingAddressSwitchController.addListener(() {
      if (billingAddressSwitchController.value) {
        isBillingAddressSameAsShipping = true;
        isDefaultBillingAddressInit = true;
        billingDefaultAddress = shippingDefaultAddress;
      } else {
        isBillingAddressSameAsShipping = false;
        isDefaultBillingAddressInit = false;
      }
      update();
    });
  }
}
