import 'customer_clue.dart';

class ListProductResponse {
  bool? success;
  int? code;
  String? msg;
  Data? data;

  ListProductResponse({this.success, this.code, this.msg, this.data});

  ListProductResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
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
  List<ProductModule>? lists;
  String? t;
  List<Customer>? dataFilter;

  Data({this.lists, this.t, this.dataFilter});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['lists'] != null) {
      lists = <ProductModule>[];
      json['lists'].forEach((v) {
        lists!.add( ProductModule.fromJson(v));
      });
    }
    t = json['t'];
    if (json['data_filter'] != null) {
      dataFilter = <Customer>[];
      json['data_filter'].forEach((v) {
        dataFilter!.add( Customer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.lists != null) {
      data['lists'] = this.lists!.map((v) => v.toJson()).toList();
    }
    data['t'] = this.t;
    if (this.dataFilter != null) {
      data['data_filter'] = this.dataFilter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductModule {
  String? tonKho;
  String? giaBan;
  String? giaNhap;
  String? avatar;
  String? coTheBan;
  String? phienBan;
  String? tenSanPham;
  String? maSanPham;
  String? id;

  ProductModule(
      {this.tonKho,
        this.giaBan,
        this.giaNhap,
        this.avatar,
        this.coTheBan,
        this.phienBan,
        this.tenSanPham,
        this.maSanPham,
        this.id});

  ProductModule.fromJson(Map<String, dynamic> json) {
    tonKho = json['ton_kho'];
    giaBan = json['gia_ban'];
    giaNhap = json['gia_nhap'];
    avatar = json['avatar'];
    coTheBan = json['co_the_ban'];
    phienBan = json['phien_ban'];
    tenSanPham = json['ten_san_pham'];
    maSanPham = json['ma_san_pham'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['ton_kho'] = this.tonKho;
    data['gia_ban'] = this.giaBan;
    data['gia_nhap'] = this.giaNhap;
    data['avatar'] = this.avatar;
    data['co_the_ban'] = this.coTheBan;
    data['phien_ban'] = this.phienBan;
    data['ten_san_pham'] = this.tenSanPham;
    data['ma_san_pham'] = this.maSanPham;
    data['id'] = this.id;
    return data;
  }
}

