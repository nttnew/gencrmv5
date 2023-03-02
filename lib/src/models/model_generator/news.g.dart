// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListNewsResponse _$ListNewsResponseFromJson(Map<String, dynamic> json) =>
    ListNewsResponse(
      code: json['code'] as int,
      message: json['message'] as String?,
      payload: (json['payload'] as List<dynamic>)
          .map((e) => NewsData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListNewsResponseToJson(ListNewsResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'payload': instance.payload,
    };

NewsData _$NewsDataFromJson(Map<String, dynamic> json) => NewsData(
      id: json['id'] as int,
      newCode: json['new_code'] as String,
      image: json['image'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      detail: json['detail'] as String,
      createdDate: json['created_date'] as String,
    );

Map<String, dynamic> _$NewsDataToJson(NewsData instance) => <String, dynamic>{
      'id': instance.id,
      'new_code': instance.newCode,
      'image': instance.image,
      'category': instance.category,
      'title': instance.title,
      'detail': instance.detail,
      'created_date': instance.createdDate,
    };
