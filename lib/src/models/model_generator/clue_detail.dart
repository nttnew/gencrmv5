import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clue_detail.g.dart';

@JsonSerializable()
class DataClueGroupName {
  String? label_field;
  String? id;
  String? link;
  String? value_field;
  DataClueGroupName(this.label_field, this.id, this.link, this.value_field);

  factory DataClueGroupName.fromJson(Map<String, dynamic> json) =>
      _$DataClueGroupNameFromJson(json);

  Map<String, dynamic> toJson() => _$DataClueGroupNameToJson(this);
}

@JsonSerializable()
class DetailClueGroupName {
  String? group_name;
  int? mup;
  List<DataClueGroupName>? data;
  String? main_id;
  String? avatar;
  DetailClueGroupName(
    this.group_name,
    this.mup,
    this.data,
    this.main_id,
    this.avatar,
  );
  factory DetailClueGroupName.fromJson(Map<String, dynamic> json) =>
      _$DetailClueGroupNameFromJson(json);

  Map<String, dynamic> toJson() => _$DetailClueGroupNameToJson(this);
}

@JsonSerializable()
class DetailClue extends BaseResponse {
  List<DetailClueGroupName>? data;
  DetailClue(this.data);
  factory DetailClue.fromJson(Map<String, dynamic> json) =>
      _$DetailClueFromJson(json);

  Map<String, dynamic> toJson() => _$DetailClueToJson(this);
}
