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
  List<ProductCustomerResponse>? lists;
  String? t;
  List<DataFilter>? dataFilter;

  Data({this.lists, this.t, this.dataFilter});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['lists'] != null) {
      lists = <ProductCustomerResponse>[];
      json['lists'].forEach((v) {
        lists!.add(new ProductCustomerResponse.fromJson(v));
      });
    }
    t = json['t'];
    if (json['data_filter'] != null) {
      dataFilter = <DataFilter>[];
      json['data_filter'].forEach((v) {
        dataFilter!.add(new DataFilter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

  ProductCustomerResponse({this.name, this.customer, this.trangThai, this.loai, this.id});

  ProductCustomerResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    trangThai = json['trang_thai'];
    loai = json['loai'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['trang_thai'] = this.trangThai;
    data['loai'] = this.loai;
    data['id'] = this.id;
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

class DataFilter {
  String? id;
  String? name;

  DataFilter({this.id, this.name});

  DataFilter.fromJson(Map<String, dynamic> json) {
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
