import 'package:json_annotation/json_annotation.dart';

part 'change_infor_acc_request.g.dart';

@JsonSerializable()
class ChangeInforAccRequest {
  final String ho_va_ten, email, dien_thoai, dia_chi, avatar;

  ChangeInforAccRequest(
      {required this.ho_va_ten,
      required this.email,
      required this.dien_thoai,
      required this.dia_chi,
      required this.avatar});

  factory ChangeInforAccRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangeInforAccRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ChangeInforAccRequestToJson(this);
}
