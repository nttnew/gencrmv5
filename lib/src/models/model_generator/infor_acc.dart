import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'infor_acc.g.dart';

@JsonSerializable(explicitToJson: true)
class InfoAcc {
  final String? user_id, fullname, email, phone, avatar, address,department_name;

  InfoAcc(this.user_id, this.fullname, this.email, this.phone, this.avatar,
      this.address,this.department_name);

  factory InfoAcc.fromJson(Map<String, dynamic> json) =>
      _$InforAccFromJson(json);

  Map<String, dynamic> toJson() => _$InforAccToJson(this);
}

@JsonSerializable(explicitToJson: true)
class InfoAccResponse extends BaseResponse {
  final InfoAcc? data;

  InfoAccResponse(this.data);

  factory InfoAccResponse.fromJson(Map<String, dynamic> json) =>
      _$InforAccResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InforAccResponseToJson(this);
}
