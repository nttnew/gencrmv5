// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkItemData _$WorkItemDataFromJson(Map<String, dynamic> json) => WorkItemData(
      json['id'] as String?,
      (json['total_comment'] as num?)?.toInt(),
      json['id_customer'] as String?,
      json['name_job'] as String?,
      json['content_job'] as String?,
      json['user_work_id'] as String?,
      json['user_work_name'] as String?,
      json['user_work_avatar'] as String?,
      json['name_customer'] as String?,
      json['status_job'] as String?,
      json['status_id'] as String?,
      json['status_color'] as String?,
      json['start_date'] as String?,
      json['location'] as String?,
      json['di_dong'] as String?,
      json['recording_url'] as String?,
      json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      json['product_customer'] == null
          ? null
          : Customer.fromJson(json['product_customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkItemDataToJson(WorkItemData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'total_comment': instance.total_comment,
      'id_customer': instance.id_customer,
      'name_job': instance.name_job,
      'content_job': instance.content_job,
      'user_work_id': instance.user_work_id,
      'user_work_name': instance.user_work_name,
      'user_work_avatar': instance.user_work_avatar,
      'name_customer': instance.name_customer,
      'status_job': instance.status_job,
      'status_id': instance.status_id,
      'status_color': instance.status_color,
      'start_date': instance.start_date,
      'location': instance.location,
      'di_dong': instance.di_dong,
      'recording_url': instance.recording_url,
      'customer': instance.customer,
      'product_customer': instance.product_customer,
    };

WorkData _$WorkDataFromJson(Map<String, dynamic> json) => WorkData(
      (json['data_list'] as List<dynamic>?)
          ?.map((e) => WorkItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['pageCount'] as num?)?.toInt(),
      (json['data_filter'] as List<dynamic>?)
          ?.map((e) => Customer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkDataToJson(WorkData instance) => <String, dynamic>{
      'data_list': instance.data_list,
      'pageCount': instance.pageCount,
      'data_filter': instance.data_filter,
    };

WorkResponse _$WorkResponseFromJson(Map<String, dynamic> json) => WorkResponse(
      json['data'] == null
          ? null
          : WorkData.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$WorkResponseToJson(WorkResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };

DetailWorkResponse _$DetailWorkResponseFromJson(Map<String, dynamic> json) =>
    DetailWorkResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => InfoDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['location'] as num?)?.toInt(),
      json['di_dong'] as String?,
      json['recording_url'] as String?,
      json['checkin'] == null
          ? null
          : CheckInLocation.fromJson(json['checkin'] as Map<String, dynamic>),
      json['checkout'] == null
          ? null
          : CheckInLocation.fromJson(json['checkout'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$DetailWorkResponseToJson(DetailWorkResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
      'location': instance.location,
      'di_dong': instance.di_dong,
      'recording_url': instance.recording_url,
      'checkin': instance.checkin,
      'checkout': instance.checkout,
    };

CheckInLocation _$CheckInLocationFromJson(Map<String, dynamic> json) =>
    CheckInLocation(
      json['latitude'] as String?,
      json['longitude'] as String?,
      json['note_location'] as String?,
      json['time'] as String?,
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$CheckInLocationToJson(CheckInLocation instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'note_location': instance.note_location,
      'time': instance.time,
    };
