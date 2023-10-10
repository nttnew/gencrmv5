import 'dart:ui';

import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';

@JsonSerializable()
class InfoUserLogin {
  final String? user_id, department_id;
  final String? department_name, fullname, avatar, email, phone, dia_chi;
  final int? enable_callcenter;
  final InfoSetupCallcenterRes? info_setup_callcenter;
  final String? extension, password_extension, group;

  InfoUserLogin(
      this.user_id,
      this.department_id,
      this.department_name,
      this.fullname,
      this.avatar,
      this.email,
      this.phone,
      this.dia_chi,
      this.enable_callcenter,
      this.info_setup_callcenter,
      this.extension,
      this.password_extension,
      this.group);

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
  final List<ItemMenu>? quick;
  final String? outbound_mobile, port_mobile, transport_mobile;
  final int? systemversion;
  final List<LanguagesResponse>? languages;

  LoginData({
    this.tien_te,
    this.info_user,
    this.token,
    this.session_id,
    this.menu,
    this.quick,
    this.systemversion,
    this.outbound_mobile,
    this.port_mobile,
    this.transport_mobile,
    this.languages,
  });

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

@JsonSerializable()
class InfoSetupCallcenterRes {
  final String? outbound,
      port,
      port_app,
      domain,
      nth,
      ntd,
      zalo_call,
      outbound_proxy,
      outbound_server,
      wss_mobile,
      api_url,
      domain_mobile;
  final int? type_call;

  InfoSetupCallcenterRes({
    this.outbound,
    this.port,
    this.port_app,
    this.domain,
    this.nth,
    this.ntd,
    this.zalo_call,
    this.type_call,
    this.outbound_proxy,
    this.outbound_server,
    this.wss_mobile,
    this.api_url,
    this.domain_mobile,
  });

  factory InfoSetupCallcenterRes.fromJson(Map<String, dynamic> json) =>
      _$InfoSetupCallcenterResFromJson(json);
  Map<String, dynamic> toJson() => _$InfoSetupCallcenterResToJson(this);
}

@JsonSerializable()
class LanguagesResponse {
  String? label;
  @JsonKey(name: 'default')
  int? defaultLanguages;
  String? flag;
  String? name;
  Locale? localeMy;

  LanguagesResponse({
    this.label,
    this.defaultLanguages,
    this.flag,
    this.name,
    this.localeMy,
  });

  factory LanguagesResponse.fromJson(Map<String, dynamic> json) =>
      _$LanguagesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LanguagesResponseToJson(this);
}
