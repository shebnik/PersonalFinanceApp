import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/pages/auth/login/login_controller.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';

class Login extends StatelessWidget {
  static const routeName = '/login';

  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(22),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppWidgets.logo,
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppStrings.login,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Obx(() => AppWidgets.textField(
                      focusNode: controller.emailFocusNode,
                      hint: AppStrings.emailHint,
                      controller: controller.emailTextFieldController.value,
                      errorText: AppStrings.emailWrong,
                      showError: controller.isEmailError.value,
                    )),
                Obx(() => AppWidgets.textField(
                      focusNode: controller.passwordFocusNode,
                      hint: AppStrings.passwordHint,
                      controller: controller.passwordTextFieldController.value,
                      isPasswordType: true,
                      errorText: AppStrings.passwordShort,
                      showError: controller.isPasswordError.value,
                    )),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 26),
                    child: GestureDetector(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(text: AppStrings.forgotPassword),
                            TextSpan(
                              text: AppStrings.resetPassword,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: controller.resetPassword,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppWidgets.textButton(
                        AppStrings.createAccount,
                        onPressed: controller.createAccount,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: AppWidgets.elevatedButton(
                          AppStrings.login,
                          onPressed: () => controller.login(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
