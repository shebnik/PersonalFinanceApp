import 'package:json_annotation/json_annotation.dart';

part 'mentor.g.dart';

@JsonSerializable(explicitToJson: true)
class Mentor {
  final String mentorEmail;
  final String mentorName;
  final String userId;

  Mentor({
    required this.mentorEmail,
    required this.mentorName,
    required this.userId,
  });

  factory Mentor.fromJson(Map<String, dynamic> json) => _$MentorFromJson(json);

  Map<String, dynamic> toJson() => _$MentorToJson(this);
}
