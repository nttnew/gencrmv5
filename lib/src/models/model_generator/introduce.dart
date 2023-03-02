import 'package:json_annotation/json_annotation.dart';
import 'package:gen_crm/src/models/index.dart';

part 'introduce.g.dart';

@JsonSerializable()
class IntroduceResponse {
  final int code;
  final String? message;
  final IntroduceData payload;

  const IntroduceResponse({required this.code, this.message, required this.payload});

  factory IntroduceResponse.fromJson(Map<String, dynamic> json) => _$IntroduceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IntroduceResponseToJson(this);
}

@JsonSerializable()
class IntroduceData {
  final int id;
  final String image, detail;

  IntroduceData({required this.id, required this.image, required this.detail});

  factory IntroduceData.fromJson(Map<String, dynamic> json) => _$IntroduceDataFromJson(json);

  Map<String, dynamic> toJson() => _$IntroduceDataToJson(this);
}
