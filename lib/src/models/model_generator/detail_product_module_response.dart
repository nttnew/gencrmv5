class DetailProductResponse {
  bool? success;
  int? code;
  String? msg;
  List<Data>? data;

  DetailProductResponse({this.success, this.code, this.msg, this.data});

  DetailProductResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? groupName;
  int? mup;
  List<Product>? data;

  Data({this.groupName, this.mup, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    groupName = json['group_name'];
    mup = json['mup'];
    if (json['data'] != null) {
      data = <Product>[];
      json['data'].forEach((v) {
        data!.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_name'] = this.groupName;
    data['mup'] = this.mup;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  String? labelField;
  String? id;
  String? valueField;
  String? link;

  Product({this.labelField, this.id, this.valueField, this.link});

  Product.fromJson(Map<String, dynamic> json) {
    labelField = json['label_field'];
    id = json['id'];
    valueField = json['value_field'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label_field'] = this.labelField;
    data['id'] = this.id;
    data['value_field'] = this.valueField;
    data['link'] = this.link;
    return data;
  }
}
