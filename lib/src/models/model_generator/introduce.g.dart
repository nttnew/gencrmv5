// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'introduce.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntroduceResponse _$IntroduceResponseFromJson(Map<String, dynamic> json) =>
    IntroduceResponse(
      code: json['code'] as int,
      message: json['message'] as String?,
      payload: IntroduceData.fromJson(json['payload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IntroduceResponseToJson(IntroduceResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'payload': instance.payload,
    };

IntroduceData _$IntroduceDataFromJson(Map<String, dynamic> json) =>
    IntroduceData(
      id: json['id'] as int,
      image: json['image'] as String,
      detail: json['detail'] as String,
    );

Map<String, dynamic> _$IntroduceDataToJson(IntroduceData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'detail': instance.detail,
    };
