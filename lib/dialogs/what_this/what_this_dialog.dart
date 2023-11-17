import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';
import 'package:pfa_flutter/widgets/info_row.dart';

class WhatThisDialog extends StatelessWidget {
  const WhatThisDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                AppStrings.whatThis,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const IconInfoRow(
                icon: Icons.credit_card_outlined,
                text: AppStrings.spentMoney,
                fontWeight: FontWeight.bold,
                description: AppStrings.spentMoneyDescr,
                fontSize: 12,
              ),
              const SizedBox(height: 15),
              const IconInfoRow(
                icon: Icons.paid_outlined,
                text: AppStrings.unspentMoney,
                fontWeight: FontWeight.bold,
                description: AppStrings.unspentMoneyDescr,
                fontSize: 12,
              ),
              const SizedBox(height: 15),
              const IconInfoRow(
                icon: Icons.trending_up_outlined,
                text: AppStrings.futurePotential,
                fontWeight: FontWeight.bold,
                description: AppStrings.futurePotentialDescr,
                fontSize: 12,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 110,
                    child: AppWidgets.elevatedButton(
                      AppStrings.ok,
                      onPressed: () => Get.back(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
