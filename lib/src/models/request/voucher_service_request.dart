class VoucherServiceRequest {
  String? col131;
  String? danhXung;
  String? tenKhachHang;
  String? diDong;
  String? col121;
  String? col112;
  String? col132;
  String? daThanhToan;
  String? hdsanPhamKh;
  String? chiTietXe;
  String? bienSo;
  String? soKilomet;
  String? mauSac;
  List<Products>? products;

  VoucherServiceRequest(
      {this.col131,
        this.danhXung,
        this.tenKhachHang,
        this.diDong,
        this.col121,
        this.col112,
        this.col132,
        this.daThanhToan,
        this.hdsanPhamKh,
        this.chiTietXe,
        this.bienSo,
        this.soKilomet,
        this.mauSac,
        this.products});

  VoucherServiceRequest.fromJson(Map<String, dynamic> json) {
    col131 = json['col131'];
    danhXung = json['danh_xung'];
    tenKhachHang = json['ten_khach_hang'];
    diDong = json['di_dong'];
    col121 = json['col121'];
    col112 = json['col112'];
    col132 = json['col132'];
    daThanhToan = json['da_thanh_toan'];
    hdsanPhamKh = json['hdsan_pham_kh'];
    chiTietXe = json['chi_tiet_xe'];
    bienSo = json['bien_so'];
    soKilomet = json['so_kilomet'];
    mauSac = json['mau_sac'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['col131'] = this.col131;
    data['danh_xung'] = this.danhXung;
    data['ten_khach_hang'] = this.tenKhachHang;
    data['di_dong'] = this.diDong;
    data['col121'] = this.col121;
    data['col112'] = this.col112;
    data['col132'] = this.col132;
    data['da_thanh_toan'] = this.daThanhToan;
    data['hdsan_pham_kh'] = this.hdsanPhamKh;
    data['chi_tiet_xe'] = this.chiTietXe;
    data['bien_so'] = this.bienSo;
    data['so_kilomet'] = this.soKilomet;
    data['mau_sac'] = this.mauSac;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  int? price;
  int? quantity;
  int? vat;
  int? unit;
  SaleOff? saleOff;

  Products(
      {this.id, this.price, this.quantity, this.vat, this.unit, this.saleOff});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    quantity = json['quantity'];
    vat = json['vat'];
    unit = json['unit'];
    saleOff = json['sale_off'] != null
        ? new SaleOff.fromJson(json['sale_off'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['vat'] = this.vat;
    data['unit'] = this.unit;
    if (this.saleOff != null) {
      data['sale_off'] = this.saleOff!.toJson();
    }
    return data;
  }
}

class SaleOff {
  String? value;
  String? type;

  SaleOff({this.value, this.type});

  SaleOff.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['type'] = this.type;
    return data;
  }
}
