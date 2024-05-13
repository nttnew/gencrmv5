// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_clue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkClueData _$WorkClueDataFromJson(Map<String, dynamic> json) => WorkClueData(
      id: json['id'] as String?,
      id_customer: json['id_customer'] as String?,
      name_customer: json['name_customer'] as String?,
      name_job: json['name_job'] as String?,
      status_job: json['status_job'] as String?,
      start_date: json['start_date'] as String?,
      content_job: json['content_job'] as String?,
      user_work_id: json['user_work_id'] as String?,
      user_work_name: json['user_work_name'] as String?,
      user_work_avatar: json['user_work_avatar'] as String?,
      total_comment: (json['total_comment'] as num?)?.toInt(),
      color: json['color'] as String?,
      product_customer: json['product_customer'] == null
          ? null
          : Customer.fromJson(json['product_customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkClueDataToJson(WorkClueData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_customer': instance.id_customer,
      'name_customer': instance.name_customer,
      'name_job': instance.name_job,
      'status_job': instance.status_job,
      'start_date': instance.start_date,
      'content_job': instance.content_job,
      'user_work_id': instance.user_work_id,
      'user_work_name': instance.user_work_name,
      'user_work_avatar': instance.user_work_avatar,
      'color': instance.color,
      'total_comment': instance.total_comment,
      'product_customer': instance.product_customer?.toJson(),
    };

WorkClueResponse _$WorkClueResponseFromJson(Map<String, dynamic> json) =>
    WorkClueResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => WorkClueData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$WorkClueResponseToJson(WorkClueResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };
