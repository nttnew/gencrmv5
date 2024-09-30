// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_uss.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataAboutUs _$DataAboutUsFromJson(Map<String, dynamic> json) => DataAboutUs(
      json['gioi_thieu'] as String?,
    );

Map<String, dynamic> _$DataAboutUsToJson(DataAboutUs instance) =>
    <String, dynamic>{
      'gioi_thieu': instance.gioi_thieu,
    };

AboutUsResponse _$AboutUsResponseFromJson(Map<String, dynamic> json) =>
    AboutUsResponse(
      json['data'] == null
          ? null
          : DataAboutUs.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success']
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$AboutUsResponseToJson(AboutUsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
