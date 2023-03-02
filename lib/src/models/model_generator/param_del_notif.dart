import 'package:json_annotation/json_annotation.dart';


part 'param_del_notif.g.dart';

@JsonSerializable()
class DelNotifiParam {
  final int id;
  final String type;


  DelNotifiParam(this.id, this.type);

  factory DelNotifiParam.fromJson(Map<String, dynamic> json) => _$DelNotifiParamFromJson(json);
  Map<String, dynamic> toJson() => _$DelNotifiParamToJson(this);
}