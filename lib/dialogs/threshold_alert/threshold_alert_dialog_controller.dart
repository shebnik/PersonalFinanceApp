// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pfa_flutter/main_controller.dart';
// import 'package:pfa_flutter/services/firebase/firestore_service.dart';
// import 'package:pfa_flutter/services/shared_preferences_service.dart';
// import 'package:pfa_flutter/utils/app_strings.dart';
// import 'package:pfa_flutter/utils/widgets.dart';

// class ThresholdAlertDialogController {
//   final Rx<TextEditingController> numberTextFieldController =
//       TextEditingController().obs;

//   final MainController mainController = Get.find();
//   RxBool isNumberError = false.obs;

//   void save(context) async {
//     String thresholdAlert = numberTextFieldController.value.text;

//     if (!validate(thresholdAlert)) return;

//     double? thresholdAlertNum = double.tryParse(thresholdAlert);
//     if (thresholdAlertNum == null) {
//       Widgets.openSnackbar(message: AppStrings.numberWrong);
//       return;
//     }

//     if (!mainController.isOnline) {
//       Widgets.openSnackbar(message: 'Please check internet connection.');
//       return;
//     }

//     FocusScope.of(context).unfocus();
//     mainController.isLoading = true;
//     if (await FirestoreService(SharedPreferencesService.getUser()!.userId)
//         .setPreferences(thresholdAlertNum)) {
//       Get.back();
//     } else {
//       Widgets.openSnackbar(message: AppStrings.numberWrong);
//     }
//     mainController.isLoading = false;
//   }

//   bool validate(String number) {
//     if (!GetUtils.isNum(number)) {
//       isNumberError.value = true;
//       return false;
//     } else {
//       isNumberError.value = false;
//     }
//     return true;
//   }
// }
