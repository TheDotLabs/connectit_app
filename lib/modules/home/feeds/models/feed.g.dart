// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Feed _$_$_FeedFromJson(Map json) {
  return $checkedNew(r'_$_Feed', json, () {
    final val = _$_Feed(
      id: $checkedConvert(json, 'id', (v) => v as String),
      title: $checkedConvert(json, 'title', (v) => v as String),
      description: $checkedConvert(json, 'description', (v) => v as String),
      time: $checkedConvert(json, 'time', (v) => v as int) ?? 0,
      author: $checkedConvert(json, 'author', (v) => v),
      hidden: $checkedConvert(json, 'hidden', (v) => v as bool) ?? false,
    );
    return val;
  });
}

Map<String, dynamic> _$_$_FeedToJson(_$_Feed instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'time': instance.time,
      'author': instance.author,
      'hidden': instance.hidden,
    };
