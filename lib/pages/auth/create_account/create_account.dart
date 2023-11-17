import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/pages/auth/create_account/create_account_controller.dart';
import 'package:pfa_flutter/utils/app_constants.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/utils/utils.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';

class CreateAccount extends StatelessWidget {
  static const routeName = '/createAccount';

  const CreateAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateAccountController controller = Get.put(CreateAccountController());
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
                    AppStrings.createAccount,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Obx(() => AppWidgets.textField(
                      hint: AppStrings.nameHint,
                      controller: controller.nameTextFieldController.value,
                      errorText: AppStrings.nameWrong,
                      showError: controller.isNameError.value,
                    )),
                Obx(() => AppWidgets.textField(
                      hint: AppStrings.emailHint,
                      controller: controller.emailTextFieldController.value,
                      errorText: AppStrings.emailWrong,
                      showError: controller.isEmailError.value,
                    )),
                Obx(() => AppWidgets.textField(
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
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(text: AppStrings.byCreating),
                            TextSpan(
                              text: AppStrings.termsOfUse,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () => Utils.openUrl(AppConstants.URL_LEGAL),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppWidgets.textButton(
                        AppStrings.login,
                        onPressed: controller.login,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: AppWidgets.elevatedButton(
                          AppStrings.createAccount,
                          onPressed: () => controller.createAccount(context),
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
