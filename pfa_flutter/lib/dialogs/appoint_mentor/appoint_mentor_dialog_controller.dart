import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/main_controller.dart';
import 'package:pfa_flutter/services/firebase/firestore_service.dart';
import 'package:pfa_flutter/services/shared_preferences_service.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';

class AppointMentorDialogController extends GetxController {
  final Rx<TextEditingController> nameTextFieldController =
      TextEditingController().obs;
  final Rx<TextEditingController> emailTextFieldController =
      TextEditingController().obs;

  final MainController mainController = Get.find();
  RxBool isNameError = false.obs;
  RxBool isEmailError = false.obs;
  var isChecked = ValueNotifier(false);

  void checkBoxChanged(bool? value) => isChecked.value = value!;

  void save(context) async {
    String name = nameTextFieldController.value.text.trim();
    String email = emailTextFieldController.value.text.trim().toLowerCase();

    if (!validate(name, email)) return;
    FocusScope.of(context).unfocus();

    if (!isChecked.value) {
      AppWidgets.openSnackbar(message: 'Please confirm the point above');
      return;
    }

    if (!mainController.isOnline) {
      AppWidgets.openSnackbar(message: 'Please check internet connection.');
      return;
    }

    mainController.isLoading = true;
    if (await FirestoreService(SharedPreferencesService.getUser()!.userId)
        .setMentor(name, email)) {
      Get.back();
    } else {
      AppWidgets.openSnackbar(message: 'Please check internet connection.');
    }
    mainController.isLoading = false;
  }

  bool validate(String name, String email) {
    if (name.isEmpty) {
      isNameError.value = true;
      return false;
    } else {
      isNameError.value = false;
    }
    if (!GetUtils.isEmail(email)) {
      isEmailError.value = true;
      return false;
    } else {
      isEmailError.value = false;
    }
    return true;
  }
}
