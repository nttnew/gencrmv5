// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse(
      success: json['success'] as bool?,
      msg: json['msg'] as String?,
      code: (json['code'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
    };
