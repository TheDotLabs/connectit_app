import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  factory User({
    String id,
    @JsonKey(includeIfNull: false) String name,
    String email,
    @JsonKey(includeIfNull: false) String avatar,
    String provider,
    @JsonKey(includeIfNull: false) String tagline,
    @JsonKey(includeIfNull: false) List<Education> education,
    @JsonKey(includeIfNull: false) List startups,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
abstract class Education with _$Education {
  factory Education({
    String college,
    String degree,
    String description,
    int startYear,
    int endYear,
  }) = _Education;

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);
}
