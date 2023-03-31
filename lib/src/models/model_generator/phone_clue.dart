import 'package:json_annotation/json_annotation.dart';
part 'phone_clue.g.dart';

@JsonSerializable()
class Phone {
  String? val;
  int? action;

  Phone(this.val, this.action);

  factory Phone.fromJson(Map<String, dynamic> json) => _$PhoneFromJson(json);
  Map<String, dynamic> toJson() => _$PhoneToJson(this);
}
