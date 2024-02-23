class DetailXeDichVuResponse {
  bool? success;
  int? code;
  String? msg;
  DetailXeDichVuData? data;

  DetailXeDichVuResponse({
    this.success,
    this.code,
    this.msg,
    this.data,
  });

  DetailXeDichVuResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    data =
        json['data'] != null ? DetailXeDichVuData.fromJson(json['data']) : null;
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

class DetailXeDichVuData {
  List<CTDichVu>? listNhanCong;
  List<CTDichVu>? listPhuTung;
  List<List<dynamic>>? listNguoiThucHien;
  List<List<dynamic>>? listTienDo;
  List<List<dynamic>>? listTrangThai;

  DetailXeDichVuData({
    this.listNhanCong,
    this.listPhuTung,
    this.listNguoiThucHien,
    this.listTienDo,
    this.listTrangThai,
  });

  DetailXeDichVuData.fromJson(Map<String, dynamic> json) {
    if (json['list_nhancong'] != null) {
      listNhanCong = <CTDichVu>[];
      json['list_nhancong'].forEach((v) {
        listNhanCong!.add(CTDichVu.fromJson(v));
      });
    }
    if (json['list_phutung'] != null) {
      listPhuTung = <CTDichVu>[];
      json['list_phutung'].forEach((v) {
        listPhuTung!.add(CTDichVu.fromJson(v));
      });
    }
    if (json['list_nguoithuchien'] != null) {
      listNguoiThucHien = <List<dynamic>>[];
      json['list_nguoithuchien'].forEach((v) {
        listNguoiThucHien!.add(v);
      });
    }
    if (json['list_tiendo'] != null) {
      listTienDo = <List<dynamic>>[];
      json['list_tiendo'].forEach((v) {
        listTienDo!.add(v);
      });
    }
    if (json['list_trangthai'] != null) {
      listTrangThai = <List<dynamic>>[];
      json['list_trangthai'].forEach((v) {
        listTrangThai!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.listNhanCong != null) {
      data['list_nhancong'] =
          this.listNhanCong!.map((v) => v.toJson()).toList();
    }
    if (this.listPhuTung != null) {
      data['list_phutung'] = this.listPhuTung!.map((v) => v.toJson()).toList();
    }
    if (this.listNguoiThucHien != null) {
      data['list_nguoithuchien'] =
          this.listNguoiThucHien!.map((v) => v).toList();
    }
    if (this.listTienDo != null) {
      data['list_tiendo'] = this.listTienDo!.map((v) => v).toList();
    }
    if (this.listTrangThai != null) {
      data['list_trangthai'] = this.listTrangThai!.map((v) => v).toList();
    }
    return data;
  }
}

class CTDichVu {
  String? idct;
  String? nguoiThucHien;
  dynamic idTienDo;
  String? idNguoiThucHien;
  String? tienDo;
  String? tenSanPham;
  String? soLuong;
  String? donViTinh;

  CTDichVu({
    this.idct,
    this.nguoiThucHien,
    this.idTienDo,
    this.idNguoiThucHien,
    this.tienDo,
    this.tenSanPham,
    this.soLuong,
    this.donViTinh,
  });

  CTDichVu.fromJson(Map<String, dynamic> json) {
    idct = json['idct'];
    nguoiThucHien = json['nguoi_thuc_hien'];
    idTienDo = json['id_tien_do'];
    idNguoiThucHien = json['id_nguoi_thuc_hien'];
    tienDo = json['tien_do'];
    tenSanPham = json['ten_san_pham'];
    soLuong = json['so_luong'];
    donViTinh = json['don_vi_tinh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['idct'] = this.idct;
    data['nguoi_thuc_hien'] = this.nguoiThucHien;
    data['id_tien_do'] = this.idTienDo;
    data['id_nguoi_thuc_hien'] = this.idNguoiThucHien;
    data['tien_do'] = this.tienDo;
    data['ten_san_pham'] = this.tenSanPham;
    data['so_luong'] = this.soLuong;
    data['don_vi_tinh'] = this.donViTinh;
    return data;
  }
}
