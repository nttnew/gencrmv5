import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'support_customer.g.dart';

@JsonSerializable()
class SupportCustomerData {
  final String? id,
      name,
      status,
      status_id,
      start_date,
      user_handling,
      color,
      total_note;

  SupportCustomerData(this.id, this.name, this.status, this.status_id,
      this.start_date, this.user_handling, this.color, this.total_note);

  factory SupportCustomerData.fromJson(Map<String, dynamic> json) =>
      _$SupportCustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$SupportCustomerDataToJson(this);
}

@JsonSerializable()
class SupportCustomerResponse extends BaseResponse {
  final List<SupportCustomerData>? data;

  SupportCustomerResponse(this.data);

  factory SupportCustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$SupportCustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SupportCustomerResponseToJson(this);
}
