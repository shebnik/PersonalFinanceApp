import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/dialogs/what_this/what_this_dialog.dart';
import 'package:pfa_flutter/pages/home/home_page_controller.dart';
import 'package:pfa_flutter/utils/app_theme.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/utils/logger.dart';
import 'package:pfa_flutter/utils/utils.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';

class HomePage extends StatefulWidget {

  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(HomePageController());
    Logger.i('_HomePageState initState');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            children: [
              selectionChip(0, '1d'),
              selectionChip(1, '7d'),
              selectionChip(2, '30d'),
            ],
          ),
        ),
        const SizedBox(height: 30),
        homeInformation(),
      ],
    );
  }

  Widget selectionChip(int index, String label) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ChoiceChip(
          selectedColor: AppTheme.primaryGreen,
          selected: controller.selectedChipIndex.value == index,
          onSelected: (value) => controller.chipSelected(index),
          label: SizedBox(
            width: 70,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget homeInformation() {
    return Obx(() {
      if (controller.isLoading.value) return AppWidgets.loading;
      return Column(
        children: [
          homeInfoRow(
            controller.spentMoney.value,
            AppStrings.spentMoney,
            Icons.credit_card_outlined,
          ),
          const SizedBox(height: 30),
          homeInfoRow(
            controller.unspentMoney.value,
            AppStrings.unspentMoney,
            Icons.paid_outlined,
          ),
          const SizedBox(height: 30),
          homeInfoRow(
            controller.futurePotential.value,
            AppStrings.futurePotential,
            Icons.trending_up_outlined,
          ),
        ],
      );
    });
  }
  
  Widget homeInfoRow(double ammount, String label, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.formatAmount(ammount),
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  helpIcon(),
                  const SizedBox(width: 5),
                  Expanded(child: Text(label)),
                ],
              ),
            ],
          ),
        ),
        Icon(
          icon,
          color: AppTheme.primaryGreen,
          size: 55,
        ),
      ],
    );
  }

  Widget helpIcon() {
    return InkWell(
      child: const Icon(
        Icons.help_outline,
        color: AppTheme.primaryGreen,
      ),
      onTap: () => Get.dialog(const WhatThisDialog()),
    );
  }
}
