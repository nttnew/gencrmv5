import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_general.g.dart';

@JsonSerializable()
class DataList {
  final String? doanh_so;
  final String? thuc_thu;
  final String? so_hop_dong;

  DataList(this.doanh_so, this.thuc_thu, this.so_hop_dong);

  factory DataList.fromJson(Map<String, dynamic> json) =>
      _$DataListFromJson(json);

  Map<String, dynamic> toJson() => _$DataListToJson(this);
}

@JsonSerializable()
class DataGeneral {
  final DataList? list;

  DataGeneral(this.list);

  factory DataGeneral.fromJson(Map<String, dynamic> json) =>
      _$DataGeneralFromJson(json);

  Map<String, dynamic> toJson() => _$DataGeneralToJson(this);
}

@JsonSerializable()
class DataGeneralResponse extends BaseResponse {
  final DataGeneral? data;

  DataGeneralResponse(this.data);

  factory DataGeneralResponse.fromJson(Map<String, dynamic> json) =>
      _$DataGeneralResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DataGeneralResponseToJson(this);
}
