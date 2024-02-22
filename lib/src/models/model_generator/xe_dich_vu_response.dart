class XeDichVuResponse {
  DataXeDichVuResponse? data;
  bool? success;
  int? code;
  String? msg;

  XeDichVuResponse({
    this.success,
    this.code,
    this.msg,
    this.data,
  });

  XeDichVuResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null
        ? DataXeDichVuResponse.fromJson(json['data'])
        : null;
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

class DataXeDichVuResponse {
  List<XeDichVu>? dataHD;
  String? t;

  DataXeDichVuResponse({
    this.dataHD,
    this.t,
  });

  DataXeDichVuResponse.fromJson(Map<String, dynamic> json) {
    if (json['dataHD'] != null) {
      dataHD = <XeDichVu>[];
      json['dataHD'].forEach((v) {
        dataHD!.add(XeDichVu.fromJson(v));
      });
    }
    t = json['t'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.dataHD != null) {
      data['dataHD'] = this.dataHD!.map((v) => v.toJson()).toList();
    }
    data['t'] = this.t;
    return data;
  }
}

class XeDichVu {
  String? id;
  String? bienSo;
  String? soPhieu;
  String? trangThai;
  String? khachHangId;
  String? tenKhachHang;
  String? diDong;
  String? chiNhanh;
  String? ngayVao;
  String? ngayRa;

  XeDichVu({
    this.id,
    this.bienSo,
    this.soPhieu,
    this.trangThai,
    this.khachHangId,
    this.tenKhachHang,
    this.diDong,
    this.chiNhanh,
    this.ngayVao,
    this.ngayRa,
  });

  XeDichVu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bienSo = json['bien_so'];
    soPhieu = json['so_phieu'];
    trangThai = json['trang_thai'];
    khachHangId = json['khach_hang_id'];
    tenKhachHang = json['ten_khach_hang'];
    diDong = json['di_dong'];
    chiNhanh = json['chi_nhanh'];
    ngayVao = json['ngay_vao'];
    ngayRa = json['ngay_ra'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['bien_so'] = this.bienSo;
    data['so_phieu'] = this.soPhieu;
    data['trang_thai'] = this.trangThai;
    data['khach_hang_id'] = this.khachHangId;
    data['ten_khach_hang'] = this.tenKhachHang;
    data['di_dong'] = this.diDong;
    data['chi_nhanh'] = this.chiNhanh;
    data['ngay_vao'] = this.ngayVao;
    data['ngay_ra'] = this.ngayRa;
    return data;
  }
}
