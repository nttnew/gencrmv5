// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataNotification _$DataNotificationFromJson(Map<String, dynamic> json) =>
    DataNotification(
      json['id'] as String?,
      json['type'] as String?,
      json['title'] as String?,
      json['content'] as String?,
      json['link'] as String?,
      json['module'] as String?,
      json['record_id'] as String?,
    );

Map<String, dynamic> _$DataNotificationToJson(DataNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'content': instance.content,
      'link': instance.link,
      'module': instance.module,
      'record_id': instance.record_id,
    };

ListNotification _$ListNotificationFromJson(Map<String, dynamic> json) =>
    ListNotification(
      (json['list'] as List<dynamic>?)
          ?.map((e) => DataNotification.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['total'] as String?,
      (json['limit'] as num?)?.toInt(),
      json['page'] as String?,
    );

Map<String, dynamic> _$ListNotificationToJson(ListNotification instance) =>
    <String, dynamic>{
      'list': instance.list?.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
    };

ListNotificationResponse _$ListNotificationResponseFromJson(
        Map<String, dynamic> json) =>
    ListNotificationResponse(
      ListNotification.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$ListNotificationResponseToJson(
        ListNotificationResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data.toJson(),
    };
