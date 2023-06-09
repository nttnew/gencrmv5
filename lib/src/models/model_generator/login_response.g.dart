// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoUserLogin _$InfoUserLoginFromJson(Map<String, dynamic> json) =>
    InfoUserLogin(
      json['user_id'] as String?,
      json['department_id'] as String?,
      json['department_name'] as String?,
      json['fullname'] as String?,
      json['avatar'] as String?,
      json['email'] as String?,
      json['phone'] as String?,
      json['dia_chi'] as String?,
      json['enable_callcenter'] as int?,
      json['info_setup_callcenter'] == null
          ? null
          : InfoSetupCallcenterRes.fromJson(
              json['info_setup_callcenter'] as Map<String, dynamic>),
      json['extension'] as String?,
      json['password_extension'] as String?,
      json['group'] as String?,
    );

Map<String, dynamic> _$InfoUserLoginToJson(InfoUserLogin instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'department_id': instance.department_id,
      'department_name': instance.department_name,
      'fullname': instance.fullname,
      'avatar': instance.avatar,
      'email': instance.email,
      'phone': instance.phone,
      'dia_chi': instance.dia_chi,
      'enable_callcenter': instance.enable_callcenter,
      'info_setup_callcenter': instance.info_setup_callcenter,
      'extension': instance.extension,
      'password_extension': instance.password_extension,
      'group': instance.group,
    };

ItemMenu _$ItemMenuFromJson(Map<String, dynamic> json) => ItemMenu(
      json['id'] as String?,
      json['name'] as String?,
      json['isallow'] as bool?,
    );

Map<String, dynamic> _$ItemMenuToJson(ItemMenu instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isallow': instance.isallow,
    };

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
      tien_te: json['tien_te'] as String?,
      info_user: json['info_user'] == null
          ? null
          : InfoUserLogin.fromJson(json['info_user'] as Map<String, dynamic>),
      token: json['token'] as String?,
      session_id: json['session_id'] as String?,
      menu: (json['menu'] as List<dynamic>?)
          ?.map((e) => ItemMenu.fromJson(e as Map<String, dynamic>))
          .toList(),
      quick: (json['quick'] as List<dynamic>?)
          ?.map((e) => ItemMenu.fromJson(e as Map<String, dynamic>))
          .toList(),
      systemversion: json['systemversion'] as int?,
      outbound_mobile: json['outbound_mobile'] as String?,
      port_mobile: json['port_mobile'] as String?,
      transport_mobile: json['transport_mobile'] as String?,
    );

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
      'tien_te': instance.tien_te,
      'info_user': instance.info_user,
      'token': instance.token,
      'session_id': instance.session_id,
      'menu': instance.menu,
      'quick': instance.quick,
      'outbound_mobile': instance.outbound_mobile,
      'port_mobile': instance.port_mobile,
      'transport_mobile': instance.transport_mobile,
      'systemversion': instance.systemversion,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      json['data'] == null
          ? null
          : LoginData.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };

InfoSetupCallcenterRes _$InfoSetupCallcenterResFromJson(
        Map<String, dynamic> json) =>
    InfoSetupCallcenterRes(
      outbound: json['outbound'] as String?,
      port: json['port'] as String?,
      port_app: json['port_app'] as String?,
      domain: json['domain'] as String?,
      nth: json['nth'] as String?,
      ntd: json['ntd'] as String?,
      zalo_call: json['zalo_call'] as String?,
      type_call: json['type_call'] as int?,
      outbound_proxy: json['outbound_proxy'] as String?,
    );

Map<String, dynamic> _$InfoSetupCallcenterResToJson(
        InfoSetupCallcenterRes instance) =>
    <String, dynamic>{
      'outbound': instance.outbound,
      'port': instance.port,
      'port_app': instance.port_app,
      'domain': instance.domain,
      'nth': instance.nth,
      'ntd': instance.ntd,
      'zalo_call': instance.zalo_call,
      'outbound_proxy': instance.outbound_proxy,
      'type_call': instance.type_call,
    };
