import 'package:json_annotation/json_annotation.dart';
part 'params_change_info.g.dart';
@JsonSerializable()
class ParamChangeInfo {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "user_code")
  String userCode;
  @JsonKey(name: "fullname")
  String fullname;
  @JsonKey(name: "imageBase64")
  String? imageBase64;
  String phone, email, gender, address;

  ParamChangeInfo({
    required this.id,
    required this.userCode,
    required this.fullname,
    this.imageBase64,
    required this.phone,
    required this.email,
    required this.gender,
    required this.address,
  });

  factory ParamChangeInfo.fromJson(Map<String, dynamic> json) => _$ParamChangeInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ParamChangeInfoToJson(this);

  List<Object?> get props => [id, userCode, fullname, imageBase64, phone, email, gender, address];
}

@JsonSerializable()
class ParamChangeInfoNotImage {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "user_code")
  String userCode;
  @JsonKey(name: "fullname")
  String fullname;
  String phone, email, gender, address;

  ParamChangeInfoNotImage({
    required this.id,
    required this.userCode,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.gender,
    required this.address,
  });

  factory ParamChangeInfoNotImage.fromJson(Map<String, dynamic> json) => _$ParamChangeInfoNotImageFromJson(json);
  Map<String, dynamic> toJson() => _$ParamChangeInfoNotImageToJson(this);

  List<Object?> get props => [id, userCode, fullname, phone, email, gender, address];
}
