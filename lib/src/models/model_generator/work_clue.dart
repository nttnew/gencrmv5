import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'work_clue.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkClueData{
  String? id,id_customer,name_customer,name_job,status_job,start_date,content_job,user_work_id,user_work_name,user_work_avatar,color;
  int? total_comment;


  WorkClueData(
  {this.id,
      this.id_customer,
      this.name_customer,
      this.name_job,
      this.status_job,
      this.start_date,
      this.content_job,
      this.user_work_id,
      this.user_work_name,
      this.user_work_avatar,
      this.total_comment,
    this.color
  });

  factory WorkClueData.fromJson(Map<String, dynamic> json) =>
      _$WorkClueDataFromJson(json);
  Map<String, dynamic> toJson() => _$WorkClueDataToJson(this);
}
@JsonSerializable(explicitToJson: true)
class WorkClueResponse extends BaseResponse{
  List<WorkClueData>? data;

  WorkClueResponse(this.data);

  factory WorkClueResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkClueResponseFromJson(json);
  Map<String, dynamic> toJson() => _$WorkClueResponseToJson(this);
}
