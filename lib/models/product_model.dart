import 'package:gen_crm/src/models/model_generator/product_response.dart';

class ProductModel {
  String id;
  int soLuong;
  ProductItem item;
  String giamGia;
  String nameDvt;
  String nameVat;
  String typeGiamGia;

  ProductModel(this.id, this.soLuong, this.item, this.giamGia, this.nameDvt,
      this.nameVat, this.typeGiamGia);
}
