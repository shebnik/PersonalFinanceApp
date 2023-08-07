// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      createdDate:
          const TimestampConverter().fromJson(json['createdDate'] as Timestamp),
      email: json['email'] as String,
      name: json['name'] as String,
      inAppPaymentInfo: InAppPaymentInfo.fromJson(
          json['inAppPaymentInfo'] as Map<String, dynamic>),
      linkedAccounts: (json['linkedAccounts'] as List<dynamic>)
          .map((e) => LinkedAccount.fromJson(e as Map<String, dynamic>))
          .toList(),
      stripeInfo:
          StripeInfo.fromJson(json['stripeInfo'] as Map<String, dynamic>),
      trialEndDate: const TimestampConverter()
          .fromJson(json['trialEndDate'] as Timestamp),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'createdDate': const TimestampConverter().toJson(instance.createdDate),
      'email': instance.email,
      'name': instance.name,
      'inAppPaymentInfo': instance.inAppPaymentInfo.toJson(),
      'linkedAccounts': instance.linkedAccounts.map((e) => e.toJson()).toList(),
      'stripeInfo': instance.stripeInfo.toJson(),
      'trialEndDate': const TimestampConverter().toJson(instance.trialEndDate),
      'userId': instance.userId,
    };
