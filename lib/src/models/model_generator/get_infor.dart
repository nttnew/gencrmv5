import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_infor.g.dart';

@JsonSerializable()
class InforData {
  final String? gioi_thieu;

  InforData(this.gioi_thieu);

  factory InforData.fromJson(Map<String, dynamic> json) =>
      _$InforDataFromJson(json);
  Map<String, dynamic> toJson() => _$InforDataToJson(this);
}

@JsonSerializable()
class InforResponse extends BaseResponse {
  InforData? data;

  InforResponse(this.data);

  factory InforResponse.fromJson(Map<String, dynamic> json) =>
      _$InforResponseFromJson(json);
  Map<String, dynamic> toJson() => _$InforResponseToJson(this);
}
