import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/pages/auth/reset_password/reset_password_controller.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';

class ResetPassword extends StatelessWidget {
  static const routeName = '/resetpassword';
  const ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResetPasswordController controller = Get.put(ResetPasswordController());
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
                    AppStrings.resetPassword,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Obx(() => AppWidgets.textField(
                      hint: AppStrings.emailHint,
                      controller: controller.emailTextFieldController.value,
                      errorText: AppStrings.emailWrong,
                      showError: controller.isEmailError.value,
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
                            const TextSpan(text: AppStrings.muscleMemory),
                            TextSpan(
                              text: AppStrings.login,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: controller.login,
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
                          AppStrings.resetPassword,
                          onPressed: () => controller.resetPassword(context),
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
