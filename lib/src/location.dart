import 'dart:convert';

import 'package:gen_crm/src/preferences_key.dart';
import 'package:gen_crm/storages/share_local.dart';

const String ID = 'id';
const String NAME = 'name';
const String CODE = 'code';
const String OPTION_DATA = 'option';
const String TINH_THANH = 'tinh_thanh';
const String QUAN_HUYEN = 'quan_huyen';
const String PHUONG_XA = 'phuong_xa';
const empty = {NAME: ''};

String getNamePhuongXa(String id) {
  for (final element in getDataLocation(PHUONG_XA)) {
    if (element[ID] == id) {
      return element[NAME];
    }
  }
  return '';
}

List<Map<String, dynamic>> getQuanHuyen(String codeTinhThanh) {
  List<Map<String, dynamic>> list = [];
  getDataLocation(QUAN_HUYEN).forEach((element) {
    if (element[OPTION_DATA] == codeTinhThanh) {
      list.add(element);
    }
  });
  return list;
}

List<Map<String, dynamic>> getPhuongXa(String codeQuanHuyen) {
  List<Map<String, dynamic>> list = [];
  getDataLocation(PHUONG_XA).forEach((element) {
    if (element[CODE].toString().contains(codeQuanHuyen)) {
      list.add(element);
    }
  });
  return list;
}

List<Map<String, dynamic>> getTinhThanh() {
  return getDataLocation(TINH_THANH);
}

List<Map<String, dynamic>> searchAddress(
  String tenQuanHuyen,
  List<Map<String, dynamic>> listQuanHuyen,
) {
  List<Map<String, dynamic>> list = [];
  listQuanHuyen.forEach((element) {
    if (element[NAME].toLowerCase().contains(tenQuanHuyen.toLowerCase())) {
      list.add(element);
    }
  });
  return list;
}

List<Map<String, dynamic>> getDataLocation(String key) {
  final dataMy = shareLocal.getString(PreferencesKey.LOCATION) ?? '';
  if (dataMy == '') return [];
  final List<dynamic> listData = jsonDecode(dataMy)[key];
  return listData.map((e) => e as Map<String, dynamic>).toList();
}

String getNameQuanHuyen(String id) {
  for (final element in getDataLocation(QUAN_HUYEN)) {
    if (element[ID] == id) {
      return element[NAME];
    }
  }
  return '';
}

String getNameTinhThanh(String id) {
  for (final element in getDataLocation(TINH_THANH)) {
    if (element[ID] == id) {
      return element[NAME];
    }
  }
  return '';
}

String checkTitle(data, title) {
  return data == '' ? title : data ?? title;
}

class LocationModel {
  String? tinhThanh;
  String? quanHuyen;
  String? phuongXa;
  String? tinhThanhId;
  String? quanHuyenId;
  String? phuongXaId;
  String? phuongXaCode;
  String? tinhThanhCode;
  String? quanHuyenCode;

  LocationModel({
    this.tinhThanh,
    this.quanHuyen,
    this.phuongXa,
    this.tinhThanhId,
    this.quanHuyenId,
    this.phuongXaId,
    this.phuongXaCode,
    this.tinhThanhCode,
    this.quanHuyenCode,
  });

  LocationModel.fromJson(Map<String, dynamic> json) {
    this.tinhThanh = json['tinhThanh'];
    this.quanHuyen = json['quanHuyen'];
    this.phuongXa = json['phuongXa'];
    this.tinhThanhId = json['tinhThanhId'];
    this.quanHuyenId = json['quanHuyenId'];
    this.phuongXaId = json['phuongXaId'];
    this.tinhThanhCode = json['tinhThanhCode'];
    this.phuongXaCode = json['phuongXaCode'];
    this.quanHuyenCode = json['quanHuyenCode'];
  }

  Map<String, dynamic> toJson() {
    return {
      'tinhThanh': this.tinhThanh,
      'quanHuyen': this.quanHuyen,
      'phuongXa': this.phuongXa,
      'tinhThanhId': this.tinhThanhId,
      'quanHuyenId': this.quanHuyenId,
      'phuongXaId': this.phuongXaId,
      'tinhThanhCode': this.tinhThanhCode,
      'quanHuyenCode': this.quanHuyenCode,
      'phuongXaCode': this.phuongXaCode,
    };
  }

  String getTitle() {
    return '$phuongXa, $quanHuyen, $tinhThanh';
  }
}
