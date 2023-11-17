import 'dart:async';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:get/state_manager.dart';
import 'package:pfa_flutter/models/preferences.dart';
import 'package:pfa_flutter/services/shared_preferences_service.dart';
import 'package:pfa_flutter/services/transaction_service.dart';
import 'package:pfa_flutter/utils/app_constants.dart';
import 'package:pfa_flutter/utils/logger.dart';
import 'package:pfa_flutter/utils/utils.dart';

class ReportsPageController extends GetxController {
  late Preferences preferences;

  RxBool isLoading = true.obs;

  final DatePickerController datePickerController = DatePickerController();
  late Rx<DateTime> startDate;
  late Rx<DateTime> selectedDate;

  RxDouble dailyBudget = 0.0.obs, totalSpent = 0.0.obs, overspent = 0.0.obs;

  RxList<ReportInfo> topCategories = RxList();
  RxList<ReportInfo> allTransactions = RxList();
  StreamSubscription? preferencesDataChange;

  @override
  void onInit() {
    super.onInit();
    preferences = SharedPreferencesService.getPreferences()!;

    startDate = Rx(DateTime.now().subtract(const Duration(days: 7)));
    selectedDate = Rx(DateTime.now());

    initStream();
    checkFetchedTodaysTransactions();
  }

  @override
  void onClose() {
    preferencesDataChange?.cancel();
    super.onClose();
  }

  void initStream() {
    if (preferencesDataChange != null) {
      preferencesDataChange!.cancel();
    }
    preferencesDataChange =
        SharedPreferencesService.sharedPreferencesChangeStream.listen((event) {
      Logger.i(event);
      if (event == DataChangeFlags.USER_CHANGED) {
        // user = SharedPreferencesService.getUser()!;
      }
      if (event == DataChangeFlags.MENTOR_CHANGED) {
        // mentor = SharedPreferencesService.getMentor()!;
      }
      if (event == DataChangeFlags.USER_PREFERENCE_CHANGED) {
        preferences = SharedPreferencesService.getPreferences()!;
        updateView();
      }
      if (event == DataChangeFlags.TRANSACTIONS_CHANGED) {
        updateView();
      }
      if (event == DataChangeFlags.FETCHED_TODAYS_TRANSACTIONS_CHANGED) {
        checkFetchedTodaysTransactions();
      }
    });
  }

  Future<void> updateView() async {
    final date = Utils.formatDate(selectedDate.value);
    var transactions = SharedPreferencesService.getTransactions(date);
    // if (transactions == null) {
    //   isLoading.value = true;
    //   var user = SharedPreferencesService.getUser()!;
    //   if (Utils.isTodayDate(selectedDate.value)) {
    //     transactions =
    //         await CloudFunctions(user.userId).getTodayTransactions(user);
    //   } else {
    //     transactions =
    //         await FirestoreService(user.userId).getTransactionsForDate(date);
    //   }
    // }
    // if (transactions != null) {
    //   SharedPreferencesService.setTransactions(transactions, date);
    // }

    dailyBudget.value = preferences.dailyBudget;
    totalSpent.value =
        TransactionService.calculateSpentMoney(transactions ?? []);
    overspent.value = (totalSpent.value - dailyBudget.value);

    topCategories.value =
        RxList(TransactionService.getTopCategories(transactions ?? []));
    allTransactions.value =
        TransactionService.getAllTransactions(transactions ?? []);
    isLoading.value = false;
    Logger.i('[TransactionService] $date: Total spent = ${totalSpent.value}');
  }

  void performChangeDate(DateTime date) {
    selectedDate.value = date;
    if (SharedPreferencesService.getUser()!.linkedAccounts.isEmpty) return;
    updateView();
  }

  void checkFetchedTodaysTransactions() {
    if (SharedPreferencesService.getFetchedTodaysTransactions()) {
      isLoading.value = false;
      updateView();
    } else {
      isLoading.value = true;
    }
  }
}
