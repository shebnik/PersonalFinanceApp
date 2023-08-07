// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teller_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TellerTransaction _$TellerTransactionFromJson(Map<String, dynamic> json) =>
    TellerTransaction(
      accountId: json['account_id'] as String,
      amount: json['amount'] as String,
      date: json['date'] as String,
      description: json['description'] as String,
      details:
          TransactionDetails.fromJson(json['details'] as Map<String, dynamic>),
      id: json['id'] as String,
      links: TransactionLinks.fromJson(json['links'] as Map<String, dynamic>),
      runningBalance: json['running_balance'] as String?,
      status: json['status'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$TellerTransactionToJson(TellerTransaction instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'amount': instance.amount,
      'date': instance.date,
      'description': instance.description,
      'details': instance.details.toJson(),
      'id': instance.id,
      'links': instance.links.toJson(),
      'running_balance': instance.runningBalance,
      'status': instance.status,
      'type': instance.type,
    };

TransactionDetails _$TransactionDetailsFromJson(Map<String, dynamic> json) =>
    TransactionDetails(
      category: json['category'] as String,
      counterparty: TransactionCounterparty.fromJson(
          json['counterparty'] as Map<String, dynamic>),
      processingStatus: json['processing_status'] as String,
    );

Map<String, dynamic> _$TransactionDetailsToJson(TransactionDetails instance) =>
    <String, dynamic>{
      'category': instance.category,
      'counterparty': instance.counterparty.toJson(),
      'processing_status': instance.processingStatus,
    };

TransactionLinks _$TransactionLinksFromJson(Map<String, dynamic> json) =>
    TransactionLinks(
      account: json['account'] as String,
      self: json['self'] as String,
    );

Map<String, dynamic> _$TransactionLinksToJson(TransactionLinks instance) =>
    <String, dynamic>{
      'account': instance.account,
      'self': instance.self,
    };

TransactionCounterparty _$TransactionCounterpartyFromJson(
        Map<String, dynamic> json) =>
    TransactionCounterparty(
      name: json['name'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$TransactionCounterpartyToJson(
        TransactionCounterparty instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
    };
