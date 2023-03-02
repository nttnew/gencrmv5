// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_clue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteClueData _$NoteClueDataFromJson(Map<String, dynamic> json) => NoteClueData(
      json['uid'] as int?,
      json['uname'] as String?,
      json['noteid'] as String?,
      json['avatar'] as String?,
      json['content'] as String?,
      json['createdtime'] as String?,
      json['passedtime'] as String?,
    );

Map<String, dynamic> _$NoteClueDataToJson(NoteClueData instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'uname': instance.uname,
      'noteid': instance.noteid,
      'avatar': instance.avatar,
      'content': instance.content,
      'createdtime': instance.createdtime,
      'passedtime': instance.passedtime,
    };

ListNoteClue _$ListNoteClueFromJson(Map<String, dynamic> json) => ListNoteClue(
      (json['notes'] as List<dynamic>?)
          ?.map((e) => NoteClueData.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['id'] as String?,
      json['remaining'] as int?,
    );

Map<String, dynamic> _$ListNoteClueToJson(ListNoteClue instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'id': instance.id,
      'remaining': instance.remaining,
    };

ListNoteClueResponse _$ListNoteClueResponseFromJson(
        Map<String, dynamic> json) =>
    ListNoteClueResponse(
      json['data'] == null
          ? null
          : ListNoteClue.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$ListNoteClueResponseToJson(
        ListNoteClueResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
