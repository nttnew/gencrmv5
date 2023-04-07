import 'package:json_annotation/json_annotation.dart';

part 'update_pass_request.g.dart';

@JsonSerializable()
class UpdatePassRequest {
  final String oldpass, newpass, username;

  UpdatePassRequest(
      {required this.oldpass, required this.newpass, required this.username});

  factory UpdatePassRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePassRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdatePassRequestToJson(this);
}
