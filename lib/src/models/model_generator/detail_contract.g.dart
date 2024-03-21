// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentContractItem _$PaymentContractItemFromJson(Map<String, dynamic> json) =>
    PaymentContractItem(
      json['field_name'] as String?,
      json['field_label'] as String?,
      json['field_value'],
      json['field_type'] as String?,
      json['field_hidden'] as int?,
      json['field_special'] as String?,
    );

Map<String, dynamic> _$PaymentContractItemToJson(
        PaymentContractItem instance) =>
    <String, dynamic>{
      'field_name': instance.field_name,
      'field_label': instance.field_label,
      'field_type': instance.field_type,
      'field_special': instance.field_special,
      'field_value': instance.field_value,
      'field_hidden': instance.field_hidden,
    };

PaymentContractResponse _$PaymentContractResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentContractResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>?)
              ?.map((e) =>
                  PaymentContractItem.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$PaymentContractResponseToJson(
        PaymentContractResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };

DetailContractResponse _$DetailContractResponseFromJson(
        Map<String, dynamic> json) =>
    DetailContractResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => InfoDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$DetailContractResponseToJson(
        DetailContractResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };

SupportContractData _$SupportContractDataFromJson(Map<String, dynamic> json) =>
    SupportContractData(
      json['id'] as String?,
      json['name'] as String?,
      json['status'] as String?,
      json['content'] as String?,
      json['created_date'] as String?,
      json['color'] as String?,
      json['total_note'] as String?,
      json['nguoi_tao'] as String?,
      json['khach_hang'] as String?,
      json['product_customer'] == null
          ? null
          : Customer.fromJson(json['product_customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SupportContractDataToJson(
        SupportContractData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'content': instance.content,
      'created_date': instance.created_date,
      'color': instance.color,
      'total_note': instance.total_note,
      'nguoi_tao': instance.nguoi_tao,
      'khach_hang': instance.khach_hang,
      'product_customer': instance.product_customer,
    };

SupportContractResponse _$SupportContractResponseFromJson(
        Map<String, dynamic> json) =>
    SupportContractResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => SupportContractData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$SupportContractResponseToJson(
        SupportContractResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
