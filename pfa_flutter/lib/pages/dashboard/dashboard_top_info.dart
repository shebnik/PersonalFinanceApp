import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/dialogs/daily_budget/daily_budget_dialog.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/utils/utils.dart';

class DashboardTopInfo extends StatefulWidget {
  final String pageTitle;

  const DashboardTopInfo({
    Key? key,
    required this.pageTitle,
  }) : super(key: key);

  @override
  State<DashboardTopInfo> createState() => _DashboardTopInfoState();
}

class _DashboardTopInfoState extends State<DashboardTopInfo> {

  void showDalyBudgetDialog() async {
    await Get.dialog(
      const DailyBudgetDialog(),
      barrierDismissible: false,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.pageTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    const TextSpan(text: AppStrings.dailyBudgetIs),
                    TextSpan(
                      text: Utils.formatAmount(Utils.dailyBudget),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
              ),
              onTap: showDalyBudgetDialog,
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          AppStrings.alwaysSpendLess,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
