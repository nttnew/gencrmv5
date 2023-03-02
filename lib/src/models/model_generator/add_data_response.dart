import 'package:json_annotation/json_annotation.dart';

import 'base_response.dart';

part 'add_data_response.g.dart';

@JsonSerializable()
class AddData{
  final dynamic id;


  AddData(this.id);

  factory AddData.fromJson(Map<String, dynamic> json) =>
      _$AddDataFromJson(json);

  Map<String, dynamic> toJson() => _$AddDataToJson(this);
}

@JsonSerializable()
class AddDataResponse extends BaseResponse{
  final AddData? data;


  AddDataResponse(
      this.data);

  factory AddDataResponse.fromJson(Map<String, dynamic> json) =>
      _$AddDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddDataResponseToJson(this);
}

@JsonSerializable()
class EditCusResponse {
  final String? idkh,type,msg;
  final bool? success;
  final int? code;


  EditCusResponse(this.idkh, this.type, this.success, this.code, this.msg);

  factory EditCusResponse.fromJson(Map<String, dynamic> json) =>
      _$EditCusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EditCusResponseToJson(this);
}