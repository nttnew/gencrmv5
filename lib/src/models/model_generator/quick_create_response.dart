import 'customer.dart';

class QuickCreateResponse {
  dynamic success;
  String? msg;
  int? code;
  DataQuickCreate? data;

  QuickCreateResponse({
    this.success,
    this.msg,
    this.code,
    this.data,
  });

  QuickCreateResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    code = json['code'];
    data = json['data'] != null ? DataQuickCreate.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataQuickCreate {
  List<CustomerData>? customers;
  List<CustomerData>? cars;

  DataQuickCreate({
    this.customers,
    this.cars,
  });

  DataQuickCreate.fromJson(Map<String, dynamic> json) {
    if (json['customers'] != null) {
      customers = <CustomerData>[];
      json['customers'].forEach((v) {
        customers!.add(CustomerData.fromJson(v));
      });
    }
    if (json['cars'] != null) {
      cars = <CustomerData>[];
      json['cars'].forEach((v) {
        cars!.add(CustomerData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.customers != null) {
      data['customers'] = this.customers!.map((v) => v.toJson()).toList();
    }
    if (this.cars != null) {
      data['cars'] = this.cars!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
