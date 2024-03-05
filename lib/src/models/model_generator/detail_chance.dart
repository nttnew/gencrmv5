import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

import 'detail_customer.dart';

part 'detail_chance.g.dart';

@JsonSerializable()
class ListDetailChanceResponse extends BaseResponse {
  final List<InfoDataModel>? data;
  final int? location;

  ListDetailChanceResponse(
    this.data,
    this.location,
  );

  factory ListDetailChanceResponse.fromJson(Map<String, dynamic> json) =>
      _$ListDetailChanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListDetailChanceResponseToJson(this);
}
