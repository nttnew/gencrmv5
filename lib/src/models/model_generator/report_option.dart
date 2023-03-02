import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:gen_crm/src/models/model_generator/customer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_option.g.dart';

@JsonSerializable()
class TimeReport {
  final List<List<String>>? thoi_gian;
  final List<List<String>>? diem_ban;
  final int? thoi_gian_mac_dinh;


  TimeReport(this.thoi_gian, this.diem_ban,this.thoi_gian_mac_dinh);

  factory TimeReport.fromJson(Map<String, dynamic> json) =>
      _$TimeReportFromJson(json);

  Map<String, dynamic> toJson() => _$TimeReportToJson(this);
}

@JsonSerializable()
class TimeResponse extends BaseResponse{
  final TimeReport? data;

  TimeResponse(this.data);

  factory TimeResponse.fromJson(Map<String, dynamic> json) =>
      _$TimeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TimeResponseToJson(this);
}

@JsonSerializable()
class FilterResponse extends BaseResponse{

  final FilterReport? data;

  FilterResponse(this.data);

  factory FilterResponse.fromJson(Map<String, dynamic> json) =>
      _$FilterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FilterResponseToJson(this);
}

@JsonSerializable()
class FilterReport {
  final List<List<String>>? diem_ban;
  final List<List<String>>? thoi_gian;
  final int? thoi_gian_mac_dinh;

  FilterReport(this.diem_ban,this.thoi_gian,this.thoi_gian_mac_dinh);

  factory FilterReport.fromJson(Map<String, dynamic> json) =>
      _$FilterReportFromJson(json);

  Map<String, dynamic> toJson() => _$FilterReportToJson(this);
}








