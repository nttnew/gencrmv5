class ListHTProductCustomerResponse {
  bool? success;
  int? code;
  String? msg;
  List<Data>? data;
  String? total;

  ListHTProductCustomerResponse(
      {this.success, this.code, this.msg, this.data, this.total});

  ListHTProductCustomerResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Data {
  String? id;
  String? tenHoTro;
  Customer? customer;
  String? createdDate;
  String? trangThai;
  String? color;
  String? totalNote;

  Data(
      {this.id,
        this.tenHoTro,
        this.customer,
        this.createdDate,
        this.trangThai,
        this.color,
        this.totalNote});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenHoTro = json['ten_ho_tro'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    createdDate = json['created_date'];
    trangThai = json['trang_thai'];
    color = json['color'];
    totalNote = json['total_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ten_ho_tro'] = this.tenHoTro;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['created_date'] = this.createdDate;
    data['trang_thai'] = this.trangThai;
    data['color'] = this.color;
    data['total_note'] = this.totalNote;
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
