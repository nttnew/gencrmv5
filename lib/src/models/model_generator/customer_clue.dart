import 'package:json_annotation/json_annotation.dart';
part 'customer_clue.g.dart';

@JsonSerializable()
class Customer {
  String? id;
  String? name;
  String? danh_xung;

  Customer(
    this.id,
    this.name,
    this.danh_xung,
  );

  Customer.two({
    this.id,
    this.name,
    this.danh_xung,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
