// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'first_intro.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirstIntroResponse _$FirstIntroResponseFromJson(Map<String, dynamic> json) =>
    FirstIntroResponse(
      code: json['code'] as int,
      message: json['message'] as String?,
      payload: (json['payload'] as List<dynamic>)
          .map((e) => FirstIntroData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FirstIntroResponseToJson(FirstIntroResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'payload': instance.payload,
    };

FirstIntroData _$FirstIntroDataFromJson(Map<String, dynamic> json) =>
    FirstIntroData(
      id: json['id'] as int,
      introductionCode: json['introduction_code'] as String,
      image: json['image'] as String,
      title: json['title'] as String,
      detail: json['detail'] as String,
    );

Map<String, dynamic> _$FirstIntroDataToJson(FirstIntroData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'introduction_code': instance.introductionCode,
      'image': instance.image,
      'title': instance.title,
      'detail': instance.detail,
    };
