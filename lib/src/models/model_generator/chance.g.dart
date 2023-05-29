// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataCustomer _$DataCustomerFromJson(Map<String, dynamic> json) => DataCustomer(
      json['id'] as String?,
      json['name'] as String?,
      json['danh_xung'] as String?,
    );

Map<String, dynamic> _$DataCustomerToJson(DataCustomer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'danh_xung': instance.danh_xung,
    };

ListChanceData _$ListChanceDataFromJson(Map<String, dynamic> json) =>
    ListChanceData(
      json['id'] as String?,
      json['name'] as String?,
      json['price'] as String?,
      json['status'],
      json['avatar'] as String?,
      json['dateNextCare'] as String?,
      json['customer'] == null
          ? null
          : DataCustomer.fromJson(json['customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListChanceDataToJson(ListChanceData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateNextCare': instance.dateNextCare,
      'name': instance.name,
      'price': instance.price,
      'avatar': instance.avatar,
      'customer': instance.customer,
      'status': instance.status,
    };

FilterChance _$FilterChanceFromJson(Map<String, dynamic> json) => FilterChance(
      json['id'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$FilterChanceToJson(FilterChance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

DataChance _$DataChanceFromJson(Map<String, dynamic> json) => DataChance(
      json['page'] as String,
      json['limit'] as int?,
      json['total'] as int?,
      (json['filter'] as List<dynamic>?)
          ?.map((e) => FilterChance.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['list'] as List<dynamic>?)
          ?.map((e) => ListChanceData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataChanceToJson(DataChance instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
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
      ..code = json['code'] as int?;

Map<String, dynamic> _$ListChanceResponseToJson(ListChanceResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
