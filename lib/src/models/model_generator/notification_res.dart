import 'package:json_annotation/json_annotation.dart';

part 'notification_res.g.dart';

@JsonSerializable()
class NotificationCallResponse {
  String? caller_name, caller_number, callid, from, to;

  NotificationCallResponse(
    this.caller_name,
    this.caller_number,
    this.callid,
    this.from,
    this.to,
  );

  factory NotificationCallResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationCallResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationCallResponseToJson(this);
}
