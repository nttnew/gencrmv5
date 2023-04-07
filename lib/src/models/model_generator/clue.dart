import './phone_clue.dart';
import './customer_clue.dart';
import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:gen_crm/src/models/model_generator/position_clue.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clue.g.dart';

@JsonSerializable(explicitToJson: true)
class Email {
  final String? val;
  final int? action;
  Email(this.action, this.val);

  factory Email.fromJson(Map<String, dynamic> json) => _$EmailFromJson(json);
  Map<String, dynamic> toJson() => _$EmailToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ClueData {
  final String? id, name;
  final Phone? phone;
  final Email? email;
  final Position? position;
  final Customer? customer;
  final String? created_date;
  final String? avatar;
  final String? total_note;

  ClueData(this.id, this.name, this.position, this.email, this.customer,
      this.phone, this.created_date, this.avatar, this.total_note);

  factory ClueData.fromJson(Map<String, dynamic> json) =>
      _$ClueDataFromJson(json);
  Map<String, dynamic> toJson() => _$ClueDataToJson(this);
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
class ListClueData {
  final String? page;
  final String? total;
  final int? limit;
  final List<ClueData>? list;
  final List<FilterData>? filter;

  ListClueData(this.page, this.total, this.limit, this.list, this.filter);

  factory ListClueData.fromJson(Map<String, dynamic> json) =>
      _$ListClueDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListClueDataToJson(this);
}

@JsonSerializable()
class ListClueResponse extends BaseResponse {
  final ListClueData? data;

  ListClueResponse({this.data});

  factory ListClueResponse.fromJson(Map<String, dynamic> json) =>
      _$ListClueResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListClueResponseToJson(this);
}
