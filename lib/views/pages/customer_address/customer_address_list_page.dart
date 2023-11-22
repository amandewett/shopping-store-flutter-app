import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/controllers/customer_address/customer_address_list_controller.dart';
import 'package:shopping_store/models/customer_address_model.dart';
import 'package:shopping_store/views/widgets/shopping_app_bar_with_search.dart';
import 'package:shopping_store/views/widgets/shopping_text_button.dart';

class CustomerAddressListPage extends StatelessWidget {
  const CustomerAddressListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final customerAddressListController = Get.put(CustomerAddressListController(context));
    return GetBuilder<CustomerAddressListController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: customerAddressListController.addNewAddress,
            label: Row(
              children: [
                const Icon(Icons.bookmark_add_outlined),
                const SizedBox(width: 5.0),
                Text(
                  "addAddress".tr,
                ),
              ],
            ),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              shoppingAppBarWithSearch(
                onBackButtonTapped: customerAddressListController.goBack,
                textEditingController: TextEditingController(),
                onChanged: (v) {},
                validator: (s, v) {
                  return null;
                },
                onSearchBarTapped: () {},
                focusNode: FocusNode(),
                cameFromSearch: true,
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: AppSizes.pagePadding,
                    right: AppSizes.pagePadding,
                  ),
                  child: ListView.builder(
                    itemCount: customerAddressListController.customerAddressesList.length,
                    itemBuilder: (lvContext, lvIndex) {
                      List<CustomerAddressModel> addressList = customerAddressListController.customerAddressesList;
                      return Column(
                        children: [
                          Card(
                            child: Container(
                              width: size.width,
                              // height: size.height / 3.9,
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    addressList[lvIndex].name,
                                    style: Theme.of(context).textTheme.titleMedium?.apply(
                                          fontWeightDelta: 2,
                                          fontSizeDelta: 2,
                                        ),
                                  ),
                                  Text(
                                    addressList[lvIndex].email,
                                    style: Theme.of(context).textTheme.bodySmall?.apply(
                                          fontWeightDelta: 1,
                                        ),
                                  ),
                                  Text(
                                    addressList[lvIndex].address2 == ""
                                        ? "${addressList[lvIndex].address}, ${addressList[lvIndex].city}"
                                        : "${addressList[lvIndex].address}, ${addressList[lvIndex].address2}, ${addressList[lvIndex].city}",
                                    style: Theme.of(context).textTheme.titleSmall?.apply(),
                                  ),
                                  addressList[lvIndex].isInternational == 0
                                      ? Text(
                                          "${addressList[lvIndex].stateDetails!.stateName}, ${addressList[lvIndex].countryDetails!.countryName} - ${addressList[lvIndex].postalCode}",
                                          style: Theme.of(context).textTheme.titleSmall?.apply(),
                                        )
                                      : Text(
                                          "${addressList[lvIndex].internationalCountryDetails!.countryName} - ${addressList[lvIndex].postalCode}",
                                          style: Theme.of(context).textTheme.titleSmall?.apply(),
                                        ),
                                  Text(
                                    addressList[lvIndex].phoneNumber,
                                    style: Theme.of(context).textTheme.titleSmall?.apply(),
                                  ),
                                  addressList[lvIndex].isDefault == 0
                                      ? Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              child: shoppingTextButton(
                                                onPressed: () => customerAddressListController.deleteAddress(addressList[lvIndex].id),
                                                buttonText: "delete".tr,
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              child: shoppingTextButton(
                                                onPressed: () {
                                                  customerAddressListController.setDefaultAddress(addressList[lvIndex].id);
                                                },
                                                buttonText: "setDefault".tr,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: lvIndex == addressList.length - 1 ? size.height / 6 : 5),
                        ],
                      );
                    },
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
