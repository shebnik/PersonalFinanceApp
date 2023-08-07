import 'package:json_annotation/json_annotation.dart';

part 'linked_account.g.dart';

@JsonSerializable(explicitToJson: true)
class LinkedAccount {
  late String? accessToken;
  late String? userId;

  final String currency;

  @JsonKey(name: "enrollment_id")
  final String enrollmentId;

  final String id;
  final AccountInstitution institution;

  @JsonKey(name: "last_four")
  final String lastFour;

  final AccountLinks links;
  final String name;
  final String subtype;
  final String type;

  LinkedAccount({
    this.accessToken,
    this.userId,
    required this.currency,
    required this.enrollmentId,
    required this.id,
    required this.institution,
    required this.lastFour,
    required this.links,
    required this.name,
    required this.subtype,
    required this.type,
  });

  factory LinkedAccount.fromJson(Map<String, dynamic> json) =>
      _$LinkedAccountFromJson(json);

  Map<String, dynamic> toJson() => _$LinkedAccountToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AccountInstitution {
  final String id;
  final String name;

  AccountInstitution({
    required this.id,
    required this.name,
  });

  factory AccountInstitution.fromJson(Map<String, dynamic> json) =>
      _$AccountInstitutionFromJson(json);

  Map<String, dynamic> toJson() => _$AccountInstitutionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AccountLinks {
  final String balances;
  final String? details;
  final String self;
  final String transactions;

  AccountLinks({
    required this.balances,
    this.details,
    required this.self,
    required this.transactions,
  });

  factory AccountLinks.fromJson(Map<String, dynamic> json) =>
      _$AccountLinksFromJson(json);

  Map<String, dynamic> toJson() => _$AccountLinksToJson(this);
}
