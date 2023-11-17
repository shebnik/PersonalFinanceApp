import 'package:json_annotation/json_annotation.dart';

part 'preferences.g.dart';

@JsonSerializable(explicitToJson: true)
class Preferences {
  double dailyBudget;
  // double thresholdAlert;
  final String userId;

  Preferences({
    required this.dailyBudget,
    // required this.thresholdAlert,
    required this.userId,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$PreferencesToJson(this);
}
