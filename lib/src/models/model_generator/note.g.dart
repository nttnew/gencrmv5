// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteItem _$NoteItemFromJson(Map<String, dynamic> json) => NoteItem(
      json['uid'],
      json['uname'] as String?,
      json['noteid'] as String?,
      json['avatar'] as String?,
      json['content'] as String?,
      json['createdtime'] as String?,
      json['passedtime'] as String?,
    );

Map<String, dynamic> _$NoteItemToJson(NoteItem instance) => <String, dynamic>{
      'uid': instance.uid,
      'uname': instance.uname,
      'noteid': instance.noteid,
      'avatar': instance.avatar,
      'content': instance.content,
      'createdtime': instance.createdtime,
      'passedtime': instance.passedtime,
    };

NoteData _$NoteDataFromJson(Map<String, dynamic> json) => NoteData(
      (json['notes'] as List<dynamic>?)
          ?.map((e) => NoteItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['id'] as String?,
      (json['remaining'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NoteDataToJson(NoteData instance) => <String, dynamic>{
      'notes': instance.notes,
      'id': instance.id,
      'remaining': instance.remaining,
    };

NoteResponse _$NoteResponseFromJson(Map<String, dynamic> json) => NoteResponse(
      json['data'] == null
          ? null
          : NoteData.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$NoteResponseToJson(NoteResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
