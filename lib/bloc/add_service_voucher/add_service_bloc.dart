import 'dart:convert';
import 'dart:io';

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
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/models/model_generator/add_customer.dart';
import '../../src/models/model_generator/customer.dart';
import '../../src/models/model_generator/list_car_response.dart';
import '../../storages/share_local.dart';
import '../../widgets/listview_loadmore_base.dart';

part 'add_service_event.dart';
part 'add_service_state.dart';

class ServiceVoucherBloc
    extends Bloc<AddServiceVoucherEvent, ServiceVoucherState> {
  ServiceVoucherBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetServiceVoucher());

  @override
  Stream<ServiceVoucherState> mapEventToState(
      AddServiceVoucherEvent event) async* {
    if (event is PostServiceVoucherEvent) {
      yield* _postAddServiceVoucher(event.sdt, event.bienSoXe);
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
  BehaviorSubject<dynamic> listCarSearchStream = BehaviorSubject();

  String hangXe = '';
  String dongXe = '';
  String phienBan = '';
  String namSanXuat = '';
  String canXe = '';
  String kieuDang = '';
  String soCho = '';
  static final String KHONG_XAC_DINH = getT(KeyT.unknown);
  static final String THEM_MOI_XE = getT(KeyT.add_new_car);
  final List<ProductModel> listProduct = [];
  double total = 0;
  LoadMoreController loadMoreControllerPhone = LoadMoreController();
  LoadMoreController loadMoreControllerBienSo = LoadMoreController();

  void addProduct(ProductModel data) {
    bool check = false;
    for (int i = 0; i < listProduct.length; i++) {
      if (data.id == listProduct[i].id &&
          data.item.combo_id == listProduct[i].item.combo_id) {
        check = true;
        break;
      }
    }
    if (check == false) {
      listProduct.add(data);
    }
  }

  String getDataSelectCar(String fieldName) {
    switch (fieldName) {
      case 'hang_xe': //fieldName theo api
        return canXe;
      case 'nam_san_xuat':
        return namSanXuat;
      case 'kieu_dang':
        return kieuDang;
      case 'dong_xe':
        return dongXe;
      case 'hang_x_xe':
        return hangXe;
      default:
        return '';
    }
  }

  bool getInput(String fieldName) {
    switch (fieldName) {
      case 'hang_xe': //fieldName theo api
      case 'nam_san_xuat':
      case 'kieu_dang':
      case 'dong_xe':
      case 'hang_x_xe':
        return true;
      default:
        return false;
    }
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

  String? getTextInit({
    String? name,
    List<dynamic>? list,
  }) {
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
        return null;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  String? getName({
    List<dynamic>? list,
    String? id,
  }) {
    if (list != null) {
      for (final data in list) {
        if (data.first == id) {
          return data[1];
        }
      }
      return null;
    } else {
      return null;
    }
  }

  Future<bool> checkHasCar(String bienSoXe) async {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.postAddServiceVoucher('', bienSoXe);
      if (isSuccess(response.code)) {
        LoadingApi().popLoading();
        final List<AddCustomerIndividualData> list = response.data ?? [];
        for (final AddCustomerIndividualData value in list) {
          for (final CustomerIndividualItemData valueChild
              in value.data ?? []) {
            if (valueChild.field_label == 'hdsan_pham_kh') {
              return valueChild.field_datasource != [] &&
                  valueChild.field_datasource != null;
            }
          }
        }
      } else {
        LoadingApi().popLoading();
      }
    } catch (e) {
      LoadingApi().popLoading();
      return false;
    }
    LoadingApi().popLoading();
    return false;
  }

  Stream<ServiceVoucherState> _postAddServiceVoucher(
      String sdt, String bienSoXe) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingServiceVoucherState();
      final response =
          await userRepository.postAddServiceVoucher(sdt, bienSoXe);
      if (isSuccess(response.code)) {
        yield GetServiceVoucherState(response.data ?? []);
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        yield ErrorGetServiceVoucherState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetServiceVoucherState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Future<dynamic> getSearchQuickCreate({
    int page = BASE_URL.PAGE_DEFAULT,
    bool isPhone = true,
    String? bienSoSearch,
    String? phoneSearch,
  }) async {
    LoadingApi().pushLoading();
    dynamic resDynamic = '';
    try {
      final response = await userRepository.getSearchQuickCreate(
        page.toString(),
        bienSo: isPhone ? null : bienSoSearch,
        phone: isPhone ? phoneSearch : null,
      );
      if (isSuccess(response.code)) {
        resDynamic =
            !isPhone ? response.data?.cars : response.data?.customers ?? [];
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else
        resDynamic = response.msg ?? '';
    } catch (e) {
      resDynamic = getT(KeyT.an_error_occurred);
      LoadingApi().popLoading();
      listCarSearchStream.add(resDynamic);
      return resDynamic;
    }
    LoadingApi().popLoading();
    listCarSearchStream.add(resDynamic);
    return resDynamic;
  }

  void disposeService() {
    listAddData.add([]);
    addData = [];
    loaiXe.add('');
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
