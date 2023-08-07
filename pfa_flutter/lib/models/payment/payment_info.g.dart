// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InAppPaymentInfo _$InAppPaymentInfoFromJson(Map<String, dynamic> json) =>
    InAppPaymentInfo(
      gateway: json['gateway'] as String?,
      subscriptionId: json['subscriptionId'] as String?,
    );

Map<String, dynamic> _$InAppPaymentInfoToJson(InAppPaymentInfo instance) =>
    <String, dynamic>{
      'gateway': instance.gateway,
      'subscriptionId': instance.subscriptionId,
    };
