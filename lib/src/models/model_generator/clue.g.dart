// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Email _$EmailFromJson(Map<String, dynamic> json) => Email(
      json['action'] as int?,
      json['val'] as String?,
    );

Map<String, dynamic> _$EmailToJson(Email instance) => <String, dynamic>{
      'val': instance.val,
      'action': instance.action,
    };

ClueData _$ClueDataFromJson(Map<String, dynamic> json) => ClueData(
      json['id'] as String?,
      json['name'] as String?,
      json['position'] == null
          ? null
          : Customer.fromJson(json['position'] as Map<String, dynamic>),
      json['email'] == null
          ? null
          : Email.fromJson(json['email'] as Map<String, dynamic>),
      json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      json['phone'] == null
          ? null
          : ActionModel.fromJson(json['phone'] as Map<String, dynamic>),
      json['created_date'] as String?,
      json['avatar'] as String?,
      json['total_note'] as String?,
    );

Map<String, dynamic> _$ClueDataToJson(ClueData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone?.toJson(),
      'email': instance.email?.toJson(),
      'position': instance.position?.toJson(),
      'customer': instance.customer?.toJson(),
      'created_date': instance.created_date,
      'avatar': instance.avatar,
      'total_note': instance.total_note,
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

ListClueData _$ListClueDataFromJson(Map<String, dynamic> json) => ListClueData(
      json['page'] as String?,
      json['total'] as String?,
      json['limit'] as int?,
      (json['list'] as List<dynamic>?)
          ?.map((e) => ClueData.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['filter'] as List<dynamic>?)
          ?.map((e) => FilterData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListClueDataToJson(ListClueData instance) =>
    <String, dynamic>{
      'page': instance.page,
      'total': instance.total,
      'limit': instance.limit,
      'list': instance.list,
      'filter': instance.filter,
    };

ListClueResponse _$ListClueResponseFromJson(Map<String, dynamic> json) =>
    ListClueResponse(
      data: json['data'] == null
          ? null
          : ListClueData.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$ListClueResponseToJson(ListClueResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
