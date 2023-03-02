// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_infor_acc_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeInforAccRequest _$ChangeInforAccRequestFromJson(
        Map<String, dynamic> json) =>
    ChangeInforAccRequest(
      ho_va_ten: json['ho_va_ten'] as String,
      email: json['email'] as String,
      dien_thoai: json['dien_thoai'] as String,
      dia_chi: json['dia_chi'] as String,
      avatar: json['avatar'] as String,
    );

Map<String, dynamic> _$ChangeInforAccRequestToJson(
        ChangeInforAccRequest instance) =>
    <String, dynamic>{
      'ho_va_ten': instance.ho_va_ten,
      'email': instance.email,
      'dien_thoai': instance.dien_thoai,
      'dia_chi': instance.dia_chi,
      'avatar': instance.avatar,
    };
