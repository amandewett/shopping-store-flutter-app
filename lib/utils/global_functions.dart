import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/main.dart';

String getRightTranslation(String englishText, String arabicText) =>
    hiveBox.get(AppStorageKeys.selectedLocale) == enumAppLanguage.english.index ? englishText : arabicText;
