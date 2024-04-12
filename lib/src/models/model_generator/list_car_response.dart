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
    data = json['data'] != null ? DataCar.fromJson(json['data']) : null;
  }

  ListCarInfo.fromJson2(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    code = json['code'];
    data = json['data'] != null ? DataCar.fromJson(json['data']) : null;
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

  DataCar({
    this.hangXe,
    this.versions,
  });

  DataCar.fromJson2(Map<String, dynamic> json) {
    if (json['hang_xe'] != null) {
      hangXe = <HangXe>[];
      json['hang_xe'].forEach((v) {
        hangXe!.add(HangXe.fromJson(v));
      });
    }
    if (json['versions'] != null) {
      versions = <Versions>[];
      json['versions'].forEach((v) {
        versions!.add(Versions.fromJson(v));
      });
    }
  }

  DataCar.fromJson(Map<String, dynamic> json) {
    if (json['hang_xe'] != null) {
      hangXe = <HangXe>[];
      Map<String, dynamic> mapHangXe = json['hang_xe'];
      mapHangXe.forEach((key, value) {
        hangXe!.add(HangXe.fromJson(value));
      });
    }
    if (json['versions'] != null) {
      versions = <Versions>[];
      Map<String, dynamic> mapVersion = json['versions'];
      mapVersion.forEach((key, value) {
        versions!.add(Versions.fromJson(value));
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

  HangXe({
    this.id,
    this.name,
  });

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

  static HangXe empty = HangXe(id: 0, name: '');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HangXe && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
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

  Versions({
    this.hangXe,
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
    this.soCho,
  });

  Versions.fromJson(Map<String, dynamic> json) {
    hangXe = _checkNull(json['hang_xe']);
    hangXeId = _checkNull(json['hang_xe_id']);
    dongXe = _checkNull(json['dong_xe']);
    dongXeId = _checkNull(json['dong_xe_id']);
    namSanXuat = _checkNull(json['nam_san_xuat']);
    loaiXe = _checkNull(json['loai_xe']);
    loaiXeId = _checkNull(json['loai_xe_id']);
    kieuDang = _checkNull(json['kieu_dang']);
    kieuDangId = _checkNull(json['kieu_dang_id']);
    phienBan = _checkNull(json['phien_ban']);
    phienBanId = _checkNull(json['phien_ban_id']);
    soCho = _checkNull(json['so_cho']);
  }

  String? _checkNull(dynamic value) {
    return '$value' == '' ? null : value.toString();
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
