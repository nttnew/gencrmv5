import 'package:json_annotation/json_annotation.dart';

part 'param_read_notifi.g.dart';

@JsonSerializable()
class ReadNotifiParam {
  final String id;
  final String type;

  ReadNotifiParam(this.id, this.type);

  factory ReadNotifiParam.fromJson(Map<String, dynamic> json) =>
      _$ReadNotifiParamFromJson(json);
  Map<String, dynamic> toJson() => _$ReadNotifiParamToJson(this);
}
