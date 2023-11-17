// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class AppConstants {
  // Shared preferences
  static const APP_USER_SHARED_PREFERENCE = "user";
  static const MENTOR_SHARED_PREFERENCE = "mentor";
  static const PREFERENCES_SHARED_PREFERENCE = "preferences";
  static TRANSACTIONS_SHARED_PREFERENCE(String date) => 'transactions/$date';
  static const FETCHED_TODAYS_TRANSACTIONS = "fetched_todays_transactions";

  static const URL_LEGAL = "https://docs.haaatch.com";
  static const URL_FAQ = "mailto:support@kittycash.app";

  static const tellerConnectURL = 'https://pfa-dev-8f971.web.app/';

  static const dailyBudget = 10.00;

  static const transactionsExcludeTypes = [
    "withdrawal",
    "credit",
    "deposit",
  ];

  // IAP
  static const String MONTHLY_ID = "pfa_monthly";
  static const String MONTHLY_NAME = "Monthly";
  static const String YEARLY_ID = "pfa_yearly";
  static const String YEARLY_NAME = "Yearly";
  static const List<String> iapIds = [MONTHLY_ID, YEARLY_ID];
  static const String ANDROID_PACKAGE_NAME = "com.personal.finance.app";
  static const String IOS_PACKAGE_NAME = "com.personal.finance.app.ios";
  static const int ANIMATION_TIME = 1000;
}

class DataChangeFlags {
  static const USER_CHANGED = "USER_CHANGED";
  static const MENTOR_CHANGED = "MENTOR_CHANGED";
  static const USER_PREFERENCE_CHANGED = "USER_PREFERENCE_CHANGED";
  static const FETCHED_TODAYS_TRANSACTIONS_CHANGED =
      "FETCHED_TODAYS_TRANSACTIONS_CHANGED";
  static const TRANSACTIONS_CHANGED = 'TRANSACTIONS_CHANGED';
}
