import 'customer_clue.dart';

class ListHDProductCustomerResponse {
  dynamic success;
  int? code;
  String? msg;
  List<ListHDProductCustomer>? data;
  String? total;

  ListHDProductCustomerResponse({
    this.success,
    this.code,
    this.msg,
    this.data,
    this.total,
  });

  ListHDProductCustomerResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <ListHDProductCustomer>[];
      json['data'].forEach((v) {
        data!.add(ListHDProductCustomer.fromJson(v));
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

class ListHDProductCustomer {
  String? id;
  String? name;
  Customer? customer, product_customer;
  String? price;
  String? status;
  String? color;
  String? conlai;

  ListHDProductCustomer({
    this.id,
    this.name,
    this.customer,
    this.product_customer,
    this.price,
    this.status,
    this.color,
    this.conlai,
  });

  ListHDProductCustomer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    product_customer = json['product_customer'] != null
        ? Customer.fromJson(json['product_customer'])
        : null;
    price = json['price'];
    status = json['status'];
    color = json['color'];
    conlai = json['conlai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.product_customer != null) {
      data['product_customer'] = this.product_customer!.toJson();
    }
    data['price'] = this.price;
    data['status'] = this.status;
    data['color'] = this.color;
    data['conlai'] = this.conlai;
    return data;
  }
}
