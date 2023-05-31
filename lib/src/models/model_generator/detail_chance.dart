import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_chance.g.dart';

@JsonSerializable()
class DataContentChance {
  final String? id;
  final String? label_field, value_field, link;
  final bool? is_link;

  DataContentChance(
      this.id, this.label_field, this.value_field, this.link, this.is_link);

  factory DataContentChance.fromJson(Map<String, dynamic> json) =>
      _$DataContentChanceFromJson(json);

  Map<String, dynamic> toJson() => _$DataContentChanceToJson(this);
}

@JsonSerializable()
class DataDetailChance {
  final int? mup;
  final String? group_name, main_id, avatar;
  final List<DataContentChance>? data;

  DataDetailChance(
      this.mup, this.group_name, this.data, this.main_id, this.avatar);

  factory DataDetailChance.fromJson(Map<String, dynamic> json) =>
      _$DataDetailChanceFromJson(json);

  Map<String, dynamic> toJson() => _$DataDetailChanceToJson(this);
}

@JsonSerializable()
class ListDetailChanceResponse extends BaseResponse {
  final List<DataDetailChance>? data;
  final int? location;

  ListDetailChanceResponse(
    this.data,
    this.location,
  );

  factory ListDetailChanceResponse.fromJson(Map<String, dynamic> json) =>
      _$ListDetailChanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListDetailChanceResponseToJson(this);
}
