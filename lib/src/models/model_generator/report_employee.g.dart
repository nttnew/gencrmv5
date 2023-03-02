// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataEmployList _$DataEmployListFromJson(Map<String, dynamic> json) =>
    DataEmployList(
      json['id'] as String?,
      json['name'] as String?,
      json['total_sales'] as String?,
      json['total_contract'] as int?,
    );

Map<String, dynamic> _$DataEmployListToJson(DataEmployList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'total_sales': instance.total_sales,
      'total_contract': instance.total_contract,
    };

DataEmployGeneral _$DataEmployGeneralFromJson(Map<String, dynamic> json) =>
    DataEmployGeneral(
      (json['list'] as List<dynamic>?)
          ?.map((e) => DataEmployList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataEmployGeneralToJson(DataEmployGeneral instance) =>
    <String, dynamic>{
      'list': instance.list,
    };

DataEmployResponse _$DataEmployResponseFromJson(Map<String, dynamic> json) =>
    DataEmployResponse(
      json['data'] == null
          ? null
          : DataEmployGeneral.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$DataEmployResponseToJson(DataEmployResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };

RequestEmployReport _$RequestEmployReportFromJson(Map<String, dynamic> json) =>
    RequestEmployReport(
      diem_ban: json['diem_ban'] as int?,
      time: json['time'] as int?,
      timefrom: json['timefrom'] as String?,
      timeto: json['timeto'] as String?,
    );

Map<String, dynamic> _$RequestEmployReportToJson(
        RequestEmployReport instance) =>
    <String, dynamic>{
      'timefrom': instance.timefrom,
      'timeto': instance.timeto,
      'time': instance.time,
      'diem_ban': instance.diem_ban,
    };
