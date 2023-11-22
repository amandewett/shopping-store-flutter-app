import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopping_store/controllers/splash/splash_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Get.put(SplashController(context));
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              AppAssets.appBarLogoPng,
              height: size.height / 40,
            ),
          ],
        ),
      ),
    );
  }
}
