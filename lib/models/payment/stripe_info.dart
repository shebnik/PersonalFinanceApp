// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'stripe_info.g.dart';

@JsonSerializable(explicitToJson: true)
class StripeInfo {
  static const String STATE_ACTIVE = "active";
  static const String STATE_INACTIVE = "inactive";

  final String status;
  final String? stripeCustomerId;

  StripeInfo({
    required this.status,
    this.stripeCustomerId,
  });

  factory StripeInfo.fromJson(Map<String, dynamic> json) =>
      _$StripeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$StripeInfoToJson(this);
}