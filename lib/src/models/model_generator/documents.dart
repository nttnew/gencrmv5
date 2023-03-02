import 'package:json_annotation/json_annotation.dart';
import 'package:gen_crm/src/models/index.dart';

part 'documents.g.dart';

@JsonSerializable()
class ListDocumentsResponse {
  final int code;
  final String? message;
  final List<ListDocumentsData> payload;

  const ListDocumentsResponse({required this.code, this.message, required this.payload});

  factory ListDocumentsResponse.fromJson(Map<String, dynamic> json) => _$ListDocumentsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListDocumentsResponseToJson(this);
}

@JsonSerializable()
class ListDocumentsData {
  @JsonKey(name: "documentation_code")
  final String documentationCode;
  @JsonKey(name: "documentations_dtl_code")
  final String documentationDtlCode;
  final String image, summary, title;

  @JsonKey(name: "created_date")
  final String createdDate;

  ListDocumentsData({required this.documentationDtlCode, required this.documentationCode, required this.image, required this.summary, required this.title, required this.createdDate});

  factory ListDocumentsData.fromJson(Map<String, dynamic> json) => _$ListDocumentsDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListDocumentsDataToJson(this);
}
