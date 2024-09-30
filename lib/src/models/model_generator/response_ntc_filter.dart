class NTCFilterModel {
  dynamic success;
  int? code;
  String? msg;
  Data? data;

  NTCFilterModel({
    this.success,
    this.code,
    this.msg,
    this.data,
  });

  NTCFilterModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  String? namDf;
  String? kyDf;
  String? tenKyDf;
  List<DataNTCFilter>? dataNTC;

  Data({
    this.namDf,
    this.kyDf,
    this.tenKyDf,
    this.dataNTC,
  });

  Data.fromJson(Map<String, dynamic> json) {
    namDf = json['namdf'];
    kyDf = json['kydf'];
    tenKyDf = json['tenkydf'];
    if (json['dataNTC'] != null) {
      dataNTC = <DataNTCFilter>[];
      json['dataNTC'].forEach((v) {
        dataNTC!.add(DataNTCFilter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['namdf'] = this.namDf;
    data['kydf'] = this.kyDf;
    data['tenkydf'] = this.tenKyDf;
    if (this.dataNTC != null) {
      data['dataNTC'] = this.dataNTC!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataNTCFilter {
  String? id;
  String? nam;
  List<KyTaiChinh>? kyTaiChinh;

  DataNTCFilter({
    this.id,
    this.nam,
    this.kyTaiChinh,
  });

  DataNTCFilter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nam = json['nam'];
    if (json['kytaichinh'] != null) {
      kyTaiChinh = <KyTaiChinh>[];
      json['kytaichinh'].forEach((v) {
        kyTaiChinh!.add(KyTaiChinh.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['nam'] = this.nam;
    if (this.kyTaiChinh != null) {
      data['kytaichinh'] = this.kyTaiChinh!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataNTCFilter &&
          runtimeType == other.runtimeType &&
          nam == other.nam;

  @override
  int get hashCode => nam.hashCode;
}

class KyTaiChinh {
  String? id;
  String? name;

  KyTaiChinh({
    this.id,
    this.name,
  });

  KyTaiChinh.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KyTaiChinh &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
