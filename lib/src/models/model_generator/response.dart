import 'package:json_annotation/json_annotation.dart';
import 'package:gen_crm/src/models/index.dart';
part 'response.g.dart';

@JsonSerializable()
class ResponseStatus {
  final int code;
  final dynamic success;
  final String? message;

  const ResponseStatus({required this.code, this.success, this.message});

  static const empty = ResponseStatus(code: 1, success: true, message: '');

  factory ResponseStatus.fromJson(Map<String, dynamic> json) =>
      _$ResponseStatusFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseStatusToJson(this);
}

@JsonSerializable()
class ResponseDataStatus {
  final int? code;
  final InfoUser? payload;
  final String? message;

  const ResponseDataStatus({this.code, this.payload, this.message});

  factory ResponseDataStatus.fromJson(Map<String, dynamic> json) =>
      _$ResponseDataStatusFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseDataStatusToJson(this);
}

@JsonSerializable()
class ResponseOtpForgotPassword {
  final int? code;
  final String? payload;
  final String? message;

  const ResponseOtpForgotPassword({this.code, this.payload, this.message});

  factory ResponseOtpForgotPassword.fromJson(Map<String, dynamic> json) =>
      _$ResponseOtpForgotPasswordFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseOtpForgotPasswordToJson(this);
}
