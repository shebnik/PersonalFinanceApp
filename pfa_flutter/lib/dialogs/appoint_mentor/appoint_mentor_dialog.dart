import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/utils/app_theme.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';
import 'package:pfa_flutter/widgets/info_row.dart';

import 'appoint_mentor_dialog_controller.dart';

class AppointMentorDialog extends StatelessWidget {
  final bool force;
  const AppointMentorDialog({
    Key? key,
    required this.force,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppointMentorDialogController controller =
        Get.put(AppointMentorDialogController());
    return WillPopScope(
      onWillPop: () async => !force,
      child: Dialog(
        insetPadding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 2,
        backgroundColor: Colors.white,
        child: Container(
          padding:
              const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.appointMenor,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const IconInfoRow(
                  icon: Icons.people_outline_outlined,
                  text: AppStrings.trustedPerson,
                  fontSize: 12,
                ),
                const SizedBox(height: 10),
                const IconInfoRow(
                  icon: Icons.paid_outlined,
                  text: AppStrings.alreadyWinning,
                  fontSize: 12,
                ),
                const SizedBox(height: 10),
                const IconInfoRow(
                  icon: Icons.mark_email_read_outlined,
                  text: AppStrings.willReceiveEmail,
                  fontSize: 12,
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 14),
                ValueListenableBuilder(
                  valueListenable: controller.isChecked,
                  builder: (context, bool value, child) {
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppTheme.primary,
                      title: const Text(
                        AppStrings.iConfirmMyMentor,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                      value: value,
                      onChanged: controller.checkBoxChanged,
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: !force,
                        child: AppWidgets.textButton(
                          AppStrings.later,
                          onPressed: () => Get.back(),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 110,
                        child: AppWidgets.elevatedButton(
                          AppStrings.save,
                          onPressed: () => controller.save(context),
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
