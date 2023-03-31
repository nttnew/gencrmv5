import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'customer_contract.g.dart';

@JsonSerializable()
class CustomerContractResponse extends BaseResponse {
  final List<List<dynamic>>? data;

  CustomerContractResponse(this.data);

  factory CustomerContractResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerContractResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerContractResponseToJson(this);
}
