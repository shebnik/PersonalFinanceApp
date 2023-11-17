import 'package:get/get.dart';
import 'package:pfa_flutter/dialogs/appoint_mentor/appoint_mentor_dialog.dart';
import 'package:pfa_flutter/dialogs/subscribe/subscribe_dialog.dart';
import 'package:pfa_flutter/main_controller.dart';
import 'package:pfa_flutter/models/mentor.dart';
import 'package:pfa_flutter/models/user.dart';
import 'package:pfa_flutter/services/firebase/auth_service.dart';
import 'package:pfa_flutter/services/firebase/firestore_service.dart';
import 'package:pfa_flutter/services/shared_preferences_service.dart';
import 'package:pfa_flutter/utils/logger.dart';
import 'package:pfa_flutter/utils/utils.dart';

class DashboardLoaderController extends GetxController {
  final MainController mainController = Get.find();
  late AppUser? user;
  late Mentor? mentor;
  // late Preferences? preferences;

  RxBool isInitialized = false.obs;

  late RxBool initialSettingsDialogShown;

  @override
  void onInit() {
    super.onInit();

    user = SharedPreferencesService.getUser();
    mentor = SharedPreferencesService.getMentor();
    // preferences = SharedPreferencesService.getPreferences();

    initialSettingsDialogShown = RxBool(mentor != null);
    //  && preferences != null;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await initialize();
  }

  Future<void> initialize() async {
    user = SharedPreferencesService.getUser();
    mentor = SharedPreferencesService.getMentor();
    initialSettingsDialogShown = RxBool(mentor != null);
    if (user == null) {
      await getUser();
    }

    if (Utils.isInvalidUser(user) && !mainController.showingSubscribeDialog) {
      mainController.showingSubscribeDialog = true;
      await Get.dialog(const SubscribeDialog(force: true));
      mainController.showingSubscribeDialog = false;
      return await initialize();
    }

    if (!initialSettingsDialogShown.value) {
      await showInitialSettingsDialog();
      return await initialize();
    }

    isInitialized.value = true;
  }

  Future<void> showInitialSettingsDialog() async {
    Logger.i('Showing dialog');
    if (mentor == null) {
      await Get.dialog(const AppointMentorDialog(force: true));
      updateState();
    }
    // else if (preferences == null) {
    //   await Get.dialog(const ThresholdAlertDialog(force: true));
    //   updateDialog();
    // }
  }

  void updateState() {
    mentor = SharedPreferencesService.getMentor();
    // preferences = SharedPreferencesService.getPreferences();
    initialSettingsDialogShown.value = mentor != null;
    //  && preferences != null;
  }

  Future<void> getUser() async {
    user = await FirestoreService(AuthService.getUserId()).getUser();
    if (user != null) {
      await SharedPreferencesService.setUser(user!);
    } else {
      await AuthService.logOut();
    }
  }
}
