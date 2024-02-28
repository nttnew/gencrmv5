class ListProductCustomerResponse {
  bool? success;
  int? code;
  String? msg;
  Data? data;

  ListProductCustomerResponse({this.success, this.code, this.msg, this.data});

  ListProductCustomerResponse.fromJson(Map<String, dynamic> json) {
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
  List<ProductCustomerResponse>? lists;
  String? t;
  List<Customer>? dataFilter;

  Data({this.lists, this.t, this.dataFilter});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['lists'] != null) {
      lists = <ProductCustomerResponse>[];
      json['lists'].forEach((v) {
        lists!.add(ProductCustomerResponse.fromJson(v));
      });
    }
    t = json['t'];
    if (json['data_filter'] != null) {
      dataFilter = <Customer>[];
      json['data_filter'].forEach((v) {
        dataFilter!.add(Customer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.lists != null) {
      data['lists'] = this.lists!.map((v) => v.toJson()).toList();
    }
    data['t'] = this.t;
    if (this.dataFilter != null) {
      data['data_filter'] = this.dataFilter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductCustomerResponse {
  String? name;
  Customer? customer;
  String? trangThai;
  String? loai;
  String? id;
  PhoneModel? phone;

  ProductCustomerResponse({
    this.name,
    this.customer,
    this.trangThai,
    this.loai,
    this.id,
    this.phone,
  });

  ProductCustomerResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    trangThai = json['trang_thai'];
    loai = json['loai'];
    id = json['id'];
    phone = json['phone'] != null ? PhoneModel.fromJson(json['phone']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['trang_thai'] = this.trangThai;
    data['loai'] = this.loai;
    data['id'] = this.id;
    if (this.phone != null) {
      data['phone'] = this.phone!.toJson();
    }
    return data;
  }
}

class Customer {
  String? id;
  String? name;

  Customer({this.id, this.name,});

  Customer.fromJson(Map<String, dynamic> json) {
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

class PhoneModel {
  String? val;
  int? action;

  PhoneModel({
    this.val,
    this.action,
  });

  PhoneModel.fromJson(Map<String, dynamic> json) {
    val = json['val'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['val'] = this.val;
    data['action'] = this.action;
    return data;
  }
}
