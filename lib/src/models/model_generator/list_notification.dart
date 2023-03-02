import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:gen_crm/src/models/model_generator/position_clue.dart';
import 'package:json_annotation/json_annotation.dart';


part 'list_notification.g.dart';
@JsonSerializable(explicitToJson: true)
class DataNotification{
  final String? id,type,title,content,link,module,record_id;


  DataNotification(this.id, this.type, this.title, this.content, this.link,
      this.module,this.record_id);

  factory DataNotification.fromJson(Map<String, dynamic> json) =>
      _$DataNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$DataNotificationToJson(this);
}
@JsonSerializable(explicitToJson: true)
class ListNotification{
  List<DataNotification>? list;
  String? total,page;
  int? limit;

  ListNotification(this.list, this.total, this.limit, this.page);
  factory ListNotification.fromJson(Map<String, dynamic> json) =>
      _$ListNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$ListNotificationToJson(this);
}
@JsonSerializable(explicitToJson: true)
class ListNotificationResponse extends BaseResponse{
  ListNotification data;


  ListNotificationResponse(this.data);

  factory ListNotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$ListNotificationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ListNotificationResponseToJson(this);
}
