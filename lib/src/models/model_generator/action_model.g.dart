// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionModel _$ActionModelFromJson(Map<String, dynamic> json) => ActionModel(
      json['val'] as String?,
      (json['action'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ActionModelToJson(ActionModel instance) =>
    <String, dynamic>{
      'val': instance.val,
      'action': instance.action,
    };
