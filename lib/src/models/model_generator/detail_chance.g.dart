// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_chance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListDetailChanceResponse _$ListDetailChanceResponseFromJson(
        Map<String, dynamic> json) =>
    ListDetailChanceResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => InfoDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['location'] as num?)?.toInt(),
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

Map<String, dynamic> _$ListDetailChanceResponseToJson(
        ListDetailChanceResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
      'location': instance.location,
      'checkin': instance.checkin,
      'checkout': instance.checkout,
    };
