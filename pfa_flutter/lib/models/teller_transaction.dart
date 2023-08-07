import 'package:json_annotation/json_annotation.dart';

part 'teller_transaction.g.dart';

@JsonSerializable(explicitToJson: true)
class TellerTransaction {
  @JsonKey(name: 'account_id')
  final String accountId;

  final String amount;
  final String date;
  final String description;
  final TransactionDetails details;
  final String id;
  final TransactionLinks links;

  @JsonKey(name: 'running_balance')
  final String? runningBalance;

  final String status;
  final String type;

  TellerTransaction({
    required this.accountId,
    required this.amount,
    required this.date,
    required this.description,
    required this.details,
    required this.id,
    required this.links,
    required this.runningBalance,
    required this.status,
    required this.type,
  });

  factory TellerTransaction.fromJson(Map<String, dynamic> json) =>
      _$TellerTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TellerTransactionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TransactionDetails {
  final String category;
  final TransactionCounterparty counterparty;

  @JsonKey(name: 'processing_status')
  final String processingStatus;

  TransactionDetails({
    required this.category,
    required this.counterparty,
    required this.processingStatus,
  });

  factory TransactionDetails.fromJson(Map<String, dynamic> json) =>
      _$TransactionDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionDetailsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TransactionLinks {
  final String account;
  final String self;

  TransactionLinks({
    required this.account,
    required this.self,
  });

  factory TransactionLinks.fromJson(Map<String, dynamic> json) =>
      _$TransactionLinksFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionLinksToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TransactionCounterparty {
  final String name;
  final String type;

  TransactionCounterparty({
    required this.name,
    required this.type,
  });

  factory TransactionCounterparty.fromJson(Map<String, dynamic> json) =>
      _$TransactionCounterpartyFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionCounterpartyToJson(this);
}
