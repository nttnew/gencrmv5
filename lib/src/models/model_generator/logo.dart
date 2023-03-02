import 'package:json_annotation/json_annotation.dart';
import 'package:gen_crm/src/models/index.dart';

part 'logo.g.dart';

@JsonSerializable()
class LogoResponse {
  final int code;
  final String? message;
  final LogoData payload;

  const LogoResponse({required this.code, this.message, required this.payload});

  factory LogoResponse.fromJson(Map<String, dynamic> json) => _$LogoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LogoResponseToJson(this);
}

@JsonSerializable()
class LogoData {
  final int id;
  @JsonKey(name: "image_logo")
  final String imageLogo;

  LogoData({required this.id, required this.imageLogo});

  factory LogoData.fromJson(Map<String, dynamic> json) => _$LogoDataFromJson(json);

  Map<String, dynamic> toJson() => _$LogoDataToJson(this);
}
