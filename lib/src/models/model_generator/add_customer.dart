import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:gen_crm/src/models/model_generator/products_response.dart';
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
  final List<ProductsRes>? products;
  final List<ButtonRes>? button;
  final FieldParent? field_parent, field_search;
  final bool? is_load;

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
    this.field_parent,
    this.field_search,
    this.is_load,
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

@JsonSerializable()
class FieldParent {
  final String? field_value;
  final String? field_keyparam;
  final String? keysearch;
  final String? field_url;

  FieldParent(
    this.field_value,
    this.field_keyparam,
    this.keysearch,
    this.field_url,
  );

  factory FieldParent.fromJson(Map<String, dynamic> json) =>
      _$FieldParentFromJson(json);

  Map<String, dynamic> toJson() => _$FieldParentToJson(this);
}
