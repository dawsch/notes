import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
class Note with _$Note{
  const Note._();

  const factory Note({
    required String id,
    required String title,
    required String content,
    @Default(null) DateTime? createTime,
    @Default(null) DateTime? modifyTime,
  }) = _Note;
  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createTime': createTime!.toIso8601String(),
      'modifyTime': modifyTime!.toIso8601String(),
    };
  }
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      createTime: DateTime.parse(map['createTime'] as String),
      modifyTime: DateTime.parse(map['modifyTime'] as String),
    );
  }
}
