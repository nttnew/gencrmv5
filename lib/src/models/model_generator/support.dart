import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:gen_crm/src/models/model_generator/customer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'support.g.dart';

@JsonSerializable()
class SupportItemData {
  final String? id, ten_ho_tro, created_date, trang_thai, color, total_note,location;
  final CustomerData? customer;

  SupportItemData(this.id, this.ten_ho_tro, this.created_date, this.trang_thai,
      this.color, this.total_note, this.customer, this.location);

  factory SupportItemData.fromJson(Map<String, dynamic> json) =>
      _$SupportItemDataFromJson(json);

  Map<String, dynamic> toJson() => _$SupportItemDataToJson(this);
}

@JsonSerializable()
class CustomerData {
  final String? id, name;

  CustomerData(this.id, this.name);

  factory CustomerData.fromJson(Map<String, dynamic> json) =>
      _$CustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerDataToJson(this);
}

@JsonSerializable()
class SupportData {
  final String? page, total;
  final int? limit;
  final List<SupportItemData>? list;
  final List<FilterData>? filter;

  SupportData(this.page, this.total, this.limit, this.list, this.filter);

  factory SupportData.fromJson(Map<String, dynamic> json) =>
      _$SupportDataFromJson(json);

  Map<String, dynamic> toJson() => _$SupportDataToJson(this);
}

@JsonSerializable()
class SupportResponse extends BaseResponse {
  final SupportData data;

  SupportResponse(this.data);

  factory SupportResponse.fromJson(Map<String, dynamic> json) =>
      _$SupportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SupportResponseToJson(this);
}
