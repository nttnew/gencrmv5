class QrCodePaymentRes {
  bool? success;
  String? msg;
  int? code;
  Data? data;

  QrCodePaymentRes({this.success, this.msg, this.code, this.data});

  QrCodePaymentRes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    code = json['code'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? qrCode;
  String? qrDataURL;

  Data({this.qrCode, this.qrDataURL});

  Data.fromJson(Map<String, dynamic> json) {
    qrCode = json['qrCode'];
    qrDataURL = json['qrDataURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['qrCode'] = this.qrCode;
    data['qrDataURL'] = this.qrDataURL;
    return data;
  }
}
