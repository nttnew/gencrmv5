import 'package:json_annotation/json_annotation.dart';

part 'call_token_res.g.dart';

@JsonSerializable()
class CallTokenResponse {
  String? domain, extension, pn_token, pn_type;

  CallTokenResponse({this.pn_token, this.extension, this.domain, this.pn_type});

  factory CallTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$CallTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CallTokenResponseToJson(this);
}
