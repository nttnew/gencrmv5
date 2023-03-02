// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_pass_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePassRequest _$UpdatePassRequestFromJson(Map<String, dynamic> json) =>
    UpdatePassRequest(
      oldpass: json['oldpass'] as String,
      newpass: json['newpass'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$UpdatePassRequestToJson(UpdatePassRequest instance) =>
    <String, dynamic>{
      'oldpass': instance.oldpass,
      'newpass': instance.newpass,
      'username': instance.username,
    };
