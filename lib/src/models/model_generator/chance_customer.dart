import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

import 'customer_clue.dart';

part 'chance_customer.g.dart';

@JsonSerializable()
class ChanceCustomerData {
  final String? id, name, sale, total_note, status, color, customer_name, date;
  final Customer? product_customer;

  ChanceCustomerData(
    this.id,
    this.name,
    this.sale,
    this.total_note,
    this.status,
    this.color,
    this.customer_name,
    this.date,
    this.product_customer,
  );

  factory ChanceCustomerData.fromJson(Map<String, dynamic> json) =>
      _$ChanceCustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$ChanceCustomerDataToJson(this);
}

@JsonSerializable()
class ChanceCustomerResponse extends BaseResponse {
  final List<ChanceCustomerData>? data;

  ChanceCustomerResponse(this.data);

  factory ChanceCustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$ChanceCustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChanceCustomerResponseToJson(this);
}
