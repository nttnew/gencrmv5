import 'dart:convert';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/models/model_item_add.dart';
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
import '../../src/models/model_generator/products_response.dart';
import '../../storages/share_local.dart';
import '../../widgets/listview/list_load_infinity.dart';

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
  BehaviorSubject<Set<HangXe>> listDongXe = BehaviorSubject.seeded({});
  BehaviorSubject<Set<HangXe>> listPhienBan = BehaviorSubject.seeded({});
  BehaviorSubject<Set<HangXe>> listNamSanXuat = BehaviorSubject.seeded({});
  BehaviorSubject<Set<HangXe>> listCanXe = BehaviorSubject.seeded({});
  BehaviorSubject<Set<HangXe>> listKieuDang = BehaviorSubject.seeded({});
  BehaviorSubject<Set<HangXe>> listSoCho = BehaviorSubject.seeded({});
  List<CustomerData>? listCus;
  BehaviorSubject<InfoCar?> infoCar = BehaviorSubject.seeded(InfoCar());
  BehaviorSubject<dynamic> listCarSearchStream = BehaviorSubject();

  HangXe? hangXe;
  HangXe? dongXe;
  HangXe? phienBan;
  HangXe? namSanXuat;
  HangXe? canXe;
  HangXe? kieuDang;
  HangXe? soCho;
  static final String KHONG_XAC_DINH = getT(KeyT.unknown);
  static final String THEM_MOI_XE = getT(KeyT.add_new_car);
  final List<ProductsRes> listProduct = [];
  double total = 0;
  LoadMoreController loadMoreControllerPhone = LoadMoreController();
  LoadMoreController loadMoreControllerBienSo = LoadMoreController();
  String? qr;

  init() {
    loadMoreControllerPhone.initData([]);
    loadMoreControllerBienSo.initData([]);
  }

  void addProduct(ProductsRes data) {
    // bool check = false;
    // for (int i = 0; i < listProduct.length; i++) {
    //   if (data.id == listProduct[i].id &&
    //       data.item.combo_id == listProduct[i].item.combo_id) {
    //     check = true;
    //     break;
    //   }
    // }
    // if (check == false) {
    //   listProduct.add(data);
    // }
  }

  String _nameData(List<List<dynamic>> list, {int name = 1}) {
    if (list.length > 0) {
      return list.first[name];
    }
    return '';
  }

  dynamic getDataSelectCar(CustomerIndividualItemData dataM) {
    final String dataName = _nameData(dataM.field_set_value_datasource ?? []);
    switch (dataM.field_name) {
      case 'hang_xe': //fieldName theo api
        return canXe?.name ?? dataName;
      case 'nam_san_xuat':
        return namSanXuat?.name ?? '${dataM.field_set_value ?? ''}';
      case 'kieu_dang':
        return kieuDang?.name ?? dataName;
      case 'dong_xe':
        return dongXe?.name ?? dataName;
      case 'hang_x_xe':
        return hangXe?.name ?? dataName;
      default:
        return '';
    }
  }

  dynamic getDataSelectCarId(CustomerIndividualItemData dataM) {
    final String dataId = _nameData(
      dataM.field_set_value_datasource ?? [],
      name: 0,
    ); //1 ==id

    switch (dataM.field_name) {
      case 'hang_xe': //fieldName theo api
        return canXe?.id ?? dataId;
      case 'nam_san_xuat':
        return namSanXuat?.name ?? dataM.field_set_value ?? '';
      case 'kieu_dang':
        return kieuDang?.id ?? dataId;
      case 'dong_xe':
        return dongXe?.id ?? dataId;
      case 'hang_x_xe':
        return hangXe?.id ?? dataId;
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
    hangXe = null;
    dongXe = null;
    phienBan = null;
    namSanXuat = null;
    canXe = null;
    kieuDang = null;
    soCho = null;
  }

  void getVersionCarInfo() {
    String data = shareLocal.getString(PreferencesKey.INFO_VERSION) ?? '';
    if (data != '' && data != 'null') {
      final DataCar dataCar = DataCar.fromJson2(jsonDecode(data));
      final hangXe = dataCar.hangXe ?? [];
      final versions = dataCar.versions ?? [];
      final Set<HangXe> list = {};
      for (final obj in hangXe) {
        list.add(obj);
      }
      listHangXe.add(list);
      listVersionCar = versions;
    }
  }

  void getListNamSanXuat(String text) {
    final Set<HangXe> list = {};
    for (final obj in listVersionCar) {
      if (obj.phienBan == text) {
        if (_checkString(obj.namSanXuat)) {
          list.add(HangXe(
            name: obj.namSanXuat,
          ));
        }
      }
    }
    list.add(
      HangXe(
        name: KHONG_XAC_DINH,
      ),
    );
    if (list.length == 1) namSanXuat = list.first;
    listNamSanXuat.add(list);
  }

  void getListCanXe(String text) {
    final Set<HangXe> list = {};
    for (final obj in listVersionCar) {
      if (obj.phienBan == text) {
        if (_checkString(obj.loaiXe)) {
          list.add(HangXe(
            id: int.tryParse(obj.loaiXeId ?? ''),
            name: obj.loaiXe ?? '',
          ));
        }
      }
    }
    list.add(
      HangXe(
        name: KHONG_XAC_DINH,
      ),
    );
    if (list.length == 1) canXe = list.first;
    listCanXe.add(list);
  }

  void getListKieuDang(String text) {
    final Set<HangXe> list = {};
    for (final obj in listVersionCar) {
      if (obj.phienBan == text) {
        if (_checkString(obj.kieuDang)) {
          list.add(HangXe(
            id: int.tryParse(obj.kieuDangId ?? ''),
            name: obj.kieuDang,
          ));
        }
      }
    }
    list.add(
      HangXe(
        name: KHONG_XAC_DINH,
      ),
    );
    if (list.length == 1) kieuDang = list.first;
    listKieuDang.add(list);
  }

  void getListSoCho(String text) {
    final Set<HangXe> list = {};
    for (final obj in listVersionCar) {
      if (obj.phienBan == text) {
        if (_checkString(obj.soCho)) {
          list.add(HangXe(
            name: obj.soCho,
          ));
        }
      }
    }
    list.add(
      HangXe(
        name: KHONG_XAC_DINH,
      ),
    );
    if (list.length == 1) soCho = list.first;
    listSoCho.add(list);
  }

  void getDongXe(String id) {
    final Set<HangXe> list = {};
    for (final obj in listVersionCar) {
      if (obj.hangXeId == id) {
        if (_checkString(obj.dongXe)) {
          list.add(HangXe(
            id: int.tryParse(obj.dongXeId ?? ''),
            name: obj.dongXe,
          ));
        }
      }
    }
    list.add(
      HangXe(
        name: KHONG_XAC_DINH,
      ),
    );
    if (list.length == 1) dongXe = list.first;
    listDongXe.add(list);
  }

  void getPhienBan(String dongXe) {
    final Set<HangXe> list = {};
    for (final obj in listVersionCar) {
      if (obj.dongXe == dongXe) {
        if (_checkString(obj.phienBan)) {
          list.add(HangXe(
            id: int.tryParse(obj.phienBanId ?? ''),
            name: obj.phienBan,
          ));
        }
      }
    }
    list.add(
      HangXe(
        name: KHONG_XAC_DINH,
      ),
    );
    if (list.length == 1) phienBan = list.first;
    listPhienBan.add(list);
  }

  bool _checkString(String? text) {
    return (text ?? '').trim() != '' && (text ?? '').trim() != 'null';
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
    dynamic resDynamic = '';
    try {
      final response = await userRepository.getSearchQuickCreate(
        page.toString(),
        bienSo: isPhone ? null : bienSoSearch,
        phone: isPhone ? phoneSearch : null,
        qr: qr,
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
      listCarSearchStream.add(resDynamic);
      return resDynamic;
    }
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
