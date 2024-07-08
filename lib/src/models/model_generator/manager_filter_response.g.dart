// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_filter_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerFilterResponse _$ManagerFilterResponseFromJson(
        Map<String, dynamic> json) =>
    ManagerFilterResponse(
      data: json['data'] == null
          ? null
          : DataResponse.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$ManagerFilterResponseToJson(
        ManagerFilterResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };

DataResponse _$DataResponseFromJson(Map<String, dynamic> json) => DataResponse(
      (json['d'] as List<dynamic>?)
          ?.map((e) => ManagerResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$DataResponseToJson(DataResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'd': instance.d,
    };

ManagerResponse _$ManagerResponseFromJson(Map<String, dynamic> json) =>
    ManagerResponse(
      (json['children'] as List<dynamic>?)
          ?.map((e) => ManagerResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['attr'] == null
          ? null
          : AttrResponse.fromJson(json['attr'] as Map<String, dynamic>),
      json['data'] == null
          ? null
          : DataTwoResponse.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$ManagerResponseToJson(ManagerResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'children': instance.children,
      'attr': instance.attr,
      'data': instance.data,
    };

AttrResponse _$AttrResponseFromJson(Map<String, dynamic> json) => AttrResponse(
      json['id'] as String?,
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$AttrResponseToJson(AttrResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'id': instance.id,
    };

DataTwoResponse _$DataTwoResponseFromJson(Map<String, dynamic> json) =>
    DataTwoResponse(
      json['icon'] as String?,
      json['title'] as String?,
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$DataTwoResponseToJson(DataTwoResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'icon': instance.icon,
      'title': instance.title,
    };
