import 'package:json_annotation/json_annotation.dart';

import 'index.dart';

part 'register_app_request.g.dart';

@JsonSerializable()
class RegisterAppRequest {
  final String fullname;
  final String email;
  final String password;
  RegisterAppRequest({required this.fullname, required this.email, required this.password});
  factory RegisterAppRequest.fromJson(Map<String, dynamic> json) => _$RegisterAppRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterAppRequestToJson(this);
}