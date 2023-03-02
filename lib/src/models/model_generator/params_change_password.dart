import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'params_change_password.g.dart';
@JsonSerializable()
class ParamChangePassword {
  @JsonKey(name: "old_password")
  String oldPass;
  @JsonKey(name: "password_new")
  String newPass;
  @JsonKey(name: "password_new_confirmation")
  String repeatPass;

  ParamChangePassword(
      {
        required this.oldPass,
        required this.newPass,
        required this.repeatPass,
        });

  factory ParamChangePassword.fromJson(Map<String, dynamic> json) => _$ParamChangePasswordFromJson(json);
  Map<String, dynamic> toJson() => _$ParamChangePasswordToJson(this);
}

@JsonSerializable()
class Timestamp {
  final String? timestamp;

  Timestamp(this.timestamp);

  factory Timestamp.fromJson(Map<String, dynamic> json) => _$TimestampFromJson(json);
  Map<String, dynamic> toJson() => _$TimestampToJson(this);
}
@JsonSerializable()
class ParamForgotPassword extends BaseResponse {
  final Timestamp? data;


  ParamForgotPassword(this.data);

  factory ParamForgotPassword.fromJson(Map<String, dynamic> json) => _$ParamForgotPasswordFromJson(json);
  Map<String, dynamic> toJson() => _$ParamForgotPasswordToJson(this);
}

@JsonSerializable()
class CodeOtp {
  final String? timestamp;

  CodeOtp(this.timestamp);

  factory CodeOtp.fromJson(Map<String, dynamic> json) => _$CodeOtpFromJson(json);
  Map<String, dynamic> toJson() => _$CodeOtpToJson(this);
}
@JsonSerializable()
class ParamForgotPasswordOtp extends BaseResponse {
  final CodeOtp? data;


  ParamForgotPasswordOtp(this.data);

  factory ParamForgotPasswordOtp.fromJson(Map<String, dynamic> json) => _$ParamForgotPasswordOtpFromJson(json);
  Map<String, dynamic> toJson() => _$ParamForgotPasswordOtpToJson(this);
}

@JsonSerializable()
class ParamRequestForgotPassword {
  @JsonKey(name: "email")
  String email;
  @JsonKey(name: "username")
  String username;
  @JsonKey(name: "timestamp")
  String timestamp;

  ParamRequestForgotPassword(
      {
        required this.email,
        required this.username,
        required this.timestamp,
      });

  factory ParamRequestForgotPassword.fromJson(Map<String, dynamic> json) => _$ParamRequestForgotPasswordFromJson(json);
  Map<String, dynamic> toJson() => _$ParamRequestForgotPasswordToJson(this);
}

@JsonSerializable()
class ParamRequestForgotPasswordOtp {
  @JsonKey(name: "timestamp")
  String timestamp;
  String code;
  String email;
  String username;

  ParamRequestForgotPasswordOtp(
      {
        required this.timestamp,
        required this.email,
        required this.code,
        required this.username
      });

  factory ParamRequestForgotPasswordOtp.fromJson(Map<String, dynamic> json) => _$ParamRequestForgotPasswordOtpFromJson(json);
  Map<String, dynamic> toJson() => _$ParamRequestForgotPasswordOtpToJson(this);
}


@JsonSerializable()
class ParamResetPassword {

  String timestamp;
  String newPass;
  String email;
  String username;


  ParamResetPassword(
      {
        required this.email,
        required this.newPass,
        required this.timestamp,
        required this.username
      });

  factory ParamResetPassword.fromJson(Map<String, dynamic> json) => _$ParamResetPasswordFromJson(json);
  Map<String, dynamic> toJson() => _$ParamResetPasswordToJson(this);
}

