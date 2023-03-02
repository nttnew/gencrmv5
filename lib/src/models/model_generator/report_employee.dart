import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:gen_crm/src/models/model_generator/customer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_employee.g.dart';

@JsonSerializable()
class DataEmployList {
  final String? id;
  final String? name;
  final String? total_sales;
  final int? total_contract;


  DataEmployList(this.id, this.name, this.total_sales, this.total_contract);

  factory DataEmployList.fromJson(Map<String, dynamic> json) =>
      _$DataEmployListFromJson(json);

  Map<String, dynamic> toJson() => _$DataEmployListToJson(this);
}

@JsonSerializable()
class DataEmployGeneral {
  final List<DataEmployList>? list;

  DataEmployGeneral(this.list);

  factory DataEmployGeneral.fromJson(Map<String, dynamic> json) =>
      _$DataEmployGeneralFromJson(json);

  Map<String, dynamic> toJson() => _$DataEmployGeneralToJson(this);
}

@JsonSerializable()
class DataEmployResponse extends BaseResponse {
  final DataEmployGeneral? data;

  DataEmployResponse(this.data);

  factory DataEmployResponse.fromJson(Map<String, dynamic> json) =>
      _$DataEmployResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DataEmployResponseToJson(this);
}

@JsonSerializable()
class RequestEmployReport {
  final String? timefrom;
  final String? timeto;
  final int? time;
  final int? diem_ban;


  RequestEmployReport( {required this.diem_ban,required this.time,required this.timefrom,required this.timeto});

  factory RequestEmployReport.fromJson(Map<String, dynamic> json) => _$RequestEmployReportFromJson(json);
  Map<String, dynamic> toJson() => _$RequestEmployReportToJson(this);
}










