import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';

@JsonSerializable()
class InfoUserLogin {
  final String? user_id, department_id;
  final String? department_name, fullname, avatar, email, phone, dia_chi;
  final int? enable_callcenter;

  InfoUserLogin(
      this.user_id,
      this.department_id,
      this.department_name,
      this.fullname,
      this.avatar,
      this.email,
      this.phone,
      this.dia_chi,
      this.enable_callcenter);

  factory InfoUserLogin.fromJson(Map<String, dynamic> json) =>
      _$InfoUserLoginFromJson(json);
  Map<String, dynamic> toJson() => _$InfoUserLoginToJson(this);
}

@JsonSerializable()
class ItemMenu {
  final String? id, name;
  final bool? isallow;

  ItemMenu(this.id, this.name,
      this.isallow); //static const empty =  InfoUserLogin('', '', '', '', '', '', '', 0);

  factory ItemMenu.fromJson(Map<String, dynamic> json) =>
      _$ItemMenuFromJson(json);
  Map<String, dynamic> toJson() => _$ItemMenuToJson(this);
}

@JsonSerializable()
class LoginData {
  final String? tien_te;
  final InfoUserLogin? info_user;
  final String? token, session_id;
  final List<ItemMenu>? menu;

  LoginData(
      {this.tien_te, this.info_user, this.token, this.session_id, this.menu});

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);
  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable()
class LoginResponse extends BaseResponse {
  final LoginData? data;

  LoginResponse(this.data);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
