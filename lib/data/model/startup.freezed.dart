// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package

part of 'startup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

Startup _$StartupFromJson(Map<String, dynamic> json) {
  return _Startup.fromJson(json);
}

mixin _$Startup {
  String get name;
  String get tagline;
  String get description;
  String get avatar;
  bool get isTrending;
  bool get isUpcoming;
  bool get isNew;

  Startup copyWith(
      {String name,
      String tagline,
      String description,
      String avatar,
      bool isTrending,
      bool isUpcoming,
      bool isNew});

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class _$_Startup implements _Startup {
  _$_Startup(
      {this.name,
      this.tagline,
      this.description,
      this.avatar,
      this.isTrending,
      this.isUpcoming,
      this.isNew});

  factory _$_Startup.fromJson(Map<String, dynamic> json) =>
      _$_$_StartupFromJson(json);

  @override
  final String name;
  @override
  final String tagline;
  @override
  final String description;
  @override
  final String avatar;
  @override
  final bool isTrending;
  @override
  final bool isUpcoming;
  @override
  final bool isNew;

  @override
  String toString() {
    return 'Startup(name: $name, tagline: $tagline, description: $description, avatar: $avatar, isTrending: $isTrending, isUpcoming: $isUpcoming, isNew: $isNew)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Startup &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.tagline, tagline) ||
                const DeepCollectionEquality()
                    .equals(other.tagline, tagline)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.avatar, avatar) ||
                const DeepCollectionEquality().equals(other.avatar, avatar)) &&
            (identical(other.isTrending, isTrending) ||
                const DeepCollectionEquality()
                    .equals(other.isTrending, isTrending)) &&
            (identical(other.isUpcoming, isUpcoming) ||
                const DeepCollectionEquality()
                    .equals(other.isUpcoming, isUpcoming)) &&
            (identical(other.isNew, isNew) ||
                const DeepCollectionEquality().equals(other.isNew, isNew)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      name.hashCode ^
      tagline.hashCode ^
      description.hashCode ^
      avatar.hashCode ^
      isTrending.hashCode ^
      isUpcoming.hashCode ^
      isNew.hashCode;

  @override
  _$_Startup copyWith({
    Object name = freezed,
    Object tagline = freezed,
    Object description = freezed,
    Object avatar = freezed,
    Object isTrending = freezed,
    Object isUpcoming = freezed,
    Object isNew = freezed,
  }) {
    return _$_Startup(
      name: name == freezed ? this.name : name as String,
      tagline: tagline == freezed ? this.tagline : tagline as String,
      description:
          description == freezed ? this.description : description as String,
      avatar: avatar == freezed ? this.avatar : avatar as String,
      isTrending: isTrending == freezed ? this.isTrending : isTrending as bool,
      isUpcoming: isUpcoming == freezed ? this.isUpcoming : isUpcoming as bool,
      isNew: isNew == freezed ? this.isNew : isNew as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$_StartupToJson(this);
  }
}

abstract class _Startup implements Startup {
  factory _Startup(
      {String name,
      String tagline,
      String description,
      String avatar,
      bool isTrending,
      bool isUpcoming,
      bool isNew}) = _$_Startup;

  factory _Startup.fromJson(Map<String, dynamic> json) = _$_Startup.fromJson;

  @override
  String get name;
  @override
  String get tagline;
  @override
  String get description;
  @override
  String get avatar;
  @override
  bool get isTrending;
  @override
  bool get isUpcoming;
  @override
  bool get isNew;

  @override
  _Startup copyWith(
      {String name,
      String tagline,
      String description,
      String avatar,
      bool isTrending,
      bool isUpcoming,
      bool isNew});
}
