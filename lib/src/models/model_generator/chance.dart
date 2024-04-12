import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

import 'customer_clue.dart';

part 'chance.g.dart';

@JsonSerializable()
class ListChanceData {
  final String? id;
  final String? dateNextCare;
  final String? name, price, status, avatar, color;
  final Customer? customer, product_customer;

  ListChanceData(
    this.id,
    this.name,
    this.price,
    this.status,
    this.avatar,
    this.color,
    this.dateNextCare,
    this.customer,
    this.product_customer,
  );

  factory ListChanceData.fromJson(Map<String, dynamic> json) =>
      _$ListChanceDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListChanceDataToJson(this);
}

@JsonSerializable()
class DataChance {
  final String? total, page;
  final int? limit;
  final List<ListChanceData>? list;
  final List<Customer>? filter;

  DataChance(this.page, this.limit, this.total, this.filter, this.list);

  factory DataChance.fromJson(Map<String, dynamic> json) =>
      _$DataChanceFromJson(json);

  Map<String, dynamic> toJson() => _$DataChanceToJson(this);
}

@JsonSerializable()
class ListChanceResponse extends BaseResponse {
  final DataChance? data;

  ListChanceResponse(this.data);

  factory ListChanceResponse.fromJson(Map<String, dynamic> json) =>
      _$ListChanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListChanceResponseToJson(this);
}
