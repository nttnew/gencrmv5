import 'customer_clue.dart';

class ListHTProductCustomerResponse {
  dynamic success;
  int? code;
  String? msg;
  List<DataHTProductCustomer>? data;
  String? total;

  ListHTProductCustomerResponse({
    this.success,
    this.code,
    this.msg,
    this.data,
    this.total,
  });

  ListHTProductCustomerResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <DataHTProductCustomer>[];
      json['data'].forEach((v) {
        data!.add(DataHTProductCustomer.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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

class DataHTProductCustomer {
  String? id;
  String? tenHoTro;
  Customer? customer, product_customer;
  String? createdDate;
  String? trangThai;
  String? color;
  String? totalNote;

  DataHTProductCustomer({
    this.id,
    this.tenHoTro,
    this.customer,
    this.product_customer,
    this.createdDate,
    this.trangThai,
    this.color,
    this.totalNote,
  });

  DataHTProductCustomer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenHoTro = json['ten_ho_tro'];
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    product_customer = json['product_customer'] != null
        ? Customer.fromJson(json['product_customer'])
        : null;
    createdDate = json['created_date'];
    trangThai = json['trang_thai'];
    color = json['color'];
    totalNote = json['total_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['ten_ho_tro'] = this.tenHoTro;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.product_customer != null) {
      data['product_customer'] = this.product_customer!.toJson();
    }
    data['created_date'] = this.createdDate;
    data['trang_thai'] = this.trangThai;
    data['color'] = this.color;
    data['total_note'] = this.totalNote;
    return data;
  }
}
