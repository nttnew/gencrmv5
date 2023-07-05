class DetailProductResponse {
  bool? success;
  int? code;
  String? msg;
  List<Data>? data;
  Info? info;

  DetailProductResponse({this.success, this.code, this.msg, this.data});

  DetailProductResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
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
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
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

class Info {
  String? productId;
  String? productCode;
  String? productEdit;
  String? productName;
  String? dvt;
  String? vat;
  String? parentId;
  String? hasChild;
  String? propertyId;
  int? sellPrice;
  String? propertyName;
  String? nameDvt;
  String? nameVat;

  Info({
    this.productId,
    this.productCode,
    this.productEdit,
    this.productName,
    this.dvt,
    this.vat,
    this.parentId,
    this.hasChild,
    this.propertyId,
    this.sellPrice,
    this.propertyName,
    this.nameDvt,
    this.nameVat,
  });

  Info.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productCode = json['product_code'];
    productEdit = json['product_edit'];
    productName = json['product_name'];
    dvt = json['dvt'];
    vat = json['vat'];
    parentId = json['parent_id'];
    hasChild = json['has_child'];
    propertyId = json['property_id'];
    sellPrice = json['sell_price'];
    propertyName = json['property_name'];
    nameDvt = json['nameDvt'];
    nameVat = json['nameVat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_code'] = this.productCode;
    data['product_edit'] = this.productEdit;
    data['product_name'] = this.productName;
    data['dvt'] = this.dvt;
    data['vat'] = this.vat;
    data['parent_id'] = this.parentId;
    data['has_child'] = this.hasChild;
    data['property_id'] = this.propertyId;
    data['sell_price'] = this.sellPrice;
    data['property_name'] = this.propertyName;
    data['nameDvt'] = this.nameDvt;
    data['nameVat'] = this.nameVat;
    return data;
  }
}
