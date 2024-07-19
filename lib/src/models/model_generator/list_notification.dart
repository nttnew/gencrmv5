class NotificationResponse {
  bool? success;
  String? msg;
  int? code;
  Data? data;

  NotificationResponse({
    this.success,
    this.msg,
    this.code,
    this.data,
  });

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    code = json['code'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  List<DataNotification>? list;
  String? page;
  int? limit;
  String? total;

  Data({
    this.list,
    this.page,
    this.limit,
    this.total,
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <DataNotification>[];
      json['list'].forEach((v) {
        list!.add(DataNotification.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['total'] = this.total;
    return data;
  }
}

class DataNotification {
  String? id;
  String? type;
  String? title;
  String? content;
  String? link;
  String? module;
  String? recordId;
  bool? isSelect;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataNotification &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          title == other.title &&
          content == other.content &&
          link == other.link &&
          module == other.module &&
          recordId == other.recordId &&
          isSelect == other.isSelect;

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      title.hashCode ^
      content.hashCode ^
      link.hashCode ^
      module.hashCode ^
      recordId.hashCode ^
      isSelect.hashCode;

  DataNotification({
    this.id,
    this.type,
    this.title,
    this.content,
    this.link,
    this.module,
    this.recordId,
    this.isSelect = false,
  });

  DataNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    content = json['content'];
    link = json['link'];
    module = json['module'];
    recordId = json['record_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['title'] = this.title;
    data['content'] = this.content;
    data['link'] = this.link;
    data['module'] = this.module;
    data['record_id'] = this.recordId;
    return data;
  }
}
