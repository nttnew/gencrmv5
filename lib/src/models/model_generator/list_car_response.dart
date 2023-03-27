class ListCarInfo {
  bool? success;
  String? msg;
  int? code;
  DataCar? data;

  ListCarInfo({this.success, this.msg, this.code, this.data});

  ListCarInfo.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    code = json['code'];
    data = json['data'] != null ? new DataCar.fromJson(json['data']) : null;
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

class DataCar {
  List<HangXe>? hangXe;
  List<Versions>? versions;

  DataCar({this.hangXe, this.versions});

  DataCar.fromJson(Map<String, dynamic> json) {
    if (json['hang_xe'] != null) {
      hangXe = <HangXe>[];
      json['hang_xe'].forEach((v) {
        hangXe!.add(new HangXe.fromJson(v));
      });
    }
    if (json['versions'] != null) {
      versions = <Versions>[];
      json['versions'].forEach((v) {
        versions!.add(new Versions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hangXe != null) {
      data['hang_xe'] = this.hangXe!.map((v) => v.toJson()).toList();
    }
    if (this.versions != null) {
      data['versions'] = this.versions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HangXe {
  int? id;
  String? name;

  HangXe({this.id, this.name});

  HangXe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Versions {
  String? hangXe;
  String? hangXeId;
  String? dongXe;
  String? dongXeId;
  String? namSanXuat;
  String? loaiXe;
  String? loaiXeId;
  String? kieuDang;
  String? kieuDangId;
  String? phienBan;
  String? phienBanId;
  String? soCho;

  Versions(
      {this.hangXe,
        this.hangXeId,
        this.dongXe,
        this.dongXeId,
        this.namSanXuat,
        this.loaiXe,
        this.loaiXeId,
        this.kieuDang,
        this.kieuDangId,
        this.phienBan,
        this.phienBanId,
        this.soCho});

  Versions.fromJson(Map<String, dynamic> json) {
    hangXe = json['hang_xe'];
    hangXeId = json['hang_xe_id'];
    dongXe = json['dong_xe'];
    dongXeId = json['dong_xe_id'];
    namSanXuat = json['nam_san_xuat'];
    loaiXe = json['loai_xe'];
    loaiXeId = json['loai_xe_id'];
    kieuDang = json['kieu_dang'];
    kieuDangId = json['kieu_dang_id'];
    phienBan = json['phien_ban'];
    phienBanId = json['phien_ban_id'];
    soCho = json['so_cho'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hang_xe'] = this.hangXe;
    data['hang_xe_id'] = this.hangXeId;
    data['dong_xe'] = this.dongXe;
    data['dong_xe_id'] = this.dongXeId;
    data['nam_san_xuat'] = this.namSanXuat;
    data['loai_xe'] = this.loaiXe;
    data['loai_xe_id'] = this.loaiXeId;
    data['kieu_dang'] = this.kieuDang;
    data['kieu_dang_id'] = this.kieuDangId;
    data['phien_ban'] = this.phienBan;
    data['phien_ban_id'] = this.phienBanId;
    data['so_cho'] = this.soCho;
    return data;
  }
}
