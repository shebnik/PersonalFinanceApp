import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/pages/settings/settings_controller.dart';
import 'package:pfa_flutter/services/firebase/auth_service.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';
import 'package:pfa_flutter/widgets/info_row.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SettingsController());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        InfoRow(
          title: AppStrings.email,
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [Obx(() => Text(controller.userEmail.value))],
        ),
        const SizedBox(height: 24),
        Obx(() => AppWidgets.textField(
              hint: AppStrings.nameHint,
              controller: controller.nameTextFieldController.value,
              errorText: AppStrings.nameWrong,
              showError: controller.isNameError.value,
            )),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 110,
              child: AppWidgets.elevatedButton(
                AppStrings.save,
                onPressed: () => controller.saveName(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        InfoRow(
          title: AppStrings.mentor,
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            Obx(() => Text(controller.mentorEmail.value)),
            const SizedBox(height: 6),
            actionButton(
              AppStrings.update,
              onTap: controller.updateMentor,
            ),
          ],
        ),
        // const SizedBox(height: 30),
        // InfoRow(
        //   title: AppStrings.thresholdAlert,
        //   style: const TextStyle(fontWeight: FontWeight.bold),
        //   children: [
        //     Obx(() => Text(controller.thresholdAlert.value)),
        //     const SizedBox(height: 6),
        //     actionButton(
        //       AppStrings.update,
        //       onTap: controller.updateThresholdAlert,
        //     ),
        //   ],
        // ),
        const SizedBox(height: 30),
        InfoRow(
          title: AppStrings.plan,
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            Obx(() => Text(controller.subscribeStatus.value)),
            const SizedBox(height: 6),
            actionButton(
              controller.subscribeActionText(),
              onTap: controller.subscribeAction,
            ),
            // const SizedBox(height: 6),
            // Visibility(
            //   child: actionButton(
            //     AppStrings.restorePurchase,
            //     onTap: controller.restorePurchase,
            //   ),
            //   visible: controller.shouldShowRestoreButton(),
            // ),
          ],
        ),
        const SizedBox(height: 50),
        const Text(
          AppStrings.reccuringBilling,
          style: TextStyle(
            fontSize: 12,
            height: 2,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          AppStrings.everythingElse,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        actionButton(AppStrings.faqHelp, onTap: controller.faqHelpTap),
        const SizedBox(height: 10),
        actionButton(AppStrings.legal, onTap: controller.legalTap),
        const SizedBox(height: 10),
        actionButton(AppStrings.logOut, onTap: AuthService.logOut),
      ],
    );
  }

  Widget actionButton(
    String title, {
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
