// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'params_change_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParamChangeInfo _$ParamChangeInfoFromJson(Map<String, dynamic> json) =>
    ParamChangeInfo(
      id: json['id'] as int,
      userCode: json['user_code'] as String,
      fullname: json['fullname'] as String,
      imageBase64: json['imageBase64'] as String?,
      phone: json['phone'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$ParamChangeInfoToJson(ParamChangeInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_code': instance.userCode,
      'fullname': instance.fullname,
      'imageBase64': instance.imageBase64,
      'phone': instance.phone,
      'email': instance.email,
      'gender': instance.gender,
      'address': instance.address,
    };

ParamChangeInfoNotImage _$ParamChangeInfoNotImageFromJson(
        Map<String, dynamic> json) =>
    ParamChangeInfoNotImage(
      id: json['id'] as int,
      userCode: json['user_code'] as String,
      fullname: json['fullname'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$ParamChangeInfoNotImageToJson(
        ParamChangeInfoNotImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_code': instance.userCode,
      'fullname': instance.fullname,
      'phone': instance.phone,
      'email': instance.email,
      'gender': instance.gender,
      'address': instance.address,
    };
