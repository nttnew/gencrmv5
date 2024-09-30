class BaoCaoSoQuy {
  dynamic success;
  int? code;
  String? msg;
  DataBaoCaoSoQuy? data;

  BaoCaoSoQuy({
    this.success,
    this.code,
    this.msg,
    this.data,
  });

  BaoCaoSoQuy.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? DataBaoCaoSoQuy.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataBaoCaoSoQuy {
  String? dauKy;
  String? tongThu;
  String? tongChi;
  String? tongDuCuoi;
  List<DataListSoQuy>? data;
  int? t;

  DataBaoCaoSoQuy({
    this.dauKy,
    this.tongThu,
    this.tongChi,
    this.tongDuCuoi,
    this.data,
    this.t,
  });

  DataBaoCaoSoQuy.fromJson(Map<String, dynamic> json) {
    dauKy = json['dauky'];
    tongThu = json['tongthu'];
    tongChi = json['tongchi'];
    tongDuCuoi = json['tongducuoi'];
    if (json['data'] != null) {
      data = <DataListSoQuy>[];
      json['data'].forEach((v) {
        data!.add(DataListSoQuy.fromJson(v));
      });
    }
    t = json['t'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dauky'] = this.dauKy;
    data['tongthu'] = this.tongThu;
    data['tongchi'] = this.tongChi;
    data['tongducuoi'] = this.tongDuCuoi;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['t'] = this.t;
    return data;
  }
}

class DataListSoQuy {
  dynamic soPhieu;
  String? ghiChu;
  int? thu;
  String? soTien;
  String? hinhThucTt;
  String? ngay;

  DataListSoQuy({
    this.soPhieu,
    this.ghiChu,
    this.thu,
    this.soTien,
    this.hinhThucTt,
    this.ngay,
  });

  DataListSoQuy.fromJson(Map<String, dynamic> json) {
    soPhieu = json['so_phieu'];
    ghiChu = json['ghi_chu'];
    thu = json['thu'];
    soTien = json['so_tien'];
    hinhThucTt = json['hinh_thuc_tt'];
    ngay = json['ngay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['so_phieu'] = this.soPhieu;
    data['ghi_chu'] = this.ghiChu;
    data['thu'] = this.thu;
    data['so_tien'] = this.soTien;
    data['hinh_thuc_tt'] = this.hinhThucTt;
    data['ngay'] = this.ngay;
    return data;
  }
}
