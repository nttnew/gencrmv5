class FileResponse {
  dynamic success;
  String? msg;
  int? code;
  Data? data;

  FileResponse({this.success, this.msg, this.code, this.data});

  FileResponse.fromJson(Map<String, dynamic> json) {
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
  List<FileDataResponse>? list;
  String? msg;

  Data({this.list, this.msg});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list!.add(FileDataResponse.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class FileDataResponse {
  String? id;
  String? name;
  double? dungLuong;
  String? ngayTao;
  String? loaiFile;
  String? link;
  int? is_after;

  FileDataResponse({
    this.id,
    this.name,
    this.dungLuong,
    this.ngayTao,
    this.loaiFile,
    this.link,
    this.is_after,
  });

  FileDataResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    dungLuong = json['dung_luong'];
    ngayTao = json['ngay_tao'];
    loaiFile = json['loai_file'];
    link = json['link'];
    is_after = json['is_after'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['dung_luong'] = this.dungLuong;
    data['ngay_tao'] = this.ngayTao;
    data['loai_file'] = this.loaiFile;
    data['link'] = this.link;
    data['link'] = this.is_after;
    return data;
  }
}
