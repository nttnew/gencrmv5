import 'package:gen_crm/src/models/model_generator/products_response.dart';

import 'detail_customer.dart';

class DetailProductResponse {
  bool? success;
  int? code;
  String? msg;
  List<InfoDataModel>? data;
  ProductsRes? info;

  DetailProductResponse({
    this.success,
    this.code,
    this.msg,
    this.data,
  });

  DetailProductResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    info = json['info'] != null ? ProductsRes.fromJson(json['info']) : null;
    if (json['data'] != null) {
      data = <InfoDataModel>[];
      json['data'].forEach((v) {
        data!.add(InfoDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
