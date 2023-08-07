import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/dialogs/subscribe/subscribe_dialog_controller.dart';
import 'package:pfa_flutter/utils/app_assets.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/utils/radio_group.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';

class SubscribeDialog extends StatelessWidget {
  final bool force;

  const SubscribeDialog({
    required this.force,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SubscribeDialogController controller = Get.put(SubscribeDialogController());
    controller.force = force;
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
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  force ? AppStrings.freeTrialExpired : AppStrings.subscribe,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  AppStrings.subscribeDialogDescr,
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 25),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    var imageSize = constraints.maxWidth / 4 - 10;
                    return Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: constraints.maxWidth / 4,
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemCount: 4,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Image(
                              image: const AssetImage(AppAssets.logo),
                              height: imageSize,
                              width: imageSize,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                const Text(
                  AppStrings.selectPlan,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                RadioGroup(
                  items: const [AppStrings.planMonthly, AppStrings.planYearly],
                  selected: controller.selectedType.value,
                  groupId: 1,
                  isDisabled: false,
                  onSelected: (index) {
                    controller.selectedType.value = index;
                  },
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      child: AppWidgets.textButton(
                        AppStrings.maybeLater,
                        onPressed: () => Get.back(),
                      ),
                      visible: !force,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: AppWidgets.elevatedButton(
                        AppStrings.subscribe,
                        onPressed: () => controller.subscribe(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  AppStrings.reccuringBilling,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
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
