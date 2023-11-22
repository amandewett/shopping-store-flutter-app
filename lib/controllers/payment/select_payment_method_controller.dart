import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/my_fatoorah_payment_failed_response.dart';
import 'package:shopping_store/models/my_fatoorah_payment_method_list_model.dart';
import 'package:shopping_store/models/my_fatoorah_payment_response_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/views/pages/bottom_navigation/bottom_navigation_page.dart';

class SelectPaymentMethodController extends GetxController {
  final BuildContext context;
  final List<MyFatoorahPaymentMethodListModel> listPaymentMethods;
  final double itemTotal;
  final double taxValue;
  final double taxPercent;
  final double discountValue;
  final double discountPercent;
  final double totalCartValue;
  final double totalCartWeight;
  final List<dynamic> cartItems;
  final int taxId;
  final int couponId;
  final int countryId;
  final int addressId;
  final int billingAddressId;
  final int isInternational;
  final double shipmentFee;
  String invoiceId = "";
  int orderId = 0;

  SelectPaymentMethodController(
    this.context,
    this.listPaymentMethods,
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
    this.addressId,
    this.billingAddressId,
    this.isInternational,
    this.shipmentFee,
  );

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  goBack() => Get.back();

  onPaymentMethodTap(MyFatoorahPaymentMethodListModel paymentMethod) async {
    MFExecutePaymentRequest mfExecutePaymentRequest = MFExecutePaymentRequest(invoiceValue: totalCartValue);
    mfExecutePaymentRequest.paymentMethodId = paymentMethod.paymentMethodId;
    if (hiveBox.get(AppStorageKeys.userEmail) != null) mfExecutePaymentRequest.customerEmail = hiveBox.get(AppStorageKeys.userEmail);
    if (hiveBox.get(AppStorageKeys.userFirstName) != null) {
      mfExecutePaymentRequest.customerName = "${hiveBox.get(AppStorageKeys.userFirstName)} ${hiveBox.get(AppStorageKeys.userLastName)}";
    }

    if (paymentMethod.paymentMethodId == 5) {
      await MFSDK.executePayment(mfExecutePaymentRequest, MFLanguage.ENGLISH, (invId) async {
        invoiceId = invId;
        await createNewOrder(invId: invoiceId);
      }).then((MFGetPaymentStatusResponse mfGetPaymentStatusResponse) async {
        if (mfGetPaymentStatusResponse.invoiceStatus == "Paid" && mfGetPaymentStatusResponse.invoiceTransactions?[0].transactionStatus == "Succss") {
          MyFatoorahPaymentResponseModel paymentResponse = myFatoorahPaymentResponseModelFromJson(jsonEncode(mfGetPaymentStatusResponse));
          if (orderId != 0) {
            await updateOrder(orderId: orderId, invId: invoiceId, pResponse: paymentResponse);
            await _clearCart();
          }
          Get.offAll(() => const BottomNavigationPage());
          BotToast.showText(text: "Payment successful");
        }
      });
    } else {
      await MFSDK.executePayment(mfExecutePaymentRequest, MFLanguage.ENGLISH, (invId) async {
        invoiceId = invId;
        await createNewOrder(invId: invoiceId);
      }).then((MFGetPaymentStatusResponse mfGetPaymentStatusResponse) async {
        if (mfGetPaymentStatusResponse.invoiceStatus == "Paid" && mfGetPaymentStatusResponse.invoiceTransactions?[0].transactionStatus == "Succss") {
          MyFatoorahPaymentResponseModel paymentResponse = myFatoorahPaymentResponseModelFromJson(jsonEncode(mfGetPaymentStatusResponse));
          if (orderId != 0) {
            paymentResponse = myFatoorahPaymentResponseModelFromJson(jsonEncode(mfGetPaymentStatusResponse));
            await updateOrder(orderId: orderId, invId: invoiceId, pResponse: paymentResponse);
            await _clearCart();
          }
          Get.offAll(() => const BottomNavigationPage());
          BotToast.showText(text: "Payment successful");
        }
      }).catchError((error) async {
        debugPrint("payment error: ${error.runtimeType}");
        debugPrint("payment error: ${error.message}");
        if (orderId != 0) {
          await updateOrderOnError(orderId: orderId, invId: invoiceId, error: error);
        }
        BotToast.showText(text: error.message);
      });
    }
  }

  Future<bool> createNewOrder({required String invId}) async {
    var payload = jsonEncode(<String, dynamic>{
      "cartItems": cartItems,
      "itemsTotal": itemTotal,
      "taxId": taxId,
      "taxPercent": taxPercent,
      "taxValue": taxValue,
      "couponId": couponId == 0 ? null : couponId,
      "discountValue": discountValue,
      "discountPercent": discountPercent,
      "shipmentPrice": shipmentFee,
      "totalCartValue": totalCartValue,
      "totalCartWeight": totalCartWeight,
      "isInternational": isInternational,
      "countryId": countryId,
      "shippingAddressId": addressId,
      "billingAddressId": billingAddressId,
      "invoiceId": invId,
    });

    Map<String, dynamic> apiResponse = await RemoteService().post(
      context: context,
      endpoint: Api.apiCreateOrder,
      payloadObj: payload,
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      orderId = apiResponse['orderId'];
      return true;
    } else {
      BotToast.showText(text: apiResponse['message']);
      return false;
    }
  }

  Future<bool> updateOrder({required int orderId, required String invId, required MyFatoorahPaymentResponseModel pResponse}) async {
    var payload = jsonEncode(<String, dynamic>{
      "id": orderId,
      "invoiceId": invId,
      "invoiceStatus": pResponse.invoiceStatus,
      "invoiceReference": pResponse.invoiceReference,
      "customerReference": pResponse.customerReference,
      "createdDate": pResponse.createdDate.toString(),
      "expiryDate": pResponse.expiryDate.toString(),
      "expiryTime": pResponse.expiryTime,
      "invoiceValue": pResponse.invoiceValue,
      "comments": pResponse.comments,
      "customerName": pResponse.customerName,
      "customerMobile": pResponse.customerMobile,
      "customerEmail": pResponse.customerEmail,
      "userDefinedField": pResponse.userDefinedField,
      "invoiceDisplayValue": pResponse.invoiceDisplayValue,
      "dueDeposit": pResponse.dueDeposit,
      "depositStatus": pResponse.depositStatus,
      "invoiceItems": pResponse.invoiceItems,
      "suppliers": pResponse.suppliers,
      "transactionDate": pResponse.invoiceTransactions[0].transactionDate.toString(),
      "paymentGateway": pResponse.invoiceTransactions[0].paymentGateway,
      "referenceId": pResponse.invoiceTransactions[0].referenceId,
      "trackId": pResponse.invoiceTransactions[0].trackId,
      "transactionId": pResponse.invoiceTransactions[0].transactionId,
      "paymentId": pResponse.invoiceTransactions[0].paymentId,
      "authorizationId": pResponse.invoiceTransactions[0].authorizationId,
      "transactionStatus": pResponse.invoiceTransactions[0].transactionStatus,
      "transactionValue": pResponse.invoiceTransactions[0].transationValue,
      "customerServiceCharge": pResponse.invoiceTransactions[0].customerServiceCharge,
      "totalServiceCharge": pResponse.invoiceTransactions[0].totalServiceCharge,
      "dueValue": pResponse.invoiceTransactions[0].dueValue,
      "paidCurrency": pResponse.invoiceTransactions[0].paidCurrency,
      "paidCurrencyValue": pResponse.invoiceTransactions[0].paidCurrencyValue,
      "ipAddress": pResponse.invoiceTransactions[0].ipAddress,
      "country": pResponse.invoiceTransactions[0].country,
      "currency": pResponse.invoiceTransactions[0].currency,
      "error": pResponse.invoiceTransactions[0].error,
      "cardNumber": pResponse.invoiceTransactions[0].cardNumber,
      "errorCode": pResponse.invoiceTransactions[0].errorCode,
    });

    Map<String, dynamic> apiResponse = await RemoteService().post(
      context: context,
      endpoint: Api.apiUpdateOrder,
      payloadObj: payload,
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      return true;
    } else {
      BotToast.showText(text: apiResponse['message']);
      return false;
    }
  }

  Future<bool> updateOrderOnError({required int orderId, required String invId, required dynamic error}) async {
    var payload = jsonEncode(<String, dynamic>{
      "id": orderId,
      "invoiceId": invId,
      "invoiceStatus": "Failed",
      "error": error.message,
      "errorCode": error.code,
    });

    Map<String, dynamic> apiResponse = await RemoteService().post(
      context: context,
      endpoint: Api.apiUpdateOrder,
      payloadObj: payload,
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      return true;
    } else {
      BotToast.showText(text: apiResponse['message']);
      return false;
    }
  }

  _clearCart() async => await RemoteService().get(context: context, endpoint: Api.apiClearCart);
}
