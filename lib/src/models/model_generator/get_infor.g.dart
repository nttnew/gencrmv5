// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_infor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InforData _$InforDataFromJson(Map<String, dynamic> json) => InforData(
      json['gioi_thieu'] as String?,
    );

Map<String, dynamic> _$InforDataToJson(InforData instance) => <String, dynamic>{
      'gioi_thieu': instance.gioi_thieu,
    };

InforResponse _$InforResponseFromJson(Map<String, dynamic> json) =>
    InforResponse(
      json['data'] == null
          ? null
          : InforData.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success']
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$InforResponseToJson(InforResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
