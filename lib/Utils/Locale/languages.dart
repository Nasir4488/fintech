import 'dart:ui';

import 'package:get/get.dart';
import 'package:fin_tech/Services/storage_services.dart';
import 'package:fin_tech/Utils/Locale/arabic.dart';
import 'package:fin_tech/Utils/Locale/english.dart';
import 'package:fin_tech/Utils/Locale/french.dart';
import 'package:fin_tech/Utils/Locale/hindi.dart';
import 'package:fin_tech/Utils/Locale/urdu.dart';

class Messages extends Translations {
  static String getLanguageCode() {
    return AppStorage.box.read(AppStorage.LANGUAGE_CODE) ?? "en";
  }

  static String getLanguageCountryCode() {
    return AppStorage.box.read(AppStorage.LANGUAGE_CODE) ?? "US";
  }

  static void saveLanguageCode(Locale locale) {
    AppStorage.box.write(AppStorage.LANGUAGE_CODE, locale.languageCode);
    AppStorage.box.write(AppStorage.LANGUAGE_COUNTRY_CODE, locale.countryCode);
  }

  static List<LanguageCodeModel> languagesList = <LanguageCodeModel>[
    LanguageCodeModel("English", const Locale("en", "EN")),
    LanguageCodeModel("عربی", const Locale("ar", "AR")),
    LanguageCodeModel("اردو", const Locale("ur", "UR")),
    LanguageCodeModel("हिंदी", const Locale("hin", "IND")),
    LanguageCodeModel("French", const Locale("fr", "FR")),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': englishLanguage,
        'ur_UR': urduLanguage,
        'ar_AR': arabicLanguage,
        'hin_IND': hindiLanguage,
        'fr_FR': frenchLanguage,
        // Add other languages here
      };
}

class LanguageCodeModel {
  String name;
  Locale locale;

  LanguageCodeModel(this.name, this.locale);
}
