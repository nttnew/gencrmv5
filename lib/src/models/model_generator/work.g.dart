// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkItemData _$WorkItemDataFromJson(Map<String, dynamic> json) => WorkItemData(
      json['id'] as String?,
      json['total_comment'] as int?,
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
    };

FilterData _$FilterDataFromJson(Map<String, dynamic> json) => FilterData(
      json['id'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$FilterDataToJson(FilterData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

WorkData _$WorkDataFromJson(Map<String, dynamic> json) => WorkData(
      (json['data_list'] as List<dynamic>?)
          ?.map((e) => WorkItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['pageCount'] as int?,
      (json['data_filter'] as List<dynamic>?)
          ?.map((e) => FilterData.fromJson(e as Map<String, dynamic>))
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
      ..code = json['code'] as int?;

Map<String, dynamic> _$WorkResponseToJson(WorkResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };

DetailWorkItemData _$DetailWorkItemDataFromJson(Map<String, dynamic> json) =>
    DetailWorkItemData(
      json['label_field'] as String?,
      json['id'] as String?,
      json['value_field'] as String?,
      json['type'] as String?,
    );

Map<String, dynamic> _$DetailWorkItemDataToJson(DetailWorkItemData instance) =>
    <String, dynamic>{
      'label_field': instance.label_field,
      'id': instance.id,
      'value_field': instance.value_field,
      'type': instance.type,
    };

DetailWorkData _$DetailWorkDataFromJson(Map<String, dynamic> json) =>
    DetailWorkData(
      json['group_name'] as String?,
      json['mup'] as int?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => DetailWorkItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DetailWorkDataToJson(DetailWorkData instance) =>
    <String, dynamic>{
      'group_name': instance.group_name,
      'mup': instance.mup,
      'data': instance.data,
    };

DetailWorkResponse _$DetailWorkResponseFromJson(Map<String, dynamic> json) =>
    DetailWorkResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => DetailWorkData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$DetailWorkResponseToJson(DetailWorkResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
