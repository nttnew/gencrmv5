import 'customer_clue.dart';

class ListCVProductCustomerResponse {
  bool? success;
  int? code;
  String? msg;
  Data? data;
  String? total;

  ListCVProductCustomerResponse(
      {this.success, this.code, this.msg, this.data, this.total});

  ListCVProductCustomerResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class Data {
  DataResponse? data;

  Data({this.data});

  Data.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? new DataResponse.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataResponse {
  List<DataList>? dataList;

  DataResponse({this.dataList});

  DataResponse.fromJson(Map<String, dynamic> json) {
    if (json['data_list'] != null) {
      dataList = <DataList>[];
      json['data_list'].forEach((v) {
        dataList!.add(new DataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dataList != null) {
      data['data_list'] = this.dataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataList {
  String? id;
  Customer? customer;
  String? nameJob;
  String? contentJob;
  String? userWorkId;
  String? userWorkName;
  String? nameCustomer;
  String? status;
  String? color;
  String? starDate;
  dynamic callId;
  dynamic ghiChuCallid;
  dynamic location;
  int? totalNote;

  DataList(
      {this.id,
      this.customer,
      this.nameJob,
      this.contentJob,
      this.userWorkId,
      this.userWorkName,
      this.nameCustomer,
      this.status,
      this.color,
      this.starDate,
      this.callId,
      this.ghiChuCallid,
      this.location,
      this.totalNote});

  DataList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    nameJob = json['name_job'];
    contentJob = json['content_job'];
    userWorkId = json['user_work_id'];
    userWorkName = json['user_work_name'];
    nameCustomer = json['name_customer'];
    status = json['status'];
    color = json['color'];
    starDate = json['start_date'];
    callId = json['call_id'];
    ghiChuCallid = json['ghi_chu_callid'];
    location = json['location'];
    totalNote = json['total_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['name_job'] = this.nameJob;
    data['content_job'] = this.contentJob;
    data['user_work_id'] = this.userWorkId;
    data['user_work_name'] = this.userWorkName;
    data['name_customer'] = this.nameCustomer;
    data['status'] = this.status;
    data['color'] = this.color;
    data['start_date'] = this.starDate;
    data['call_id'] = this.callId;
    data['ghi_chu_callid'] = this.ghiChuCallid;
    data['location'] = this.location;
    data['total_note'] = this.totalNote;
    return data;
  }
}

