import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:gen_crm/src/models/model_generator/customer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chance.g.dart';

@JsonSerializable()
class DataCustomer {
  final String? id;
  final String? name, danh_xung;

  DataCustomer(this.id, this.name, this.danh_xung);

  factory DataCustomer.fromJson(Map<String, dynamic> json) =>
      _$DataCustomerFromJson(json);

  Map<String, dynamic> toJson() => _$DataCustomerToJson(this);
}

@JsonSerializable()
class ListChanceData {
  final String? id;
  final String? dateNextCare;
  final String? name, price, avatar;
  final DataCustomer? customer;
  final dynamic status;

  ListChanceData(this.id, this.name, this.price, this.status, this.avatar,
      this.dateNextCare, this.customer);

  factory ListChanceData.fromJson(Map<String, dynamic> json) =>
      _$ListChanceDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListChanceDataToJson(this);
}

@JsonSerializable()
class FilterChance {
  String? id;
  String? name;

  FilterChance(this.id, this.name);

  factory FilterChance.fromJson(Map<String, dynamic> json) =>
      _$FilterChanceFromJson(json);

  Map<String, dynamic> toJson() => _$FilterChanceToJson(this);
}

@JsonSerializable()
class DataChance {
  final String page;
  final int? limit, total;
  final List<ListChanceData>? list;
  final List<FilterChance>? filter;

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
