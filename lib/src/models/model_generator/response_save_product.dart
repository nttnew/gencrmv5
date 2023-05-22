class ResponseSaveProduct {
  bool? success;
  int? code;
  String? msg;
  List<dynamic>? data;
  int? id;

  ResponseSaveProduct({this.success, this.code, this.msg, this.data, this.id});

  ResponseSaveProduct.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Null>[];
      json['data'].forEach((v) {
        data!.add(v);
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}
