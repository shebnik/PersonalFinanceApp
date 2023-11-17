// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferences _$PreferencesFromJson(Map<String, dynamic> json) => Preferences(
      dailyBudget: (json['dailyBudget'] as num).toDouble(),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$PreferencesToJson(Preferences instance) =>
    <String, dynamic>{
      'dailyBudget': instance.dailyBudget,
      'userId': instance.userId,
    };
