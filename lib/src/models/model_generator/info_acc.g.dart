// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_acc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoAcc _$InfoAccFromJson(Map<String, dynamic> json) => InfoAcc(
      json['user_id'] as String?,
      json['fullname'] as String?,
      json['email'] as String?,
      json['phone'] as String?,
      json['avatar'] as String?,
      json['address'] as String?,
      json['department_name'] as String?,
      json['ten_cong_ty'] as String?,
      json['ten_viet_tat'] as String?,
    );

Map<String, dynamic> _$InfoAccToJson(InfoAcc instance) => <String, dynamic>{
      'user_id': instance.user_id,
      'fullname': instance.fullname,
      'email': instance.email,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'address': instance.address,
      'department_name': instance.department_name,
      'ten_cong_ty': instance.ten_cong_ty,
      'ten_viet_tat': instance.ten_viet_tat,
    };

InfoAccResponse _$InfoAccResponseFromJson(Map<String, dynamic> json) =>
    InfoAccResponse(
      json['data'] == null
          ? null
          : InfoAcc.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$InfoAccResponseToJson(InfoAccResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data?.toJson(),
    };
