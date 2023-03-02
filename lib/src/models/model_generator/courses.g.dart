// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoursesResponse _$CoursesResponseFromJson(Map<String, dynamic> json) =>
    CoursesResponse(
      code: json['code'] as int,
      message: json['message'] as String?,
      payload: (json['payload'] as List<dynamic>)
          .map((e) => CoursesData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CoursesResponseToJson(CoursesResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'payload': instance.payload,
    };

DetailCoursesResponse _$DetailCoursesResponseFromJson(
        Map<String, dynamic> json) =>
    DetailCoursesResponse(
      code: json['code'] as int,
      message: json['message'] as String?,
      payload: CoursesData.fromJson(json['payload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetailCoursesResponseToJson(
        DetailCoursesResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'payload': instance.payload,
    };

CoursesData _$CoursesDataFromJson(Map<String, dynamic> json) => CoursesData(
      id: json['id'] as int,
      courseCode: json['course_code'] as String,
      courseName: json['course_name'] as String,
      amountNew: json['amount_new'] as int,
      amountOld: json['amount_old'] as int,
      time: json['time'] as int,
      image: json['image'] as String?,
      fee: json['fee'] as String?,
      author: json['author'] as String?,
      certificate: json['certificate'] as String?,
      level: json['level'] as String?,
      category: json['category'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CoursesDataToJson(CoursesData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course_code': instance.courseCode,
      'course_name': instance.courseName,
      'amount_new': instance.amountNew,
      'amount_old': instance.amountOld,
      'time': instance.time,
      'image': instance.image,
      'fee': instance.fee,
      'author': instance.author,
      'certificate': instance.certificate,
      'category': instance.category,
      'level': instance.level,
      'description': instance.description,
    };

ParamOrderCourse _$ParamOrderCourseFromJson(Map<String, dynamic> json) =>
    ParamOrderCourse(
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      note: json['note'] as String,
    );

Map<String, dynamic> _$ParamOrderCourseToJson(ParamOrderCourse instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'phone': instance.phone,
      'address': instance.address,
      'note': instance.note,
    };
