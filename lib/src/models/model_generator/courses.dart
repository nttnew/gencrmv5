import 'package:json_annotation/json_annotation.dart';
import 'package:gen_crm/src/models/index.dart';

part 'courses.g.dart';

@JsonSerializable()
class CoursesResponse {
  final int code;
  final String? message;
  final List<CoursesData> payload;

  const CoursesResponse({required this.code, this.message, required this.payload});

  factory CoursesResponse.fromJson(Map<String, dynamic> json) => _$CoursesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CoursesResponseToJson(this);
}

@JsonSerializable()
class DetailCoursesResponse {
  final int code;
  final String? message;
  final CoursesData payload;

  const DetailCoursesResponse({required this.code, this.message, required this.payload});

  factory DetailCoursesResponse.fromJson(Map<String, dynamic> json) => _$DetailCoursesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DetailCoursesResponseToJson(this);
}

@JsonSerializable()
class CoursesData {
  final int id;
  @JsonKey(name: "course_code")
  final String courseCode;
  @JsonKey(name: "course_name")
  final String courseName;
  @JsonKey(name: "amount_new")
  final int amountNew;
  @JsonKey(name: "amount_old")
  final int amountOld;
  final int time;
  final String? image, fee, author, certificate, category, level, description;

  CoursesData({required this.id, required this.courseCode, required this.courseName, required this.amountNew, required this.amountOld,
    required this.time, required this.image, required this.fee, required this.author, required this.certificate,
    required this.level, required this.category, required this.description});

  factory CoursesData.fromJson(Map<String, dynamic> json) => _$CoursesDataFromJson(json);

  Map<String, dynamic> toJson() => _$CoursesDataToJson(this);
}


@JsonSerializable()
class ParamOrderCourse {
  @JsonKey(name: "full_name")
  String fullName;
  @JsonKey(name: "phone")
  String phone;
  @JsonKey(name: "address")
  String address;
  @JsonKey(name: "note")
  String note;

  ParamOrderCourse(
      {
        required this.fullName,
        required this.phone,
        required this.address,
        required this.note,
      });

  factory ParamOrderCourse.fromJson(Map<String, dynamic> json) => _$ParamOrderCourseFromJson(json);
  Map<String, dynamic> toJson() => _$ParamOrderCourseToJson(this);
}
