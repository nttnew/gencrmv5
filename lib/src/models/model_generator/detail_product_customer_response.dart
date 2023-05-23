class DetailProductCustomerResponse {
  bool? success;
  int? code;
  String? msg;
  List<DataResponse>? data;
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
      data = <DataResponse>[];
      json['data'].forEach((v) {
        data!.add(new DataResponse.fromJson(v));
      });
    }
    if (json['tabs'] != null) {
      tabs = <Tabs>[];
      json['tabs'].forEach((v) {
        tabs!.add(new Tabs.fromJson(v));
      });
    }
    if (json['actions'] != null) {
      actions = <Tabs>[];
      json['actions'].forEach((v) {
        actions!.add(new Tabs.fromJson(v));
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
    if (this.tabs != null) {
      data['tabs'] = this.tabs!.map((v) => v.toJson()).toList();
    }
    if (this.actions != null) {
      data['actions'] = this.actions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataResponse {
  String? groupName;
  int? mup;
  List<Data>? data;

  DataResponse({this.groupName, this.mup, this.data});

  DataResponse.fromJson(Map<String, dynamic> json) {
    groupName = json['group_name'];
    mup = json['mup'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? labelField;
  String? id;
  String? link;
  String? valueField;

  Data({this.labelField, this.id, this.link, this.valueField});

  Data.fromJson(Map<String, dynamic> json) {
    labelField = json['label_field'];
    id = json['id'];
    link = json['link'];
    valueField = json['value_field'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label_field'] = this.labelField;
    data['id'] = this.id;
    data['link'] = this.link;
    data['value_field'] = this.valueField;
    return data;
  }
}

class Tabs {
  String? module;
  String? name;

  Tabs({this.module, this.name});

  Tabs.fromJson(Map<String, dynamic> json) {
    module = json['module'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['module'] = this.module;
    data['name'] = this.name;
    return data;
  }
}
