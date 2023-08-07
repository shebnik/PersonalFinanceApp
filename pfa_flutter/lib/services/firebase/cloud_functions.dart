import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:pfa_flutter/models/linked_account.dart';
import 'package:pfa_flutter/models/teller_transaction.dart';
import 'package:pfa_flutter/models/user.dart';
import 'package:pfa_flutter/services/firebase/firestore_service.dart';
import 'package:pfa_flutter/utils/logger.dart';
import 'package:pfa_flutter/utils/utils.dart';

class CloudFunctionsPath {
  static const tellerEndpoint = 'tellerEndpoint';

  static const getAccounts = 'getAccounts';
  static const getTransactions = 'getTransactions';
  static const removeAccount = 'removeAccount';
}

class CloudFunctions {
  final String uid;

  late FirebaseFunctions _service;

  late HttpsCallable _tellerEndpoint;

  CloudFunctions(this.uid) {
    _service = FirebaseFunctions.instance;

    _tellerEndpoint = _service.httpsCallable(CloudFunctionsPath.tellerEndpoint);
  }

  Future<dynamic> getAccounts(String accessToken) async {
    try {
      final result = await _tellerEndpoint({
        'msg': CloudFunctionsPath.getAccounts,
        'accessToken': accessToken,
      });
      final data = result.data;
      Logger.i('[CloudFunctions] getAccounts data: $data');
      return data;
    } catch (e) {
      Logger.e('[CloudFunctions] getAccounts error: $e');
      return null;
    }
  }

  Future<List<TellerTransaction>?> getTodayTransactions(AppUser user) async {
    if (user.linkedAccounts.isEmpty) {
      Logger.i('[CloudFunctions] getTodayTransactions - no accounts linked');
      return null;
    }
    try {
      final result = await _tellerEndpoint({
        'msg': CloudFunctionsPath.getTransactions,
        'linkedAccounts': user.linkedAccounts.map((e) => e.toJson()).toList(),
        'date': Utils.formatDate(DateTime.now()),
        'userId': user.userId,
      });
      final data = result.data;
      // Logger.i('[CloudFunctions] getTodayTransactions data: $data');
      final List response = json.decode(data);
      final List<TellerTransaction> transactions =
          response.map((item) => TellerTransaction.fromJson(item)).toList();
      FirestoreService(user.userId).updateTransactions(transactions);
      return transactions;
    } catch (e) {
      Logger.e('[CloudFunctions] getTodayTransactions error: $e');
      return null;
    }
  }

  Future<bool> removeAccount(LinkedAccount account) async {
    try {
      await _tellerEndpoint({
        'msg': CloudFunctionsPath.removeAccount,
        'accessToken': account.accessToken,
        'id': account.id,
      });
      return true;
    } catch (e) {
      Logger.e('[CloudFunctions] removeAccount error: $e');
      return false;
    }
  }
}
