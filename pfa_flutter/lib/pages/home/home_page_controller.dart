import 'dart:async';

import 'package:get/get.dart';
import 'package:pfa_flutter/main_controller.dart';
import 'package:pfa_flutter/models/preferences.dart';
import 'package:pfa_flutter/models/user.dart';
import 'package:pfa_flutter/services/compound_interest_calculator.dart';
import 'package:pfa_flutter/services/shared_preferences_service.dart';
import 'package:pfa_flutter/services/transaction_service.dart';
import 'package:pfa_flutter/utils/app_constants.dart';
import 'package:pfa_flutter/utils/logger.dart';

class HomePageController extends GetxController {
  final MainController mainController = Get.find();
  late AppUser user;
  late Preferences preferences;

  StreamSubscription? preferencesDataChange;

  RxInt selectedChipIndex = 0.obs;
  RxBool isLoading = true.obs;

  RxDouble spentMoney = 0.0.obs;
  RxDouble unspentMoney = 0.0.obs;
  RxDouble futurePotential = 0.0.obs;

  @override
  void onInit() {
    super.onInit();

    user = SharedPreferencesService.getUser()!;
    preferences = SharedPreferencesService.getPreferences()!;

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
        user = SharedPreferencesService.getUser()!;
        // event = UserLinksAccount ? fetchTrans
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

  void updateView() {
    int days = getDaysBySelectedChip();
    var transactions = TransactionService.getTransactions(days);

    spentMoney.value = TransactionService.calculateSpentMoney(transactions);
    unspentMoney.value = preferences.dailyBudget * days - spentMoney.value;
    futurePotential.value =
        CompoundInterestCalculator.calculate(unspentMoney.value);

    isLoading.value = false;
  }

  Future<void> chipSelected(int index) async {
    if (selectedChipIndex.value == index || isLoading.value) return;
    isLoading.value = true;
    selectedChipIndex.value = index;
    updateView();
  }

  int getDaysBySelectedChip() {
    switch (selectedChipIndex.value) {
      case 0:
        // 1d
        return 1;
      case 1:
        // 7d
        return 7;
      case 2:
        // 30d
        return 30;
      default:
        return -1;
    }
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
