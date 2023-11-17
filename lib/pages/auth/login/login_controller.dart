import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/main_controller.dart';
import 'package:pfa_flutter/pages/auth/reset_password/reset_password.dart';
import 'package:pfa_flutter/pages/dashboard_loader/dashboard_loader.dart';
import 'package:pfa_flutter/services/firebase/auth_service.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';

class LoginController extends GetxController {
  final Rx<TextEditingController> emailTextFieldController =
      TextEditingController().obs;
  final Rx<TextEditingController> passwordTextFieldController =
      TextEditingController().obs;
  final MainController mainController = Get.find();
  RxBool isEmailError = false.obs;
  RxBool isPasswordError = false.obs;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void onClose() {
    emailTextFieldController.value.dispose();
    passwordTextFieldController.value.dispose();
    super.onClose();
  }

  void createAccount() => Get.back();

  void resetPassword() => Get.toNamed(ResetPassword.routeName);

  void login(context) async {
    String email = emailTextFieldController.value.text.trim().toLowerCase();
    String password = passwordTextFieldController.value.text;

    if (!validate(email, password)) return;
    FocusScope.of(context).unfocus();
    if (!mainController.isOnline) {
      AppWidgets.openSnackbar(message: "Please check internet connection.");
      return;
    }

    mainController.isLoading = true;
    if (await AuthService.login(email, password)) {
      mainController.isLoading = false;
      mainController.initListeners();
      Get.offAllNamed(DashboardLoader.routeName,
          predicate: (Route<dynamic> route) => false);
    } else {
      mainController.isLoading = false;
      if (FirebaseAuth.instance.currentUser != null) {
        FirebaseAuth.instance.signOut();
      }
    }
  }

  bool validate(String email, String password) {
    if (!GetUtils.isEmail(email)) {
      isEmailError.value = true;
      return false;
    } else {
      isEmailError.value = false;
    }
    if (password.length < 6) {
      isPasswordError.value = true;
      return false;
    } else {
      isPasswordError.value = false;
    }
    return true;
  }
}
