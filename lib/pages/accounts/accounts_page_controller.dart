import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:pfa_flutter/dialogs/already_linked/already_linked_account_dialog.dart';
import 'package:pfa_flutter/main_controller.dart';
import 'package:pfa_flutter/models/linked_account.dart';
import 'package:pfa_flutter/models/preferences.dart';
import 'package:pfa_flutter/models/user.dart';
import 'package:pfa_flutter/services/firebase/cloud_functions.dart';
import 'package:pfa_flutter/services/firebase/firestore_service.dart';
import 'package:pfa_flutter/services/shared_preferences_service.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/utils/logger.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';
import 'package:universal_html/html.dart' as html;

import 'link_account_webview.dart';

class AccountsPageController extends GetxController {
  final isLoading = ValueNotifier<bool>(false);
  final accountList = ValueNotifier<List<LinkedAccount>>([]);

  StreamSubscription? htmlMessageStream;

  late AppUser user;
  late Preferences preferences;
  late CloudFunctions _cloudFunctions;
  late FirestoreService _firestoreService;

  @override
  void onInit() {
    super.onInit();
    user = SharedPreferencesService.getUser()!;
    preferences = SharedPreferencesService.getPreferences()!;
    _cloudFunctions = CloudFunctions(user.userId);
    _firestoreService = FirestoreService(user.userId);

    if (user.linkedAccounts.isNotEmpty) {
      accountList.value = user.linkedAccounts;
    }
  }

  @override
  void onClose() {
    super.onClose();
    htmlMessageStream?.cancel();
  }

  Future<void> openLinkClick() async {
    if (await Get.find<MainController>().checkSubscription() == false) return;
    if (accountList.value.isNotEmpty) {
      Get.dialog(const AlreadyLinkedAccountDialog());
      return;
    }
    if (kIsWeb) {
      initWebTellerConnect();
      return;
    }
    isLoading.value = true;
    showLinkAccountWebView();
  }

  void initWebTellerConnect() {
    final data = {'msg': 'tellerConnectOpen'};
    final json = const JsonEncoder().convert(data);
    html.window.postMessage(json, "*");

    if (htmlMessageStream != null) return;

    htmlMessageStream = html.window.onMessage.listen((event) {
      var data = jsonDecode(event.data);
      if (data['msg'] == null) return;

      var msg = data['msg'].toString();
      Logger.i('html message: $msg');

      switch (msg) {
        case 'tellerOnInit':
          return tellerOnInit([]);
        case 'tellerOnSuccess':
          tellerOnSuccess([data['enrollment']]);
          return;
        case 'tellerOnExit':
          return tellerOnExit([]);
        case 'tellerOnFailure':
          return tellerOnFailure([data['error']]);
      }
    });
  }

  void tellerOnInit(List<dynamic> _) {
    Logger.i("[onInit] Teller Connect has initialized");
    isLoading.value = false;
  }

  Future<void> tellerOnSuccess(List<dynamic> args) async {
    hideLinkAccountWebView();
    isLoading.value = true;
    Map<String, dynamic> response = args[0];

    final accessToken = response['accessToken'];
    final userId = response['user']['id'];

    var accountsJson = await _cloudFunctions.getAccounts(accessToken);
    if (accountsJson == null) {
      Logger.i('[onSuccess] Accounts is null');
      return;
    }

    final List jsonMap = json.decode(accountsJson);
    final List<LinkedAccount> linkedAccounts = jsonMap.map((item) {
      var linkedAccount = LinkedAccount.fromJson(item);
      linkedAccount.accessToken = accessToken;
      linkedAccount.userId = userId;
      return linkedAccount;
    }).toList();

    final result = await _firestoreService.addLinkedAccount(linkedAccounts);
    if (result == false) {
      Logger.i('[onSuccess] Link account firestore write failed');
      isLoading.value = false;
      return;
    }
    accountList.value = [...accountList.value, ...linkedAccounts];

    AppUser user = SharedPreferencesService.getUser()!;
    user.linkedAccounts = [...user.linkedAccounts, ...linkedAccounts];
    SharedPreferencesService.setUser(user);

    Logger.i("[onSuccess] User enrolled successfully");

    isLoading.value = false;
  }

  void tellerOnExit(List<dynamic> _) {
    Logger.i("[onExit] User closed Teller Connect");
    hideLinkAccountWebView();
    isLoading.value = false;
  }

  void tellerOnFailure(List<dynamic> args) {
    var e = args[0];
    Logger.i("[onFailure] $e");
    hideLinkAccountWebView();
    isLoading.value = false;
    AppWidgets.openSnackbar(message: AppStrings.error);
  }

  Future<void> onUnlink(LinkedAccount account) async {
    isLoading.value = true;

    var result = await _cloudFunctions.removeAccount(account);
    if (!result) return showError();

    result = await _firestoreService.removeAccount(account);
    if (!result) return showError();

    accountList.value = List.from(accountList.value)..remove(account);

    AppWidgets.openSnackbar(message: 'Unlinked');
    isLoading.value = false;
  }

  void showError() {
    AppWidgets.openSnackbar(message: AppStrings.error);
    isLoading.value = false;
  }

  void showLinkAccountWebView() {
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) => Get.dialog(
        LinkAccountWebView(
          onInit: tellerOnInit,
          onSuccess: tellerOnSuccess,
          onExit: tellerOnExit,
          onFailure: tellerOnFailure,
        ),
        barrierDismissible: false,
        barrierColor: Colors.transparent,
      ),
    );
  }

  void hideLinkAccountWebView() {
    if (!kIsWeb) Get.back();
  }
}
