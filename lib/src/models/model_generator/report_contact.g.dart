// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerContact _$CustomerContactFromJson(Map<String, dynamic> json) =>
    CustomerContact(
      json['id'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$CustomerContactToJson(CustomerContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

DataListContact _$DataListContactFromJson(Map<String, dynamic> json) =>
    DataListContact(
      json['id'] as String?,
      json['name'] as String?,
      json['customer'] == null
          ? null
          : CustomerContact.fromJson(json['customer'] as Map<String, dynamic>),
      json['status'] as String?,
      json['status_edit'] as String?,
      json['status_color'] as String?,
      json['avatar'] as String?,
      json['total_note'] as String?,
      json['conlai'] as String?,
      json['price'],
    );

Map<String, dynamic> _$DataListContactToJson(DataListContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'customer': instance.customer,
      'price': instance.price,
      'status': instance.status,
      'status_edit': instance.status_edit,
      'status_color': instance.status_color,
      'avatar': instance.avatar,
      'total_note': instance.total_note,
      'conlai': instance.conlai,
    };

DataContactReport _$DataContactReportFromJson(Map<String, dynamic> json) =>
    DataContactReport(
      json['page'] as int?,
      json['limit'] as int?,
      json['total'] as String?,
      (json['list'] as List<dynamic>?)
          ?.map((e) => DataListContact.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['tien_te'] as String?,
    );

Map<String, dynamic> _$DataContactReportToJson(DataContactReport instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'list': instance.list,
      'tien_te': instance.tien_te,
    };

ContactReportResponse _$ContactReportResponseFromJson(
        Map<String, dynamic> json) =>
    ContactReportResponse(
      json['data'] == null
          ? null
          : DataContactReport.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..msg = json['msg'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$ContactReportResponseToJson(
        ContactReportResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'code': instance.code,
      'data': instance.data,
    };

RequestBodyReport _$RequestBodyReportFromJson(Map<String, dynamic> json) =>
    RequestBodyReport(
      id: json['id'] as int?,
      diem_ban: json['diem_ban'] as String?,
      time: json['time'] as int?,
      page: json['page'] as int?,
      gt: json['gt'] as String?,
    );

Map<String, dynamic> _$RequestBodyReportToJson(RequestBodyReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'diem_ban': instance.diem_ban,
      'gt': instance.gt,
      'time': instance.time,
      'page': instance.page,
    };
