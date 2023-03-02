import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'product_response.g.dart';

@JsonSerializable()
class ProductItem {
  String? product_id,product_code,product_edit,product_name,dvt,vat,sell_price;


  ProductItem(this.product_id, this.product_code, this.product_edit,
      this.product_name, this.dvt, this.vat, this.sell_price);

  factory ProductItem.fromJson(Map<String, dynamic> json) =>
      _$ProductItemFromJson(json);
  Map<String, dynamic> toJson() => _$ProductItemToJson(this);
}

@JsonSerializable()
class ProductData {
  dynamic page;
  int? limit;
  int? total;
  List<ProductItem>? product;
  List<List<dynamic>>? units,vats;


  ProductData(
      this.page, this.limit, this.total, this.product, this.units, this.vats);

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDataToJson(this);
}

@JsonSerializable()
class ProductResponse extends BaseResponse {
  ProductData? data;


  ProductResponse(this.data);

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProductResponseToJson(this);
}