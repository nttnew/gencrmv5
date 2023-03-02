// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_app_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginAppRequest _$LoginAppRequestFromJson(Map<String, dynamic> json) =>
    LoginAppRequest(
      email: json['uname'] as String,
      password: json['pass'] as String,
      device_token: json['device_token'] as String,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$LoginAppRequestToJson(LoginAppRequest instance) =>
    <String, dynamic>{
      'uname': instance.email,
      'pass': instance.password,
      'device_token': instance.device_token,
      'platform': instance.platform,
    };
