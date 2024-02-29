import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

import 'customer_clue.dart';

part 'work.g.dart';

@JsonSerializable()
class WorkItemData {
  final String? id;
  final int? total_comment;
  final String? id_customer,
      name_job,
      content_job,
      user_work_id,
      user_work_name,
      user_work_avatar,
      name_customer,
      status_job,
      status_id,
      status_color,
      start_date,
      location,
      di_dong;
  final Customer customer, product_customer;

  WorkItemData(
    this.id,
    this.total_comment,
    this.id_customer,
    this.name_job,
    this.content_job,
    this.user_work_id,
    this.user_work_name,
    this.user_work_avatar,
    this.name_customer,
    this.status_job,
    this.status_id,
    this.status_color,
    this.start_date,
    this.location,
    this.di_dong,
    this.customer,
    this.product_customer,
  );

  factory WorkItemData.fromJson(Map<String, dynamic> json) =>
      _$WorkItemDataFromJson(json);

  Map<String, dynamic> toJson() => _$WorkItemDataToJson(this);
}

@JsonSerializable()
class WorkData {
  final List<WorkItemData>? data_list;
  final int? pageCount;
  final List<Customer>? data_filter;

  WorkData(
    this.data_list,
    this.pageCount,
    this.data_filter,
  );

  factory WorkData.fromJson(Map<String, dynamic> json) =>
      _$WorkDataFromJson(json);

  Map<String, dynamic> toJson() => _$WorkDataToJson(this);
}

@JsonSerializable()
class WorkResponse extends BaseResponse {
  final WorkData? data;

  WorkResponse(this.data);

  factory WorkResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkResponseToJson(this);
}

@JsonSerializable()
class DetailWorkItemData {
  final String? label_field, id, value_field, type, link;
  final bool? is_link;

  DetailWorkItemData(
    this.label_field,
    this.id,
    this.value_field,
    this.type,
    this.link,
    this.is_link,
  );

  factory DetailWorkItemData.fromJson(Map<String, dynamic> json) =>
      _$DetailWorkItemDataFromJson(json);

  Map<String, dynamic> toJson() => _$DetailWorkItemDataToJson(this);
}

@JsonSerializable()
class DetailWorkData {
  final String? group_name;
  final int? mup;
  final List<DetailWorkItemData>? data;

  DetailWorkData(this.group_name, this.mup, this.data);

  factory DetailWorkData.fromJson(Map<String, dynamic> json) =>
      _$DetailWorkDataFromJson(json);

  Map<String, dynamic> toJson() => _$DetailWorkDataToJson(this);
}

@JsonSerializable()
class DetailWorkResponse extends BaseResponse {
  final List<DetailWorkData>? data;
  final int? location;
  final String? di_dong;

  DetailWorkResponse(this.data, this.location, this.di_dong);

  factory DetailWorkResponse.fromJson(Map<String, dynamic> json) =>
      _$DetailWorkResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DetailWorkResponseToJson(this);
}
