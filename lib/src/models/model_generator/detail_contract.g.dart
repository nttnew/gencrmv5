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

DetailContractItem _$DetailContractItemFromJson(Map<String, dynamic> json) =>
    DetailContractItem(
      json['label_field'] as String?,
      json['id'] as String?,
      json['value_field'] as String?,
      json['is_link'] as bool?,
      json['field_type'] as String?,
      json['link'] as String?,
    );

Map<String, dynamic> _$DetailContractItemToJson(DetailContractItem instance) =>
    <String, dynamic>{
      'label_field': instance.label_field,
      'id': instance.id,
      'value_field': instance.value_field,
      'field_type': instance.field_type,
      'link': instance.link,
      'is_link': instance.is_link,
    };

DetailContractData _$DetailContractDataFromJson(Map<String, dynamic> json) =>
    DetailContractData(
      json['group_name'] as String?,
      json['mup'] as int?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => DetailContractItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['listFile'] as List<dynamic>?)
          ?.map((e) => AttachFile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DetailContractDataToJson(DetailContractData instance) =>
    <String, dynamic>{
      'group_name': instance.group_name,
      'mup': instance.mup,
      'data': instance.data,
      'listFile': instance.listFile,
    };

DetailContractResponse _$DetailContractResponseFromJson(
        Map<String, dynamic> json) =>
    DetailContractResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => DetailContractData.fromJson(e as Map<String, dynamic>))
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
