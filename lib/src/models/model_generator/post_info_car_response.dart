class InfoCar {
  String? soMay;
  String? soKhung;
  String? bienSo;
  String? idbg;
  String? chiTietXe;
  String? soKilomet;
  String? hangXe;
  String? mauXe;

  InfoCar(
      {this.soMay,
      this.soKhung,
      this.bienSo,
      this.idbg,
      this.chiTietXe,
      this.soKilomet,
      this.hangXe,
      this.mauXe,
      });

  InfoCar.fromJson(Map<String, dynamic> json) {
    soMay = json['so_may'];
    soKhung = json['so_khung'];
    bienSo = json['bien_so'];
    idbg = json['idbg'];
    chiTietXe = json['chi_tiet_xe'];
    soKilomet = json['so_kilomet'];
    hangXe = json['hang_xe'];
    mauXe = json['mau_xe'];
  }
}
