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
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/models/model_generator/add_customer.dart';
import '../../src/models/model_generator/customer.dart';
import '../../src/models/model_generator/list_car_response.dart';
import '../../storages/share_local.dart';
import '../../widgets/widget_dialog.dart';

part 'add_service_event.dart';
part 'add_service_state.dart';

class ServiceVoucherBloc
    extends Bloc<AddServiceVoucherEvent, ServiceVoucherState> {
  final UserRepository userRepository;

  List<ModelItemAdd> addData = [];
  BehaviorSubject<bool> checkboxStream = BehaviorSubject.seeded(false);
  BehaviorSubject<String> idCar = BehaviorSubject.seeded('');
  BehaviorSubject<String> loaiXe = BehaviorSubject.seeded('');
  BehaviorSubject<List<File>?> listFileAllStream = BehaviorSubject();
  List<AddCustomerIndividualData> listAddData = [];
  List<File> listFile = [];
  List<File> listImage = [];

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
      yield* _postAddSave(event.voucherServiceRequest);
    }
  }

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

  List<List<dynamic>>? listThemXe(List<List<dynamic>>? list) {
    final listXe = list;
    listXe?.add(["", THEM_MOI_XE, "", ""]);
    return listXe ?? null;
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
    String data = shareLocal.getString(PreferencesKey.INFO_VERSION) ?? "";
    final result = json.decode(data);
    final hangXe = result['hang_xe'] as List<dynamic>;
    final versions = result['versions'] as List<dynamic>;
    final resultHangXe = hangXe.map((e) => HangXe.fromJson(e)).toList();
    final Set<HangXe> list = {};
    for (final obj in resultHangXe) {
      list.add(obj);
    }
    listHangXe.add(list);
    listVersionCar = versions.map((e) => Versions.fromJson(e)).toList();
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

  String? getTextInit({String? id, List<dynamic>? list}) {
    if (id == '13366') {
      return infoCar.value?.chiTietXe;
    } else if (id == '12914') {
      return infoCar.value?.bienSo;
    } else if (id == '13432') {
      return infoCar.value?.hangXe;
    } else if (id == '13314') {
      return infoCar.value?.soKilomet;
    } else if (id == '13559') {
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
      VoucherServiceRequest voucherServiceRequest) async* {
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
        if (listFileAllStream.valueOrNull?.isNotEmpty ?? false) {
          final responseUpload = await userRepository.uploadMultiFileContract(
              id: data['recordId'].toString(),
              files: listFileAllStream.value ?? [],
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
        Get.dialog(WidgetDialog(
          title: MESSAGES.NOTIFICATION,
          content: "Phiên đăng nhập hết hạn, hãy đăng nhập lại!",
          textButton1: "OK",
          backgroundButton1: COLORS.PRIMARY_COLOR,
          onTap1: () {
            AppNavigator.navigateLogout();
          },
        ));
      } else {
        yield ErrorGetServiceVoucherState(
            (response).getOrElse('msg', () => -1) ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      LoadingApi().popLoading();
      Get.dialog(WidgetDialog(
        title: MESSAGES.NOTIFICATION,
        content: "Phiên đăng nhập hết hạn, hãy đăng nhập lại!",
        textButton1: "OK",
        backgroundButton1: COLORS.PRIMARY_COLOR,
        onTap1: () {
          AppNavigator.navigateLogout();
        },
      ));
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
                      e.data?.map((e) {
                            return CustomerIndividualItemData(
                                e.fieldId,
                                e.fieldName,
                                e.fieldLabel,
                                e.fieldType,
                                e.fieldValidation,
                                e.fieldValidationMessage,
                                e.fieldMaxlength,
                                e.fieldHidden,
                                e.fieldRequire,
                                e.fieldSetValue,
                                e.fieldId == '12708' //theem xe
                                    ? listThemXe(e.fieldDatasource)
                                    : e.fieldDatasource,
                                e.fieldSpecial,
                                e.fieldSetValueDatasource,
                                e.fieldValue,
                                null
                                // e.fieldProducts
                                );
                          }).toList() ??
                          [],
                      e.groupName,
                      null),
                )
                .toList() ??
            [];
        yield GetServiceVoucherState(list);
      } else if (response.code == 999) {
        Get.dialog(WidgetDialog(
          title: MESSAGES.NOTIFICATION,
          content: "Phiên đăng nhập hết hạn, hãy đăng nhập lại!",
          textButton1: "OK",
          backgroundButton1: COLORS.PRIMARY_COLOR,
          onTap1: () {
            AppNavigator.navigateLogout();
          },
        ));
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

  static ServiceVoucherBloc of(BuildContext context) =>
      BlocProvider.of<ServiceVoucherBloc>(context);

  void dispose() {
    addData = [];
    listFile = [];
    listImage = [];
    loaiXe.add('');
    listFileAllStream.add(null);
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
}
