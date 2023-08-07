import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:get/state_manager.dart';
import 'package:pfa_flutter/main_controller.dart';
import 'package:pfa_flutter/pages/auth/create_account/create_account.dart';
import 'package:pfa_flutter/services/firebase/auth_service.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/utils/logger.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';

class ResetPasswordController extends GetxController {
  final Rx<TextEditingController> emailTextFieldController =
      TextEditingController().obs;
  final MainController mainController = Get.find();
  RxBool isEmailError = false.obs;
  @override
  void onClose() {
    emailTextFieldController.value.dispose();
    super.onClose();
  }

  void login() => Get.back();

  void createAccount() =>
      Get.until((route) => Get.currentRoute == CreateAccount.routeName);

  void resetPassword(context) {
    String email = emailTextFieldController.value.text.trim().toLowerCase();
    if (validate(email)) {
      FocusScope.of(context).unfocus();
      AuthService.resetPassword(email)
          .then(
              (value) => AppWidgets.openSnackbar(message: AppStrings.sentAnEmail))
          .catchError((e) {
        Logger.i(e);
        AppWidgets.openSnackbar(message: e.message);
      });
    }
  }

  bool validate(String email) {
    if (!GetUtils.isEmail(email)) {
      isEmailError.value = true;
      return false;
    } else {
      isEmailError.value = false;
    }
    return true;
  }
}
