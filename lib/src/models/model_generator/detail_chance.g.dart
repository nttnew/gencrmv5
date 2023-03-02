// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_chance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataContentChance _$DataContentChanceFromJson(Map<String, dynamic> json) =>
    DataContentChance(
      json['id'] as String?,
      json['label_field'] as String?,
      json['value_field'] as String?,
      json['link'] as String?,
    );

Map<String, dynamic> _$DataContentChanceToJson(DataContentChance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label_field': instance.label_field,
      'value_field': instance.value_field,
      'link': instance.link,
    };

DataDetailChance _$DataDetailChanceFromJson(Map<String, dynamic> json) =>
    DataDetailChance(
      json['mup'] as int?,
      json['group_name'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => DataContentChance.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['main_id'] as String?,
      json['avatar'] as String?,
    );

Map<String, dynamic> _$DataDetailChanceToJson(DataDetailChance instance) =>
    <String, dynamic>{
      'mup': instance.mup,
      'group_name': instance.group_name,
      'main_id': instance.main_id,
      'avatar': instance.avatar,
      'data': instance.data,
    };

ListDetailChanceResponse _$ListDetailChanceResponseFromJson(
        Map<String, dynamic> json) =>
    ListDetailChanceResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => DataDetailChance.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$ListDetailChanceResponseToJson(
        ListDetailChanceResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
