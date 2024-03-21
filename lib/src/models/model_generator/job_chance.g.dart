// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_chance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataFormAdd _$DataFormAddFromJson(Map<String, dynamic> json) => DataFormAdd(
      json['id'] as String?,
      json['total_comment'] as int?,
      json['name_job'] as String?,
      json['user_work_id'] as String?,
      json['user_work_name'] as String?,
      json['user_work_avatar'] as String?,
      json['name_customer'] as String?,
      json['status_job'] as String?,
      json['start_date'] as String?,
      json['color'] as String?,
      json['product_customer'] == null
          ? null
          : Customer.fromJson(json['product_customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataFormAddToJson(DataFormAdd instance) =>
    <String, dynamic>{
      'total_comment': instance.total_comment,
      'id': instance.id,
      'name_job': instance.name_job,
      'user_work_id': instance.user_work_id,
      'user_work_name': instance.user_work_name,
      'user_work_avatar': instance.user_work_avatar,
      'name_customer': instance.name_customer,
      'status_job': instance.status_job,
      'start_date': instance.start_date,
      'color': instance.color,
      'product_customer': instance.product_customer,
    };

JobChance _$JobChanceFromJson(Map<String, dynamic> json) => JobChance(
      (json['data'] as List<dynamic>?)
          ?.map((e) => DataFormAdd.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$JobChanceToJson(JobChance instance) => <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
