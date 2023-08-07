// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pfa_flutter/models/linked_account.dart';
import 'package:pfa_flutter/models/payment/payment_info.dart';
import 'package:pfa_flutter/models/payment/stripe_info.dart';
import 'package:pfa_flutter/utils/timestamp_converter.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class AppUser {
  @TimestampConverter()
  final DateTime createdDate;

  final String email;
  final String name;
  final InAppPaymentInfo inAppPaymentInfo;
  List<LinkedAccount> linkedAccounts;
  final StripeInfo stripeInfo;

  @TimestampConverter()
  final DateTime trialEndDate;

  final String userId;

  AppUser({
    required this.createdDate,
    required this.email,
    required this.name,
    required this.inAppPaymentInfo,
    required this.linkedAccounts,
    required this.stripeInfo,
    required this.trialEndDate,
    required this.userId,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}