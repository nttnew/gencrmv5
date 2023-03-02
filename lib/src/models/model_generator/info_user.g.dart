// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoUser _$InfoUserFromJson(Map<String, dynamic> json) => InfoUser(
      id: json['id'] as int?,
      userCode: json['user_code'] as String?,
      fullName: json['fullname'] as String?,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      token: json['token'] as String?,
      otpCode: json['otp_code'] as String?,
      deviceToken: json['device_token'] as String?,
    );

Map<String, dynamic> _$InfoUserToJson(InfoUser instance) => <String, dynamic>{
      'id': instance.id,
      'user_code': instance.userCode,
      'fullname': instance.fullName,
      'phone': instance.phone,
      'gender': instance.gender,
      'address': instance.address,
      'email': instance.email,
      'role': instance.role,
      'token': instance.token,
      'avatar': instance.avatar,
      'otp_code': instance.otpCode,
      'device_token': instance.deviceToken,
    };
