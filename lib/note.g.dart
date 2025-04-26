// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteImpl _$$NoteImplFromJson(Map<String, dynamic> json) => _$NoteImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  createTime:
      json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String),
  modifyTime:
      json['modifyTime'] == null
          ? null
          : DateTime.parse(json['modifyTime'] as String),
);

Map<String, dynamic> _$$NoteImplToJson(_$NoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'createTime': instance.createTime?.toIso8601String(),
      'modifyTime': instance.modifyTime?.toIso8601String(),
    };
