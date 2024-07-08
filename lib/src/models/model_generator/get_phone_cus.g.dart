// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_phone_cus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPhoneCusResponse _$GetPhoneCusResponseFromJson(Map<String, dynamic> json) =>
    GetPhoneCusResponse(
      json['data'] as String?,
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$GetPhoneCusResponseToJson(
        GetPhoneCusResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
