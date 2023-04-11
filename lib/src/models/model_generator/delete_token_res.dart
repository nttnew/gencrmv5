import 'package:json_annotation/json_annotation.dart';

part 'delete_token_res.g.dart';

@JsonSerializable()
class DeleteTokenResponse {
  String? domain, extension, pn_token;

  DeleteTokenResponse({this.pn_token, this.extension, this.domain});

  factory DeleteTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteTokenResponseToJson(this);
}
