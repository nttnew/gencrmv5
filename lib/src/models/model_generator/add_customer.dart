import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:gen_crm/src/models/model_generator/customer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_customer.g.dart';

@JsonSerializable()
class CustomerIndividualItemData {
  final String? field_id,field_name,field_label,field_type,field_validation,field_validation_message,field_maxlength,field_hidden;
  final int? field_require;
  final dynamic field_set_value;
  final List<List<dynamic>>? field_datasource;
  final List<List<dynamic>>? field_set_value_datasource;
  final String? field_special,field_value;
  final List<ProductItemContract>? products;


  CustomerIndividualItemData(
      this.field_id,
      this.field_name,
      this.field_label,
      this.field_type,
      this.field_validation,
      this.field_validation_message,
      this.field_maxlength,
      this.field_hidden,
      this.field_require,
      this.field_set_value,
      this.field_datasource,
      this.field_special,
      this.field_set_value_datasource,
      this.field_value,this.products);

  factory CustomerIndividualItemData.fromJson(Map<String, dynamic> json) =>
      _$CustomerIndividualItemDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerIndividualItemDataToJson(this);
}

@JsonSerializable()
class AddCustomerIndividualData{
  final List<CustomerIndividualItemData>? data;
  final String? group_name;
  final int? mup;


  AddCustomerIndividualData(
      this.data,this.group_name,this.mup);

  factory AddCustomerIndividualData.fromJson(Map<String, dynamic> json) =>
      _$AddCustomerIndividualDataFromJson(json);

  Map<String, dynamic> toJson() => _$AddCustomerIndividualDataToJson(this);
}

@JsonSerializable()
class ProductItemContract{
  final String? name_product,price,quantity,vat,vat_name,unit_name;
  final int? id,id_product,unit;
  final SaleOff sale_off;


  ProductItemContract(this.name_product, this.price, this.quantity, this.vat,
      this.vat_name, this.unit, this.unit_name, this.id, this.id_product,
      this.sale_off);

  factory ProductItemContract.fromJson(Map<String, dynamic> json) =>
      _$ProductItemContractFromJson(json);

  Map<String, dynamic> toJson() => _$ProductItemContractToJson(this);
}

@JsonSerializable()
class SaleOff{
  final String? value,type;


  SaleOff(this.value,this.type);

  factory SaleOff.fromJson(Map<String, dynamic> json) =>
      _$SaleOffFromJson(json);

  Map<String, dynamic> toJson() => _$SaleOffToJson(this);
}

@JsonSerializable()
class AddCustomerIndividual extends BaseResponse{
  final List<AddCustomerIndividualData>? data;


  AddCustomerIndividual(
      this.data);

  factory AddCustomerIndividual.fromJson(Map<String, dynamic> json) =>
      _$AddCustomerIndividualFromJson(json);

  Map<String, dynamic> toJson() => _$AddCustomerIndividualToJson(this);
}







