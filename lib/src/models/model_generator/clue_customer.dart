import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

import 'action_model.dart';

part 'clue_customer.g.dart';

@JsonSerializable()
class ClueCustomerData {
  final String? id, name, danh_xung, total_note;
  final Position? position;
  final ActionModel? phone, email;

  ClueCustomerData(this.id, this.name, this.phone, this.danh_xung,
      this.position, this.email, this.total_note);

  factory ClueCustomerData.fromJson(Map<String, dynamic> json) =>
      _$ClueCustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$ClueCustomerDataToJson(this);
}

@JsonSerializable()
class Position {
  final String? id, name;

  Position(this.id, this.name);

  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);

  Map<String, dynamic> toJson() => _$PositionToJson(this);
}

@JsonSerializable()
class ClueCustomerResponse extends BaseResponse {
  final List<ClueCustomerData>? data;

  ClueCustomerResponse(this.data);

  factory ClueCustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$ClueCustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClueCustomerResponseToJson(this);
}
