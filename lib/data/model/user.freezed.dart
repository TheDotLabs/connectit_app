// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

mixin _$User {
  String get id;
  String get name;
  String get email;
  String get avatar;
  String get provider;

  User copyWith(
      {String id, String name, String email, String avatar, String provider});

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class _$_User implements _User {
  _$_User({this.id, this.name, this.email, this.avatar, this.provider});

  factory _$_User.fromJson(Map<String, dynamic> json) =>
      _$_$_UserFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String avatar;
  @override
  final String provider;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, avatar: $avatar, provider: $provider)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _User &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.avatar, avatar) ||
                const DeepCollectionEquality().equals(other.avatar, avatar)) &&
            (identical(other.provider, provider) ||
                const DeepCollectionEquality()
                    .equals(other.provider, provider)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      avatar.hashCode ^
      provider.hashCode;

  @override
  _$_User copyWith({
    Object id = freezed,
    Object name = freezed,
    Object email = freezed,
    Object avatar = freezed,
    Object provider = freezed,
  }) {
    return _$_User(
      id: id == freezed ? this.id : id as String,
      name: name == freezed ? this.name : name as String,
      email: email == freezed ? this.email : email as String,
      avatar: avatar == freezed ? this.avatar : avatar as String,
      provider: provider == freezed ? this.provider : provider as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$_UserToJson(this);
  }
}

abstract class _User implements User {
  factory _User(
      {String id,
      String name,
      String email,
      String avatar,
      String provider}) = _$_User;

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String get avatar;
  @override
  String get provider;

  @override
  _User copyWith(
      {String id, String name, String email, String avatar, String provider});
}
