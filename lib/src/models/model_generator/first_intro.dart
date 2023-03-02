import 'package:json_annotation/json_annotation.dart';
import 'package:gen_crm/src/models/index.dart';

part 'first_intro.g.dart';

@JsonSerializable()
class FirstIntroResponse {
  final int code;
  final String? message;
  final List<FirstIntroData> payload;

  const FirstIntroResponse({required this.code, this.message, required this.payload});

  factory FirstIntroResponse.fromJson(Map<String, dynamic> json) => _$FirstIntroResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FirstIntroResponseToJson(this);
}

@JsonSerializable()
class FirstIntroData {
  final int id;
  @JsonKey(name: "introduction_code")
  final String introductionCode;
  final String image, title, detail;

  FirstIntroData({required this.id, required this.introductionCode, required this.image, required this.title, required this.detail});

  factory FirstIntroData.fromJson(Map<String, dynamic> json) => _$FirstIntroDataFromJson(json);

  Map<String, dynamic> toJson() => _$FirstIntroDataToJson(this);
}
