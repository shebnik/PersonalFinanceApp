import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/pages/auth/create_account/create_account.dart';
import 'package:pfa_flutter/utils/app_assets.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';
import 'package:pfa_flutter/widgets/info_row.dart';

class Start extends StatelessWidget {
  const Start({Key? key}) : super(key: key);

  static const routeName = '/start';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(22),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Expanded(
                    child: startDescription(),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.expand(height: 50),
                    child: AppWidgets.elevatedButton(
                      AppStrings.startFreeTrial,
                      onPressed: () =>
                          Get.offAndToNamed(CreateAccount.routeName),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget startDescription() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(AppAssets.logo),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            AppStrings.appReportsYour,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 40),
          child: IconInfoRow(
            icon: Icons.check_circle_outline_rounded,
            text: AppStrings.learnFromYour,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: IconInfoRow(
            icon: Icons.check_circle_outline_rounded,
            text: AppStrings.gainFinancial,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: IconInfoRow(
            icon: Icons.check_circle_outline_rounded,
            text: AppStrings.visualizeHowMuch,
          ),
        ),
      ],
    );
  }
}
