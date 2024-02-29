// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clue_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClueCustomerData _$ClueCustomerDataFromJson(Map<String, dynamic> json) =>
    ClueCustomerData(
      json['id'] as String?,
      json['name'] as String?,
      json['phone'] == null
          ? null
          : ActionModel.fromJson(json['phone'] as Map<String, dynamic>),
      json['danh_xung'] as String?,
      json['position'] == null
          ? null
          : Position.fromJson(json['position'] as Map<String, dynamic>),
      json['email'] == null
          ? null
          : ActionModel.fromJson(json['email'] as Map<String, dynamic>),
      json['total_note'] as String?,
    );

Map<String, dynamic> _$ClueCustomerDataToJson(ClueCustomerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'danh_xung': instance.danh_xung,
      'total_note': instance.total_note,
      'position': instance.position,
      'phone': instance.phone,
      'email': instance.email,
    };

Position _$PositionFromJson(Map<String, dynamic> json) => Position(
      json['id'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$PositionToJson(Position instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ClueCustomerResponse _$ClueCustomerResponseFromJson(
        Map<String, dynamic> json) =>
    ClueCustomerResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => ClueCustomerData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$ClueCustomerResponseToJson(
        ClueCustomerResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
