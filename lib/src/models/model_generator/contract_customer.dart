import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

import 'customer_clue.dart';

part 'contract_customer.g.dart';

@JsonSerializable()
class ContractCustomerData {
  final String? id,
      name,
      status,
      ngay_ky,
      total_value,
      customer_name,
      color,
      total_note;
  final Customer? product_customer;

  ContractCustomerData(
    this.id,
    this.name,
    this.status,
    this.ngay_ky,
    this.total_value,
    this.customer_name,
    this.color,
    this.total_note,
    this.product_customer,
  );

  factory ContractCustomerData.fromJson(Map<String, dynamic> json) =>
      _$ContractCustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContractCustomerDataToJson(this);
}

@JsonSerializable()
class ContractCustomerResponse extends BaseResponse {
  final List<ContractCustomerData>? data;

  ContractCustomerResponse(this.data);

  factory ContractCustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$ContractCustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContractCustomerResponseToJson(this);
}
