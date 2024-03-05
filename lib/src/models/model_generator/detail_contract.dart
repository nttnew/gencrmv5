import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
import 'customer_clue.dart';
import 'detail_customer.dart';

part 'detail_contract.g.dart';

@JsonSerializable()
class PaymentContractItem {
  final String? field_name, field_label, field_type, field_special;
  final dynamic field_value;
  final int? field_hidden;

  PaymentContractItem(this.field_name, this.field_label, this.field_value,
      this.field_type, this.field_hidden, this.field_special);

  factory PaymentContractItem.fromJson(Map<String, dynamic> json) =>
      _$PaymentContractItemFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentContractItemToJson(this);
}

@JsonSerializable()
class PaymentContractResponse extends BaseResponse {
  final List<List<PaymentContractItem>?>? data;

  PaymentContractResponse(this.data);

  factory PaymentContractResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentContractResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentContractResponseToJson(this);
}

@JsonSerializable()
class DetailContractResponse extends BaseResponse {
  final List<InfoDataModel>? data;

  DetailContractResponse(this.data);

  factory DetailContractResponse.fromJson(Map<String, dynamic> json) =>
      _$DetailContractResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DetailContractResponseToJson(this);
}

@JsonSerializable()
class SupportContractData {
  final String? id,
      name,
      status,
      content,
      created_date,
      color,
      total_note,
      nguoi_tao,
      khach_hang;
  final Customer product_customer;

  SupportContractData(
    this.id,
    this.name,
    this.status,
    this.content,
    this.created_date,
    this.color,
    this.total_note,
    this.nguoi_tao,
    this.khach_hang,
    this.product_customer,
  );

  factory SupportContractData.fromJson(Map<String, dynamic> json) =>
      _$SupportContractDataFromJson(json);

  Map<String, dynamic> toJson() => _$SupportContractDataToJson(this);
}

@JsonSerializable()
class SupportContractResponse extends BaseResponse {
  final List<SupportContractData>? data;

  SupportContractResponse(this.data);

  factory SupportContractResponse.fromJson(Map<String, dynamic> json) =>
      _$SupportContractResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SupportContractResponseToJson(this);
}
