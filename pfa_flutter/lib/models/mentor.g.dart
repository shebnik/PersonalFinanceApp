// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mentor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mentor _$MentorFromJson(Map<String, dynamic> json) => Mentor(
      mentorEmail: json['mentorEmail'] as String,
      mentorName: json['mentorName'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$MentorToJson(Mentor instance) => <String, dynamic>{
      'mentorEmail': instance.mentorEmail,
      'mentorName': instance.mentorName,
      'userId': instance.userId,
    };
