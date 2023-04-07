import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_customer.g.dart';

@JsonSerializable()
class JobCustomerData {
  final String? id,
      name,
      status,
      status_id,
      start_date,
      user,
      color,
      total_note;

  JobCustomerData(this.id, this.name, this.status, this.status_id,
      this.start_date, this.user, this.color, this.total_note);

  factory JobCustomerData.fromJson(Map<String, dynamic> json) =>
      _$JobCustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$JobCustomerDataToJson(this);
}

@JsonSerializable()
class JobCustomerResponse extends BaseResponse {
  final List<JobCustomerData>? data;

  JobCustomerResponse(this.data);

  factory JobCustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$JobCustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JobCustomerResponseToJson(this);
}
