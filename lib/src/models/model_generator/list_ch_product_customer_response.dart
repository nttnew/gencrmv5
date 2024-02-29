import 'customer_clue.dart';

class ListCHProductCustomerResponse {
  bool? success;
  int? code;
  String? msg;
  DataListCHProductCustomer? data;

  ListCHProductCustomerResponse({
    this.success,
    this.code,
    this.msg,
    this.data,
  });

  ListCHProductCustomerResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null
        ? new DataListCHProductCustomer.fromJson(json['data'])
        : null;
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

class DataListCHProductCustomer {
  List<CHProductCustomer>? lists;
  String? t;

  DataListCHProductCustomer({
    this.lists,
    this.t,
  });

  DataListCHProductCustomer.fromJson(Map<String, dynamic> json) {
    if (json['lists'] != null) {
      lists = <CHProductCustomer>[];
      json['lists'].forEach((v) {
        lists!.add(new CHProductCustomer.fromJson(v));
      });
    }
    t = json['t'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lists != null) {
      data['lists'] = this.lists!.map((v) => v.toJson()).toList();
    }
    data['t'] = this.t;
    return data;
  }
}

class CHProductCustomer {
  String? id;
  String? name;
  Customer? customer, product_customer;
  String? price;
  String? trangThai;
  String? color;

  CHProductCustomer({
    this.id,
    this.name,
    this.customer,
    this.product_customer,
    this.price,
    this.trangThai,
    this.color,
  });

  CHProductCustomer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    product_customer = json['product_customer'] != null
        ? new Customer.fromJson(json['product_customer'])
        : null;
    price = json['price'];
    trangThai = json['trang_thai'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.product_customer != null) {
      data['product_customer'] = this.product_customer!.toJson();
    }
    data['price'] = this.price;
    data['trang_thai'] = this.trangThai;
    data['color'] = this.color;
    return data;
  }
}
