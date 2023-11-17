import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pfa_flutter/utils/timestamp_converter.dart';

part 'google_payment.g.dart';

@JsonSerializable(explicitToJson: true)
class GooglePayment {
  String userId;
  String subscriptionId;
  String purchaseToken;
  int status;

  @TimestampConverter()
  DateTime createdTime;

  @TimestampConverter()
  DateTime updatedTime;

  GooglePayment({
    this.userId = "",
    this.subscriptionId = "",
    this.purchaseToken = "",
    this.status = 0,
    updatedTime,
    createdTime,
  })  : createdTime = createdTime ?? Timestamp.fromMillisecondsSinceEpoch(0),
        updatedTime = updatedTime ?? Timestamp.fromMillisecondsSinceEpoch(0);

  
  factory GooglePayment.fromJson(Map<String, dynamic> json) =>
      _$GooglePaymentFromJson(json);

  Map<String, dynamic> toJson() => _$GooglePaymentToJson(this);

  // factory GooglePayment.fromSnapshot(DocumentSnapshot snapshot) {
  //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //   return GooglePayment(
  //     userId: data['userId'],
  //     createdTime: data['createdTime'],
  //     status: data['status'],
  //     updatedTime:
  //         data['updatedTime'] ?? Timestamp.fromMillisecondsSinceEpoch(0),
  //     subscriptionId: data['subscriptionId'],
  //     purchaseToken: data['purchaseToken'],
  //   );
  // }
}
