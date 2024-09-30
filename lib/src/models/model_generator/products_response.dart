class ProductsResponse {
  dynamic success;
  String? msg;
  int? code;
  DataProductsResponse? data;

  ProductsResponse({
    this.success,
    this.msg,
    this.code,
    this.data,
  });

  ProductsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    code = json['code'];
    data = json['data'] != null
        ? DataProductsResponse.fromJson(json['data'])
        : null;
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

class DataProductsResponse {
  String? page;
  int? limit;
  int? total;
  List<ProductsRes>? product;
  List<List<dynamic>>? units;
  List<List<dynamic>>? vats;

  DataProductsResponse({
    this.page,
    this.limit,
    this.total,
    this.product,
    this.units,
    this.vats,
  });

  DataProductsResponse.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    if (json['product'] != null) {
      product = <ProductsRes>[];
      json['product'].forEach((v) {
        product!.add(ProductsRes.fromJson(v));
      });
    }
    if (json['units'] != null) {
      units = <List>[];
      json['units'].forEach((v) {
        units!.add(v);
      });
    }
    if (json['vats'] != null) {
      vats = <List>[];
      json['vats'].forEach((v) {
        vats!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['total'] = this.total;
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    if (this.units != null) {
      data['units'] = this.units!.map((v) => v).toList();
    }
    if (this.vats != null) {
      data['vats'] = this.vats!.map((v) => v).toList();
    }
    return data;
  }
}

class ProductsRes {
  String? id;
  String? productId;
  String? productCode;
  String? productEdit;
  String? productName;
  String? tenSanPhamEn;
  String? tenSanPhamCn;
  String? dvt;
  String? vat;
  dynamic parentId;
  String? hasChild;
  dynamic propertyId;
  dynamic sellPrice;
  String? tenSanPhamJp;
  String? tenSanPhamKr;
  String? tenSanPhamBm;
  dynamic propertyName;
  String? tenCombo;
  String? comboId;
  List<FormProduct>? form;
  bool isShowLocal = false;
  int? soTienGui = 0;
  int? donGiaDefault;

  ProductsRes({
    this.id,
    this.productId,
    this.productCode,
    this.productEdit,
    this.productName,
    this.tenSanPhamEn,
    this.tenSanPhamCn,
    this.dvt,
    this.vat,
    this.parentId,
    this.hasChild,
    this.propertyId,
    this.sellPrice,
    this.tenSanPhamJp,
    this.tenSanPhamKr,
    this.tenSanPhamBm,
    this.propertyName,
    this.tenCombo,
    this.comboId,
    this.form,
    this.soTienGui = 0,
    this.donGiaDefault,
  });

  ProductsRes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    productCode = json['product_code'];
    productEdit = json['product_edit'];
    productName = json['product_name'];
    tenSanPhamEn = json['ten_san_pham_en'];
    tenSanPhamCn = json['ten_san_pham_cn'];
    dvt = json['dvt'];
    vat = json['vat'];
    parentId = json['parent_id'];
    hasChild = json['has_child'];
    propertyId = json['property_id'];
    sellPrice = json['sell_price'];
    tenSanPhamJp = json['ten_san_pham_jp'];
    tenSanPhamKr = json['ten_san_pham_kr'];
    tenSanPhamBm = json['ten_san_pham_bm'];
    propertyName = json['property_name'];
    tenCombo = json['ten_combo'];
    comboId = json['combo_id'];
    soTienGui = json['soTienGui'];
    donGiaDefault = json['donGiaDefault'];
    if (json['form'] != null) {
      form = <FormProduct>[];
      json['form'].forEach((v) {
        form!.add(FormProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['product_code'] = this.productCode;
    data['product_edit'] = this.productEdit;
    data['product_name'] = this.productName;
    data['ten_san_pham_en'] = this.tenSanPhamEn;
    data['ten_san_pham_cn'] = this.tenSanPhamCn;
    data['dvt'] = this.dvt;
    data['vat'] = this.vat;
    data['parent_id'] = this.parentId;
    data['has_child'] = this.hasChild;
    data['property_id'] = this.propertyId;
    data['sell_price'] = this.sellPrice;
    data['ten_san_pham_jp'] = this.tenSanPhamJp;
    data['ten_san_pham_kr'] = this.tenSanPhamKr;
    data['ten_san_pham_bm'] = this.tenSanPhamBm;
    data['property_name'] = this.propertyName;
    data['combo_id'] = this.comboId;
    data['ten_combo'] = this.tenCombo;
    data['soTienGui'] = this.soTienGui;
    data['donGiaDefault'] = this.donGiaDefault;
    if (this.form != null) {
      data['form'] = this.form!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toJsonPost() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['product_code'] = this.productCode;
    data['product_edit'] = this.productEdit;
    data['product_name'] = this.productName;
    data['ten_san_pham_en'] = this.tenSanPhamEn;
    data['ten_san_pham_cn'] = this.tenSanPhamCn;
    data['dvt'] = this.dvt;
    data['vat'] = this.vat;
    data['parent_id'] = this.parentId;
    data['has_child'] = this.hasChild;
    data['property_id'] = this.propertyId;
    data['sell_price'] = this.sellPrice;
    data['ten_san_pham_jp'] = this.tenSanPhamJp;
    data['ten_san_pham_kr'] = this.tenSanPhamKr;
    data['ten_san_pham_bm'] = this.tenSanPhamBm;
    data['property_name'] = this.propertyName;
    data['combo_id'] = this.comboId;
    data['ten_combo'] = this.tenCombo;
    data['dongia'] = this.donGiaDefault;
    data['sotiengui'] = this.soTienGui;
    data['tongdongia'] = (this.soTienGui ?? 0) + (this.donGiaDefault ?? 0);
    if (this.form != null) {
      form?.forEach((element) {
        if (element.isShow) {
          if (element.fieldName.toString() == 'sdgiamgiapopchhd')
            data['type_of_sale'] = element.typeOfSale;
          data[element.fieldName.toString()] = element.fieldSetValue;
        }
      });
    }
    return data;
  }
}

class FormProduct {
  String? fieldId;
  String? fieldName;
  String? fieldLabel;
  String? fieldType;
  String? typeOfSale;
  int? fieldRequire;
  String? fieldHidden;
  List<List<dynamic>>? fieldDatasource;
  dynamic fieldReadOnly;
  dynamic fieldSetValue;
  dynamic fieldValue;
  bool? isReloadLocal;
  List<List<dynamic>>? fieldSetValueDatasource;
  List<String>? listTypeContract;
  bool isShow = false;

  FormProduct({
    this.fieldId,
    this.fieldName,
    this.fieldLabel,
    this.fieldType,
    this.typeOfSale,
    this.fieldRequire,
    this.fieldHidden,
    this.fieldDatasource,
    this.fieldReadOnly,
    this.fieldSetValue,
    this.fieldValue,
    this.fieldSetValueDatasource,
    this.listTypeContract,
    this.isShow = false,
  });

  FormProduct.fromJson(Map<String, dynamic> json) {
    fieldId = json['field_id'];
    fieldName = json['field_name'];
    fieldLabel = json['field_label'];
    fieldType = json['field_type'];

    typeOfSale = json['type_of_sale'];
    fieldRequire = json['field_require'];
    fieldHidden = json['field_hidden'];
    if (json['field_datasource'] != null) {
      fieldDatasource = <List>[];
      json['field_datasource'].forEach((v) {
        fieldDatasource!.add(v);
      });
    }
    fieldReadOnly = json['field_read_only'];
    fieldSetValue = json['field_set_value'];
    fieldValue = json['field_value'];
    if (json['field_set_value_datasource'] != null) {
      fieldSetValueDatasource = <List>[];
      json['field_set_value_datasource'].forEach((v) {
        fieldSetValueDatasource!.add(v);
      });
    }
    if (json['show_by_id_loai_hd'] != null) {
      listTypeContract = [];
      json['show_by_id_loai_hd'].forEach((v) {
        listTypeContract!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['field_id'] = this.fieldId;
    data['field_name'] = this.fieldName;
    data['field_label'] = this.fieldLabel;
    data['field_type'] = this.fieldType;

    data['type_of_sale'] = this.typeOfSale;
    data['field_require'] = this.fieldRequire;
    data['field_hidden'] = this.fieldHidden;
    if (this.fieldDatasource != null) {
      data['field_datasource'] = this.fieldDatasource!.map((v) => v).toList();
    }
    data['field_read_only'] = this.fieldReadOnly;
    data['field_set_value'] = this.fieldSetValue;
    data['field_value'] = this.fieldValue;
    if (this.fieldSetValueDatasource != null) {
      data['field_set_value_datasource'] =
          this.fieldSetValueDatasource!.map((v) => v).toList();
    }
    if (this.listTypeContract != null) {
      data['show_by_id_loai_hd'] =
          this.listTypeContract!.map((v) => v).toList();
    }
    data['isShow'] = this.isShow;
    return data;
  }
}
