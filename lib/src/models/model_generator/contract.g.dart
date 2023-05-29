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
          : CustomerContract.fromJson(json['customer'] as Map<String, dynamic>),
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
    };

CustomerContract _$CustomerContractFromJson(Map<String, dynamic> json) =>
    CustomerContract(
      json['id'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$CustomerContractToJson(CustomerContract instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ContractData _$ContractDataFromJson(Map<String, dynamic> json) => ContractData(
      (json['list'] as List<dynamic>?)
          ?.map((e) => ContractItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['page'] as String?,
      json['total'] as int?,
      json['limit'] as int?,
      (json['filter'] as List<dynamic>?)
          ?.map((e) => FilterData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContractDataToJson(ContractData instance) =>
    <String, dynamic>{
      'list': instance.list,
      'filter': instance.filter,
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
    };

ContractResponse _$ContractResponseFromJson(Map<String, dynamic> json) =>
    ContractResponse(
      ContractData.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$ContractResponseToJson(ContractResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
