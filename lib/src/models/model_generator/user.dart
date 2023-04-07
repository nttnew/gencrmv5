import 'package:json_annotation/json_annotation.dart';
import 'package:gen_crm/src/models/index.dart';

part 'user.g.dart';

@JsonSerializable()
class UserResponse {
  final bool? status;
  final DataUser? data;
  final String? message;

  const UserResponse({this.status, this.message, this.data});

  static const empty = UserResponse(status: true, data: null, message: '');

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}

@JsonSerializable()
class DataUser {
  final String? token;
  final InfoUser? user;

  const DataUser({this.token, this.user});

  static const empty = DataUser(user: null, token: '');

  factory DataUser.fromJson(Map<String, dynamic> json) =>
      _$DataUserFromJson(json);

  Map<String, dynamic> toJson() => _$DataUserToJson(this);
}
