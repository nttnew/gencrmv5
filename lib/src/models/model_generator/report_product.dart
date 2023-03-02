import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:gen_crm/src/models/model_generator/customer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_product.g.dart';

@JsonSerializable()
class ListReportProduct {
  final int id;
  final String? name;
  final String? doanh_so;


  ListReportProduct(this.name, this.id, this.doanh_so);

  factory ListReportProduct.fromJson(Map<String, dynamic> json) =>
      _$ListReportProductFromJson(json);

  Map<String, dynamic> toJson() => _$ListReportProductToJson(this);
}

@JsonSerializable()
class ReportProduct {
  final List<ListReportProduct> list;


  ReportProduct(this.list);

  factory ReportProduct.fromJson(Map<String, dynamic> json) =>
      _$ReportProductFromJson(json);

  Map<String, dynamic> toJson() => _$ReportProductToJson(this);
}

@JsonSerializable()
class ReportProductResponse extends BaseResponse{
  final ReportProduct? data;

  ReportProductResponse(this.data);

  factory ReportProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportProductResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReportProductResponseToJson(this);
}

@JsonSerializable()
class RequestBodyReportProduct {
  final String? diem_ban;
  final String? timefrom;
  final String? timeto;
  final int? time;
  final int? cl;


  RequestBodyReportProduct({required this.diem_ban,required this.time,required this.cl,required this.timefrom, required this.timeto});

  factory RequestBodyReportProduct.fromJson(Map<String, dynamic> json) => _$RequestBodyReportProductFromJson(json);
  Map<String, dynamic> toJson() => _$RequestBodyReportProductToJson(this);
}








