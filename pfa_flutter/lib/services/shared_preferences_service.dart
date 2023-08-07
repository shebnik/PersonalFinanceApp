import 'dart:async';
import 'dart:convert';

import 'package:pfa_flutter/models/mentor.dart';
import 'package:pfa_flutter/models/preferences.dart';
import 'package:pfa_flutter/models/teller_transaction.dart';
import 'package:pfa_flutter/models/user.dart';
import 'package:pfa_flutter/utils/app_constants.dart';
import 'package:pfa_flutter/utils/logger.dart';
import 'package:pfa_flutter/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late final SharedPreferences sharedPreferences;

  static late StreamController sharedPreferencesStreamController;
  static late Stream sharedPreferencesChangeStream;

  static initStreams() {
    sharedPreferencesStreamController = StreamController<String>.broadcast();
    sharedPreferencesChangeStream = sharedPreferencesStreamController.stream;
  }

  static closeStreams() {
    sharedPreferencesStreamController.close();
  }

  static AppUser? getUser() {
    try {
      return AppUser.fromJson(
          readJson(AppConstants.APP_USER_SHARED_PREFERENCE));
    } catch (e) {
      Logger.e('getUser error: ', e);
      return null;
    }
  }

  static Future<void> setUser(AppUser user) async {
    await saveJson(AppConstants.APP_USER_SHARED_PREFERENCE, user.toJson());
    sharedPreferencesStreamController.add(DataChangeFlags.USER_CHANGED);
  }

  static Mentor? getMentor() {
    try {
      return Mentor.fromJson(readJson(AppConstants.MENTOR_SHARED_PREFERENCE));
    } catch (e) {
      Logger.e('getMentor error: ', e);
      return null;
    }
  }

  static Future<void> setMentor(Mentor mentor) async {
    await saveJson(AppConstants.MENTOR_SHARED_PREFERENCE, mentor.toJson());
    sharedPreferencesStreamController.add(DataChangeFlags.MENTOR_CHANGED);
  }

  static Preferences? getPreferences() {
    try {
      return Preferences.fromJson(
          readJson(AppConstants.PREFERENCES_SHARED_PREFERENCE));
    } catch (e) {
      Logger.e('getPreferences error: ', e);
      return null;
    }
  }

  static Future<void> setPreferences(Preferences preferences) async {
    await saveJson(AppConstants.PREFERENCES_SHARED_PREFERENCE, preferences.toJson());
    sharedPreferencesStreamController
        .add(DataChangeFlags.USER_PREFERENCE_CHANGED);
  }

  static List<TellerTransaction>? getTransactions(String date) {
    try {
      return readJson(AppConstants.TRANSACTIONS_SHARED_PREFERENCE(date))
          .map<TellerTransaction>((e) => TellerTransaction.fromJson(e))
          .toList();
    } catch (e) {
      Logger.e('GetTransactions for date $date not found');
      return null;
    }
  }

  static Future<void> setTransactions(
    List<TellerTransaction> transactions,
    String date,
  ) async {
    await saveJson(AppConstants.TRANSACTIONS_SHARED_PREFERENCE(date),
        transactions.map((e) => e.toJson()).toList());
    sharedPreferencesStreamController.add(DataChangeFlags.TRANSACTIONS_CHANGED);
    Logger.i('Saved transactions for date: $date');
  }

  static bool getFetchedTodaysTransactions() =>
      readBoolean(AppConstants.FETCHED_TODAYS_TRANSACTIONS) ?? false;

  static setFetchedTodaysTransactions(bool value) async {
    await saveBoolean(AppConstants.FETCHED_TODAYS_TRANSACTIONS, value);
    sharedPreferencesStreamController
        .add(DataChangeFlags.FETCHED_TODAYS_TRANSACTIONS_CHANGED);
  }

  static readString(String key) {
    return sharedPreferences.getString(key);
  }

  static saveString(String key, String value) async {
    return await sharedPreferences.setString(key, value);
  }

  static readInt(String key) {
    return sharedPreferences.getInt(key);
  }

  static saveInt(String key, int value) async {
    return await sharedPreferences.setInt(key, value);
  }

  static readBoolean(String key) {
    return sharedPreferences.getBool(key);
  }

  static saveBoolean(String key, bool value) async {
    return await sharedPreferences.setBool(key, value);
  }

  static dynamic readJson(String key) {
     final json = sharedPreferences.getString(key);
    if (json != null) {
      final decodedJson = jsonDecode(
        json,
        reviver: Utils.jsonReviver,
      );
      Logger.i('[SharedPreferences] [READ] $key - $json');
      return decodedJson;
    }
    Logger.i('[SharedPreferences] [READ] $key - null');
  }

  static Future<bool> saveJson(String key, value) {
    Logger.i('[SharedPreferences] [SAVE] $key - $value');
    return sharedPreferences.setString(
      key,
      json.encode(
        value,
        toEncodable: Utils.dateSerializer,
      ),
    );
  }

  static remove(String key) async {
    await sharedPreferences.remove(key);
  }

  static clear() async {
    await sharedPreferences.clear();
  }
}
