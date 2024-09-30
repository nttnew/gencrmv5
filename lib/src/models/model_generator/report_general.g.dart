// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_general.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataList _$DataListFromJson(Map<String, dynamic> json) => DataList(
      json['doanh_so'] as String?,
      json['thuc_thu'] as String?,
      json['so_hop_dong'] as String?,
    );

Map<String, dynamic> _$DataListToJson(DataList instance) => <String, dynamic>{
      'doanh_so': instance.doanh_so,
      'thuc_thu': instance.thuc_thu,
      'so_hop_dong': instance.so_hop_dong,
    };

DataGeneral _$DataGeneralFromJson(Map<String, dynamic> json) => DataGeneral(
      json['list'] == null
          ? null
          : DataList.fromJson(json['list'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataGeneralToJson(DataGeneral instance) =>
    <String, dynamic>{
      'list': instance.list,
    };

DataGeneralResponse _$DataGeneralResponseFromJson(Map<String, dynamic> json) =>
    DataGeneralResponse(
      json['data'] == null
          ? null
          : DataGeneral.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success']
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$DataGeneralResponseToJson(
        DataGeneralResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
