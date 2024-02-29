import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_customer.g.dart';

@JsonSerializable()
class CustomerIndividualItemData {
  final String? field_id,
      field_name,
      field_label,
      field_type,
      field_validation,
      field_validation_message,
      field_maxlength,
      field_hidden,
      parent;
  final int? field_require;
  final dynamic field_set_value, field_read_only;
  final List<List<dynamic>>? field_datasource;
  final List<List<dynamic>>? field_set_value_datasource;
  final String? field_special, field_value;
  final List<ProductItemContract>? products;
  final List<ButtonRes>? button;

  CustomerIndividualItemData(
    this.field_id,
    this.field_name,
    this.field_label,
    this.field_type,
    this.field_validation,
    this.field_validation_message,
    this.field_maxlength,
    this.field_hidden,
    this.parent,
    this.field_require,
    this.field_read_only,
    this.field_set_value,
    this.field_datasource,
    this.field_special,
    this.field_set_value_datasource,
    this.field_value,
    this.products,
    this.button,
  );

  factory CustomerIndividualItemData.fromJson(Map<String, dynamic> json) =>
      _$CustomerIndividualItemDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerIndividualItemDataToJson(this);
}

@JsonSerializable()
class ChuKyResponse {
  final String? group_name;
  final List<ChuKyModelResponse>? data;
  ChuKyResponse(this.group_name, this.data);

  factory ChuKyResponse.fromJson(Map<String, dynamic> json) =>
      _$ChuKyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChuKyResponseToJson(this);
}

@JsonSerializable()
class ChuKyModelResponse {
  final String? doituongky;
  final String? nhanhienthi;
  final String? giatrimacdinh;
  final String? chuky;
  final String? id;

  ChuKyModelResponse(
    this.doituongky,
    this.nhanhienthi,
    this.giatrimacdinh,
    this.chuky,
    this.id,
  );

  factory ChuKyModelResponse.fromJson(Map<String, dynamic> json) =>
      _$ChuKyModelResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChuKyModelResponseToJson(this);
}

@JsonSerializable()
class AddCustomerIndividualData {
  final List<CustomerIndividualItemData>? data;
  final String? group_name;
  final int? mup;

  AddCustomerIndividualData(this.data, this.group_name, this.mup);

  factory AddCustomerIndividualData.fromJson(Map<String, dynamic> json) =>
      _$AddCustomerIndividualDataFromJson(json);

  Map<String, dynamic> toJson() => _$AddCustomerIndividualDataToJson(this);
}

@JsonSerializable()
class ProductItemContract {
  final String? name_product,
      price,
      quantity,
      vat,
      vat_name,
      unit_name,
      ten_combo,
      combo_id;
  final int? id, id_product, unit;
  final SaleOff sale_off;

  ProductItemContract(
    this.name_product,
    this.price,
    this.quantity,
    this.vat,
    this.vat_name,
    this.unit,
    this.unit_name,
    this.id,
    this.id_product,
    this.sale_off,
    this.ten_combo,
    this.combo_id,
  );

  factory ProductItemContract.fromJson(Map<String, dynamic> json) =>
      _$ProductItemContractFromJson(json);

  Map<String, dynamic> toJson() => _$ProductItemContractToJson(this);
}

@JsonSerializable()
class SaleOff {
  final String? value, type;

  SaleOff(this.value, this.type);

  factory SaleOff.fromJson(Map<String, dynamic> json) =>
      _$SaleOffFromJson(json);

  Map<String, dynamic> toJson() => _$SaleOffToJson(this);
}

@JsonSerializable()
class AddCustomerIndividual extends BaseResponse {
  final List<AddCustomerIndividualData>? data;
  final List<ChuKyResponse>? chu_ky;
  final double? chuathanhtoan;

  AddCustomerIndividual(
    this.data,
    this.chu_ky,
    this.chuathanhtoan,
  );

  factory AddCustomerIndividual.fromJson(Map<String, dynamic> json) =>
      _$AddCustomerIndividualFromJson(json);

  Map<String, dynamic> toJson() => _$AddCustomerIndividualToJson(this);
}

@JsonSerializable()
class ButtonRes {
  final String? field_label;
  final String? field_url;
  final String? field_type;

  ButtonRes(
    this.field_label,
    this.field_url,
    this.field_type,
  );

  factory ButtonRes.fromJson(Map<String, dynamic> json) =>
      _$ButtonResFromJson(json);

  Map<String, dynamic> toJson() => _$ButtonResToJson(this);
}
