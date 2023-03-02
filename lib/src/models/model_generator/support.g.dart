// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportItemData _$SupportItemDataFromJson(Map<String, dynamic> json) =>
    SupportItemData(
      json['id'] as String?,
      json['ten_ho_tro'] as String?,
      json['created_date'] as String?,
      json['trang_thai'] as String?,
      json['color'] as String?,
      json['total_note'] as String?,
      json['customer'] == null
          ? null
          : CustomerData.fromJson(json['customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SupportItemDataToJson(SupportItemData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ten_ho_tro': instance.ten_ho_tro,
      'created_date': instance.created_date,
      'trang_thai': instance.trang_thai,
      'color': instance.color,
      'total_note': instance.total_note,
      'customer': instance.customer,
    };

CustomerData _$CustomerDataFromJson(Map<String, dynamic> json) => CustomerData(
      json['id'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$CustomerDataToJson(CustomerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

SupportData _$SupportDataFromJson(Map<String, dynamic> json) => SupportData(
      json['page'] as String?,
      json['total'] as String?,
      json['limit'] as int?,
      (json['list'] as List<dynamic>?)
          ?.map((e) => SupportItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['filter'] as List<dynamic>?)
          ?.map((e) => FilterData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SupportDataToJson(SupportData instance) =>
    <String, dynamic>{
      'page': instance.page,
      'total': instance.total,
      'limit': instance.limit,
      'list': instance.list,
      'filter': instance.filter,
    };

SupportResponse _$SupportResponseFromJson(Map<String, dynamic> json) =>
    SupportResponse(
      SupportData.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$SupportResponseToJson(SupportResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
