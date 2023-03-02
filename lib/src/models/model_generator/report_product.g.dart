// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListReportProduct _$ListReportProductFromJson(Map<String, dynamic> json) =>
    ListReportProduct(
      json['name'] as String?,
      json['id'] as int,
      json['doanh_so'] as String?,
    );

Map<String, dynamic> _$ListReportProductToJson(ListReportProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'doanh_so': instance.doanh_so,
    };

ReportProduct _$ReportProductFromJson(Map<String, dynamic> json) =>
    ReportProduct(
      (json['list'] as List<dynamic>)
          .map((e) => ListReportProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportProductToJson(ReportProduct instance) =>
    <String, dynamic>{
      'list': instance.list,
    };

ReportProductResponse _$ReportProductResponseFromJson(
        Map<String, dynamic> json) =>
    ReportProductResponse(
      json['data'] == null
          ? null
          : ReportProduct.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$ReportProductResponseToJson(
        ReportProductResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };

RequestBodyReportProduct _$RequestBodyReportProductFromJson(
        Map<String, dynamic> json) =>
    RequestBodyReportProduct(
      diem_ban: json['diem_ban'] as String?,
      time: json['time'] as int?,
      cl: json['cl'] as int?,
      timefrom: json['timefrom'] as String?,
      timeto: json['timeto'] as String?,
    );

Map<String, dynamic> _$RequestBodyReportProductToJson(
        RequestBodyReportProduct instance) =>
    <String, dynamic>{
      'diem_ban': instance.diem_ban,
      'timefrom': instance.timefrom,
      'timeto': instance.timeto,
      'time': instance.time,
      'cl': instance.cl,
    };
