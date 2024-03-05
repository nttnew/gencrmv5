// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clue_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailClue _$DetailClueFromJson(Map<String, dynamic> json) => DetailClue(
      (json['data'] as List<dynamic>?)
          ?.map((e) => InfoDataModel.fromJson(e as Map<String, dynamic>))
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
