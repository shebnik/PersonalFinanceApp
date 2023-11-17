import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/pages/reports/reports_page_controller.dart';
import 'package:pfa_flutter/services/transaction_service.dart';
import 'package:pfa_flutter/utils/app_assets.dart';
import 'package:pfa_flutter/utils/app_theme.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/utils/utils.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';
import 'package:pfa_flutter/widgets/info_row.dart';

class ReportsPage extends StatefulWidget {
  static const routeName = '/reports';
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  late ReportsPageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ReportsPageController());

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      controller.datePickerController.jumpToSelection();
      controller.updateView();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        datePickerWidget(),
        const SizedBox(height: 25),
        reportsColumn()
      ],
    );
  }

  Widget reportsColumn() {
    return Obx(() {
      if (controller.isLoading.value) return AppWidgets.loading;
      return Column(
        children: [
          overspentWidget(),
          const SizedBox(height: 30),
          spentInfo(
            AppStrings.dailyBudgetIs,
            controller.dailyBudget,
          ),
          const SizedBox(height: 10),
          spentInfo(
            AppStrings.totalSpentIs,
            controller.totalSpent,
          ),
          const SizedBox(height: 10),
          spentInfo(
            AppStrings.overspentIs,
            controller.overspent,
          ),
          const SizedBox(height: 30),
          topCategoriesList(),
          const SizedBox(height: 30),
          allTransactionsList(),
          const SizedBox(height: 35),
        ],
      );
    });
  }

  Widget datePickerWidget() {
    return Obx(
      () => AbsorbPointer(
        absorbing: controller.isLoading.value,
        child: DatePicker(
          controller.startDate.value,
          initialSelectedDate: controller.selectedDate.value,
          width: 80,
          height: 95,
          daysCount: 8,
          controller: controller.datePickerController,
          selectionColor: AppTheme.primaryGreen,
          selectedTextColor: Colors.black,
          monthTextStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          dateTextStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          dayTextStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          onDateChange: controller.performChangeDate,
        ),
      ),
    );
  }

  Widget overspentWidget() {
    return Obx(() {
      if (controller.overspent.value <= 0) return const SizedBox.shrink();
      return LayoutBuilder(
        builder: (context, constraints) {
          var size = constraints.maxWidth / 3;
          return Column(
            children: [
              Image(
                image: const AssetImage(AppAssets.logo),
                width: size,
                height: size,
              ),
              const SizedBox(height: 10),
              const Text(
                AppStrings.overspent,
                style: TextStyle(
                  color: AppTheme.red,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      );
    });
  }

  Widget spentInfo(String title, RxDouble amount) {
    return InfoRow(
      title: title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      children: [
        Obx(
          () => Text(
            Utils.formatAmount(amount.value),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget topCategoriesList() {
    return Obx(() {
      if (controller.topCategories.isEmpty) return const SizedBox.shrink();
      return Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppStrings.topCategories,
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.topCategories.length,
              reverse: true,
              separatorBuilder: (context, index) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                ReportInfo reportInfo = controller.topCategories[index];
                return InfoRow(
                  title: reportInfo.name,
                  children: [
                    Text(Utils.formatAmount(reportInfo.amount)),
                  ],
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget allTransactionsList() {
    return Obx(() {
      if (controller.allTransactions.isEmpty) return const SizedBox.shrink();
      return Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppStrings.allTransactions,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.allTransactions.length,
              reverse: true,
              separatorBuilder: (context, index) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                ReportInfo reportInfo = controller.allTransactions[index];
                return InfoRow(
                  title: reportInfo.name,
                  children: [
                    Text(Utils.formatAmount(reportInfo.amount)),
                  ],
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
