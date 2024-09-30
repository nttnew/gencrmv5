class ServiceParkResponse {
  dynamic success;
  int? code;
  String? msg;
  List<DataServicePark>? data;
  String? urlCall;

  ServiceParkResponse(
      {this.success, this.code, this.msg, this.data, this.urlCall});

  ServiceParkResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <DataServicePark>[];
      json['data'].forEach((v) {
        data!.add(new DataServicePark.fromJson(v));
      });
    }
    urlCall = json['url_call'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['url_call'] = this.urlCall;
    return data;
  }
}

class DataServicePark {
  String? s0;
  String? s1;
  String? s2;
  String? s3;
  String? s4;
  String? s5;
  String? s6;
  String? s7;
  String? id;
  String? tenCombo;
  String? goiYDichVu;
  String? suDung;
  String? ngayTao;
  String? nguoiTao;
  String? ngaySua;
  String? nguoiSua;
  int? tongTien;
  int? countSp;
  String? tongTienFormat;
  bool? isSelect;

  DataServicePark(
      {this.s0,
      this.s1,
      this.s2,
      this.s3,
      this.s4,
      this.s5,
      this.s6,
      this.s7,
      this.id,
      this.tenCombo,
      this.goiYDichVu,
      this.suDung,
      this.ngayTao,
      this.nguoiTao,
      this.ngaySua,
      this.nguoiSua,
      this.tongTien,
      this.countSp,
      this.tongTienFormat});

  DataServicePark.fromJson(Map<String, dynamic> json) {
    s0 = json['0'];
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
    s5 = json['5'];
    s6 = json['6'];
    s7 = json['7'];
    id = json['id'];
    tenCombo = json['ten_combo'];
    goiYDichVu = json['goi_y_dich_vu'];
    suDung = json['su_dung'];
    ngayTao = json['ngay_tao'];
    nguoiTao = json['nguoi_tao'];
    ngaySua = json['ngay_sua'];
    nguoiSua = json['nguoi_sua'];
    tongTien = json['tong_tien'];
    countSp = json['count_sp'];
    tongTienFormat = json['tong_tien_format'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0'] = this.s0;
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    data['4'] = this.s4;
    data['5'] = this.s5;
    data['6'] = this.s6;
    data['7'] = this.s7;
    data['id'] = this.id;
    data['ten_combo'] = this.tenCombo;
    data['goi_y_dich_vu'] = this.goiYDichVu;
    data['su_dung'] = this.suDung;
    data['ngay_tao'] = this.ngayTao;
    data['nguoi_tao'] = this.nguoiTao;
    data['ngay_sua'] = this.ngaySua;
    data['nguoi_sua'] = this.nguoiSua;
    data['tong_tien'] = this.tongTien;
    data['count_sp'] = this.countSp;
    data['tong_tien_format'] = this.tongTienFormat;
    return data;
  }
}
