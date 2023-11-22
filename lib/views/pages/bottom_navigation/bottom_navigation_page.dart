import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/controllers/bottom_navigation/bottom_navigation_controller.dart';
import 'package:shopping_store/views/widgets/custom_app_bar.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class BottomNavigationPage extends StatelessWidget {
  final int selectedTab;

  const BottomNavigationPage({
    super.key,
    this.selectedTab = 0,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomNavigationController = Get.put(BottomNavigationController(context, selectedTab));
    return GetBuilder<BottomNavigationController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          bottomNavigationBar: StylishBottomBar(
            option: AnimatedBarOptions(
              iconSize: size.width / 16,
              barAnimation: BarAnimation.transform3D,
              iconStyle: IconStyle.Default,
              padding: const EdgeInsets.all(0),
            ),
            items: [
              BottomBarItem(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_outlined),
                selectedColor: Theme.of(context).colorScheme.primary,
                unSelectedColor: Theme.of(context).hintColor,
                title: Text("home".tr),
              ),
              BottomBarItem(
                icon: const Icon(Icons.store_outlined),
                selectedIcon: const Icon(Icons.store_outlined),
                selectedColor: Theme.of(context).colorScheme.primary,
                unSelectedColor: Theme.of(context).hintColor,
                title: Text('shop'.tr),
              ),
              BottomBarItem(
                icon: const Icon(Icons.shopping_cart_outlined),
                selectedIcon: const Icon(Icons.shopping_cart_outlined),
                selectedColor: Theme.of(context).colorScheme.primary,
                unSelectedColor: Theme.of(context).hintColor,
                title: Text('cart'.tr),
              ),
              BottomBarItem(
                icon: const Icon(Icons.face_outlined),
                selectedIcon: const Icon(Icons.face_outlined),
                selectedColor: Theme.of(context).colorScheme.primary,
                unSelectedColor: Theme.of(context).hintColor,
                title: Text('myshopping'.tr),
              ),
            ],
            hasNotch: true,
            fabLocation: StylishBarFabLocation.center,
            currentIndex: bottomNavigationController.selectedTab,
            onTap: bottomNavigationController.onItemTap,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: bottomNavigationController.onFloatingButtonTap,
            mini: true,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.chat_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Visibility(
                visible: bottomNavigationController.isAppBarVisible,
                child: CustomAppBar(
                  expandedTileController: bottomNavigationController.expandedTileController,
                  title: bottomNavigationController.listAppBarTitle[bottomNavigationController.selectedTab],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: bottomNavigationController.pageController,
                  itemCount: bottomNavigationController.listPages.length,
                  onPageChanged: bottomNavigationController.onPageChanges,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (pvContext, pvPosition) {
                    return bottomNavigationController.listPages[pvPosition];
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
