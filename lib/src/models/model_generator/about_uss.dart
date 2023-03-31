import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'about_uss.g.dart';

@JsonSerializable()
class DataAboutUs {
  final String? gioi_thieu;

  DataAboutUs(this.gioi_thieu);

  factory DataAboutUs.fromJson(Map<String, dynamic> json) =>
      _$DataAboutUsFromJson(json);

  Map<String, dynamic> toJson() => _$DataAboutUsToJson(this);
}

@JsonSerializable()
class AboutUsResponse extends BaseResponse {
  final DataAboutUs? data;

  AboutUsResponse(this.data);

  factory AboutUsResponse.fromJson(Map<String, dynamic> json) =>
      _$AboutUsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AboutUsResponseToJson(this);
}
