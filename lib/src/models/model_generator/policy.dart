import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'policy.g.dart';

@JsonSerializable(explicitToJson: true)
class PolicyData {
  String? chinh_sach;

  PolicyData({this.chinh_sach});

  factory PolicyData.fromJson(Map<String, dynamic> json) =>
      _$PolicyDataFromJson(json);
  Map<String, dynamic> toJson() => _$PolicyDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PolicyResponse extends BaseResponse {
  PolicyData? data;

  PolicyResponse(this.data);

  factory PolicyResponse.fromJson(Map<String, dynamic> json) =>
      _$PolicyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PolicyResponseToJson(this);
}
