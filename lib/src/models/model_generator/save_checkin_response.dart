class CheckInResponse {
  dynamic success;
  String? msg;
  int? code;
  Data? data;

  CheckInResponse({this.success, this.msg, this.code, this.data});

  CheckInResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  int? recordId;

  Data({this.recordId});

  Data.fromJson(Map<String, dynamic> json) {
    recordId = json['recordId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recordId'] = this.recordId;
    return data;
  }
}
