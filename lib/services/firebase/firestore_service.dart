import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pfa_flutter/models/linked_account.dart';
import 'package:pfa_flutter/models/mentor.dart';
import 'package:pfa_flutter/models/preferences.dart';
import 'package:pfa_flutter/models/teller_transaction.dart';
import 'package:pfa_flutter/models/user.dart';
import 'package:pfa_flutter/services/firebase/firestore.dart';
import 'package:pfa_flutter/services/shared_preferences_service.dart';
import 'package:pfa_flutter/utils/app_constants.dart';
import 'package:pfa_flutter/utils/logger.dart';
import 'package:pfa_flutter/utils/utils.dart';

class FirestorePath {
  // Collections
  static const users = 'users';
  static const mentors = 'mentors';
  static const preferences = 'preferences';
  static const transactions = 'transactions';

  static const googlePaymentsCollection = 'googlePayments';
  static const applePaymentsCollection = 'applePayments';

  // Snapshots
  static userSnapshot(String uid) =>
      FirebaseFirestore.instance.doc(userDoc(uid)).snapshots();

  static transactionsSnapshot(String uid) => FirebaseFirestore.instance
      .collection(transactions)
      .where(userIdField, isEqualTo: uid)
      .where(dateField, isGreaterThanOrEqualTo: Utils.getPastDate(30))
      .snapshots();

  // Docs
  static userDoc(String uid) => '$users/$uid';
  static transactionDoc(String uid, String date) => '$transactions/$uid:$date';
  static mentorDoc(String uid) => '$mentors/$uid';
  static preferencesDoc(String uid) => '$preferences/$uid';

  // Fields
  static const userIdField = 'userId';
  static const accessTokenField = 'accessToken';
  static const linkedAccountsField = 'linkedAccounts';
  static const transactionsField = 'transactions';
  static const dailyBudgetField = 'dailyBudget';
  static const thresholdAlertField = 'thresholdAlert';
  static const dateField = 'date';
  static const userName = 'name';
}

class FirestoreService {
  final String uid;
  late FirestorePath firestorePath;

  FirestoreService(this.uid);

  final service = AppFirestore.instance;

  Future<bool> setUser(AppUser user) async => await service.setData(
        path: FirestorePath.userDoc(uid),
        data: user.toJson(),
      );

  Future<AppUser?> getUser([String? uid]) async {
    var data = await service.getData(
      path: FirestorePath.userDoc(uid ?? this.uid),
    );
    if (data == null) return null;
    try {
      return AppUser.fromJson(data);
    } catch (e) {
      Logger.e('Error getUser: ', e);
      return null;
    }
  }

  Future<bool> addLinkedAccount(List<LinkedAccount> linkedAccount) async {
    return await service.arrayUnion(
      path: FirestorePath.userDoc(uid),
      arrayPath: FirestorePath.linkedAccountsField,
      data: [...linkedAccount.map((e) => e.toJson())],
    );
  }

  Future<bool> removeAccount(LinkedAccount linkedAccount) async {
    return await service.arrayRemove(
      path: FirestorePath.userDoc(uid),
      arrayPath: FirestorePath.linkedAccountsField,
      data: [linkedAccount.toJson()],
    );
  }

  Future<void> updateTransactions(List<TellerTransaction> transactions) async {
    final todayDate = DateTime.now();
    Logger.i('[updateTransactions] todayDate: $todayDate');

    final path = FirestorePath.transactionDoc(uid, Utils.formatDate(todayDate));
    await service.setData(
      path: path,
      data: {
        'date': todayDate,
        'transactions': transactions.map((e) => e.toJson()).toList(),
        'userId': uid,
      },
      merge: true,
    );

    // final path = firestorePath.transactionDoc(todayDate);
    // final doc = await _service.getDoc(path: path);

    // if (doc != null && doc.exists) {
    //   await _service.arrayUnion(
    //     path: path,
    //     arrayPath: FirestorePath.transactionsField,
    //     data: transactions.map((e) => e.toJson()).toList(),
    //   );
    // } else {
    //   await _service.setData(
    //     path: path,
    //     data: {
    //       'date': todayDate,
    //       'transactions': transactions.map((e) => e.toJson()).toList(),
    //       'userId': uid,
    //     },
    //   );
    // }
  }

  Future<bool> setMentor(String name, String email) async {
    final mentor = Mentor(
      mentorName: name,
      mentorEmail: email,
      userId: uid,
    );
    bool result = await service.setData(
      path: FirestorePath.mentorDoc(uid),
      data: mentor.toJson(),
    );
    if (result) SharedPreferencesService.setMentor(mentor);
    return result;
  }

  Future<Mentor?> getMentor() async {
    var data = await service.getData(
      path: FirestorePath.mentorDoc(uid),
    );
    if (data == null) return null;
    try {
      return Mentor.fromJson(data);
    } catch (e) {
      Logger.e('Error getMentor: ', e);
      return null;
    }
  }

  // Future<bool> setPreferences(double thresholdAlert) async {
  //   final localPreferences = SharedPreferencesService.getPreferences();
  //   double dailyBudget = AppConstants.dailyBudget;
  //   if (localPreferences != null) {
  //     dailyBudget = localPreferences.dailyBudget;
  //   }

  //   final preferences = Preferences(
  //     // thresholdAlert: thresholdAlert,
  //     dailyBudget: dailyBudget,
  //     userId: uid,
  //   );

  //   bool result = await _service.setData(
  //     path: FirestorePath.preferencesDoc(uid),
  //     data: preferences.toJson(),
  //     merge: true,
  //   );

  //   if (result) SharedPreferencesService.setPreferences(preferences);
  //   return result;
  // }

  Future<bool> updateDailyBudget(double usd) async {
    try {
      bool result = await service.updateData(
        path: FirestorePath.preferencesDoc(uid),
        field: FirestorePath.dailyBudgetField,
        value: usd,
      );

      if (result) {
        final preferences = SharedPreferencesService.getPreferences()!;
        preferences.dailyBudget = usd;
        SharedPreferencesService.setPreferences(preferences);
      }

      return result;
    } catch (e) {
      Logger.e('Error updateDailyBudget: ', e);
      return false;
    }
  }

  // Future<bool> updateThresholdAlert(double usd) async {
  //   try {
  //     bool result = await _service.updateData(
  //       path: FirestorePath.preferencesDoc(uid),
  //       field: FirestorePath.thresholdAlertField,
  //       value: usd,
  //     );

  //     if (result) {
  //       final preferences = SharedPreferencesService.getPreferences()!;
  //       preferences.thresholdAlert = usd;
  //       SharedPreferencesService.setPreferences(preferences);
  //     }

  //     return result;
  //   } catch (e) {
  //     Logger.e('Error updateThresholdAlert: ', e);
  //     return false;
  //   }
  // }

  Future<Preferences?> getPreferences() async {
    var data = await service.getData(
      path: FirestorePath.preferencesDoc(uid),
    );
    if (data == null) return null;
    try {
      return Preferences.fromJson(data);
    } catch (e) {
      Logger.e('Error getPreferences: ', e);
      return null;
    }
  }

  // Future<List<TellerTransaction>> fetchTransactions(List<String> dates) async {
  //   var resultList = <TellerTransaction>[];
  //   try {
  //     // firestore limits batches to 10
  //     if (dates.length == 30) {
  //       resultList = [
  //         ...resultList,
  //         ...await transactionsQuery(dates.sublist(0, 10)),
  //         ...await transactionsQuery(dates.sublist(10, 20)),
  //         ...await transactionsQuery(dates.sublist(20, 30)),
  //       ];
  //     } else {
  //       resultList = [...resultList, ...await transactionsQuery(dates)];
  //     }
  //     Logger.i(
  //         'Total transactions count for range: ${dates.last} - ${dates.first} = ${resultList.length.toString()}');
  //   } catch (e) {
  //     Logger.e('fetchTransactions error: ', e);
  //   }

  //   return resultList;
  // }

  // Future<List<TellerTransaction>> transactionsQuery(List<String> dates) async {
  //   var query = await _service.db
  //       .collection(FirestorePath.transactions)
  //       .where(FirestorePath.userIdField, isEqualTo: uid)
  //       .where(FirestorePath.dateField, whereIn: dates)
  //       .get();

  //   var resultList = <TellerTransaction>[];
  //   for (var queryDoc in query.docs) {
  //     var data = queryDoc.data();
  //     List<TellerTransaction> transactions =
  //         data[FirestorePath.transactionsField]
  //             .map<TellerTransaction>((e) => TellerTransaction.fromJson(e))
  //             .toList();
  //     Logger.i(
  //         'date: ${data['date']}, transactions count: ${transactions.length}');
  //     resultList = [...resultList, ...transactions];
  //   }
  //   return resultList;
  // }

  // Future<List<TellerTransaction>> getTransactionsForDate(String date) async {
  //   var query = await _service.db
  //       .collection(FirestorePath.transactions)
  //       .where(FirestorePath.userIdField, isEqualTo: uid)
  //       .where(FirestorePath.dateField, isEqualTo: date)
  //       .limit(1)
  //       .get();

  //   var resultList = <TellerTransaction>[];
  //   for (var queryDoc in query.docs) {
  //     var data = queryDoc.data();
  //     List<TellerTransaction> transactions =
  //         data[FirestorePath.transactionsField]
  //             .map<TellerTransaction>((e) => TellerTransaction.fromJson(e))
  //             .toList();
  //     Logger.i(
  //         'date: ${data['date']}, transactions count: ${transactions.length}');
  //     resultList = [...resultList, ...transactions];
  //   }
  //   return resultList;
  // }

  Future<bool> updateUser(String path, String name) async {
    return await service.updateData(
      path: FirestorePath.userDoc(uid),
      field: path,
      value: name,
    );
  }

  Future<bool> setPreferences() async {
    final localPreferences = SharedPreferencesService.getPreferences();
    double dailyBudget = AppConstants.dailyBudget;
    if (localPreferences != null) {
      dailyBudget = localPreferences.dailyBudget;
    }

    final preferences = Preferences(
      dailyBudget: dailyBudget,
      userId: uid,
    );

    bool result = await service.setData(
      path: FirestorePath.preferencesDoc(uid),
      data: preferences.toJson(),
      merge: true,
    );

    if (result) SharedPreferencesService.setPreferences(preferences);
    return result;
  }

  CollectionReference get firestoreGooglePaymentsCollection =>
      service.db.collection(FirestorePath.googlePaymentsCollection);

  CollectionReference get firestoreApplePaymentsCollection =>
      service.db.collection(FirestorePath.applePaymentsCollection);
}
