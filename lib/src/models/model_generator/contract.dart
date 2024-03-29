import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:gen_crm/src/models/model_generator/customer_clue.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contract.g.dart';

@JsonSerializable()
class ContractItemData {
  final String? id, name, status;
  final String? status_edit, status_color, avatar, total_note, conlai;
  final dynamic price;
  final Customer? customer, product_customer;

  ContractItemData(
    this.id,
    this.name,
    this.price,
    this.status,
    this.status_edit,
    this.status_color,
    this.avatar,
    this.customer,
    this.product_customer,
    this.total_note,
    this.conlai,
  );

  factory ContractItemData.fromJson(Map<String, dynamic> json) =>
      _$ContractItemDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContractItemDataToJson(this);
}

@JsonSerializable()
class ContractData {
  final List<ContractItemData>? list;
  final List<Customer>? filter;
  final String? page, total;
  final int? limit;

  ContractData(this.list, this.page, this.total, this.limit, this.filter);

  factory ContractData.fromJson(Map<String, dynamic> json) =>
      _$ContractDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContractDataToJson(this);
}

@JsonSerializable()
class ContractResponse extends BaseResponse {
  final ContractData data;

  ContractResponse(this.data);

  factory ContractResponse.fromJson(Map<String, dynamic> json) =>
      _$ContractResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContractResponseToJson(this);
}
