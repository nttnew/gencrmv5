import 'package:json_annotation/json_annotation.dart';
import 'package:gen_crm/src/models/index.dart';

part 'news.g.dart';

@JsonSerializable()
class ListNewsResponse {
  final int code;
  final String? message;
  final List<NewsData> payload;

  const ListNewsResponse({required this.code, this.message, required this.payload});

  factory ListNewsResponse.fromJson(Map<String, dynamic> json) => _$ListNewsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListNewsResponseToJson(this);
}

@JsonSerializable()
class NewsData {
  final int id;
  @JsonKey(name: "new_code")
  final String newCode;
  final String image, category, title, detail;

  @JsonKey(name: "created_date")
  final String createdDate;

  NewsData({required this.id, required this.newCode, required this.image, required this.category, required this.title, required this.detail, required this.createdDate});

  factory NewsData.fromJson(Map<String, dynamic> json) => _$NewsDataFromJson(json);

  Map<String, dynamic> toJson() => _$NewsDataToJson(this);
}
