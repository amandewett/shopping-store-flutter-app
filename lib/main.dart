import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shopping_store/constants/app_colors.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/controllers/language/language_controller.dart';
import 'package:shopping_store/firebase_options.dart';
import 'package:shopping_store/translations/app_translations.dart';
import 'package:shopping_store/utils/app_themes.dart';
import 'package:shopping_store/views/pages/splash/splash_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

late Box hiveBox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  hiveBox = await Hive.openBox(AppStorageKeys.hiveBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final languageController = Get.put(LanguageController());
    return GetBuilder<LanguageController>(builder: (gbContext) {
      return GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayColor: Colors.black.withOpacity(0.2),
        overlayWidget: Center(
          child: SpinKitSpinningLines(
            color: AppColors.lightPrimaryColor,
            size: size.width / 4,
            lineWidth: 2.0,
            itemCount: 3,
          ),
        ),
        child: GetMaterialApp(
          debugShowCheckedModeBanner: true,
          translations: AppTranslations(),
          locale: languageController.currentLocale,
          fallbackLocale: const Locale("en", "US"),
          builder: BotToastInit(),
          navigatorObservers: [
            BotToastNavigatorObserver(),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const <Locale>[
            Locale("en", "US"),
            Locale("ar", "AE"),
          ],
          theme: AppThemes().light(context: context),
          darkTheme: AppThemes().dark(context: context),
          themeMode: ThemeMode.light,
          home: const SplashPage(),
        ),
      );
    });
  }
}
