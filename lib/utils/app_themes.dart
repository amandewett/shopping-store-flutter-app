import 'package:flutter/material.dart';
import 'package:shopping_store/constants/app_assets.dart';
import 'package:shopping_store/constants/app_colors.dart';
import 'package:shopping_store/constants/app_sizes.dart';

class AppThemes {
  ThemeData light({required BuildContext context}) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.lightPrimaryColor,
      colorScheme: ColorScheme.fromSeed(
        primary: AppColors.lightPrimaryColor,
        seedColor: AppColors.lightPrimaryColor,
        brightness: Brightness.light,
        error: AppColors.lightErrorColor,
        background: AppColors.lightBackgroundColor,
      ),
      hintColor: AppColors.lightHintColor,
      scaffoldBackgroundColor: AppColors.lightScaffoldBackgroundColor,
      fontFamily: AppAssets.appFontFamilyRoboto,
      splashColor: AppColors.lightPrimaryColor.withOpacity(0.1),
      cardTheme: CardTheme(
        color: AppColors.lightCardBackground,
        shadowColor: AppColors.lightBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: AppSizes.buttonElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.cardBorderRadius,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: AppColors.lightCardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.cardBorderRadius,
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.lightTextColor,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.lightTextColor,
        ),
        displayMedium: TextStyle(
          color: AppColors.lightTextColor,
        ),
        displaySmall: TextStyle(
          color: AppColors.lightTextColor,
        ),
        headlineLarge: TextStyle(
          color: AppColors.lightTextColor,
        ),
        headlineMedium: TextStyle(
          color: AppColors.lightTextColor,
        ),
        headlineSmall: TextStyle(
          color: AppColors.lightTextColor,
        ),
        titleLarge: TextStyle(
          color: AppColors.lightTextColor,
        ),
        titleMedium: TextStyle(
          color: AppColors.lightTextColor,
        ),
        titleSmall: TextStyle(
          color: AppColors.lightTextColor,
        ),
        bodyLarge: TextStyle(
          color: AppColors.lightTextColor,
        ),
        bodyMedium: TextStyle(
          color: AppColors.lightTextColor,
        ),
        bodySmall: TextStyle(
          color: AppColors.lightTextColor,
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.lightTextColor,
        size: AppSizes.iconSize,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(
            AppSizes.buttonElevation,
          ),
          textStyle: MaterialStateProperty.all(
            Theme.of(context).textTheme.bodyLarge!.apply(
                  fontSizeDelta: -2,
                ),
          ),
          backgroundColor: MaterialStateProperty.all(
            AppColors.lightPrimaryColor,
          ),
          foregroundColor: MaterialStateProperty.all(
            AppColors.lightBackgroundColor,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppSizes.cardBorderRadius,
              ),
            ),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(
            AppSizes.buttonElevation,
          ),
          textStyle: MaterialStateProperty.all(
            Theme.of(context).textTheme.bodyLarge!.apply(
                  fontSizeDelta: -2,
                ),
          ),
          backgroundColor: MaterialStateProperty.all(
            AppColors.lightBackgroundColor,
          ),
          foregroundColor: MaterialStateProperty.all(
            AppColors.lightPrimaryColor,
          ),
          side: MaterialStateProperty.all<BorderSide>(
            const BorderSide(
              width: 1.5,
              color: AppColors.lightPrimaryColor,
            ),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppSizes.cardBorderRadius,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: AppSizes.buttonElevation,
      ),
    );
  }

  ThemeData dark({required BuildContext context}) {
    return ThemeData(
      brightness: Brightness.dark,
    );
  }
}
