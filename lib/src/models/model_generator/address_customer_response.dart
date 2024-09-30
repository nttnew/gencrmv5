class AddressCustomerResponse {
  dynamic success;
  String? msg;
  int? code;
  String? data;

  AddressCustomerResponse({this.success, this.msg, this.code, this.data});

  AddressCustomerResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    code = json['code'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    data['code'] = this.code;
    data['data'] = this.data;
    return data;
  }
}
