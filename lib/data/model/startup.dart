import 'package:freezed_annotation/freezed_annotation.dart';

part 'startup.freezed.dart';

part 'startup.g.dart';

@freezed
abstract class Startup with _$Startup {
  factory Startup({
    String name,
    String tagline,
    String description,
    String avatar,
    bool isTrending,
    bool isUpcoming,
    bool isNew,
  }) = _Startup;

  factory Startup.fromJson(Map<String, dynamic> json) => _$StartupFromJson(json);
}
