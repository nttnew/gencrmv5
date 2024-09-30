class BieuMauResponse {
  dynamic success;
  String? msg;
  int? code;
  List<BieuMauItemRes>? data;

  BieuMauResponse({
    this.success,
    this.msg,
    this.code,
    this.data,
  });

  BieuMauResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    code = json['code'];
    if (json['data'] != null) {
      data = <BieuMauItemRes>[];
      json['data'].forEach((v) {
        data!.add(BieuMauItemRes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BieuMauItemRes {
  String? id;
  String? tenBieuMau;

  BieuMauItemRes({
    this.id,
    this.tenBieuMau,
  });

  BieuMauItemRes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenBieuMau = json['ten_bieu_mau'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['ten_bieu_mau'] = this.tenBieuMau;
    return data;
  }
}
