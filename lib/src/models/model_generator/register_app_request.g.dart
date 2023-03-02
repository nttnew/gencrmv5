// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_app_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterAppRequest _$RegisterAppRequestFromJson(Map<String, dynamic> json) =>
    RegisterAppRequest(
      fullname: json['fullname'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$RegisterAppRequestToJson(RegisterAppRequest instance) =>
    <String, dynamic>{
      'fullname': instance.fullname,
      'email': instance.email,
      'password': instance.password,
    };
