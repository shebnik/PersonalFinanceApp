// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GooglePayment _$GooglePaymentFromJson(Map<String, dynamic> json) =>
    GooglePayment(
      userId: json['userId'] as String? ?? "",
      subscriptionId: json['subscriptionId'] as String? ?? "",
      purchaseToken: json['purchaseToken'] as String? ?? "",
      status: json['status'] as int? ?? 0,
      updatedTime: json['updatedTime'],
      createdTime: json['createdTime'],
    );

Map<String, dynamic> _$GooglePaymentToJson(GooglePayment instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'subscriptionId': instance.subscriptionId,
      'purchaseToken': instance.purchaseToken,
      'status': instance.status,
      'createdTime': const TimestampConverter().toJson(instance.createdTime),
      'updatedTime': const TimestampConverter().toJson(instance.updatedTime),
    };
