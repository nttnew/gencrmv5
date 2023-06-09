import 'dart:convert';
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/models/model_item_add.dart';
import 'package:gen_crm/models/product_model.dart';
import 'package:gen_crm/src/models/model_generator/post_info_car_response.dart';
import 'package:gen_crm/src/models/request/voucher_service_request.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:rxdart/rxdart.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/app_const.dart';
import '../../src/models/model_generator/add_customer.dart';
import '../../src/models/model_generator/customer.dart';
import '../../src/models/model_generator/list_car_response.dart';
import '../../storages/share_local.dart';

part 'add_service_event.dart';
part 'add_service_state.dart';

class ServiceVoucherBloc
    extends Bloc<AddServiceVoucherEvent, ServiceVoucherState> {
  ServiceVoucherBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetServiceVoucher()) {
    getVersionCarInfo();
  }

  @override
  Stream<ServiceVoucherState> mapEventToState(
      AddServiceVoucherEvent event) async* {
    if (event is PostServiceVoucherEvent) {
      yield* _postAddServiceVoucher(event.sdt, event.bienSoXe);
    } else if (event is SaveVoucherServiceEvent) {
      yield* _postAddSave(event.voucherServiceRequest, event.listFile);
    }
  }

  final UserRepository userRepository;
  List<ModelItemAdd> addData = [];
  BehaviorSubject<bool> checkboxStream = BehaviorSubject.seeded(false);
  BehaviorSubject<String> idCar = BehaviorSubject.seeded('');
  BehaviorSubject<String> loaiXe = BehaviorSubject.seeded('');
  BehaviorSubject<List<AddCustomerIndividualData>> listAddData =
      BehaviorSubject.seeded([]);
  List<Versions> listVersionCar = [];
  BehaviorSubject<Set<HangXe>> listHangXe = BehaviorSubject.seeded({});
  BehaviorSubject<Set<String>> listDongXe = BehaviorSubject.seeded({});
  BehaviorSubject<Set<String>> listPhienBan = BehaviorSubject.seeded({});
  BehaviorSubject<Set<String>> listNamSanXuat = BehaviorSubject.seeded({});
  BehaviorSubject<Set<String>> listCanXe = BehaviorSubject.seeded({});
  BehaviorSubject<Set<String>> listKieuDang = BehaviorSubject.seeded({});
  BehaviorSubject<Set<String>> listSoCho = BehaviorSubject.seeded({});
  List<CustomerData>? listCus;
  BehaviorSubject<InfoCar?> infoCar = BehaviorSubject.seeded(InfoCar());
  String hangXe = '';
  String dongXe = '';
  String phienBan = '';
  String namSanXuat = '';
  String canXe = '';
  String kieuDang = '';
  String soCho = '';
  static const String KHONG_XAC_DINH = 'Không xác định';
  static const String THEM_MOI_XE = 'Thêm xe mới';
  final List<ProductModel> listProduct = [];
  double total = 0;

  void addProduct(ProductModel data) {
    bool check = false;
    for (int i = 0; i < listProduct.length; i++) {
      if (data.id == listProduct[i].id) {
        check = true;
        break;
      }
    }
    if (check == false) {
      listProduct.add(data);
    }
  }

  List<List<dynamic>>? listThemXe(List<List<dynamic>>? list, String bienSoXe) {
    if (bienSoXe != '') {
      for (final value in list ?? []) {
        if (value[1].toLowerCase() == bienSoXe.toLowerCase()) {
          getCar(value[0]);
        }
      }
    }
    final listXe = list;
    listXe?.add(["", THEM_MOI_XE, "", ""]);
    return listXe ?? null;
  }

  String? checkXe(List<List<dynamic>>? list, String bienSoXe) {
    if (bienSoXe != '') {
      for (final value in list ?? []) {
        if (value[1].toLowerCase() == bienSoXe.toLowerCase()) {
          return bienSoXe;
        }
      }
    }
    return null;
  }

  String getIdXe(
      List<List<dynamic>>? list, String bienSoXe, int index, int index1) {
    if (bienSoXe != '') {
      for (final value in list ?? []) {
        if (value[1].toLowerCase() == bienSoXe.toLowerCase()) {
          return value[0];
        }
      }
    }
    return '';
  }

  void resetDataCarVerison() {
    hangXe = '';
    dongXe = '';
    phienBan = '';
    namSanXuat = '';
    canXe = '';
    kieuDang = '';
    soCho = '';
  }

  void getVersionCarInfo() {
    String data = shareLocal.getString(PreferencesKey.INFO_VERSION) ?? '';
    if (data != '' && data != 'null') {
      final result = json.decode(data);
      final hangXe = (result['hang_xe'] ?? []) as List<dynamic>;
      final versions = (result['versions'] ?? []) as List<dynamic>;
      final resultHangXe = hangXe.map((e) => HangXe.fromJson(e)).toList();
      final Set<HangXe> list = {};
      for (final obj in resultHangXe) {
        list.add(obj);
      }
      listHangXe.add(list);
      listVersionCar = versions.map((e) => Versions.fromJson(e)).toList();
    }
  }

  void getListNamSanXuat(String text) {
    final Set<String> list = {};
    for (final obj in listVersionCar) {
      if (obj.phienBan == text) {
        if (obj.namSanXuat?.trim().isNotEmpty ?? false) {
          list.add(obj.namSanXuat.toString());
        }
      }
    }
    list.add(KHONG_XAC_DINH);
    if (list.length == 1) namSanXuat = list.first;
    listNamSanXuat.add(list);
  }

  void getListCanXe(String text) {
    final Set<String> list = {};
    for (final obj in listVersionCar) {
      if (obj.phienBan == text) {
        if (obj.loaiXe?.trim().isNotEmpty ?? false) {
          list.add(obj.loaiXe.toString());
        }
      }
    }
    list.add(KHONG_XAC_DINH);
    if (list.length == 1) canXe = list.first;
    listCanXe.add(list);
  }

  void getListKieuDang(String text) {
    final Set<String> list = {};
    for (final obj in listVersionCar) {
      if (obj.phienBan == text) {
        if (obj.kieuDang?.trim().isNotEmpty ?? false) {
          list.add(obj.kieuDang.toString());
        }
      }
    }
    list.add(KHONG_XAC_DINH);
    if (list.length == 1) kieuDang = list.first;
    listKieuDang.add(list);
  }

  void getListSoCho(String text) {
    final Set<String> list = {};
    for (final obj in listVersionCar) {
      if (obj.phienBan == text) {
        if (obj.soCho?.trim().isNotEmpty ?? false) {
          list.add(obj.soCho.toString());
        }
      }
    }
    list.add(KHONG_XAC_DINH);
    if (list.length == 1) soCho = list.first;
    listSoCho.add(list);
  }

  void getDongXe(String id) {
    final Set<String> list = {};
    for (final obj in listVersionCar) {
      if (obj.hangXeId == id) {
        if (obj.dongXe?.trim().isNotEmpty ?? false) {
          list.add(obj.dongXe.toString());
        }
      }
    }
    list.add(KHONG_XAC_DINH);
    if (list.length == 1) dongXe = list.first;
    listDongXe.add(list);
  }

  void getPhienBan(String dongXe) {
    final Set<String> list = {};
    for (final obj in listVersionCar) {
      if (obj.dongXe == dongXe) {
        if (obj.phienBan?.trim().isNotEmpty ?? false) {
          list.add(obj.phienBan.toString());
        }
      }
    }
    list.add(KHONG_XAC_DINH);
    if (list.length == 1) phienBan = list.first;
    listPhienBan.add(list);
  }

  void getCar(String id) {
    if (id.trim() == '') {
      infoCar.add(InfoCar(
        soKilomet: '',
        soMay: '',
        soKhung: '',
        chiTietXe: '',
        idbg: '',
        bienSo: '',
        hangXe: '',
        mauXe: '',
      ));
    } else {
      userRepository.postInfoCar(id).then((value) => infoCar.add(value));
    }
  }

  String? getTextInit({String? name, List<dynamic>? list}) {
    if (name == 'chi_tiet_xe') {
      return infoCar.value?.chiTietXe;
    } else if (name == 'bien_so') {
      return infoCar.value?.bienSo;
    } else if (name == 'hang_xe') {
      return infoCar.value?.hangXe;
    } else if (name == 'so_kilomet') {
      return infoCar.value?.soKilomet;
    } else if (name == 'mau_sac') {
      if (list != null) {
        for (final data in list) {
          if (data.first == infoCar.value?.mauXe) {
            return data[1];
          }
        }
        return '';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Stream<ServiceVoucherState> _postAddSave(
    VoucherServiceRequest voucherServiceRequest,
    List<File>? listFile,
  ) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingServiceVoucherState();
      final response =
          await userRepository.saveServiceVoucher(voucherServiceRequest);
      final statusCode =
          (response as Map<String, dynamic>).getOrElse('code', () => -1);
      final data = (response).getOrElse('data', () => -1);
      if ((statusCode == BASE_URL.SUCCESS) ||
          (statusCode == BASE_URL.SUCCESS_200)) {
        if (listFile?.isNotEmpty ?? false) {
          final responseUpload = await userRepository.uploadMultiFileBase(
              id: data['recordId'].toString(),
              files: listFile ?? [],
              module: getURLModule(Module.HOP_DONG));
          if ((responseUpload.code == BASE_URL.SUCCESS) ||
              (responseUpload.code == BASE_URL.SUCCESS_200)) {
            LoadingApi().popLoading();
            yield SaveServiceVoucherState();
          } else {
            LoadingApi().popLoading();
            yield ErrorGetServiceVoucherState(responseUpload.msg ?? '');
          }
        } else {
          LoadingApi().popLoading();
          yield SaveServiceVoucherState();
        }
      } else if (statusCode == 999) {
        loginSessionExpired();
      } else {
        yield ErrorGetServiceVoucherState(
            (response).getOrElse('msg', () => -1) ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      LoadingApi().popLoading();
      loginSessionExpired();
      yield ErrorGetServiceVoucherState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<ServiceVoucherState> _postAddServiceVoucher(
      String sdt, String bienSoXe) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingServiceVoucherState();
      final response =
          await userRepository.postAddServiceVoucher(sdt, bienSoXe);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        final List<AddCustomerIndividualData> list = response.data?.data
                ?.map(
                  (e) => AddCustomerIndividualData(
                    e.data?.map((f) {
                          return CustomerIndividualItemData(
                              f.fieldId,
                              f.fieldName,
                              f.fieldLabel,
                              f.fieldType,
                              f.fieldValidation,
                              f.fieldValidationMessage,
                              f.fieldMaxlength,
                              f.fieldHidden,
                              null,
                              f.fieldRequire,
                              f.fieldSetValue,
                              f.fieldName == 'hdsan_pham_kh' //theem xe
                                  ? listThemXe(f.fieldDatasource, bienSoXe)
                                  : f.fieldDatasource,
                              f.fieldSpecial,
                              f.fieldSetValueDatasource,
                              f.fieldName == 'hdsan_pham_kh' &&
                                      bienSoXe != '' //theem xe
                                  ? checkXe(f.fieldDatasource, bienSoXe)
                                  : f.fieldValue,
                              null
                              // e.fieldProducts
                              );
                        }).toList() ??
                        [],
                    e.groupName,
                    null,
                  ),
                )
                .toList() ??
            [];
        yield GetServiceVoucherState(list);
      } else if (response.code == 999) {
        loginSessionExpired();
      } else {
        yield ErrorGetServiceVoucherState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetServiceVoucherState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  void dispose() {
    listAddData.add([]);
    addData = [];
    // listFile = [];
    // listImage = [];
    loaiXe.add('');
    // listFileAllStream.add(null);
    resetDataCarVerison();
    infoCar.add(InfoCar(
      soKilomet: '',
      soMay: '',
      soKhung: '',
      chiTietXe: '',
      idbg: '',
      bienSo: '',
      hangXe: '',
      mauXe: '',
    ));
    idCar.add('');
    listProduct.clear();
    total = 0;
    checkboxStream.add(false);
  }

  static ServiceVoucherBloc of(BuildContext context) =>
      BlocProvider.of<ServiceVoucherBloc>(context);
}
