// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractCustomerData _$ContractCustomerDataFromJson(
        Map<String, dynamic> json) =>
    ContractCustomerData(
      json['id'] as String?,
      json['name'] as String?,
      json['status'] as String?,
      json['ngay_ky'] as String?,
      json['total_value'] as String?,
      json['customer_name'] as String?,
      json['color'] as String?,
      json['total_note'] as String?,
      json['product_customer'] == null
          ? null
          : Customer.fromJson(json['product_customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContractCustomerDataToJson(
        ContractCustomerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'ngay_ky': instance.ngay_ky,
      'total_value': instance.total_value,
      'customer_name': instance.customer_name,
      'color': instance.color,
      'total_note': instance.total_note,
      'product_customer': instance.product_customer,
    };

ContractCustomerResponse _$ContractCustomerResponseFromJson(
        Map<String, dynamic> json) =>
    ContractCustomerResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => ContractCustomerData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$ContractCustomerResponseToJson(
        ContractCustomerResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
