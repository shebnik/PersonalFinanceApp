import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/dialogs/daily_budget/daily_budget_dialog_controller.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';
import 'package:pfa_flutter/widgets/info_row.dart';

class DailyBudgetDialog extends StatelessWidget {
  const DailyBudgetDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(DailyBudgetDialogController());
    return Dialog(
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
                AppStrings.dailyBudgetIs,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const IconInfoRow(
                icon: Icons.paid_outlined,
                text: AppStrings.enterAnEstimated,
                fontSize: 12,
              ),
              const SizedBox(height: 10),
              const IconInfoRow(
                icon: Icons.mark_email_read_outlined,
                text: AppStrings.changesWillBeSent,
                fontSize: 12,
              ),
              const SizedBox(height: 20),
              Obx(() => AppWidgets.textField(
                    isNumberType: true,
                    prefixIcon: const Icon(Icons.attach_money_outlined),
                    controller: controller.numberTextFieldController.value,
                    errorText: AppStrings.numberWrong,
                    showError: controller.isNumberError.value,
                  )),
              const SizedBox(height: 14),
              Container(
                margin: const EdgeInsets.only(top: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppWidgets.textButton(
                      AppStrings.later,
                      onPressed: controller.close,
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
    );
  }
}
