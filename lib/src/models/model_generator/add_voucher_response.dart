import 'add_customer.dart';

class AddVoucherResponse {
  bool? success;
  String? msg;
  int? code;
  Data? data;

  AddVoucherResponse({this.success, this.msg, this.code, this.data});

  AddVoucherResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<Data1>? data;

  Data({this.data});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data1>[];
      json['data'].forEach((v) {
        data!.add(new Data1.fromJson(v));
      });
    }
  }
}

class Data1 {
  String? groupName;
  List<Data2>? data;

  Data1({this.groupName, this.data});

  Data1.fromJson(Map<String, dynamic> json) {
    groupName = json['group_name'];
    if (json['data'] != null) {
      data = <Data2>[];
      json['data'].forEach((v) {
        data!.add(new Data2.fromJson(v));
      });
    }
  }
}

class Data2 {
  String? fieldId;
  String? fieldName;
  String? fieldLabel;
  String? fieldType;
  int? fieldRequire;
  String? fieldHidden;
  List<List<dynamic>>? fieldDatasource;
  // int? fieldReadOnly;
  dynamic fieldSetValue;
  String? fieldValue;
  List<List<dynamic>>? fieldSetValueDatasource;
  String? fieldValidation;
  String? fieldValidationMessage;
  String? fieldMaxlength;
  TriggerData? triggerData;
  String? fieldSpecial;
  String? fieldUrl;
  List<dynamic>? fieldProducts;
  List<ButtonRes>? buttons;

  Data2({
    this.fieldId,
    this.fieldName,
    this.fieldLabel,
    this.fieldType,
    this.fieldRequire,
    this.fieldHidden,
    this.fieldDatasource,
    // this.fieldReadOnly,
    this.fieldSetValue,
    this.fieldValue,
    this.fieldSetValueDatasource,
    this.fieldValidation,
    this.fieldValidationMessage,
    this.fieldMaxlength,
    this.triggerData,
    this.fieldSpecial,
    this.fieldUrl,
    this.fieldProducts,
    this.buttons,
  });

  Data2.fromJson(Map<String, dynamic> json) {
    fieldId = json['field_id'];
    fieldName = json['field_name'];
    fieldLabel = json['field_label'];
    fieldType = json['field_type'];
    fieldRequire = json['field_require'];
    fieldHidden = json['field_hidden'];
    if (json['field_datasource'] != null) {
      fieldDatasource = [];
      json['field_datasource'].forEach((v) {
        fieldDatasource!.add(v);
      });
    }
    // fieldReadOnly = json['field_read_only'];
    fieldSetValue = json['field_set_value'];
    fieldValue = json['field_value'];
    if (json['field_set_value_datasource'] != null) {
      fieldSetValueDatasource = [];
      json['field_set_value_datasource'].forEach((v) {
        fieldSetValueDatasource!.add(v);
      });
    }
    fieldValidation = json['field_validation'];
    fieldValidationMessage = json['field_validation_message'];
    fieldMaxlength = json['field_maxlength'];
    triggerData = json['trigger_data'] != null
        ? new TriggerData.fromJson(json['trigger_data'])
        : null;
    fieldSpecial = json['field_special'];
    fieldUrl = json['field_url'];
    if (json['field_products'] != null) {
      fieldProducts = <dynamic>[];
      json['field_products'].forEach((v) {
        fieldProducts!.add(v);
      });
    }
    if (json['button'] != null) {
      buttons = <ButtonRes>[];
      json['button'].forEach((v) {
        buttons!.add(v);
      });
    }
  }
}

// class FieldDatasource {
//
//
//   FieldDatasource({});
//
// FieldDatasource.fromJson(Map<String, dynamic> json) {
// }
//
// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   return data;
// }
// }

class TriggerData {
  String? url;
  String? fieldKeyparam;
  String? fieldChangeValue;

  TriggerData({this.url, this.fieldKeyparam, this.fieldChangeValue});

  TriggerData.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    fieldKeyparam = json['field_keyparam'];
    fieldChangeValue = json['field_change_value'];
  }
}
