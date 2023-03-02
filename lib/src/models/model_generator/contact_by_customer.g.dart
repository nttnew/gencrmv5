// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_by_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactByCustomerResponse _$ContactByCustomerResponseFromJson(
        Map<String, dynamic> json) =>
    ContactByCustomerResponse(
      (json['data'] as List<dynamic>?)?.map((e) => e as List<dynamic>).toList(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$ContactByCustomerResponseToJson(
        ContactByCustomerResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
