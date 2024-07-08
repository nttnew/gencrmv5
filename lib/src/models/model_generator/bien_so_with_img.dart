class BienSoWithImgResponse {
  bool? success;
  String? msg;
  int? code;
  DataBienSoWithImg? data;

  BienSoWithImgResponse({
    this.success,
    this.msg,
    this.code,
    this.data,
  });

  BienSoWithImgResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    code = json['code'];
    data =
        json['data'] != null ? DataBienSoWithImg.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataBienSoWithImg {
  List<ListBienSos>? listBienSos;
  List<dynamic>? listLoaiXes;
  List<dynamic>? listBienSoNgoaiVungs;
  List<dynamic>? listLoaiXeNgoaiVungs;
  double? recognitionTime;

  DataBienSoWithImg({
    this.listBienSos,
    this.listLoaiXes,
    this.listBienSoNgoaiVungs,
    this.listLoaiXeNgoaiVungs,
    this.recognitionTime,
  });

  DataBienSoWithImg.fromJson(Map<String, dynamic> json) {
    if (json['listBienSos'] != null) {
      listBienSos = <ListBienSos>[];
      json['listBienSos'].forEach((v) {
        listBienSos!.add(ListBienSos.fromJson(v));
      });
    }
    if (json['listLoaiXes'] != null) {
      listLoaiXes = <Null>[];
      json['listLoaiXes'].forEach((v) {
        listLoaiXes!.add(v);
      });
    }
    if (json['listBienSoNgoaiVungs'] != null) {
      listBienSoNgoaiVungs = <Null>[];
      json['listBienSoNgoaiVungs'].forEach((v) {
        listBienSoNgoaiVungs!.add(v);
      });
    }
    if (json['listLoaiXeNgoaiVungs'] != null) {
      listLoaiXeNgoaiVungs = <Null>[];
      json['listLoaiXeNgoaiVungs'].forEach((v) {
        listLoaiXeNgoaiVungs!.add(v);
      });
    }
    recognitionTime = json['recognitionTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.listBienSos != null) {
      data['listBienSos'] = this.listBienSos!.map((v) => v.toJson()).toList();
    }
    if (this.listLoaiXes != null) {
      data['listLoaiXes'] = this.listLoaiXes!.map((v) => v.toJson()).toList();
    }
    if (this.listBienSoNgoaiVungs != null) {
      data['listBienSoNgoaiVungs'] =
          this.listBienSoNgoaiVungs!.map((v) => v.toJson()).toList();
    }
    if (this.listLoaiXeNgoaiVungs != null) {
      data['listLoaiXeNgoaiVungs'] =
          this.listLoaiXeNgoaiVungs!.map((v) => v.toJson()).toList();
    }
    data['recognitionTime'] = this.recognitionTime;
    return data;
  }
}

class ListBienSos {
  int? id;
  String? bienso;
  int? loaixe;
  int? maubien;
  double? gocnghieng;
  int? recX;
  int? recY;
  int? recW;
  int? recH;
  double? confident;
  double? confidentBsFormat;
  String? plateImage;
  String? vehicleType;

  ListBienSos(
      {this.id,
      this.bienso,
      this.loaixe,
      this.maubien,
      this.gocnghieng,
      this.recX,
      this.recY,
      this.recW,
      this.recH,
      this.confident,
      this.confidentBsFormat,
      this.plateImage,
      this.vehicleType});

  ListBienSos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bienso = json['bienso'];
    loaixe = json['loaixe'];
    maubien = json['maubien'];
    gocnghieng = json['gocnghieng'];
    recX = json['rec_x'];
    recY = json['rec_y'];
    recW = json['rec_w'];
    recH = json['rec_h'];
    confident = json['confident'];
    confidentBsFormat = json['confident_bs_format'];
    plateImage = json['plate_image'];
    vehicleType = json['vehicle_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['bienso'] = this.bienso;
    data['loaixe'] = this.loaixe;
    data['maubien'] = this.maubien;
    data['gocnghieng'] = this.gocnghieng;
    data['rec_x'] = this.recX;
    data['rec_y'] = this.recY;
    data['rec_w'] = this.recW;
    data['rec_h'] = this.recH;
    data['confident'] = this.confident;
    data['confident_bs_format'] = this.confidentBsFormat;
    data['plate_image'] = this.plateImage;
    data['vehicle_type'] = this.vehicleType;
    return data;
  }
}
