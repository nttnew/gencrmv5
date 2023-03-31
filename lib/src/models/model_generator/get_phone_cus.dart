import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_phone_cus.g.dart';

@JsonSerializable()
class GetPhoneCusResponse extends BaseResponse {
  String? data;

  GetPhoneCusResponse(this.data);

  factory GetPhoneCusResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPhoneCusResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetPhoneCusResponseToJson(this);
}
