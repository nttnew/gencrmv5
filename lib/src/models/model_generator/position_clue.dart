import 'package:json_annotation/json_annotation.dart';
part 'position_clue.g.dart';

@JsonSerializable()
class Position {
  String? id;
  String? name;

  Position(this.id, this.name);

  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);
  Map<String, dynamic> toJson() => _$PositionToJson(this);
}
