class ListHDProductCustomerResponse {
  bool? success;
  int? code;
  String? msg;
  List<Data>? data;
  String? total;

  ListHDProductCustomerResponse(
      {this.success, this.code, this.msg, this.data, this.total});

  ListHDProductCustomerResponse.fromJson(Map<String, dynamic> json) {
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
  String? name;
  Customer? customer;
  String? price;
  String? status;
  String? color;
  String? conlai;

  Data(
      {this.id,
        this.name,
        this.customer,
        this.price,
        this.status,
        this.color,
        this.conlai});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    price = json['price'];
    status = json['status'];
    color = json['color'];
    conlai = json['conlai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['price'] = this.price;
    data['status'] = this.status;
    data['color'] = this.color;
    data['conlai'] = this.conlai;
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
