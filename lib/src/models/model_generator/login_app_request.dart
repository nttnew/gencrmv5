import 'package:json_annotation/json_annotation.dart';

import 'info_user.dart';

part 'login_app_request.g.dart';

@JsonSerializable()
class LoginAppRequest {
  @JsonKey(name: "uname")
  final String email;
  @JsonKey(name: "pass")
  final String password;
  final String device_token;
  final String platform;

  LoginAppRequest({required this.email, required this.password,required this.device_token,required this.platform});

  factory LoginAppRequest.fromJson(Map<String, dynamic> json) => _$LoginAppRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginAppRequestToJson(this);
}

