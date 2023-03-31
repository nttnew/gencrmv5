import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'addJob_chance.g.dart';

@JsonSerializable()
class Field_Datasource {
  Field_Datasource();

  factory Field_Datasource.fromJson(Map<String, dynamic> json) =>
      _$Field_DatasourceFromJson(json);

  Map<String, dynamic> toJson() => _$Field_DatasourceToJson(this);
}

@JsonSerializable()
class DataField {
  final String? field_id;
  final String? field_label,
      field_type,
      field_require,
      field_validation,
      field_validation_message,
      field_hidden,
      field_special;
  final List<Field_Datasource>? field_datasource;

  DataField(
      this.field_id,
      this.field_label,
      this.field_type,
      this.field_validation,
      this.field_datasource,
      this.field_hidden,
      this.field_require,
      this.field_special,
      this.field_validation_message);

  factory DataField.fromJson(Map<String, dynamic> json) =>
      _$DataFieldFromJson(json);

  Map<String, dynamic> toJson() => _$DataFieldToJson(this);
}

@JsonSerializable()
class Field_General {
  final int? mup;
  final String? group_name;
  final List<DataField>? data;

  Field_General(this.data, this.group_name, this.mup);

  factory Field_General.fromJson(Map<String, dynamic> json) =>
      _$Field_GeneralFromJson(json);

  Map<String, dynamic> toJson() => _$Field_GeneralToJson(this);
}

@JsonSerializable()
class AddJobResponse extends BaseResponse {
  final List<Field_General>? data;

  AddJobResponse(
    this.data,
  );

  factory AddJobResponse.fromJson(Map<String, dynamic> json) =>
      _$AddJobResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddJobResponseToJson(this);
}
