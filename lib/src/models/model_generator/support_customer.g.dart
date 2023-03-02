// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportCustomerData _$SupportCustomerDataFromJson(Map<String, dynamic> json) =>
    SupportCustomerData(
      json['id'] as String?,
      json['name'] as String?,
      json['status'] as String?,
      json['status_id'] as String?,
      json['start_date'] as String?,
      json['user_handling'] as String?,
      json['color'] as String?,
      json['total_note'] as String?,
    );

Map<String, dynamic> _$SupportCustomerDataToJson(
        SupportCustomerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'status_id': instance.status_id,
      'start_date': instance.start_date,
      'user_handling': instance.user_handling,
      'color': instance.color,
      'total_note': instance.total_note,
    };

SupportCustomerResponse _$SupportCustomerResponseFromJson(
        Map<String, dynamic> json) =>
    SupportCustomerResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => SupportCustomerData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$SupportCustomerResponseToJson(
        SupportCustomerResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
