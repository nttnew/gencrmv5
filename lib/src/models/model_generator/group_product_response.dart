class GroupProductResponse {
  dynamic success;
  int? code;
  String? msg;
  Data? data;

  GroupProductResponse({this.success, this.code, this.msg, this.data});

  GroupProductResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Cats>? cats;

  Data({this.cats});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['cats'] != null) {
      cats = <Cats>[];
      json['cats'].forEach((v) {
        cats!.add(new Cats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cats != null) {
      data['cats'] = this.cats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cats {
  String? id;
  String? label;
  String? parentID;
  List<Children>? children;

  Cats({this.id, this.label, this.parentID, this.children});

  Cats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    parentID = json['parentID'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children!.add(new Children.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['parentID'] = this.parentID;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Children {
  String? id;
  String? label;
  String? parentID;

  Children({this.id, this.label, this.parentID});

  Children.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    parentID = json['parentID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['parentID'] = this.parentID;
    return data;
  }
}
