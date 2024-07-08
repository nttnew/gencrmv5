// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addJob_chance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Field_Datasource _$Field_DatasourceFromJson(Map<String, dynamic> json) =>
    Field_Datasource();

Map<String, dynamic> _$Field_DatasourceToJson(Field_Datasource instance) =>
    <String, dynamic>{};

DataField _$DataFieldFromJson(Map<String, dynamic> json) => DataField(
      json['field_id'] as String?,
      json['field_label'] as String?,
      json['field_type'] as String?,
      json['field_validation'] as String?,
      (json['field_datasource'] as List<dynamic>?)
          ?.map((e) => Field_Datasource.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['field_hidden'] as String?,
      json['field_require'] as String?,
      json['field_special'] as String?,
      json['field_validation_message'] as String?,
    );

Map<String, dynamic> _$DataFieldToJson(DataField instance) => <String, dynamic>{
      'field_id': instance.field_id,
      'field_label': instance.field_label,
      'field_type': instance.field_type,
      'field_require': instance.field_require,
      'field_validation': instance.field_validation,
      'field_validation_message': instance.field_validation_message,
      'field_hidden': instance.field_hidden,
      'field_special': instance.field_special,
      'field_datasource': instance.field_datasource,
    };

Field_General _$Field_GeneralFromJson(Map<String, dynamic> json) =>
    Field_General(
      (json['data'] as List<dynamic>?)
          ?.map((e) => DataField.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['group_name'] as String?,
      (json['mup'] as num?)?.toInt(),
    );

Map<String, dynamic> _$Field_GeneralToJson(Field_General instance) =>
    <String, dynamic>{
      'mup': instance.mup,
      'group_name': instance.group_name,
      'data': instance.data,
    };

AddJobResponse _$AddJobResponseFromJson(Map<String, dynamic> json) =>
    AddJobResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => Field_General.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = (json['code'] as num?)?.toInt();

Map<String, dynamic> _$AddJobResponseToJson(AddJobResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };
