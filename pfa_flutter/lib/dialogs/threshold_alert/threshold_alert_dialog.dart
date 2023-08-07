// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pfa_flutter/dialogs/threshold_alert/threshold_alert_dialog_controller.dart';
// import 'package:pfa_flutter/utils/app_strings.dart';
// import 'package:pfa_flutter/utils/widgets.dart';

// class ThresholdAlertDialog extends StatelessWidget {
//   final bool force;
//   const ThresholdAlertDialog({
//     Key? key,
//     required this.force,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     ThresholdAlertDialogController controller =
//         Get.put(ThresholdAlertDialogController());
//     return WillPopScope(
//       onWillPop: () async => !force,
//       child: Dialog(
//         insetPadding: const EdgeInsets.only(top: 20, left: 15, right: 15),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//         elevation: 2,
//         backgroundColor: Colors.white,
//         child: Container(
//           padding:
//               const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   AppStrings.thresholdAlert,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 15),
//                 const IconInfoRow(
//                   icon: Icons.warning_amber,
//                   text: AppStrings.yourMentorIsAlerted,
//                   fontSize: 12,
//                 ),
//                 const SizedBox(height: 20),
//                 Obx(() => Widgets.textField(
//                       isNumberType: true,
//                       prefixIcon: const Icon(Icons.attach_money),
//                       controller: controller.numberTextFieldController.value,
//                       errorText: AppStrings.numberWrong,
//                       showError: controller.isNumberError.value,
//                     )),
//                 const SizedBox(height: 14),
//                 Container(
//                   margin: const EdgeInsets.only(top: 24),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Visibility(
//                         visible: !force,
//                         child: Widgets.textButton(
//                           AppStrings.later,
//                           onPressed: () => Get.back(),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       SizedBox(
//                         width: 110,
//                         child: Widgets.elevatedButton(
//                           AppStrings.save,
//                           onPressed: () => controller.save(context),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
