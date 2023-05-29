// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerData _$CustomerDataFromJson(Map<String, dynamic> json) => CustomerData(
      json['id'] as String?,
      json['name'] as String?,
      json['phone'] as String?,
      json['rank_type'] as String?,
      json['danh_xung'] as String?,
      json['color'] as String?,
      json['cap_khach_hang'] as String?,
      json['muc_do_tiem_nang'] as String?,
      json['address'] as String?,
      json['avatar'] as String?,
      json['is_company'] as bool?,
      json['rank_max_level'] as int?,
      json['rank_value'] as int?,
      json['total_comment'] as int?,
      json['email'] as String?,
      json['tong_so_hop_dong'] as int?,
    );

Map<String, dynamic> _$CustomerDataToJson(CustomerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'rank_type': instance.rank_type,
      'danh_xung': instance.danh_xung,
      'color': instance.color,
      'cap_khach_hang': instance.cap_khach_hang,
      'muc_do_tiem_nang': instance.muc_do_tiem_nang,
      'address': instance.address,
      'avatar': instance.avatar,
      'is_company': instance.is_company,
      'rank_max_level': instance.rank_max_level,
      'rank_value': instance.rank_value,
      'total_comment': instance.total_comment,
      'tong_so_hop_dong': instance.tong_so_hop_dong,
      'phone': instance.phone,
      'email': instance.email,
    };

ActionData _$ActionDataFromJson(Map<String, dynamic> json) => ActionData(
      json['val'] as String?,
      json['action'] as int?,
    );

Map<String, dynamic> _$ActionDataToJson(ActionData instance) =>
    <String, dynamic>{
      'val': instance.val,
      'action': instance.action,
    };

FilterData _$FilterDataFromJson(Map<String, dynamic> json) => FilterData(
      json['id'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$FilterDataToJson(FilterData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ListCustomerData _$ListCustomerDataFromJson(Map<String, dynamic> json) =>
    ListCustomerData(
      json['page'] as String?,
      json['total'] as int?,
      json['limit'] as int?,
      (json['list'] as List<dynamic>?)
          ?.map((e) => CustomerData.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['filter'] as List<dynamic>?)
          ?.map((e) => FilterData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListCustomerDataToJson(ListCustomerData instance) =>
    <String, dynamic>{
      'page': instance.page,
      'total': instance.total,
      'limit': instance.limit,
      'list': instance.list,
      'filter': instance.filter,
    };

ListCustomerResponse _$ListCustomerResponseFromJson(
        Map<String, dynamic> json) =>
    ListCustomerResponse(
      json['data'] == null
          ? null
          : ListCustomerData.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$ListCustomerResponseToJson(
        ListCustomerResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
