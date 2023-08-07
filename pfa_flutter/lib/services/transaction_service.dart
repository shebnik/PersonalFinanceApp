import 'dart:collection';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:intl/intl.dart';
import 'package:pfa_flutter/main_controller.dart';
import 'package:pfa_flutter/models/teller_transaction.dart';
import 'package:pfa_flutter/models/user.dart';
import 'package:pfa_flutter/services/firebase/cloud_functions.dart';
import 'package:pfa_flutter/services/shared_preferences_service.dart';
import 'package:pfa_flutter/utils/app_constants.dart';
import 'package:pfa_flutter/utils/logger.dart';
import 'package:pfa_flutter/utils/utils.dart';

class ReportInfo {
  final String name;
  final double amount;

  ReportInfo({
    required this.name,
    required this.amount,
  });
}

class TransactionService {
  static Future<void> fetchTodaysTransactions() async {
    if (await Get.find<MainController>().checkSubscription() == false) {
      Logger.i('[CloudFunctions] fetchTodaysTransactions - user is invalid');
      return;
    }
    SharedPreferencesService.setFetchedTodaysTransactions(false);

    final AppUser? user = SharedPreferencesService.getUser();
    if (user != null) {
      var transactions =
          await CloudFunctions(user.userId).getTodayTransactions(user);

      if (transactions != null) {
        Logger.i(
            'Todays transactions count: ${transactions.length.toString()}');
        saveTransactions(1, transactions);
      }
    }

    SharedPreferencesService.setFetchedTodaysTransactions(true);
    Logger.i('Fetched todays transactions');
  }

  static List<TellerTransaction> getTransactions(int pastDays) {
    List<TellerTransaction> transactions = [];
    for (var date in Utils.getPastDates(pastDays)) {
      transactions = [
        ...transactions,
        ...SharedPreferencesService.getTransactions(date) ?? []
      ];
    }
    return transactions;
  }

  static void saveTransactions(int days, List<TellerTransaction> transactions) {
    for (var date in Utils.getPastDates(days)) {
      SharedPreferencesService.setTransactions(
        transactions.where((element) => element.date == date).toList(),
        date,
      );
    }
  }

  static double calculateSpentMoney(List<TellerTransaction> transactions) {
    double spentMoney = 0;
    for (var transaction in transactions) {
      if (shouldExclude(transaction)) {
        continue;
      }
      
      double? amount = double.tryParse(transaction.amount);
      if (amount == null || amount > 0) continue;
      spentMoney -= amount;
    }
    return spentMoney;
  }

  static List<ReportInfo> getTopCategories(
      List<TellerTransaction> transactions) {
    Map<String, double> topCategories = {};
    for (var transaction in transactions) {
      if (shouldExclude(transaction)) {
        continue;
      }

      double? amount = double.tryParse(transaction.amount);
      if (amount == null || amount > 0) continue;
      amount = amount.abs();

      String category = transaction.details.category;
      try {
        category = toBeginningOfSentenceCase(category)!;
      } catch (e) {
        Logger.e('[getTopCategories] toBeginningOfSentenceCase error: ', e);
      }

      if (topCategories.containsKey(category)) {
        topCategories[category] = topCategories[category]! + amount;
      } else {
        topCategories[category] = amount;
      }
    }
    final sorted = SplayTreeMap<String, double>.from(topCategories,
        (key1, key2) => topCategories[key1]!.compareTo(topCategories[key2]!));

    var list = sorted.entries
        .map((entry) => ReportInfo(name: entry.key, amount: entry.value))
        .toList();
    return list;
  }

  static List<ReportInfo> getAllTransactions(
      List<TellerTransaction> transactions) {
    List<ReportInfo> list = [];
    for (var transaction in transactions) {
      if (shouldExclude(transaction)) {
        continue;
      }

      double? amount = double.tryParse(transaction.amount);
      if (amount == null || amount > 0) continue;
      amount = amount.abs();
      String description = transaction.description;
      list.add(ReportInfo(name: description, amount: amount));
    }
    // list.sort((key1, key2) => key1.amount.compareTo(key2.amount));
    return list;
  }

  static bool shouldExclude(TellerTransaction transaction) {
    if (AppConstants.transactionsExcludeTypes.contains(transaction.type) ||
        transaction.description.toLowerCase().contains('withdrawal')) {
      return true;
    }
    return false;
  }
}
