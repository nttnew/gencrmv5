import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_by_customer.g.dart';
@JsonSerializable()
class ContactByCustomerResponse extends BaseResponse{
  List<List<dynamic>>? data;

  ContactByCustomerResponse(this.data);

  factory ContactByCustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactByCustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContactByCustomerResponseToJson(this);

}