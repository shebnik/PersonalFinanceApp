import 'dart:async';

import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:pfa_flutter/dialogs/appoint_mentor/appoint_mentor_dialog.dart';
import 'package:pfa_flutter/dialogs/subscribe/subscribe_dialog.dart';
import 'package:pfa_flutter/main_controller.dart';
import 'package:pfa_flutter/models/mentor.dart';
import 'package:pfa_flutter/models/payment/payment_info.dart';
import 'package:pfa_flutter/models/payment/stripe_info.dart';
import 'package:pfa_flutter/models/preferences.dart';
import 'package:pfa_flutter/models/user.dart';
import 'package:pfa_flutter/services/firebase/firestore_service.dart';
import 'package:pfa_flutter/services/shared_preferences_service.dart';
import 'package:pfa_flutter/utils/app_constants.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/utils/logger.dart';
import 'package:pfa_flutter/utils/utils.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';
import 'package:intl/intl.dart';

class SettingsController extends GetxController {
  late AppUser user;
  late Mentor mentor;
  late Preferences preferences;

  late RxString userEmail, mentorEmail, subscribeStatus;
  // late RxString thresholdAlert;

  final Rx<TextEditingController> nameTextFieldController =
      TextEditingController().obs;

  RxBool isNameError = false.obs;
  StreamSubscription? preferencesDataChange;

  final MainController mainController = Get.find();

  @override
  void onInit() {
    super.onInit();
    user = SharedPreferencesService.getUser()!;
    mentor = SharedPreferencesService.getMentor()!;
    preferences = SharedPreferencesService.getPreferences()!;

    userEmail = user.email.obs;
    mentorEmail = mentor.mentorEmail.obs;
    // thresholdAlert = Utils.formatAmount(preferences.thresholdAlert).obs;
    subscribeStatus = getSubscribeStatusText().obs;

    nameTextFieldController.value.text = user.name;

    initStream();
  }

  @override
  void onClose() {
    nameTextFieldController.value.dispose();
    preferencesDataChange?.cancel();
    super.onClose();
  }

  Future<void> saveName(BuildContext context) async {
    String name = nameTextFieldController.value.text.trim();
    if (name == user.name) {
      FocusScope.of(context).unfocus();
      return;
    }
    if (!validate(name)) return;
    FocusScope.of(context).unfocus();

    if (!mainController.isOnline) {
      AppWidgets.openSnackbar(message: 'Please check internet connection.');
      return;
    }

    mainController.isLoading = true;
    if (await FirestoreService(user.userId)
        .updateUser(FirestorePath.userName, name)) {
    } else {
      AppWidgets.openSnackbar(message: 'Please check internet connection.');
    }
    mainController.isLoading = false;
  }

  void initStream() {
    if (preferencesDataChange != null) {
      preferencesDataChange!.cancel();
    }
    preferencesDataChange =
        SharedPreferencesService.sharedPreferencesChangeStream.listen((event) {
      Logger.i(event);
      if (event == DataChangeFlags.USER_CHANGED) {
        user = SharedPreferencesService.getUser()!;
        userEmail.value = user.email;
        subscribeStatus.value = getSubscribeStatusText();
      }
      if (event == DataChangeFlags.MENTOR_CHANGED) {
        mentor = SharedPreferencesService.getMentor()!;
        mentorEmail.value = mentor.mentorEmail;
      }
      // if (event == DataChangeFlags.USER_PREFERENCE_CHANGED) {
      //   preferences = SharedPreferencesService.getPreferences()!;
      //   thresholdAlert.value = Utils.formatAmount(preferences.thresholdAlert);
      // }
    });
  }

  bool validate(String name) {
    if (name.isEmpty) {
      isNameError.value = true;
      return false;
    } else {
      isNameError.value = false;
    }
    return true;
  }

  void updateMentor() {
    Get.dialog(const AppointMentorDialog(force: false));
  }

  // void updateThresholdAlert() {
  //   Get.dialog(const ThresholdAlertDialog(force: false));
  // }

  void faqHelpTap() {
    Utils.openUrl(AppConstants.URL_FAQ);
  }

  void legalTap() {
    Utils.openUrl(AppConstants.URL_LEGAL);
  }

  void subscribeAction() {
    var subscribed = StripeInfo.STATE_ACTIVE == user.stripeInfo.status;
    return subscribed ? manage() : subscribe();
  }

  String getSubscribeStatusText() {
    var subscribed = StripeInfo.STATE_ACTIVE == user.stripeInfo.status;
    return subscribed ? getPlanText() : getFreeTrialText();
  }

  String getFreeTrialText() {
    DateTime dateTime = user.trialEndDate;
    return '${AppStrings.freeTrialExpires} ${DateFormat("dd MMM yyyy", "en-US").format(dateTime)}';
  }

  String getPlanText() {
    String? subscriptionId = user.inAppPaymentInfo.subscriptionId;
    String planName = "";
    if (AppConstants.MONTHLY_ID == subscriptionId) {
      planName = AppConstants.MONTHLY_NAME;
    } else if (AppConstants.YEARLY_ID == subscriptionId) {
      planName = AppConstants.YEARLY_NAME;
    }
    return planName;
  }

  Future<void> restorePurchase() async {
    Logger.i("restore purchase");
    // await PaymentService.instance.restoreProduct();
  }

  String subscribeActionText() {
    var subscribed = StripeInfo.STATE_ACTIVE == user.stripeInfo.status;
    return subscribed ? "Manage" : "Subscribe";
  }

  void manage() {
    String? gateway = user.inAppPaymentInfo.gateway;
    String? subscriptionId = user.inAppPaymentInfo.subscriptionId;
    if (gateway != null && subscriptionId != null) {
      if (gateway == InAppPaymentInfo.GATEWAY_GOOGLE) {
        String url = "https://play.google.com/store/account/subscriptions"
            "?sku=$subscriptionId&package=${AppConstants.ANDROID_PACKAGE_NAME}";
        Utils.openUrl(url);
      } else if (gateway == InAppPaymentInfo.GATEWAY_APPLE) {
        String url = "https://apps.apple.com/account/subscriptions";
        Utils.openUrl(url);
      }
    }
  }

  void subscribe() async {
    Get.dialog(
      const SubscribeDialog(
        force: false,
      ),
    );
  }

  bool shouldShowRestoreButton() {
    var subscribed = StripeInfo.STATE_ACTIVE == user.stripeInfo.status;
    return !subscribed;
  }
}
