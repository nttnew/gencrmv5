// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobCustomerData _$JobCustomerDataFromJson(Map<String, dynamic> json) =>
    JobCustomerData(
      json['id'] as String?,
      json['name'] as String?,
      json['status'] as String?,
      json['status_id'] as String?,
      json['start_date'] as String?,
      json['user'] as String?,
      json['color'] as String?,
      json['total_note'] as String?,
      json['recording_url'] as String?,
      json['product_customer'] == null
          ? null
          : Customer.fromJson(json['product_customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JobCustomerDataToJson(JobCustomerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'status_id': instance.status_id,
      'start_date': instance.start_date,
      'user': instance.user,
      'color': instance.color,
      'total_note': instance.total_note,
      'recording_url': instance.recording_url,
      'product_customer': instance.product_customer,
    };

JobCustomerResponse _$JobCustomerResponseFromJson(Map<String, dynamic> json) =>
    JobCustomerResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => JobCustomerData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success']
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$JobCustomerResponseToJson(
        JobCustomerResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
