class DetailProductCustomerResponse {
  bool? success;
  int? code;
  String? msg;
  List<Data>? data;

  DetailProductCustomerResponse({this.success, this.code, this.msg, this.data});

  DetailProductCustomerResponse.fromJson(Map<String, dynamic> json) {
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
  List<DataProductCustomer>? data;

  Data({this.groupName, this.mup, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    groupName = json['group_name'];
    mup = json['mup'];
    if (json['data'] != null) {
      data = <DataProductCustomer>[];
      json['data'].forEach((v) {
        data!.add(new DataProductCustomer.fromJson(v));
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

class DataProductCustomer {
  String? labelField;
  String? id;
  String? link;
  String? valueField;

  DataProductCustomer({this.labelField, this.id, this.link, this.valueField});

  DataProductCustomer.fromJson(Map<String, dynamic> json) {
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
