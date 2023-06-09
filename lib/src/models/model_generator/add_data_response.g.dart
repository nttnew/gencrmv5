// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddData _$AddDataFromJson(Map<String, dynamic> json) => AddData(
      json['id'],
    );

Map<String, dynamic> _$AddDataToJson(AddData instance) => <String, dynamic>{
      'id': instance.id,
    };

AddDataResponse _$AddDataResponseFromJson(Map<String, dynamic> json) =>
    AddDataResponse(
      json['data'] == null
          ? null
          : AddData.fromJson(json['data'] as Map<String, dynamic>),
      json['name'],
      json['id'],
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$AddDataResponseToJson(AddDataResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
      'name': instance.name,
      'id': instance.id,
    };

EditCusResponse _$EditCusResponseFromJson(Map<String, dynamic> json) =>
    EditCusResponse(
      json['idkh'] as String?,
      json['type'] as String?,
      json['success'] as bool?,
      json['code'] as int?,
      json['msg'] as String?,
    );

Map<String, dynamic> _$EditCusResponseToJson(EditCusResponse instance) =>
    <String, dynamic>{
      'idkh': instance.idkh,
      'type': instance.type,
      'msg': instance.msg,
      'success': instance.success,
      'code': instance.code,
    };
