// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerContractResponse _$CustomerContractResponseFromJson(
        Map<String, dynamic> json) =>
    CustomerContractResponse(
      (json['data'] as List<dynamic>?)?.map((e) => e as List<dynamic>).toList(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$CustomerContractResponseToJson(
        CustomerContractResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
