// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'params_change_password.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParamChangePassword _$ParamChangePasswordFromJson(Map<String, dynamic> json) =>
    ParamChangePassword(
      oldPass: json['old_password'] as String,
      newPass: json['password_new'] as String,
      repeatPass: json['password_new_confirmation'] as String,
    );

Map<String, dynamic> _$ParamChangePasswordToJson(
        ParamChangePassword instance) =>
    <String, dynamic>{
      'old_password': instance.oldPass,
      'password_new': instance.newPass,
      'password_new_confirmation': instance.repeatPass,
    };

Timestamp _$TimestampFromJson(Map<String, dynamic> json) => Timestamp(
      json['timestamp'] as String?,
    );

Map<String, dynamic> _$TimestampToJson(Timestamp instance) => <String, dynamic>{
      'timestamp': instance.timestamp,
    };

ParamForgotPassword _$ParamForgotPasswordFromJson(Map<String, dynamic> json) =>
    ParamForgotPassword(
      json['data'] == null
          ? null
          : Timestamp.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$ParamForgotPasswordToJson(
        ParamForgotPassword instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };

CodeOtp _$CodeOtpFromJson(Map<String, dynamic> json) => CodeOtp(
      json['timestamp'] as String?,
    );

Map<String, dynamic> _$CodeOtpToJson(CodeOtp instance) => <String, dynamic>{
      'timestamp': instance.timestamp,
    };

ParamForgotPasswordOtp _$ParamForgotPasswordOtpFromJson(
        Map<String, dynamic> json) =>
    ParamForgotPasswordOtp(
      json['data'] == null
          ? null
          : CodeOtp.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$ParamForgotPasswordOtpToJson(
        ParamForgotPasswordOtp instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };

ParamRequestForgotPassword _$ParamRequestForgotPasswordFromJson(
        Map<String, dynamic> json) =>
    ParamRequestForgotPassword(
      email: json['email'] as String,
      username: json['username'] as String,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$ParamRequestForgotPasswordToJson(
        ParamRequestForgotPassword instance) =>
    <String, dynamic>{
      'email': instance.email,
      'username': instance.username,
      'timestamp': instance.timestamp,
    };

ParamRequestForgotPasswordOtp _$ParamRequestForgotPasswordOtpFromJson(
        Map<String, dynamic> json) =>
    ParamRequestForgotPasswordOtp(
      timestamp: json['timestamp'] as String,
      email: json['email'] as String,
      code: json['code'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$ParamRequestForgotPasswordOtpToJson(
        ParamRequestForgotPasswordOtp instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'code': instance.code,
      'email': instance.email,
      'username': instance.username,
    };

ParamResetPassword _$ParamResetPasswordFromJson(Map<String, dynamic> json) =>
    ParamResetPassword(
      email: json['email'] as String,
      newPass: json['newPass'] as String,
      timestamp: json['timestamp'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$ParamResetPasswordToJson(ParamResetPassword instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'newPass': instance.newPass,
      'email': instance.email,
      'username': instance.username,
    };
