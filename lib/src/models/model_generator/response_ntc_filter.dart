class NTCFilterModel {
  bool? success;
  int? code;
  String? msg;
  List<DataNTCFilter>? data;

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
    if (json['data'] != null) {
      data = <DataNTCFilter>[];
      json['data'].forEach((v) {
        data!.add(DataNTCFilter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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
          id == other.id &&
          nam == other.nam &&
          kyTaiChinh == other.kyTaiChinh;

  @override
  int get hashCode => id.hashCode ^ nam.hashCode ^ kyTaiChinh.hashCode;
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
}
