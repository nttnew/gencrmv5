class ListCHProductCustomerResponse {
  bool? success;
  int? code;
  String? msg;
  Data? data;

  ListCHProductCustomerResponse({this.success, this.code, this.msg, this.data});

  ListCHProductCustomerResponse.fromJson(Map<String, dynamic> json) {
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
  List<Lists>? lists;
  String? t;

  Data({this.lists, this.t});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['lists'] != null) {
      lists = <Lists>[];
      json['lists'].forEach((v) {
        lists!.add(new Lists.fromJson(v));
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

class Lists {
  String? id;
  String? name;
  Customer? customer;
  String? price;
  String? trangThai;
  String? color;

  Lists(
      {this.id,
        this.name,
        this.customer,
        this.price,
        this.trangThai,
        this.color});

  Lists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
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
    data['price'] = this.price;
    data['trang_thai'] = this.trangThai;
    data['color'] = this.color;
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
