import 'package:gen_crm/src/models/model_generator/products_response.dart';

class ProductServicePackModel {
  bool? success;
  int? code;
  String? msg;
  List<ProductsRes>? data;

  ProductServicePackModel({this.success, this.code, this.msg, this.data});

  ProductServicePackModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <ProductsRes>[];
      json['data'].forEach((v) {
        data!.add(ProductsRes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
