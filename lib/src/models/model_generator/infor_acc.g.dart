// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infor_acc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InforAcc _$InforAccFromJson(Map<String, dynamic> json) => InforAcc(
      json['user_id'] as String?,
      json['fullname'] as String?,
      json['email'] as String?,
      json['phone'] as String?,
      json['avatar'] as String?,
      json['address'] as String?,
    );

Map<String, dynamic> _$InforAccToJson(InforAcc instance) => <String, dynamic>{
      'user_id': instance.user_id,
      'fullname': instance.fullname,
      'email': instance.email,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'address': instance.address,
    };

InforAccResponse _$InforAccResponseFromJson(Map<String, dynamic> json) =>
    InforAccResponse(
      json['data'] == null
          ? null
          : InforAcc.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$InforAccResponseToJson(InforAccResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data?.toJson(),
    };
