import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

import 'detail_customer.dart';

part 'clue_detail.g.dart';

@JsonSerializable()
class DetailClue extends BaseResponse {
  List<InfoDataModel>? data;
  DetailClue(this.data);
  factory DetailClue.fromJson(Map<String, dynamic> json) =>
      _$DetailClueFromJson(json);

  Map<String, dynamic> toJson() => _$DetailClueToJson(this);
}
