// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogoResponse _$LogoResponseFromJson(Map<String, dynamic> json) => LogoResponse(
      code: json['code'] as int,
      message: json['message'] as String?,
      payload: LogoData.fromJson(json['payload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LogoResponseToJson(LogoResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'payload': instance.payload,
    };

LogoData _$LogoDataFromJson(Map<String, dynamic> json) => LogoData(
      id: json['id'] as int,
      imageLogo: json['image_logo'] as String,
    );

Map<String, dynamic> _$LogoDataToJson(LogoData instance) => <String, dynamic>{
      'id': instance.id,
      'image_logo': instance.imageLogo,
    };
