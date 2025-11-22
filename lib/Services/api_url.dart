// ignore_for_file: constant_identifier_names

class APiUrls {
  static const BASE_URL = "https://allv20.vrcscan.com/api/";

  /// Support Questions
  static const SUPPORT_PREFIX = "api/";
  static const SUPPORT_BASE_URL = "https://v20-support.vzsolution.com/";

  static const GET_SUPPORT_QUERY = "$SUPPORT_BASE_URL${SUPPORT_PREFIX}question?an=";
  static const GET_CURRENT_USER_QUERY = "$SUPPORT_BASE_URL${SUPPORT_PREFIX}userQueries?wA=";
  static const GET_SUPPORT_QUESTIONS = "$SUPPORT_BASE_URL${SUPPORT_PREFIX}question/getQuestions/";
  static const SUBMIT_QUERY = "$SUPPORT_BASE_URL${SUPPORT_PREFIX}userQueries";
  static const AIR_DROP = "$SUPPORT_BASE_URL${SUPPORT_PREFIX}user/sendDate";

  /// Deposit
  static const DEPOSIT_SIGNATURE = "${BASE_URL}deposit/getDepositSignature";
  static const CALCULATE_REWARD = "${BASE_URL}withdraw/getRewardCalculation/";
  static const WITHDRAW_SIGNATURE = "${BASE_URL}withdraw/getWithdrawSignature/";
  static const GET_ACTIVE_TEAM_STAKE = "${BASE_URL}withdraw/getActiveTeamStake/";
  static const GET_VRC_VALUE_IN_USD = "${BASE_URL}price/coinPrice";

  /// HOME PAGE DATA
  static const GET_CURRENT_USER_STATE = "${BASE_URL}withdraw/userStats/";

  /// Staking and withdraw History
  static const GET_DEPOSIT_HISTORY = "${BASE_URL}deposit/depositHistory?userAddress=";
  static const GET_WITHDRAW_HISTORY = "${BASE_URL}withdraw/userWithdraw?userAddress=";

  /// Levels Details
  static const GET_ALL_LEVELS = "${BASE_URL}withdraw/allLevelDetails/";
  static const LEVEL_USER_DETAIL = "${BASE_URL}withdraw/levelUers?userAddress=";
  static const GET_ACTIVE_INACTIVE_MEMBERS = "${BASE_URL}withdraw/getActiveInactiveMembes/";



}
