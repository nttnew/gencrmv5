import 'package:json_annotation/json_annotation.dart';
part 'action_model.g.dart';

@JsonSerializable()
class ActionModel {
  String? val;
  int? action;

  ActionModel(
    this.val,
    this.action,
  );

  factory ActionModel.fromJson(Map<String, dynamic> json) => _$ActionModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActionModelToJson(this);
}
