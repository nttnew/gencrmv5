import 'detail_customer.dart';

class DetailProductCustomerResponse {
  dynamic success;
  int? code;
  String? msg;
  List<InfoDataModel>? data;
  List<Tabs>? tabs;
  List<Tabs>? actions;

  DetailProductCustomerResponse({
    this.success,
    this.code,
    this.msg,
    this.data,
    this.tabs,
    this.actions,
  });

  DetailProductCustomerResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <InfoDataModel>[];
      json['data'].forEach((v) {
        data!.add(InfoDataModel.fromJson(v));
      });
    }
    if (json['tabs'] != null) {
      tabs = <Tabs>[];
      json['tabs'].forEach((v) {
        tabs!.add(Tabs.fromJson(v));
      });
    }
    if (json['actions'] != null) {
      actions = <Tabs>[];
      json['actions'].forEach((v) {
        actions!.add(Tabs.fromJson(v));
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
    if (this.tabs != null) {
      data['tabs'] = this.tabs!.map((v) => v.toJson()).toList();
    }
    if (this.actions != null) {
      data['actions'] = this.actions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tabs {
  String? module;
  String? name;

  Tabs({
    this.module,
    this.name,
  });

  Tabs.fromJson(Map<String, dynamic> json) {
    module = json['module'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['module'] = this.module;
    data['name'] = this.name;
    return data;
  }
}
