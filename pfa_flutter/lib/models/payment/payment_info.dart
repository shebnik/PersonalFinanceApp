// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'payment_info.g.dart';

@JsonSerializable(explicitToJson: true)
class InAppPaymentInfo {
  static const String GATEWAY_GOOGLE = "google";
  static const String GATEWAY_APPLE = "apple";

  final String? gateway;
  final String? subscriptionId;

  InAppPaymentInfo({
    required this.gateway,
    required this.subscriptionId,
  });

  factory InAppPaymentInfo.fromJson(Map<String, dynamic> json) =>
      _$InAppPaymentInfoFromJson(json);

  Map<String, dynamic> toJson() => _$InAppPaymentInfoToJson(this);
}
