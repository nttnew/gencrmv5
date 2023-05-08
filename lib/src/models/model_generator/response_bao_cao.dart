class ResponseBaoCao {
  bool? success;
  int? code;
  String? msg;
  Data? data;

  ResponseBaoCao({this.success, this.code, this.msg, this.data});

  ResponseBaoCao.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  List<ItemResponseReportCar>? lists;
  String? page;
  String? total;
  int? limit;
  String? tienTe;

  Data({this.lists, this.page, this.total, this.limit, this.tienTe});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['lists'] != null) {
      lists = <ItemResponseReportCar>[];
      json['lists'].forEach((v) {
        lists!.add(new ItemResponseReportCar.fromJson(v));
      });
    }
    page = json['page'];
    total = json['total'];
    limit = json['limit'];
    tienTe = json['tien_te'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lists != null) {
      data['lists'] = this.lists!.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['total'] = this.total;
    data['limit'] = this.limit;
    data['tien_te'] = this.tienTe;
    return data;
  }
}

class ItemResponseReportCar {
  String? id;
  String? name;
  String? ngayKy;
  String? giaTriHopDong;
  String? status;
  String? color;
  Customer? customer;
  String? bienSo;
  String? idXe;

  ItemResponseReportCar(
      {this.id,
        this.name,
        this.ngayKy,
        this.giaTriHopDong,
        this.status,
        this.color,
        this.customer,
        this.bienSo,
        this.idXe});

  ItemResponseReportCar.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ngayKy = json['ngay_ky'];
    giaTriHopDong = json['gia_tri_hop_dong'];
    status = json['status'];
    color = json['color'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    bienSo = json['bien_so'];
    idXe = json['id_xe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ngay_ky'] = this.ngayKy;
    data['gia_tri_hop_dong'] = this.giaTriHopDong;
    data['status'] = this.status;
    data['color'] = this.color;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['bien_so'] = this.bienSo;
    data['id_xe'] = this.idXe;
    return data;
  }
}

class Customer {
  String? id;
  String? name;

  Customer({this.id, this.name});

  Customer.fromJson(Map<String, dynamic> json) {
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
