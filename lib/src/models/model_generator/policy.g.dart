// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PolicyData _$PolicyDataFromJson(Map<String, dynamic> json) => PolicyData(
      chinh_sach: json['chinh_sach'] as String?,
    );

Map<String, dynamic> _$PolicyDataToJson(PolicyData instance) =>
    <String, dynamic>{
      'chinh_sach': instance.chinh_sach,
    };

PolicyResponse _$PolicyResponseFromJson(Map<String, dynamic> json) =>
    PolicyResponse(
      json['data'] == null
          ? null
          : PolicyData.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$PolicyResponseToJson(PolicyResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data?.toJson(),
    };
