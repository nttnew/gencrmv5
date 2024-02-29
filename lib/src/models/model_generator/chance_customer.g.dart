// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chance_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChanceCustomerData _$ChanceCustomerDataFromJson(Map<String, dynamic> json) =>
    ChanceCustomerData(
      json['id'] as String?,
      json['name'] as String?,
      json['sale'] as String?,
      json['total_note'] as String?,
      json['status'] as String?,
      json['color'] as String?,
      json['customer_name'] as String?,
      json['date'] as String?,
      json['product_customer'] == null
          ? null
          : Customer.fromJson(json['product_customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChanceCustomerDataToJson(ChanceCustomerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sale': instance.sale,
      'total_note': instance.total_note,
      'status': instance.status,
      'color': instance.color,
      'customer_name': instance.customer_name,
      'date': instance.date,
      'product_customer': instance.product_customer,
    };

ChanceCustomerResponse _$ChanceCustomerResponseFromJson(
        Map<String, dynamic> json) =>
    ChanceCustomerResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => ChanceCustomerData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$ChanceCustomerResponseToJson(
        ChanceCustomerResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
