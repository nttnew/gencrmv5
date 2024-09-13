import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

import 'customer_clue.dart';

part 'job_chance.g.dart';

@JsonSerializable()
class DataFormAdd {
  final int? total_comment;
  final String? id;
  final String? name_job,
      user_work_id,
      user_work_name,
      user_work_avatar,
      name_customer,
      status_job,
      start_date,
      color,
      recording_url;
  final Customer? product_customer;

  DataFormAdd(
    this.id,
    this.total_comment,
    this.name_job,
    this.user_work_id,
    this.user_work_name,
    this.user_work_avatar,
    this.name_customer,
    this.status_job,
    this.start_date,
    this.color,
    this.recording_url,
    this.product_customer,
  );

  factory DataFormAdd.fromJson(Map<String, dynamic> json) =>
      _$DataFormAddFromJson(json);

  Map<String, dynamic> toJson() => _$DataFormAddToJson(this);
}

@JsonSerializable()
class JobChance extends BaseResponse {
  final List<DataFormAdd>? data;

  JobChance(this.data);

  factory JobChance.fromJson(Map<String, dynamic> json) =>
      _$JobChanceFromJson(json);

  Map<String, dynamic> toJson() => _$JobChanceToJson(this);
}
