// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_chance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListDetailChanceResponse _$ListDetailChanceResponseFromJson(
        Map<String, dynamic> json) =>
    ListDetailChanceResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => InfoDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['location'] as int?,
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
      'location': instance.location,
    };
