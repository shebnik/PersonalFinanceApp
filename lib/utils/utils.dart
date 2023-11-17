import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:pfa_flutter/models/linked_account.dart';
import 'package:pfa_flutter/models/payment/stripe_info.dart';
import 'package:pfa_flutter/models/user.dart';
import 'package:pfa_flutter/services/shared_preferences_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pfa_flutter/utils/logger.dart';
import 'package:intl/intl.dart';

class Utils {
  static String formatAmount(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  static get dailyBudget {
    try {
      return SharedPreferencesService.getPreferences()!.dailyBudget;
    } catch (e) {
      Logger.e('getDailyBudget error: ', e);
    }
  }

  // static get thresholdAlert {
  //   try {
  //     return SharedPreferencesService.getPreferences()!.thresholdAlert;
  //   } catch (e) {
  //     Logger.e('thresholdAlert error: ', e);
  //   }
  // }

  static bool isInvalidUser([AppUser? user]) {
    user ??= SharedPreferencesService.getUser();
    if (user != null) {
      if (StripeInfo.STATE_ACTIVE != user.stripeInfo.status) {
        if (user.trialEndDate.isBefore(DateTime.now())) {
          return true;
        }
      }
    }
    return false;
  }

  static void openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Logger.i('Cannot load URL $url');
    }
  }

  static dynamic dateSerializer(dynamic object) {
    if (object is Timestamp) {
      return DateTime.fromMicrosecondsSinceEpoch(object.microsecondsSinceEpoch)
          .toIso8601String();
    }
    return object;
  }

  static dynamic jsonReviver(dynamic key, dynamic value) {
    if (key == 'createdDate' || key == 'trialEndDate') {
      final date = DateTime.parse(value);
      final timestamp = Timestamp.fromDate(date);
      return timestamp;
    }
    return value;
  }

  static List<TextInputFormatter> getInputFormatters({
    bool isNumberType = false,
  }) {
    return [
      LengthLimitingTextInputFormatter(64),
      FilteringTextInputFormatter.deny(
        RegExp(
            r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
      ),
      if (isNumberType)
        FilteringTextInputFormatter.allow(RegExp(r'([0-9]+[.,]?[0-9]*)')),
    ];
  }

  static String getAccountInfo(LinkedAccount account) {
    return '${account.institution.name} - ${account.name} (${account.lastFour})';
  }

  static List<String> getPastDates(int count) {
    DateTime date = DateTime.now();
    List<String> days = [];
    for (int i = 0; i < count; i++) {
      days.add(formatDate(date.subtract(Duration(days: i))));
    }
    return days;
  }

  static String formatDate(DateTime dateTime) {
    final date = DateFormat('yyyy-MM-dd').format(dateTime);
    return date;
  }

  static bool isTodayDate(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays ==
        0;
  }

  static DateTime getPastDate(int count) {
    DateTime now = DateTime.now();
    DateTime date = now.subtract(Duration(days: count));
    return date;
  }

  static DateTime dateFromTimestamp(Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(
        timestamp.millisecondsSinceEpoch);
  }

  static Timestamp timestampFromDate(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }
}
