// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clue_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataClueGroupName _$DataClueGroupNameFromJson(Map<String, dynamic> json) =>
    DataClueGroupName(
      json['label_field'] as String?,
      json['id'] as String?,
      json['link'] as String?,
      json['value_field'] as String?,
    );

Map<String, dynamic> _$DataClueGroupNameToJson(DataClueGroupName instance) =>
    <String, dynamic>{
      'label_field': instance.label_field,
      'id': instance.id,
      'link': instance.link,
      'value_field': instance.value_field,
    };

DetailClueGroupName _$DetailClueGroupNameFromJson(Map<String, dynamic> json) =>
    DetailClueGroupName(
      json['group_name'] as String?,
      json['mup'] as int?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => DataClueGroupName.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['main_id'] as String?,
      json['avatar'] as String?,
    );

Map<String, dynamic> _$DetailClueGroupNameToJson(
        DetailClueGroupName instance) =>
    <String, dynamic>{
      'group_name': instance.group_name,
      'mup': instance.mup,
      'data': instance.data,
      'main_id': instance.main_id,
      'avatar': instance.avatar,
    };

DetailClue _$DetailClueFromJson(Map<String, dynamic> json) => DetailClue(
      (json['data'] as List<dynamic>?)
          ?.map((e) => DetailClueGroupName.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$DetailClueToJson(DetailClue instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
