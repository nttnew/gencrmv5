class ProductServicePackModel {
  bool? success;
  int? code;
  String? msg;
  List<DataProductServicePack>? data;

  ProductServicePackModel({this.success, this.code, this.msg, this.data});

  ProductServicePackModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <DataProductServicePack>[];
      json['data'].forEach((v) {
        data!.add(new DataProductServicePack.fromJson(v));
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

class DataProductServicePack {
  String? idProduct;
  String? productId;
  String? nameProduct;
  String? code;
  int? price;
  dynamic quantity;
  String? vat;
  String? vatName;
  String? unit;
  String? unitName;
  SaleOff? saleOff;
  String? suDung;
  String? tenCombo;
  String? comboId;

  DataProductServicePack(
      {this.idProduct,
        this.productId,
        this.nameProduct,
        this.code,
        this.price,
        this.quantity,
        this.vat,
        this.vatName,
        this.unit,
        this.unitName,
        this.saleOff,
        this.suDung,
        this.tenCombo,
        this.comboId,
      });

  DataProductServicePack.fromJson(Map<String, dynamic> json) {
    idProduct = json['id_product'];
    productId = json['product_id'];
    nameProduct = json['name_product'];
    code = json['code'];
    price = json['price'];
    quantity = json['quantity'];
    vat = json['vat'];
    vatName = json['vat_name'];
    unit = json['unit'];
    unitName = json['unit_name'];
    saleOff = json['sale_off'] != null
        ? new SaleOff.fromJson(json['sale_off'])
        : null;
    suDung = json['su_dung'];
    tenCombo = json['ten_combo'];
    comboId = json['combo_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_product'] = this.idProduct;
    data['product_id'] = this.productId;
    data['name_product'] = this.nameProduct;
    data['code'] = this.code;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['vat'] = this.vat;
    data['vat_name'] = this.vatName;
    data['unit'] = this.unit;
    data['unit_name'] = this.unitName;
    if (this.saleOff != null) {
      data['sale_off'] = this.saleOff!.toJson();
    }
    data['su_dung'] = this.suDung;
    data['ten_combo'] = this.tenCombo;
    data['combo_id'] = this.comboId;
    return data;
  }
}

class SaleOff {
  dynamic value;
  String? type;

  SaleOff({this.value, this.type});

  SaleOff.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['type'] = this.type;
    return data;
  }
}
