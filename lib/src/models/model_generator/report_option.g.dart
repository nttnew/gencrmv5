// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeReport _$TimeReportFromJson(Map<String, dynamic> json) => TimeReport(
      (json['thoi_gian'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      (json['diem_ban'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      (json['thoi_gian_mac_dinh'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TimeReportToJson(TimeReport instance) =>
    <String, dynamic>{
      'thoi_gian': instance.thoi_gian,
      'diem_ban': instance.diem_ban,
      'thoi_gian_mac_dinh': instance.thoi_gian_mac_dinh,
    };

TimeResponse _$TimeResponseFromJson(Map<String, dynamic> json) => TimeResponse(
      json['data'] == null
          ? null
          : TimeReport.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success']
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$TimeResponseToJson(TimeResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };

FilterResponse _$FilterResponseFromJson(Map<String, dynamic> json) =>
    FilterResponse(
      json['data'] == null
          ? null
          : FilterReport.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success']
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$FilterResponseToJson(FilterResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };

FilterReport _$FilterReportFromJson(Map<String, dynamic> json) => FilterReport(
      (json['diem_ban'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      (json['thoi_gian'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      (json['trangthaihd'] as List<dynamic>?)
          ?.map((e) => TrangThaiHDReport.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['thoi_gian_mac_dinh'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FilterReportToJson(FilterReport instance) =>
    <String, dynamic>{
      'diem_ban': instance.diem_ban,
      'thoi_gian': instance.thoi_gian,
      'trangthaihd': instance.trangthaihd,
      'thoi_gian_mac_dinh': instance.thoi_gian_mac_dinh,
    };

TrangThaiHDReport _$TrangThaiHDReportFromJson(Map<String, dynamic> json) =>
    TrangThaiHDReport(
      json['id'] as String?,
      json['label'] as String?,
    );

Map<String, dynamic> _$TrangThaiHDReportToJson(TrangThaiHDReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
    };
