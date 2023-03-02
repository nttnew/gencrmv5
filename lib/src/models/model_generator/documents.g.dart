// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListDocumentsResponse _$ListDocumentsResponseFromJson(
        Map<String, dynamic> json) =>
    ListDocumentsResponse(
      code: json['code'] as int,
      message: json['message'] as String?,
      payload: (json['payload'] as List<dynamic>)
          .map((e) => ListDocumentsData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListDocumentsResponseToJson(
        ListDocumentsResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'payload': instance.payload,
    };

ListDocumentsData _$ListDocumentsDataFromJson(Map<String, dynamic> json) =>
    ListDocumentsData(
      documentationDtlCode: json['documentations_dtl_code'] as String,
      documentationCode: json['documentation_code'] as String,
      image: json['image'] as String,
      summary: json['summary'] as String,
      title: json['title'] as String,
      createdDate: json['created_date'] as String,
    );

Map<String, dynamic> _$ListDocumentsDataToJson(ListDocumentsData instance) =>
    <String, dynamic>{
      'documentation_code': instance.documentationCode,
      'documentations_dtl_code': instance.documentationDtlCode,
      'image': instance.image,
      'summary': instance.summary,
      'title': instance.title,
      'created_date': instance.createdDate,
    };
