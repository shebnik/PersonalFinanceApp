import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/dialogs/subscribe/subscribe_dialog.dart';
import 'package:pfa_flutter/models/teller_transaction.dart';
import 'package:pfa_flutter/services/firebase/auth_service.dart';
import 'package:pfa_flutter/services/firebase/firestore_service.dart';
import 'package:pfa_flutter/services/shared_preferences_service.dart';
import 'package:pfa_flutter/utils/logger.dart';
import 'package:pfa_flutter/models/user.dart';
import 'package:pfa_flutter/utils/payment/payment_services.dart';
import 'package:pfa_flutter/utils/utils.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';

class MainController extends GetxController {
  RxBool isLoadingObs = false.obs;
  bool get isLoading => isLoadingObs.value;
  set isLoading(bool value) => isLoadingObs.value = value;

  RxBool isOnlineObs = true.obs;
  bool get isOnline => isOnlineObs.value;
  set isOnline(bool value) => isOnlineObs.value = value;

  late StreamSubscription connectivityStream;
  List<StreamSubscription> streamSubscriptions = [];

  bool showingSubscribeDialog = false;

  void prepare() {
    if (kIsWeb == false) {
      FirebaseFirestore.instance.settings =
          const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
    }
    initStreams();
    initListeners();
    initIAP();
  }

  void initStreams() {
    AuthService.listenAuthState();
    SharedPreferencesService.initStreams();
    connectivityStream = Connectivity().onConnectivityChanged.listen((event) {
      isOnline = event != ConnectivityResult.none;
      Logger.i("Connectivity: ${isOnline ? "Online" : "Offline"}");
    });
    Connectivity().checkConnectivity().then((value) {
      isOnline = value != ConnectivityResult.none;
    });
  }

  void initIAP() {
    if (kIsWeb) return;
    PaymentService.instance.initConnection();
    PaymentService.instance.addToErrorListeners((errorString) {
      AppWidgets.openSnackbar(message: errorString);
    });
  }

  Future<void> initListeners() async {
    if (await AuthService.isSignedIn() == false) {
      Logger.i('[MainController] initListeners - user is not logged in. ignore listeners.');
      return;
    }
    final String uid = AuthService.getUserId();
    var userSnapshot = FirestorePath.userSnapshot(uid);
    streamSubscriptions.add(
      userSnapshot.listen(
        (DocumentSnapshot doc) async {
          Logger.i("User changed ${doc.id}");

          AppUser user = AppUser.fromJson(doc.data() as Map<String, dynamic>);
          await SharedPreferencesService.setUser(user);

          // firestoreDataChangeStreamController.sink
          //     .add(FirestoreDataChangeFlags.FLAG_USER_CHANGED);

          if (showingSubscribeDialog && !Utils.isInvalidUser(user)) {
            Get.back();
            showingSubscribeDialog = false;
          }
        },
      ),
    );
    var transactionSnapshot = FirestorePath.transactionsSnapshot(uid);
    streamSubscriptions.add(
      transactionSnapshot.listen((QuerySnapshot querySnapshot) {
        for (DocumentChange documentChange in querySnapshot.docChanges) {
          final DocumentSnapshot doc = documentChange.doc;
          Logger.i("Transaction changed ${doc.id}");

          var data = doc.data() as Map<String, dynamic>;
          final timestamp = data['date'] as Timestamp;
          var transactionsJson = data['transactions'] as List<dynamic>;

          List<TellerTransaction> transactions = transactionsJson
              .map((e) => TellerTransaction.fromJson(e as Map<String, dynamic>))
              .toList();

          Logger.i('Transaction count: ${transactions.length.toString()}');

          SharedPreferencesService.setTransactions(
            transactions,
            Utils.formatDate(Utils.dateFromTimestamp(timestamp)),
          );
        }
      }),
    );
  }

  void cancelFirestoreListeners() {
    streamSubscriptions.map((e) => e.cancel());
    streamSubscriptions.clear();
  }

  @override
  void onClose() {
    cancelFirestoreListeners();
    SharedPreferencesService.closeStreams();
    // firestoreDataChangeStreamController.close();
    connectivityStream.cancel();
    PaymentService.instance.dispose();
    super.onClose();
  }

  Future<bool> checkSubscription([AppUser? user]) async {
    if (Utils.isInvalidUser(user) && !showingSubscribeDialog) {
      showingSubscribeDialog = true;
      await Get.dialog(const SubscribeDialog(force: true));
      showingSubscribeDialog = false;
      return false;
    }
    return true;
  }
}
