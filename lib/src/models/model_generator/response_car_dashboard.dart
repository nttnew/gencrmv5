class ResponseCarDashboard {
  dynamic success;
  int? code;
  String? msg;
  DataCarDashboard? data;

  ResponseCarDashboard({this.success, this.code, this.msg, this.data});

  ResponseCarDashboard.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new DataCarDashboard.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataCarDashboard {
  List<Status>? status;
  int? total;
  String? tienTe;

  DataCarDashboard({this.status, this.total, this.tienTe});

  DataCarDashboard.fromJson(Map<String, dynamic> json) {
    if (json['status'] != null) {
      status = <Status>[];
      json['status'].forEach((v) {
        status!.add(new Status.fromJson(v));
      });
    }
    total = json['total'];
    tienTe = json['tien_te'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['tien_te'] = this.tienTe;
    return data;
  }
}

class Status {
  int? id;
  String? name;
  int? total;

  Status({this.id, this.name, this.total});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['total'] = this.total;
    return data;
  }
}
