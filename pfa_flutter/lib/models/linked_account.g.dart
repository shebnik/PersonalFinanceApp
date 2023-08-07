// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linked_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkedAccount _$LinkedAccountFromJson(Map<String, dynamic> json) =>
    LinkedAccount(
      accessToken: json['accessToken'] as String?,
      userId: json['userId'] as String?,
      currency: json['currency'] as String,
      enrollmentId: json['enrollment_id'] as String,
      id: json['id'] as String,
      institution: AccountInstitution.fromJson(
          json['institution'] as Map<String, dynamic>),
      lastFour: json['last_four'] as String,
      links: AccountLinks.fromJson(json['links'] as Map<String, dynamic>),
      name: json['name'] as String,
      subtype: json['subtype'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$LinkedAccountToJson(LinkedAccount instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'userId': instance.userId,
      'currency': instance.currency,
      'enrollment_id': instance.enrollmentId,
      'id': instance.id,
      'institution': instance.institution.toJson(),
      'last_four': instance.lastFour,
      'links': instance.links.toJson(),
      'name': instance.name,
      'subtype': instance.subtype,
      'type': instance.type,
    };

AccountInstitution _$AccountInstitutionFromJson(Map<String, dynamic> json) =>
    AccountInstitution(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$AccountInstitutionToJson(AccountInstitution instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

AccountLinks _$AccountLinksFromJson(Map<String, dynamic> json) => AccountLinks(
      balances: json['balances'] as String,
      details: json['details'] as String?,
      self: json['self'] as String,
      transactions: json['transactions'] as String,
    );

Map<String, dynamic> _$AccountLinksToJson(AccountLinks instance) =>
    <String, dynamic>{
      'balances': instance.balances,
      'details': instance.details,
      'self': instance.self,
      'transactions': instance.transactions,
    };
