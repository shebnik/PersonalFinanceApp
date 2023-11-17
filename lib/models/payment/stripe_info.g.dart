// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StripeInfo _$StripeInfoFromJson(Map<String, dynamic> json) => StripeInfo(
      status: json['status'] as String,
      stripeCustomerId: json['stripeCustomerId'] as String?,
    );

Map<String, dynamic> _$StripeInfoToJson(StripeInfo instance) =>
    <String, dynamic>{
      'status': instance.status,
      'stripeCustomerId': instance.stripeCustomerId,
    };
