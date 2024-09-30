class BienSoWithImgResponse {
  dynamic success;
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

  DataBienSoWithImg({
    this.listBienSos,
  });

  DataBienSoWithImg.fromJson(Map<String, dynamic> json) {
    if (json['listBienSos'] != null) {
      listBienSos = <ListBienSos>[];
      json['listBienSos'].forEach((v) {
        listBienSos!.add(ListBienSos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.listBienSos != null) {
      data['listBienSos'] = this.listBienSos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListBienSos {
  String? bienso;

  ListBienSos({
    this.bienso,
  });

  ListBienSos.fromJson(Map<String, dynamic> json) {
    bienso = json['bienso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['bienso'] = this.bienso;
    return data;
  }
}
