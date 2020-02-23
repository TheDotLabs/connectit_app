// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package

part of 'feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

Feed _$FeedFromJson(Map<String, dynamic> json) {
  return _Feed.fromJson(json);
}

mixin _$Feed {
  String get id;
  String get title;
  String get description;
  @JsonKey(defaultValue: 0)
  int get time;
  dynamic get author;
  @JsonKey(defaultValue: false)
  bool get hidden;

  Feed copyWith(
      {String id,
      String title,
      String description,
      @JsonKey(defaultValue: 0) int time,
      dynamic author,
      @JsonKey(defaultValue: false) bool hidden});

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class _$_Feed implements _Feed {
  _$_Feed(
      {this.id,
      this.title,
      this.description,
      @JsonKey(defaultValue: 0) this.time,
      this.author,
      @JsonKey(defaultValue: false) this.hidden});

  factory _$_Feed.fromJson(Map<String, dynamic> json) =>
      _$_$_FeedFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  @JsonKey(defaultValue: 0)
  final int time;
  @override
  final dynamic author;
  @override
  @JsonKey(defaultValue: false)
  final bool hidden;

  @override
  String toString() {
    return 'Feed(id: $id, title: $title, description: $description, time: $time, author: $author, hidden: $hidden)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Feed &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.time, time) ||
                const DeepCollectionEquality().equals(other.time, time)) &&
            (identical(other.author, author) ||
                const DeepCollectionEquality().equals(other.author, author)) &&
            (identical(other.hidden, hidden) ||
                const DeepCollectionEquality().equals(other.hidden, hidden)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      time.hashCode ^
      author.hashCode ^
      hidden.hashCode;

  @override
  _$_Feed copyWith({
    Object id = freezed,
    Object title = freezed,
    Object description = freezed,
    Object time = freezed,
    Object author = freezed,
    Object hidden = freezed,
  }) {
    return _$_Feed(
      id: id == freezed ? this.id : id as String,
      title: title == freezed ? this.title : title as String,
      description:
          description == freezed ? this.description : description as String,
      time: time == freezed ? this.time : time as int,
      author: author == freezed ? this.author : author as dynamic,
      hidden: hidden == freezed ? this.hidden : hidden as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$_FeedToJson(this);
  }
}

abstract class _Feed implements Feed {
  factory _Feed(
      {String id,
      String title,
      String description,
      @JsonKey(defaultValue: 0) int time,
      dynamic author,
      @JsonKey(defaultValue: false) bool hidden}) = _$_Feed;

  factory _Feed.fromJson(Map<String, dynamic> json) = _$_Feed.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  @JsonKey(defaultValue: 0)
  int get time;
  @override
  dynamic get author;
  @override
  @JsonKey(defaultValue: false)
  bool get hidden;

  @override
  _Feed copyWith(
      {String id,
      String title,
      String description,
      @JsonKey(defaultValue: 0) int time,
      dynamic author,
      @JsonKey(defaultValue: false) bool hidden});
}
