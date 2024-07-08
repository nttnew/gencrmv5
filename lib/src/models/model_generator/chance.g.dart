// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListChanceData _$ListChanceDataFromJson(Map<String, dynamic> json) =>
    ListChanceData(
      json['id'] as String?,
      json['name'] as String?,
      json['price'] as String?,
      json['status'] as String?,
      json['avatar'] as String?,
      json['color'] as String?,
      json['dateNextCare'] as String?,
      json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      json['product_customer'] == null
          ? null
          : Customer.fromJson(json['product_customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListChanceDataToJson(ListChanceData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateNextCare': instance.dateNextCare,
      'name': instance.name,
      'price': instance.price,
      'status': instance.status,
      'avatar': instance.avatar,
      'color': instance.color,
      'customer': instance.customer,
      'product_customer': instance.product_customer,
    };

DataChance _$DataChanceFromJson(Map<String, dynamic> json) => DataChance(
      json['page'] as String?,
      (json['limit'] as num?)?.toInt(),
      json['total'] as String?,
      (json['filter'] as List<dynamic>?)
          ?.map((e) => Customer.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['list'] as List<dynamic>?)
          ?.map((e) => ListChanceData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataChanceToJson(DataChance instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'list': instance.list,
      'filter': instance.filter,
    };

ListChanceResponse _$ListChanceResponseFromJson(Map<String, dynamic> json) =>
    ListChanceResponse(
      json['data'] == null
          ? null
          : DataChance.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$ListChanceResponseToJson(ListChanceResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
