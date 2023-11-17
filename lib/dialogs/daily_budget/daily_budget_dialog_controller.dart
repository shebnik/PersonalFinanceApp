import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/main_controller.dart';
import 'package:pfa_flutter/services/firebase/firestore_service.dart';
import 'package:pfa_flutter/services/shared_preferences_service.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';

class DailyBudgetDialogController {
  final Rx<TextEditingController> numberTextFieldController =
      TextEditingController().obs;

  final MainController mainController = Get.find();
  RxBool isNumberError = false.obs;

  void close() => Get.back();

  void save(context) async {
    String number = numberTextFieldController.value.text;

    if (!validate(number)) return;
    FocusScope.of(context).unfocus();

    if (!mainController.isOnline) {
      AppWidgets.openSnackbar(message: 'Please check internet connection.');
      return;
    }

    mainController.isLoading = true;
    double? usd = double.tryParse(number);
    if (usd == null) {
      mainController.isLoading = false;
      AppWidgets.openSnackbar(message: AppStrings.numberWrong);
      return;
    }

    if (await FirestoreService(SharedPreferencesService.getUser()!.userId)
        .updateDailyBudget(usd)) {
      mainController.isLoading = false;
      Get.back();
    } else {
      mainController.isLoading = false;
      AppWidgets.openSnackbar(message: AppStrings.numberWrong);
    }
  }

  bool validate(String number) {
    if (!GetUtils.isNum(number)) {
      isNumberError.value = true;
      return false;
    } else {
      isNumberError.value = false;
    }
    return true;
  }
}
