import 'customer_clue.dart';

class MainMenuResponse {
  dynamic success;
  String? msg;
  int? code;
  Data? data;

  MainMenuResponse({
    this.success,
    this.msg,
    this.code,
    this.data,
  });

  MainMenuResponse.fromJson(Map<String, dynamic> json) {
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
  List<MainMenu>? mainMenu;
  List<Customer>? quickMenu;

  Data({
    this.mainMenu,
    this.quickMenu,
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['main_menu'] != null) {
      mainMenu = <MainMenu>[];
      json['main_menu'].forEach((v) {
        mainMenu!.add(MainMenu.fromJson(v));
      });
    }
    if (json['quick_menu'] != null) {
      quickMenu = <Customer>[];
      json['quick_menu'].forEach((v) {
        quickMenu!.add(Customer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.mainMenu != null) {
      data['main_menu'] = this.mainMenu!.map((v) => v.toJson()).toList();
    }
    if (this.quickMenu != null) {
      data['quick_menu'] = this.quickMenu!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MainMenu {
  String? id;
  bool? isallow;
  String? name;

  MainMenu({this.id, this.isallow, this.name});

  MainMenu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isallow = json['isallow'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['isallow'] = this.isallow;
    data['name'] = this.name;
    return data;
  }
}
