// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;

class ApplePaymentUtils {
  static const _APPLE_RECEIPT_PRODUCTION_URL =
      "https://buy.itunes.apple.com/verifyReceipt";
  static const _APPLE_RECEIPT_SANDOX_URL =
      "https://sandbox.itunes.apple.com/verifyReceipt";
  static const _STATUS_SANDBOX = 21007;

  static Future<String> verifyReceipt(String receipt) async {
    // var headers = <String, String>{
    //   'Content-Type': 'application/json; charset=UTF-8',
    // };
    var requestBody = jsonEncode(<String, String>{
      "receipt-data": receipt,
      "password": "bbc1cf4a8be6461789f6bc7fbc3376a0"
    });
    var prodResponse = await http.post(
      Uri.parse(_APPLE_RECEIPT_PRODUCTION_URL) /*, headers: headers*/,
      body: requestBody,
    );
    if (prodResponse.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(prodResponse.body);
      int status = responseBody['status'];
      if (status == _STATUS_SANDBOX) {
        var sandboxResponse = await http.post(
          Uri.parse(_APPLE_RECEIPT_SANDOX_URL) /*, headers: headers*/,
          body: requestBody,
        );
        if (sandboxResponse.statusCode == 200) {
          responseBody = jsonDecode(sandboxResponse.body);
        } else {
          throw Exception("Verify Sandbox Apple receipt error");
        }
      }
      var latestReceiptInfo =
          responseBody['latest_receipt_info'] as List<dynamic>;
      if (latestReceiptInfo.isNotEmpty) {
        String? originalTransactionId =
            latestReceiptInfo.first['original_transaction_id'];
        if (originalTransactionId != null) {
          return originalTransactionId;
        } else {
          throw Exception("Original transaction ID not found");
        }
      } else {
        throw Exception("No receipt data");
      }
    } else {
      throw Exception("Verify Apple receipt error");
    }
  }
}
