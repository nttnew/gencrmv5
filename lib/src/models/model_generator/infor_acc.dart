import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'infor_acc.g.dart';

@JsonSerializable(explicitToJson: true)
class InforAcc {
  final String? user_id, fullname, email, phone, avatar, address,department_name;

  InforAcc(this.user_id, this.fullname, this.email, this.phone, this.avatar,
      this.address,this.department_name);

  factory InforAcc.fromJson(Map<String, dynamic> json) =>
      _$InforAccFromJson(json);

  Map<String, dynamic> toJson() => _$InforAccToJson(this);
}

@JsonSerializable(explicitToJson: true)
class InforAccResponse extends BaseResponse {
  final InforAcc? data;

  InforAccResponse(this.data);

  factory InforAccResponse.fromJson(Map<String, dynamic> json) =>
      _$InforAccResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InforAccResponseToJson(this);
}
