import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_contact.g.dart';

@JsonSerializable()
class CustomerContact {
  final String? id;
  final String? name;

  CustomerContact(this.id, this.name);

  factory CustomerContact.fromJson(Map<String, dynamic> json) =>
      _$CustomerContactFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerContactToJson(this);
}

@JsonSerializable()
class DataListContact {
  final String? id;
  final String? name;
  final CustomerContact? customer;
  final dynamic price;
  final String? status;
  final String? status_edit;
  final String? status_color;
  final String? avatar;
  final String? total_note;
  final String? conlai;

  DataListContact(
      this.id,
      this.name,
      this.customer,
      this.status,
      this.status_edit,
      this.status_color,
      this.avatar,
      this.total_note,
      this.conlai,
      this.price);

  factory DataListContact.fromJson(Map<String, dynamic> json) =>
      _$DataListContactFromJson(json);

  Map<String, dynamic> toJson() => _$DataListContactToJson(this);
}

@JsonSerializable()
class DataContactReport {
  final int? page;
  final int? limit;
  final String? total;
  final List<DataListContact>? list;
  final String? tien_te;

  DataContactReport(this.page, this.limit, this.total, this.list, this.tien_te);

  factory DataContactReport.fromJson(Map<String, dynamic> json) =>
      _$DataContactReportFromJson(json);

  Map<String, dynamic> toJson() => _$DataContactReportToJson(this);
}

@JsonSerializable()
class ContactReportResponse extends BaseResponse {
  final DataContactReport? data;

  ContactReportResponse(this.data);

  factory ContactReportResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContactReportResponseToJson(this);
}

@JsonSerializable()
class RequestBodyReport {
  final int? id;
  final String? diem_ban, gt;
  final int? time;
  final int? page;

  RequestBodyReport(
      {required this.id,
      required this.diem_ban,
      required this.time,
      required this.page,
      this.gt});

  factory RequestBodyReport.fromJson(Map<String, dynamic> json) =>
      _$RequestBodyReportFromJson(json);
  Map<String, dynamic> toJson() => _$RequestBodyReportToJson(this);
}
