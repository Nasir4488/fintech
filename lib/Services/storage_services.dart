// ignore_for_file: constant_identifier_names

import 'package:get_storage/get_storage.dart';

class AppStorage {
  static const DARK_MODE = "DARK_MODE";
  static const WALLET_INTRO = "WALLET_INTRO";
  static const WALLETS_DATA = "WALLETS_DATA";
  static const MASTER_SEEDS = "MASTER_SEEDS";
  static const WALLET_PASSWORD = "WALLET_PASSWORD";
  static const ENABLE_BIO = "ENABLE_BIO";
  static const LAST_TIME_OF_AUTH = "LAST_TIME_OF_AUTH";
  static const LAST_TIME_OF_MESSAGE = "LAST_TIME_OF_MESSAGE";
  static const SKIP_ADD_DATETIME = "IS_SKIP_ADD";
  static const CHATS_MUTED = "CHATS_MUTED";
  static const CHAT_TERMS = "CHAT_TERMS";
  static const USERDATA="USERDATA";
  static const RPC = "RPC";



  // static const CURRENT_USER_STATES = "CURRENT_USER_STATES";

  static const CHAT_USER_DATA = "CHAT_USER_DATA";

  /// App Rate
  static const INSTALL_DATE = "INSTALL_DATE";
  static const APP_RATED = "APP_RATED";
  static const RATE_LATER = "RATE_LATER";

  /// Beneficiary
  static const BENEFICIARY = "BENEFICIARY_DATA";



  /// History

  static const WALLET_HISTORY = "WALLET_HISTORY";

  /// Adds
  static const HAPPY_NEW_YEAR = "HAPPY_NEW_YEAR_2024";
  static const Congratulations = "Congratulations";

  /// Language
  static const LANGUAGE_CODE = "LANGUAGE_CODE";
  static const LANGUAGE_COUNTRY_CODE = "LANGUAGE_COUNTRY_CODE";

  static final box = GetStorage();
}
