// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractItemData _$ContractItemDataFromJson(Map<String, dynamic> json) =>
    ContractItemData(
      json['id'] as String?,
      json['name'] as String?,
      json['price'],
      json['status'] as String?,
      json['status_edit'] as String?,
      json['status_color'] as String?,
      json['avatar'] as String?,
      json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      json['product_customer'] == null
          ? null
          : Customer.fromJson(json['product_customer'] as Map<String, dynamic>),
      json['total_note'] as String?,
      json['conlai'] as String?,
    );

Map<String, dynamic> _$ContractItemDataToJson(ContractItemData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'status_edit': instance.status_edit,
      'status_color': instance.status_color,
      'avatar': instance.avatar,
      'total_note': instance.total_note,
      'conlai': instance.conlai,
      'price': instance.price,
      'customer': instance.customer,
      'product_customer': instance.product_customer,
    };

ContractData _$ContractDataFromJson(Map<String, dynamic> json) => ContractData(
      (json['list'] as List<dynamic>?)
          ?.map((e) => ContractItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['page'] as String?,
      json['total'] as String?,
      (json['limit'] as num?)?.toInt(),
      (json['filter'] as List<dynamic>?)
          ?.map((e) => Customer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContractDataToJson(ContractData instance) =>
    <String, dynamic>{
      'list': instance.list,
      'filter': instance.filter,
      'page': instance.page,
      'total': instance.total,
      'limit': instance.limit,
    };

ContractResponse _$ContractResponseFromJson(Map<String, dynamic> json) =>
    ContractResponse(
      json['data'] == null
          ? null
          : ContractData.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success']
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$ContractResponseToJson(ContractResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
