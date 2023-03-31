import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class CustomerData {
  final String? id;
  final String? name,
      rank_type,
      danh_xung,
      color,
      cap_khach_hang,
      muc_do_tiem_nang,
      address,
      avatar;
  final bool? is_company;
  final int? rank_max_level, rank_value, total_comment, tong_so_hop_dong;
  final ActionData? phone, email;

  CustomerData(
      this.id,
      this.name,
      this.phone,
      this.rank_type,
      this.danh_xung,
      this.color,
      this.cap_khach_hang,
      this.muc_do_tiem_nang,
      this.address,
      this.avatar,
      this.is_company,
      this.rank_max_level,
      this.rank_value,
      this.total_comment,
      this.email,
      this.tong_so_hop_dong);

  factory CustomerData.fromJson(Map<String, dynamic> json) =>
      _$CustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerDataToJson(this);
}

@JsonSerializable()
class ActionData {
  final String? val;
  final int? action;

  ActionData(this.val, this.action);

  factory ActionData.fromJson(Map<String, dynamic> json) =>
      _$ActionDataFromJson(json);

  Map<String, dynamic> toJson() => _$ActionDataToJson(this);
}

@JsonSerializable()
class FilterData {
  final String? id;
  final String? name;

  FilterData(this.id, this.name);

  factory FilterData.fromJson(Map<String, dynamic> json) =>
      _$FilterDataFromJson(json);

  Map<String, dynamic> toJson() => _$FilterDataToJson(this);
}

@JsonSerializable()
class ListCustomerData {
  final String? page;
  final int? total, limit;
  final List<CustomerData>? list;
  final List<FilterData>? filter;

  ListCustomerData(this.page, this.total, this.limit, this.list, this.filter);

  factory ListCustomerData.fromJson(Map<String, dynamic> json) =>
      _$ListCustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListCustomerDataToJson(this);
}

@JsonSerializable()
class ListCustomerResponse extends BaseResponse {
  final ListCustomerData? data;

  ListCustomerResponse(this.data);

  factory ListCustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$ListCustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListCustomerResponseToJson(this);
}
