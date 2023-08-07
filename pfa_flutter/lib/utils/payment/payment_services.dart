import 'dart:async';
import 'dart:convert';

import 'package:pfa_flutter/models/payment/stripe_info.dart';
import 'package:pfa_flutter/services/firebase/auth_service.dart';
import 'package:pfa_flutter/services/firebase/firestore_service.dart';
import 'package:pfa_flutter/utils/app_constants.dart';
import 'package:pfa_flutter/models/payment/google_payment.dart';
import 'package:pfa_flutter/utils/logger.dart';
import 'package:pfa_flutter/utils/payment/apple_payment_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';

class PaymentService {
  PaymentService._internal();

  static final PaymentService instance = PaymentService._internal();

  /// To listen the status of connection between app and the billing server
  StreamSubscription<ConnectionResult>? _connectionSubscription;

  /// To listen the status of the purchase made inside or outside of the app (App Store / Play Store)
  ///
  /// If status is not error then app will be notied by this stream
  StreamSubscription<PurchasedItem>? _purchaseUpdatedSubscription;

  /// To listen the errors of the purchase
  StreamSubscription<PurchaseResult>? _purchaseErrorSubscription;

  /// List of product ids you want to fetch
  final List<String> _productIds = AppConstants.iapIds;

  /// All available products will be store in this list
  List<IAPItem>? _products;

  /// All past purchases will be store in this list
  List<PurchasedItem>? _pastPurchases;

  /// Connected to store
  bool isConnected = true;

  /// view of the app will subscribe to this to get errors of the purchase
  final ObserverList<Function(String)> _errorListeners =
      ObserverList<Function(String)>();

  /// view can subscribe to _errorListeners using this method
  addToErrorListeners(Function(String) callback) {
    _errorListeners.add(callback);
  }

  /// view can cancel to _errorListeners using this method
  removeFromErrorListeners(Function(String) callback) {
    _errorListeners.remove(callback);
  }

  /// Call this method at the startup of you app to initialize connection
  /// with billing server and get all the necessary data
  void initConnection() async {
    await FlutterInappPurchase.instance.initialize();
    _connectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      isConnected = connected.connected ?? false;
    });

    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated
        .listen(_handlePurchaseUpdate) as StreamSubscription<PurchasedItem>?;

    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError
        .listen(_handlePurchaseError) as StreamSubscription<PurchaseResult>?;

    _getItems();

    _processNonCompletedTransactions();

    // _getPastPurchases();
  }

  /// call when user close the app
  void dispose() {
    _connectionSubscription?.cancel();
    _purchaseErrorSubscription?.cancel();
    _purchaseUpdatedSubscription?.cancel();
    FlutterInappPurchase.instance.finalize();
  }

  void _handlePurchaseError(PurchaseResult? purchaseError) {
    if (purchaseError != null) {
      _callErrorListeners(purchaseError.message);
    }
  }

  /// Called when new updates arrives at ``purchaseUpdated`` stream
  void _handlePurchaseUpdate(PurchasedItem? productItem) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _handlePurchaseUpdateAndroid(productItem);
    } else {
      await _handlePurchaseUpdateIOS(productItem);
    }
  }

  Future<void> _handlePurchaseUpdateIOS(PurchasedItem? purchasedItem) async {
    if (purchasedItem == null) return;
    switch (purchasedItem.transactionStateIOS) {
      case TransactionState.deferred:
        // Edit: This was a bug that was pointed out here : https://github.com/dooboolab/flutter_inapp_purchase/issues/234
        // FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      case TransactionState.failed:
        _callErrorListeners("Transaction Failed");
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      case TransactionState.purchased:
        await _verifyAndFinishTransaction(purchasedItem);
        break;
      case TransactionState.purchasing:
        break;
      case TransactionState.restored:
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      default:
    }
  }

  /// three purchase state https://developer.android.com/reference/com/android/billingclient/api/Purchase.PurchaseState
  /// 0 : UNSPECIFIED_STATE
  /// 1 : PURCHASED
  /// 2 : PENDING
  Future<void> _handlePurchaseUpdateAndroid(
      PurchasedItem? purchasedItem) async {
    if (purchasedItem == null) return;
    switch (purchasedItem.purchaseStateAndroid) {
      case PurchaseState.purchased:
        if (!(purchasedItem.isAcknowledgedAndroid ?? false)) {
          await _verifyAndFinishTransaction(purchasedItem);
        }
        break;
      default:
        _callErrorListeners("Something went wrong");
    }
  }

  /// Call this method when status of purchase is success
  /// Call API of your back end to verify the reciept
  /// back end has to call billing server's API to verify the purchase token
  _verifyAndFinishTransaction(PurchasedItem purchasedItem) async {
    final uid = AuthService.getUserId();
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return FirestoreService(uid)
          .firestoreApplePaymentsCollection
          .where('transactionId', isEqualTo: purchasedItem.transactionId)
          .get()
          .then((value) async {
        if (value.size > 0) {
          // already processed by webhook
          Logger.i(
              '_verifyAndFinishTransaction: transactionID ${purchasedItem.transactionId} exist on Firestore.');
          FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        } else {
          Logger.i(
              '_verifyAndFinishTransaction: transactionID ${purchasedItem.transactionId} not exist on Firestore.');
          ApplePaymentUtils.verifyReceipt(purchasedItem.transactionReceipt!)
              .then((originalTransactionId) => {
                    FirestoreService(uid).firestoreApplePaymentsCollection.add({
                      "userId": uid,
                      "originalTransactionId": originalTransactionId,
                      "transactionId": purchasedItem.transactionId,
                      "productId": purchasedItem.productId,
                      "purchaseToken": purchasedItem.purchaseToken,
                      "status": "SUBSCRIBE",
                      "purchaseTime":
                          Timestamp.fromDate(purchasedItem.transactionDate!),
                      "createdTime": Timestamp.now()
                    }).then((value) {
                      Logger.i("Write success");
                      AppWidgets.openSnackbar(
                          message:
                              "Thanks for subscribing! We're processing your payment. This may take a while.");
                      FlutterInappPurchase.instance
                          .finishTransaction(purchasedItem);
                    }).catchError((error) {
                      Logger.e(error.toString());
                      AppWidgets.openSnackbar(message: error.toString());
                    })
                  })
              .catchError((error) {
            Logger.e(error.toString());
            AppWidgets.openSnackbar(message: error.toString());
          });
        }
      });
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return FirestoreService(uid)
          .firestoreGooglePaymentsCollection
          .doc(uid)
          .set({
        "userId": uid,
        "subscriptionId": purchasedItem.productId,
        "purchaseToken": purchasedItem.purchaseToken,
        "status": 4,
        "createdTime": Timestamp.now()
      }).then((value) {
        Logger.i("Write success");
        AppWidgets.openSnackbar(
            message:
                "Thanks for subscribing! We're processing your payment. This may take a while.");
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
      }).catchError((error) {
        Logger.e(error.toString());
        _callErrorListeners(error.toString());
      });
    }
  }

  /// Call this method to notify all the subsctibers of _errorListeners
  void _callErrorListeners(String? error) {
    if (error == null) return;
    for (var callback in _errorListeners) {
      callback(error);
    }
  }

  Future<List<IAPItem>?> get products async {
    if (_products == null) {
      await _getItems();
    }
    return _products;
  }

  Future<void> _getItems() async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getSubscriptions(_productIds);
    _products = [];
    for (var item in items) {
      _products?.add(item);
    }
  }

  Future<void> _getPastPurchases() async {
    List<PurchasedItem> purchasedItems =
        await FlutterInappPurchase.instance.getAvailablePurchases() ?? [];
    if (purchasedItems.isNotEmpty) {
      PurchasedItem firstItem = purchasedItems.first;
      if (defaultTargetPlatform == TargetPlatform.android) {
        await restoreGooglePlaySubscription(firstItem);
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        await restoreAppStoreSubscription(firstItem);
      }
    }

    _pastPurchases = List.empty(growable: true);
    _pastPurchases?.addAll(purchasedItems);
  }

  Future<void> restoreProduct() async {
    await _getPastPurchases();
  }

  Future<void> buyProduct(IAPItem item) async {
    try {
      await FlutterInappPurchase.instance.requestSubscription(item.productId!);
    } catch (error) {
      Logger.e(error.toString());
    }
  }

  Future<void> restoreGooglePlaySubscription(PurchasedItem element) async {
    var newUserId = AuthService.getUserId();
    final FirestoreService firestoreService = FirestoreService(newUserId);
    var serverVerificationData = element.purchaseToken;

    var oldUserPaymentDoc = await FirestoreService(newUserId)
        .firestoreGooglePaymentsCollection
        .where('purchaseToken', isEqualTo: serverVerificationData)
        .limit(1)
        .get();

    if (oldUserPaymentDoc.size > 0) {
      var writeBatch = firestoreService.service.db.batch();
      var oldUserPayment = oldUserPaymentDoc.docs.first;
      var oldUserId = oldUserPayment.id;

      if (oldUserId == newUserId) {
        Logger.i("Same user. Not restore");
        return;
      }

      var oldUserPaymentData =
          GooglePayment.fromJson(oldUserPayment.data() as Map<String, dynamic>);
      oldUserPaymentData.userId = newUserId;

      // delete old user payment
      writeBatch.delete(
          firestoreService.firestoreGooglePaymentsCollection.doc(oldUserId));

      // write new user payment
      writeBatch.set(
        firestoreService.firestoreGooglePaymentsCollection.doc(newUserId),
        oldUserPaymentData.toJson(),
      );

      var oldUserInfo = await firestoreService.getUser(oldUserId);
      var oldUserPaymentInfo = oldUserInfo?.inAppPaymentInfo;
      var oldUserStripeInfo = oldUserInfo?.stripeInfo;

      // turn old user to inactive
      writeBatch.update(
        firestoreService.service.db
            .collection(FirestorePath.users)
            .doc(oldUserId),
        {
          "stripeInfo.status": StripeInfo.STATE_INACTIVE,
        },
      );

      // turn old user to active
      writeBatch.update(
        firestoreService.service.db
            .collection(FirestorePath.users)
            .doc(newUserId),
        {
          "inAppPaymentInfo": oldUserPaymentInfo?.toJson(),
          "stripeInfo.status": oldUserStripeInfo != null
              ? oldUserStripeInfo.status
              : StripeInfo.STATE_INACTIVE
        },
      );

      await writeBatch.commit();
    } else {
      _callErrorListeners("Purchase not found");
    }
  }

  Future<void> restoreAppStoreSubscription(PurchasedItem element) async {
    Logger.i(element.transactionId ?? '');
    var newUserId = AuthService.getUserId();
    final FirestoreService firestoreService = FirestoreService(newUserId);
    var originalTransactionId =
        await ApplePaymentUtils.verifyReceipt(element.transactionReceipt!);
    var oldUserPaymentDoc = await firestoreService
        .firestoreApplePaymentsCollection
        .where('originalTransactionId', isEqualTo: originalTransactionId)
        .where('productId', isEqualTo: element.productId)
        .orderBy('createdTime', descending: true)
        .limit(1)
        .get();
    if (oldUserPaymentDoc.size > 0) {
      var writeBatch = firestoreService.service.db.batch();
      var oldUserPayment = oldUserPaymentDoc.docs.first;
      String oldUserId;
      Map<String, dynamic> oldUserPaymentMap =
          oldUserPayment.data() as Map<String, dynamic>;
      oldUserId = oldUserPaymentMap['userId'];
      if (oldUserId == newUserId) {
        Logger.i("Same user. Not restore");
        return;
      }

      Logger.i("Old UID: $oldUserId | New UID: $newUserId");

      oldUserPaymentMap['userId'] = newUserId;
      oldUserPaymentMap['createdTime'] = Timestamp.now();

      // write new user payment
      writeBatch.set(firestoreService.firestoreApplePaymentsCollection.doc(),
          oldUserPaymentMap);

      var oldUserInfo = await firestoreService.getUser(oldUserId);
      var oldUserPaymentInfo = oldUserInfo?.inAppPaymentInfo;
      var oldUserStripeInfo = oldUserInfo?.stripeInfo;

      // turn old user to inactive
      writeBatch.update(
        firestoreService.service.db
            .collection(FirestorePath.users)
            .doc(oldUserId),
        {
          "stripeInfo.status": StripeInfo.STATE_INACTIVE,
        },
      );

      // turn new user to active
      writeBatch.update(
          firestoreService.service.db
              .collection(FirestorePath.users)
              .doc(oldUserId),
          {
            "inAppPaymentInfo": oldUserPaymentInfo?.toJson(),
            "stripeInfo.status": oldUserStripeInfo != null
                ? oldUserStripeInfo.status
                : StripeInfo.STATE_INACTIVE
          });

      await writeBatch.commit();
    } else {
      _callErrorListeners("Purchase not found");
    }
  }

  Future<void> _processNonCompletedTransactions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      List<PurchasedItem> pendingItems =
          await FlutterInappPurchase.instance.getPendingTransactionsIOS() ?? [];
      Logger.i("Pending count: ${pendingItems.length}");
      for (PurchasedItem pendingItem in pendingItems) {
        _handlePurchaseUpdate(pendingItem);
      }
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      List<PurchasedItem> purchasedItems =
          await FlutterInappPurchase.instance.getAvailablePurchases() ?? [];
      Logger.i("purchasedItems: ${purchasedItems.length}");
      for (var purchasedItem in purchasedItems) {
        Map map = json.decode(purchasedItem.transactionReceipt!);
        if (!map['acknowledged']) {
          Logger.i("not acknowledge yet");
          _handlePurchaseUpdateAndroid(purchasedItem);
        }
      }
    }
  }
}
