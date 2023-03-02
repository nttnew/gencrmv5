import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:gen_crm/src/src_index.dart';

part 'info_user.g.dart';

@JsonSerializable()
// ignore: must_be_immutable
class InfoUser extends Equatable {
  int? id;
  @JsonKey(name: "user_code")
  String? userCode;
  @JsonKey(name: "fullname")
  String? fullName;
  String? phone, gender, address, email, role, token, avatar;
  @JsonKey(name: "otp_code")
  String? otpCode;
  @JsonKey(name: "device_token")
  String? deviceToken;

  static const empty = null;

  InfoUser({
      this.id,
      this.userCode,
      this.fullName,
      this.avatar,
      this.phone,
      this.gender,
      this.address,
      this.email,
      this.role,
      this.token,
      this.otpCode,
      this.deviceToken
  });

  InfoUser copyWith(
      {
        String? userCode,
        int? id,
        String? fullName,
        String? avatar,
        String? phone, gender, address, email, role, token,
        String? otpCode,
        String? deviceToken,
      }) {
    return InfoUser(
      id: id ?? this.id,
      userCode: userCode ?? this.userCode,
      fullName: fullName ?? this.fullName,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
      otpCode: otpCode ?? this.otpCode,
      deviceToken: deviceToken ?? this.deviceToken,
    );
  }

  factory InfoUser.fromJson(Map<String, dynamic> json) =>
      _$InfoUserFromJson(json);

  Map<String, dynamic> toJson() => _$InfoUserToJson(this);

  @override
  List<Object> get props => [
    id!, gender!, userCode!, avatar!, fullName!, role!, token!, otpCode!, phone!, deviceToken!, address!, email!
  ];
}