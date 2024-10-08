import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/form_add_data/add_data_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/form_add_data_bloc.dart';
import 'package:gen_crm/bloc/product_customer_module/product_customer_module_bloc.dart';
import 'package:gen_crm/bloc/product_module/product_module_bloc.dart';
import 'package:gen_crm/models/model_item_add.dart';
import 'package:gen_crm/screens/form/product_list/item_products.dart';
import 'package:gen_crm/screens/form/widget/field_image.dart';
import 'package:gen_crm/screens/form/widget/field_text.dart';
import 'package:gen_crm/screens/form/widget/field_text_api.dart';
import 'package:gen_crm/screens/form/widget/field_text_car_view.dart';
import 'package:gen_crm/screens/form/widget/location_select.dart';
import 'package:gen_crm/screens/form/widget/render_check_box.dart';
import 'package:gen_crm/screens/form/widget/type_car.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/models/model_generator/products_response.dart';
import 'package:gen_crm/src/string_ext.dart';
import 'package:gen_crm/widgets/appbar_base.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:gen_crm/widgets/field_input_select_multi.dart';
import 'package:gen_crm/widgets/showToastM.dart';
import 'package:gen_crm/widgets/widget_field_input_percent.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../../src/models/model_generator/add_customer.dart';
import '../../../bloc/add_service_voucher/add_service_bloc.dart';
import '../../../bloc/clue/clue_bloc.dart';
import '../../../bloc/contact_by_customer/contact_by_customer_bloc.dart';
import '../../../bloc/contract/attack_bloc.dart';
import '../../../bloc/contract/contract_bloc.dart';
import '../../../bloc/contract/detail_contract_bloc.dart';
import '../../../bloc/detail_product/detail_product_bloc.dart';
import '../../../bloc/detail_product_customer/detail_product_customer_bloc.dart';
import '../../../bloc/support/support_bloc.dart';
import '../../../bloc/work/work_bloc.dart';
import '../../../l10n/key_text.dart';
import '../../../models/model_data_add.dart';
import '../../../widgets/btn_save.dart';
import '../../../widgets/loading_api.dart';
import '../../../widgets/widget_input_date.dart';
import '../../../src/models/model_generator/login_response.dart';
import '../../../widgets/pick_file_image.dart';
import '../../../src/src_index.dart';
import '../../../storages/share_local.dart';
import '../../../widgets/location_base.dart';
import 'package:geolocator/geolocator.dart' show Position;
import '../../../widgets/multiple_widget.dart';
import '../home/contract/widget/widget_total_sum.dart';
import 'product_list/product_field.dart';
import 'widget/input_drop_down_base.dart';

const String GIA_TRI_HOP_DONG_FN = 'col311';
const String GIA_TRI_XUAT_HOA_DON = 'gia_tri_xuat_hoa_don';
const String TIEN_GIAM_FN =
    'tong_tien_giam'; // key id của các trường động autosum
const String TONG_TIEN_THUE_FN = 'tien_thue';
const String CHUA_THANH_TOAN_FN = 'chuathanhtoan';
const String TONG_BAO_HIEM_TRA = 'tong_bao_hiem_tra';
const String LOAI_HOP_DONG_DB = 'loai_hop_dong'; // case add edit HOP_DONG
const String SELECT_NGAN_HANG = 'banks';
const String FIELD_NAME_STATUS_P = 'sdtrangthaipopchhd';
const String STATUS_CANCEL = 'HUY';
const String STATUS_VIRTUAL = 'AO';
const String STATUS_SEND = 'GUI';
const String DA_THANH_TOAN = 'dathanhtoan';
// status == ảo +tiền ảo/ status = huỷ không công tiền ảo

class FormAddData extends StatefulWidget {
  const FormAddData({Key? key}) : super(key: key);

  @override
  State<FormAddData> createState() => _FormAddDataState();
}

class _FormAddDataState extends State<FormAddData> {
  String _title = Get.arguments[0];
  String _type = Get.arguments[1] ?? '';
  String _id = Get.arguments[2] != null ? Get.arguments[2].toString() : '';
  bool _isCheckIn = Get.arguments[3] ?? false;
  String _typeCheckIn = Get.arguments[4];
  bool _isGetData = Get.arguments[5] ?? false;
  ProductsRes? _product = Get.arguments[6];
  String _sdt = Get.arguments[7] ?? '';
  String _bienSo = Get.arguments[8] ?? '';
  String _idDetail = Get.arguments[9] ?? '';
  String _idPay = Get.arguments[10] ?? '';
  String _idNganHang = '';

  double _total = 0;
  double _tongTienGiam = 0;
  double _daThanhToan = 0;
  double _giam_gia_tong = 0;
  double _tongTienThue = 0;
  double _tongBaoHiemTra = 0;
  double _tongChuaThanhToan = 0;
  double _tongGiaTriXuatHoaDon = 0;
  List<ProductsRes> _listProduct = [];
  List<ModelItemAdd> _addData = [];
  late String _idUserLocal;
  Position? _position;
  late final BehaviorSubject<String> _nameLocation;
  late final BehaviorSubject<String>
      _reloadStream; // dùng để reload con của field
  late final TextEditingController _controllerTextNoteLocation;
  late final FormAddBloc _bloc;
  late final AddDataBloc _blocAdd;
  late final ServiceVoucherBloc _blocService;
  late final AttackBloc _attackBloc;
  late final ContactByCustomerBloc _contactBy;
  // late final TotalBloc _totalBloc;
  BehaviorSubject<String> _autoSumStream = BehaviorSubject.seeded('');
  BehaviorSubject<String> _typeContact = BehaviorSubject.seeded('');
  // auto sum dùng để reload khi value của các field autosum thay đổi

  /// check hinhTTT = 'CK' && so_tien >0  : showQRcode
  bool isAttack = (Get.arguments[1] ?? '') != ADD_PAYMENT &&
      (Get.arguments[1] ?? '') != EDIT_PAYMENT &&
      !(Get.arguments[5] ?? false);
  BehaviorSubject<bool> _showQrCodePayment = BehaviorSubject.seeded(false);
  // làm riêng cho carpa
  BehaviorSubject<String> _showFieldStream = BehaviorSubject.seeded('');

  ///

  @override
  void initState() {
    final _p = _product;
    if (_p != null) _listProduct.add(_p); // add product từ detail product
    _blocService = ServiceVoucherBloc.of(context);
    _attackBloc = AttackBloc.of(context);
    _bloc = FormAddBloc(userRepository: FormAddBloc.of(context).userRepository);
    _blocAdd =
        AddDataBloc(userRepository: AddDataBloc.of(context).userRepository);
    _contactBy = ContactByCustomerBloc.of(context);
    _controllerTextNoteLocation = TextEditingController();
    _nameLocation = BehaviorSubject.seeded('');
    _reloadStream = BehaviorSubject.seeded('');
    _nameLocation.listen((value) {
      if (value != '' &&
          value != LOADING &&
          _controllerTextNoteLocation.text != value) {
        _controllerTextNoteLocation.text = value;
      }
    });
    _loadUser();
    _addBlocEvent(_type);
    super.initState();
  }

  String? _getData(String key) {
    for (final value in _addData) {
      for (final value2 in value.data) {
        if (value2.label == key) {
          return value2.value;
        }
      }
    }
    return null;
  }

  _setData(String key, dynamic value, {bool? isUpdate}) {
    for (int i = 0; i < _addData.length; i++) {
      for (int j = 0; j < _addData[i].data.length; j++) {
        if (_addData[i].data[j].label == key) {
          _addData[i].data[j].value = value;
        }
      }
    }
  }

  bool _checkThanhToan() {
    _idNganHang = '';
    if (_type != ADD_PAYMENT && _type != EDIT_PAYMENT) return false;
    bool _checkTT = false;
    bool _checkCK = false;
    // số tiền thanh toán
    _addData.forEach((_element) {
      _element.data.forEach((_element2) {
        if (_element2.label == hdSoTien) {
          if ((int.tryParse(_element2.value) ?? 0) > 0) {
            _checkTT = true;
          }
        }

        if (_element2.label == hinhThucTT) {
          if (_element2.isCK ?? false) {
            _checkCK = true;
          }
        }

        if (_element2.label == SELECT_NGAN_HANG) {
          _idNganHang = '${_element2.value ?? ''}';
        }
      });
    });
    return _checkTT && _checkCK && _idNganHang != '';
  }

  void _addBlocEvent(String type) {
    _attackBloc.add(LoadingAttackEvent());
    final eventMap = {
      ADD_CUSTOMER_OR: InitFormAddCusOrEvent(),
      ADD_CUSTOMER: InitFormAddCustomerEvent(),
      ADD_CLUE_CUSTOMER: InitFormAddContactCusEvent(_id),
      ADD_CHANCE_CUSTOMER: InitFormAddOppCusEvent(_id),
      ADD_CONTRACT_CUS: InitFormAddContractCusEvent(_id),
      ADD_JOB_CUSTOMER: InitFormAddJobCusEvent(_id),
      ADD_SUPPORT_CUSTOMER: InitFormAddSupportCusEvent(_id),
      ADD_CLUE: InitFormAddAgencyEvent(),
      ADD_CHANCE: InitFormAddChanceEvent(),
      ADD_CONTRACT: InitFormAddContractEvent(id: _id),
      ADD_JOB: InitFormAddJobEvent(),
      ADD_SUPPORT: InitFormAddSupportEvent(),
      ADD_CLUE_JOB: InitFormAddJobOppEvent(_id),
      ADD_CHANCE_JOB: InitFormAddJobChanceEvent(_id),
      ADD_SUPPORT_CONTRACT: InitFormAddSupportContractEvent(_id),
      ADD_JOB_CONTRACT: InitFormAddJobContractEvent(_id),
      PRODUCT_TYPE: InitFormAddProductEvent(),
      PRODUCT_CUSTOMER_TYPE:
          InitFormAddProductCustomerEvent(idCustomer: int.tryParse(_id)),
      CH_PRODUCT_CUSTOMER_TYPE:
          InitFormAddCHProductCustomerEvent(int.tryParse(_id) ?? 0),
      CV_PRODUCT_CUSTOMER_TYPE:
          InitFormAddCVProductCustomerEvent(int.tryParse(_id) ?? 0),
      HT_PRODUCT_CUSTOMER_TYPE:
          InitFormAddHTProductCustomerEvent(int.tryParse(_id) ?? 0),
      HD_PRODUCT_CUSTOMER_TYPE:
          InitFormAddHDProductCustomerEvent(int.tryParse(_id) ?? 0),
      ADD_QUICK_CONTRACT: InitFormAddQuickContract(_sdt, _bienSo),
      EDIT_CUSTOMER: InitFormEditCusEvent(_id),
      EDIT_CLUE: InitFormEditClueEvent(_id),
      EDIT_CHANCE: InitFormEditChanceEvent(_id),
      EDIT_CONTRACT: InitFormEditContractEvent(_id),
      EDIT_JOB: InitFormEditJobEvent(_id),
      EDIT_SUPPORT: InitFormEditSupportEvent(_id),
      PRODUCT_TYPE_EDIT: InitFormEditProductEvent(_id),
      PRODUCT_CUSTOMER_TYPE_EDIT: InitFormEditProductCustomerEvent(_id),
      ADD_PAYMENT: InitFormAddPaymentEvent(_id),
      EDIT_PAYMENT: InitFormEditPaymentEvent(_id, _idPay, _idDetail),
    };

    if (eventMap.containsKey(type)) {
      _bloc.add(eventMap[type]!);
    }
  }

  void _loadUser() async {
    final response = await shareLocal.getString(PreferencesKey.USER);
    if (response != null) {
      _idUserLocal =
          LoginData.fromJson(jsonDecode(response)).info_user?.user_id ?? '';
    }
  }

  @override
  void deactivate() {
    _contactBy.chiTietXe.add('');
    _contactBy.listXe.add([]);
    _attackBloc.add(RemoveAllAttackEvent());
    _blocService.loaiXe.add('');
    _blocService.resetDataCarVerison();
    super.deactivate();
  }

  @override
  void dispose() {
    _nameLocation.close();
    _blocAdd.close();
    _showQrCodePayment.close();
    _showFieldStream.close();
    super.dispose();
  }

  _getNameLocation() async {
    _position = await determinePosition(context);
    if (_position != null) {
      _nameLocation.add(LOADING);
      final location = await getLocationName(
          _position?.latitude ?? 0, _position?.longitude ?? 0);
      _nameLocation.add(location);
    }
  }

  _location() {
    return _isCheckIn
        ? StreamBuilder<String>(
            stream: _nameLocation,
            builder: (context, snapshot) {
              final location = snapshot.data ?? '';
              return Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        WidgetText(
                          title: getT(KeyT.your_position),
                          style: AppStyle.DEFAULT_18_BOLD,
                        ),
                        WidgetText(
                          title: '*',
                          style: AppStyle.DEFAULT_18_BOLD.copyWith(
                            color: COLORS.RED,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (location != '') ...[
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 16,
                          width: 16,
                          child: SvgPicture.asset(
                            ICONS.IC_LOCATION_SVG,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        location != LOADING
                            ? Expanded(
                                child: WidgetText(
                                title: location,
                                style: AppStyle.DEFAULT_14_BOLD,
                              ))
                            : SizedBox(
                                height: 12,
                                width: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.4,
                                ),
                              ),
                      ],
                    ),
                  ],
                  SizedBox(
                    height: 16,
                  ),
                  if (location == '')
                    GestureDetector(
                      onTap: () async {
                        await _getNameLocation();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: COLORS.TEXT_COLOR,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              16,
                            ),
                          ),
                          border: Border.all(
                            color: COLORS.TEXT_COLOR,
                          ),
                        ),
                        child: WidgetText(
                            title: getT(KeyT.check_in),
                            style: AppStyle.DEFAULT_14_BOLD.copyWith(
                              color: COLORS.WHITE,
                            )),
                      ),
                    ),
                  if (location != '')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await _getNameLocation();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  16,
                                ),
                              ),
                              border: Border.all(
                                color: COLORS.TEXT_COLOR,
                              ),
                            ),
                            child: WidgetText(
                              title: getT(KeyT.check_in_again),
                              style: AppStyle.DEFAULT_14_BOLD.copyWith(
                                color: COLORS.TEXT_COLOR,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        GestureDetector(
                          onTap: () async {
                            _nameLocation.add('');
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  16,
                                ),
                              ),
                              border: Border.all(
                                color: COLORS.RED,
                              ),
                            ),
                            child: WidgetText(
                              title: getT(KeyT.delete),
                              style: AppStyle.DEFAULT_14_BOLD.copyWith(
                                color: COLORS.RED,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 16,
                  ),
                  if (location != '') ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          text: getT(KeyT.location),
                          style: AppStyle.DEFAULT_14W600,
                          children: <TextSpan>[
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: COLORS.RED,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: COLORS.ffBEB4B4,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          top: 5,
                          bottom: 5,
                        ),
                        child: Container(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: _controllerTextNoteLocation,
                            style: AppStyle.DEFAULT_14_BOLD,
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(
                    height: 16,
                  ),
                ],
              );
            })
        : SizedBox();
  }

  _getDataProduct(
    String fieldName,
    ProductsRes product, {
    bool isGetThree = false,
  }) {
    for (final FormProduct value in product.form ?? []) {
      if (fieldName == value.fieldName)
        switch (value.fieldType) {
          case COUNT:
          case TEXT_NUMERIC:
          case TEXT:
            return value.fieldSetValue;
          case PERCENTAGE:
            return {
              VALUE_GIAM_GIA: value.fieldSetValue,
              TYPE_GIAM_GIA: value.typeOfSale,
            };
          case SELECT:
            if ((value.fieldSetValueDatasource?.length ?? 0) > 0)
              return !isGetThree
                  ? value.fieldSetValueDatasource?.first[1]
                  : (value.fieldSetValueDatasource?.first.length ?? 0) > 2
                      ? value.fieldSetValueDatasource?.first[2]
                      : null;
            else
              return '';
        }
    }
  }

  void _setDataLoaiHopDong(
    CustomerIndividualItemData data,
    String v,
  ) {
    // set data loai and reload products
    if (LOAI_HOP_DONG_DB == data.field_name) {
      _typeContact.add(v);
    }
  }

  _tinhTheoProduct() {
    _total = 0;
    _tongTienThue = 0;
    _tongTienGiam = 0;
    _tongBaoHiemTra = 0;
    _tongGiaTriXuatHoaDon = 0;
    double _tongTienAo = 0;
    _listProduct.forEach((element) {
      _tongBaoHiemTra +=
          _getDataProduct(BA0_HIEM_TRA, element).toString().toDoubleTry();
      _tongTienGiam += _tienGiamProduct(element);
      _tongTienThue += _vatProduct(element);
      if (isStatusVirtual(element)) {
        _tongTienAo += _getIntoMoney(element);
        // lấy ra tổng tiền ảo + vào giá trị xuất hoá đơn
      } else if (isStatusCancel(element)) {
        // không tính tiền ảo
      } else {
        _total += _getIntoMoney(element);
        // không vào 2 trường hợp trên công hết
      }
    });
    _tongTienGiam = _tongTienGiam + _giam_gia_tong;
    _total = _total - _giam_gia_tong;
    _tongChuaThanhToan = _total - _daThanhToan;
    _tongGiaTriXuatHoaDon = _total + _tongTienAo;
    _autoSumStream.add(
        '$_total$_tongTienGiam$_tongTienThue$_tongChuaThanhToan$_tongBaoHiemTra$_tongGiaTriXuatHoaDon');
  }

  String _getDataWithFieldName(String v, {setValue}) {
    switch (v) {
      case GIA_TRI_HOP_DONG_FN:
        return _total.toStringAsFixed(0);
      case GIA_TRI_XUAT_HOA_DON:
        return _tongGiaTriXuatHoaDon.toStringAsFixed(0);
      case TIEN_GIAM_FN:
        return _tongTienGiam.toStringAsFixed(0);
      case TONG_TIEN_THUE_FN:
        return _tongTienThue.toStringAsFixed(0);
      case TONG_BAO_HIEM_TRA:
        return _tongBaoHiemTra.toStringAsFixed(0);
      case CHUA_THANH_TOAN_FN:
        return _tongChuaThanhToan.toStringAsFixed(0);
      case DA_THANH_TOAN:
        return '$setValue';
      default:
        return '';
    }
  }

  bool isStatusVirtual(ProductsRes _product) {
    // [10658, Sử dụng, SUDUNG, 1,
    //  [10657, Hủy, HUY, 0, ],
    //  [10656, Nợ, HOAN, 0, ],
    //  [10697, Ảo, AO, 0, ],
    //  [10698, Gửi, GUI, 0, ],
    //  [36868, Đổi trả, , 0, ],
    //  [36869, Dùng thử, , 0, ]
    // == Ảo => true
    // field_id: "12897",
    // field_name: "sdtrangthaipopchhd",
    return _getDataProduct(FIELD_NAME_STATUS_P, _product, isGetThree: true) ==
        STATUS_VIRTUAL;
  }

  bool isStatusCancel(ProductsRes _product) {
    //[[10658, Sử dụng], [10657, Hủy], [10656, Nợ], [10697, Ảo],
    // [10698, Gửi], [36868, Đổi trả], [36869, Dùng thử]]
    // == Ảo => true
    // field_id: "12897",
    // field_name: "sdtrangthaipopchhd",
    return _getDataProduct(FIELD_NAME_STATUS_P, _product, isGetThree: true) ==
        STATUS_CANCEL;
  }

  double _getIntoMoney(ProductsRes product) {
    double _priceProduct =
        _getDataProduct(DON_GIA, product).toString().toDoubleTry();
    double _vatProduct = 0;
    double _vatProductNumber = _getDataProduct(VAT, product) != ''
        ? (_getDataProduct(VAT, product) != null)
            ? _getDataProduct(VAT, product)
                .split(PHAN_TRAM)
                .first
                .toString()
                .toDoubleTry()
            : 0
        : 0;
    double _discount = 0;
    double _discountNumber = _getDataProduct(GIAM_GIA, product)[VALUE_GIAM_GIA]
        .toString()
        .toDoubleTry();
    bool _isTypeGiamGia =
        _getDataProduct(GIAM_GIA, product)[TYPE_GIAM_GIA] != PHAN_TRAM;
    double _countProduct =
        _getDataProduct(SO_LUONG, product).toString().toDoubleTry();

    if (!_isTypeGiamGia) {
      _discount = _priceProduct * _discountNumber / 100;
    } else {
      _discount = _discountNumber;
    }

    _vatProduct = _vatProductNumber * (_priceProduct - _discount) / 100;

    double _intoMoney = 0;
    _intoMoney = (_priceProduct + _vatProduct - _discount) * _countProduct;
    return _intoMoney;
  }

  double _tienGiamProduct(ProductsRes product) {
    double _discountNumber = _getDataProduct(GIAM_GIA, product)[VALUE_GIAM_GIA]
        .toString()
        .toDoubleTry();
    double _priceProduct =
        _getDataProduct(DON_GIA, product).toString().toDoubleTry();
    double _discount = 0;
    bool _isTypeGiamGia =
        _getDataProduct(GIAM_GIA, product)[TYPE_GIAM_GIA] != PHAN_TRAM;
    double _countProduct =
        _getDataProduct(SO_LUONG, product).toString().toDoubleTry();

    if (!_isTypeGiamGia) {
      _discount = (_priceProduct * _discountNumber / 100) * _countProduct;
    } else {
      _discount = _discountNumber * _countProduct;
    }
    return _discount;
  }

  _vatProduct(ProductsRes product) {
    double _vatProductNumber = _getDataProduct(VAT, product) != ''
        ? (_getDataProduct(VAT, product) != null)
            ? _getDataProduct(VAT, product)
                .split(PHAN_TRAM)
                .first
                .toString()
                .toDoubleTry()
            : 0
        : 0;
    double _discountNumber = _getDataProduct(GIAM_GIA, product)[VALUE_GIAM_GIA]
        .toString()
        .toDoubleTry();
    double _countProduct =
        _getDataProduct(SO_LUONG, product).toString().toDoubleTry();
    double _priceProduct =
        _getDataProduct(DON_GIA, product).toString().toDoubleTry();
    double _vatProduct = 0;
    double _discount = 0;
    bool _isTypeGiamGia =
        _getDataProduct(GIAM_GIA, product)[TYPE_GIAM_GIA] != PHAN_TRAM;

    if (!_isTypeGiamGia) {
      _discount = _priceProduct * _discountNumber / 100;
    } else {
      _discount = _discountNumber;
    }

    _vatProduct = _vatProductNumber * (_priceProduct - _discount) / 100;

    return _vatProduct * _countProduct;
  }

  _handleNavigationAndReloadData(
    String type,
    BuildContext context,
    SuccessAddData state,
  ) {
    switch (type) {
      case ADD_QUICK_CONTRACT:
        ContractBloc.of(context).add(InitGetContractEvent());
        AppNavigator.navigateContract();
        break;
      case ADD_CLUE:
        GetListClueBloc.of(context).loadMoreController.reloadData();
        break;
      case ADD_CHANCE:
        GetListChanceBloc.of(context).loadMoreController.reloadData();
        break;
      case ADD_CONTRACT:
        ContractBloc.of(context).loadMoreController.reloadData();
        if (_product != null) AppNavigator.navigateContract();
        break;
      case ADD_JOB:
        WorkBloc.of(context).loadMoreController.reloadData();
        break;
      case ADD_SUPPORT:
        SupportBloc.of(context).loadMoreController.reloadData();
        break;
      case PRODUCT_TYPE:
        ProductModuleBloc.of(context).loadMoreController.reloadData();
        break;
      case PRODUCT_CUSTOMER_TYPE:
        if (_isGetData) {
          Navigator.of(context)
            ..pop()
            ..pop([state.dataSPKH, state.idKH]);
        } else {
          ProductCustomerModuleBloc.of(context).loadMoreController.reloadData();
        }
        break;
      case CV_PRODUCT_CUSTOMER_TYPE:
        DetailProductCustomerBloc.of(context).controllerCv.reloadData();
        break;
      case CH_PRODUCT_CUSTOMER_TYPE:
        DetailProductCustomerBloc.of(context).controllerCh.reloadData();
        break;
      case HT_PRODUCT_CUSTOMER_TYPE:
        DetailProductCustomerBloc.of(context).controllerHt.reloadData();
        break;
      case HD_PRODUCT_CUSTOMER_TYPE:
        DetailProductCustomerBloc.of(context).controllerHd.reloadData();
        break;
      case EDIT_CLUE:
        GetListClueBloc.of(context).loadMoreController.reloadData();
        break;
      case EDIT_CHANCE:
        GetListDetailChanceBloc.of(context)
            .add(InitGetListDetailEvent(int.tryParse(_id) ?? 0));
        GetListChanceBloc.of(context).loadMoreController.reloadData();
        break;
      case EDIT_JOB:
        WorkBloc.of(context).loadMoreController.reloadData();
        break;
      case EDIT_CONTRACT:
        ContractBloc.of(context).add(InitGetContractEvent());
        DetailContractBloc.of(context)
            .add(InitGetDetailContractEvent(int.tryParse(_id) ?? 0));
        break;
      case EDIT_SUPPORT:
        SupportBloc.of(context).loadMoreController.reloadData();
        break;
      case PRODUCT_TYPE_EDIT:
        ProductModuleBloc.of(context).loadMoreController.reloadData();
        DetailProductBloc.of(context).add(InitGetDetailProductEvent(_id));
        break;
      case PRODUCT_CUSTOMER_TYPE_EDIT:
        ProductCustomerModuleBloc.of(context).loadMoreController.reloadData();
        DetailProductCustomerBloc.of(context)
            .add(InitGetDetailProductCustomerEvent(_id));
        break;
      case ADD_PAYMENT:
        break;
      case EDIT_PAYMENT:
        break;
      case EDIT_CUSTOMER:
        GetListCustomerBloc.of(context).loadMoreController.reloadData();
        break;
      case ADD_CUSTOMER:
      case ADD_CUSTOMER_OR:
        Navigator.of(context)
          ..pop()
          ..pop(state.result);
        GetListCustomerBloc.of(context).loadMoreController.reloadData();
        break;
      default:
        break;
    }
  }

  _showDialogQrCode(String data) {
    var image = base64Decode(data.replaceAll('data:image/png;base64,', ''));
    return showBottomGenCRM(
      child: StatefulBuilder(
        builder: (context, statePay) {
          return Container(
            padding: EdgeInsets.only(
              top: 24,
            ),
            decoration: BoxDecoration(
              color: COLORS.WHITE,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.memory(image),
                ButtonCustom(
                    title: getT(KeyT.xac_nhan_da_thanh_toan),
                    onTap: () {
                      Navigator.of(context).pop();
                      _onClickSave();
                    }),
              ],
            ),
          );
        },
      ),
    );
  }

  _addReloadField(
    CustomerIndividualItemData data,
    v,
  ) {
    if (data.isShowParrent == true) _showFieldStream.add(v.toString());
    if (data.is_load == true) _reloadStream.add('${data.field_name}$v');
  }

  _addDataV(
    int indexParent,
    int indexChild,
    v,
  ) {
    _addData[indexParent].data[indexChild].value = v;
  }

  _getDataV(
    int indexParent,
    int indexChild,
  ) {
    return _addData[indexParent].data[indexChild].value;
  }

  @override
  Widget build(BuildContext context) {
    final double paddingTop = MediaQuery.of(context).padding.top +
        140; //140 là chiều cao của các widget còn lại
    return Scaffold(
      backgroundColor: COLORS.WHITE,
      appBar: AppbarBaseNormal(_title.toUpperCase().capitalizeFirst ?? ''),
      body: BlocListener<AddDataBloc, AddDataState>(
        bloc: _blocAdd,
        listener: (context, state) {
          if (state is SuccessAddData) {
            Loading().popLoading();
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: state.isEdit
                  ? getT(KeyT.update_data_successfully)
                  : getT(KeyT.new_data_added_successfully),
              onTap1: () {
                if (!_isGetData &&
                    _type != ADD_CUSTOMER &&
                    _type != ADD_CUSTOMER_OR &&
                    _type != ADD_QUICK_CONTRACT) {
                  Navigator.of(context)
                    ..pop()
                    ..pop(true);
                }
                _handleNavigationAndReloadData(_type, context, state);
              },
            );
          } else if (state is ErrorAddData) {
            Loading().popLoading();
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: state.msg,
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(
            16,
          ),
          child: Column(
            children: [
              _location(),
              BlocBuilder<FormAddBloc, FormAddState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    if (state is LoadingForm) {
                      _addData = [];
                      return SizedBox.shrink();
                    } else if (state is ErrorForm) {
                      return Text(
                        state.msg,
                        style: AppStyle.DEFAULT_16_T,
                      );
                    } else if (state is SuccessForm) {
                      final List<AddCustomerIndividualData> _listAddData =
                          state.listAddData;
                      if (_addData.isEmpty) {
                        for (int i = 0; i < _listAddData.length; i++) {
                          //
                          _addData.add(
                            ModelItemAdd(
                              group_name: _listAddData[i].group_name ?? '',
                              data: [],
                            ),
                          );
                          //
                          for (int j = 0;
                              j < (_listAddData[i].data?.length ?? 0);
                              j++) {
                            CustomerIndividualItemData _item =
                                _listAddData[i].data![j];
                            //
                            if ((_item.products ?? []).length > 0)
                              _listProduct = _item.products ?? [];

                            _addData[i].data.add(
                                  ModelDataAdd(
                                    title: _item.field_label,
                                    label: _item.field_name,
                                    value: _item.field_set_value.toString(),
                                    required: _item.field_require,
                                    txtValidate: _item.field_validation_message,
                                    type: _item.field_type,
                                  ),
                                );
                          }
                        }
                      }
                      return Column(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height -
                                  paddingTop,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(_listAddData.length,
                                      (indexParent) {
                                    final itemParent =
                                        _listAddData[indexParent];
                                    return (itemParent.data != null &&
                                            (itemParent.data?.length ?? 0) > 0)
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if ('${itemParent.group_name ?? ''}'
                                                      .trim() !=
                                                  '') ...[
                                                itemParent.group_name != null
                                                    ? WidgetText(
                                                        title: itemParent
                                                                .group_name ??
                                                            '',
                                                        style: AppStyle
                                                            .DEFAULT_18_BOLD,
                                                      )
                                                    : SizedBox.shrink(),
                                                AppValue.vSpace20,
                                              ],
                                              Column(
                                                children: List.generate(
                                                    itemParent.data?.length ??
                                                        0, (indexChild) {
                                                  CustomerIndividualItemData
                                                      dataItem = itemParent
                                                          .data![indexChild];
                                                  List<dynamic>
                                                      listShowParents =
                                                      dataItem.showparents ??
                                                          [];
                                                  if (listShowParents.length >
                                                      0) {
                                                    return StreamBuilder<
                                                            String>(
                                                        stream:
                                                            _showFieldStream,
                                                        builder: (context,
                                                            snapshot) {
                                                          final String value =
                                                              snapshot.data ??
                                                                  '';
                                                          if (_checkListShow(
                                                              listShowParents,
                                                              value)) {
                                                            _addData[indexParent]
                                                                .data[
                                                                    indexChild]
                                                                .isHide = false;
                                                            return _getBody(
                                                              dataItem,
                                                              indexParent,
                                                              indexChild,
                                                            );
                                                          } else {
                                                            _addReloadField(
                                                                dataItem, '');
                                                            _addDataV(
                                                                indexParent,
                                                                indexChild,
                                                                '');
                                                            return widgetHide(
                                                                indexParent,
                                                                indexChild);
                                                          }
                                                        });
                                                  } else {
                                                    return _getBody(
                                                      dataItem,
                                                      indexParent,
                                                      indexChild,
                                                    );
                                                  }
                                                }),
                                              )
                                            ],
                                          )
                                        : SizedBox.shrink();
                                  }),
                                ),
                                if (isAttack)
                                  FileDinhKemUiBase(
                                    context: context,
                                  ),
                                AppValue.vSpace20,
                              ],
                            ),
                          ),
                          FileLuuBase(
                            context,
                            () => _onClickSave(),
                            isAttack: isAttack,
                            btn: _btnShowQR(),
                          ),
                        ],
                      );
                    } else
                      return SizedBox.shrink();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  bool _checkListShow(
    List<dynamic> _listShowParents,
    String _value,
  ) {
    final List<String> _listValue = _value.split(',');

    if (_listShowParents.contains(_value) ||
        hasCommonElement(_listShowParents, _listValue)) {
      return true;
    }
    return false;
  }

  bool hasCommonElement(List<dynamic> list1, List<String> list2) {
    // Duyệt qua từng phần tử trong list1
    for (final element in list1) {
      // Nếu phần tử đó tồn tại trong list2, trả về true
      if (list2.contains(element.toString())) {
        return true;
      }
    }
    // Nếu không có phần tử nào chung, trả về false
    return false;
  }

  _btnShowQR() => (_type == ADD_PAYMENT || _type == EDIT_PAYMENT)
      ? StreamBuilder<bool>(
          stream: _showQrCodePayment,
          builder: (context, snapshot) {
            if (snapshot.data ?? false)
              return ButtonSave(
                title: getT(KeyT.hien_qr),
                background: COLORS.PRIMARY_COLOR1,
                paddingHorizontal: 12,
                onTap: () async {
                  final String? soTien = _getData(hdSoTien);
                  final String? note = _getData(ghiChu);
                  final res = await _bloc.showQrCodePayment(
                    soTien,
                    note,
                    _idNganHang,
                  );
                  if (res['mes'] == '') {
                    _showDialogQrCode(res['data'].toString());
                  } else {
                    showToastM(context, title: res['mes'].toString());
                  }
                },
              );
            return SizedBox.shrink();
          })
      : SizedBox.shrink();

  _addCheckHTTT({
    required CustomerIndividualItemData data,
    required int indexParent,
    required int indexChild,
    required bool? isCK,
  }) {
    if (data.field_name == hinhThucTT && isCK == true) {
      _addData[indexParent].data[indexChild].isCK = true;
      _showQrCodePayment.add(_checkThanhToan());
    } else if (data.field_name == hinhThucTT && isCK == false) {
      _addData[indexParent].data[indexChild].isCK = false;
      _showQrCodePayment.add(false);
    }
  }

  _addCheckSoTien({
    required CustomerIndividualItemData data,
  }) {
    if (data.field_name == hdSoTien) {
      _showQrCodePayment.add(_checkThanhToan());
    }
  }

  _setDataMapCheck(Map<String, dynamic>? _dataM) {
    if (_dataM?.isNotEmpty ?? false) {
      _dataM!.forEach((key, value) {
        _setData(key, value, isUpdate: true);
      });
      setState(() {});
    }
  }

  Widget _getBody(
    CustomerIndividualItemData data,
    int indexParent,
    int indexChild,
  ) {
    return data.field_hidden != '1' &&
            (data.field_type != 'HIDDEN' ||
                data.field_special == 'url') // ==1 ẩn
        ? data.field_special == 'url'
            ? StreamBuilder<String>(
                stream: _typeContact,
                builder: (context, snapshot) {
                  final snap = snapshot.data ?? '';
                  return ProductField(
                    key: Key(snap),
                    typeContract: snap,
                    listBtn: data.button,
                    data: _listProduct,
                    onChange: (List<ProductsRes> v) {
                      _listProduct = v;
                      _tinhTheoProduct();
                    },
                    isDelete: true,
                  );
                })
            : _blocService.getInput(data.field_name ?? '')
                ? StreamBuilder<String>(
                    stream: _blocService.loaiXe, // getdata selectcar local
                    builder: (context, snapshot) {
                      return fieldTextCar(
                        data,
                        _blocService.getDataSelectCar(data).toString(),
                        () {
                          String v =
                              _blocService.getDataSelectCarId(data).toString();
                          _addDataV(indexParent, indexChild, v);
                        },
                      );
                    })
                : data.field_name == 'chi_tiet_xe' //chọn chi tiết xe
                    ? data.field_parent != null
                        ? StreamBuilder<String>(
                            stream: _reloadStream,
                            builder: (context, snapshot) {
                              return TypeCarBase(
                                data: data,
                                bloc: _blocService,
                                function: (v) {
                                  _addDataV(indexParent, indexChild, v);
                                },
                                addData: _addData,
                              );
                            })
                        : TypeCarBase(
                            data: data,
                            bloc: _blocService,
                            function: (v) {
                              _addDataV(indexParent, indexChild, v);
                            },
                            addData: _addData,
                          )
                    : data.field_type == 'TEXT' ||
                            data.field_type == 'TEXTAREA' ||
                            data.field_type == 'MONEY'
                        ? data.field_parent != null
                            ? StreamBuilder<String>(
                                stream: _reloadStream,
                                builder: (context, snapshot) {
                                  return FieldTextAPi(
                                    addData: _addData,
                                    data: data,
                                    onChange: (v) {
                                      _addDataV(indexParent, indexChild, v);
                                    },
                                  );
                                })
                            : FieldText(
                                data: data,
                                onChange: (v, mapV) {
                                  _tinhAuto(data, v);
                                  _addDataV(indexParent, indexChild, v);
                                  _setDataMapCheck(mapV);
                                },
                                init: _getDataV(indexParent, indexChild),
                              )
                        : data.field_type == 'SELECT'
                            // case hiện chọn ngân hàng
                            // hiển thị ki mà HTTT == CK
                            ? data.field_name == SELECT_NGAN_HANG
                                ? StreamBuilder<bool>(
                                    stream: _showQrCodePayment,
                                    builder: (context, snapshot) {
                                      if (snapshot.data ?? false)
                                        return InputDropdownBase(
                                          data: data,
                                          addData: _addData,
                                          onChange: (v, bool? isCK) {
                                            _addDataV(
                                                indexParent, indexChild, v);
                                            _idNganHang = '${v ?? ''}';
                                          },
                                        );
                                      return widgetHide(
                                          indexParent, indexChild);
                                    })
                                : checkLocation(data) // TH Select địa chỉ
                                    ? LocationWidget(
                                        data: data,
                                        onSuccess: (v) {
                                          _addDataV(indexParent, indexChild, v);
                                        },
                                        initData: data.field_value, //edit
                                        initText: _getDataV(
                                                        indexParent, indexChild)
                                                    .runtimeType ==
                                                String // vì string là lấy từ api còn k thì k cần init_text
                                            ? _getDataV(indexParent, indexChild)
                                            : null,
                                      )
                                    : data.field_parent != null // TH reload api
                                        ? StreamBuilder<String>(
                                            stream: _reloadStream,
                                            builder: (context, snapshot) {
                                              return InputDropdownBase(
                                                data: data,
                                                addData: _addData,
                                                onChange: (v, bool? isCK) {
                                                  _addDataV(indexParent,
                                                      indexChild, v);
                                                  _addCheckHTTT(
                                                    data: data,
                                                    indexParent: indexParent,
                                                    indexChild: indexChild,
                                                    isCK: isCK,
                                                  );
                                                  _setDataLoaiHopDong(
                                                      data, v.toString());
                                                  _addReloadField(data, v);
                                                },
                                              );
                                            })
                                        : data.field_name == hinhThucTT &&
                                                _type != ADD_PAYMENT &&
                                                _type != EDIT_PAYMENT
                                            ? StreamBuilder<String>(
                                                stream: _autoSumStream,
                                                builder: (context, snapshot) {
                                                  if (_daThanhToan == 0) {
                                                    return SizedBox();
                                                  } else {
                                                    return InputDropdownBase(
                                                      data: data,
                                                      addData: _addData,
                                                      onChange:
                                                          (v, bool? isCK) {
                                                        _addDataV(indexParent,
                                                            indexChild, v);
                                                        _addReloadField(
                                                            data, v);
                                                        _addCheckHTTT(
                                                          data: data,
                                                          indexParent:
                                                              indexParent,
                                                          indexChild:
                                                              indexChild,
                                                          isCK: isCK,
                                                        );
                                                      },
                                                    );
                                                  }
                                                })
                                            : InputDropdownBase(
                                                data: data,
                                                addData: _addData,
                                                onChange: (v, bool? isCK) {
                                                  _addDataV(indexParent,
                                                      indexChild, v);
                                                  _addReloadField(data, v);
                                                  _addCheckHTTT(
                                                    data: data,
                                                    indexParent: indexParent,
                                                    indexChild: indexChild,
                                                    isCK: isCK,
                                                  );
                                                  _setDataLoaiHopDong(
                                                      data, v.toString());
                                                },
                                              )
                            : data.field_type == 'TEXT_MULTI'
                                ? SelectMulti(
                                    dropdownItemList:
                                        data.field_datasource ?? [],
                                    label: data.field_label ?? '',
                                    required: data.field_require ?? 0,
                                    maxLength: data.field_maxlength ?? '',
                                    initValue:
                                        _getDataV(indexParent, indexChild)
                                            .toString()
                                            .split(','),
                                    onChange: (v) {
                                      _addReloadField(data, v);
                                      _addDataV(indexParent, indexChild, v);
                                    },
                                  )
                                : data.field_type == 'TEXT_MULTI_NEW'
                                    ? InputMultipleWidget(
                                        data: data,
                                        onSelect: (data) {
                                          final v = data.join(',');
                                          _addDataV(indexParent, indexChild, v);
                                        },
                                        value: (_getDataV(indexParent,
                                                        indexChild) !=
                                                    null &&
                                                _getDataV(indexParent,
                                                        indexChild) !=
                                                    '')
                                            ? _getDataV(indexParent, indexChild)
                                                .split(',')
                                            : (data.field_set_value != null &&
                                                    data.field_set_value != '')
                                                ? data.field_set_value
                                                    .split(',')
                                                : [],
                                      )
                                    : data.field_type == 'DATE'
                                        ? WidgetInputDate(
                                            data: data,
                                            dateText: data.field_set_value,
                                            onSelect: (v) {
                                              _addDataV(
                                                  indexParent, indexChild, v);
                                            },
                                            onInit: (v) {
                                              _addDataV(
                                                  indexParent, indexChild, v);
                                            },
                                          )
                                        : data.field_type == 'DATETIME'
                                            ? WidgetInputDate(
                                                isDate: false,
                                                data: data,
                                                dateText: data.field_set_value,
                                                onSelect: (v) {
                                                  _addDataV(indexParent,
                                                      indexChild, v);
                                                },
                                                onInit: (v) {
                                                  _addDataV(indexParent,
                                                      indexChild, v);
                                                },
                                              )
                                            : data.field_type == 'CHECK'
                                                ? RenderCheckBox(
                                                    init: data.field_set_value
                                                            .toString() ==
                                                        '1',
                                                    onChange: (check) {
                                                      final v = check ? 1 : 0;
                                                      _addDataV(indexParent,
                                                          indexChild, v);
                                                    },
                                                    data: data,
                                                  )
                                                : data.field_type ==
                                                        'PERCENTAGE'
                                                    ? FieldInputPercent(
                                                        data: data,
                                                        onChanged: (v) {
                                                          _addDataV(indexParent,
                                                              indexChild, v);
                                                        },
                                                      )
                                                    : data.field_type ==
                                                            'TEXT_NUMERIC'
                                                        ? data.field_special ==
                                                                    'autosum' ||
                                                                data
                                                                        .field_name ==
                                                                    // gía trị xuất hoá đơn nhắc BE trả về autosum
                                                                    GIA_TRI_XUAT_HOA_DON
                                                            ? StreamBuilder<
                                                                    String>(
                                                                stream:
                                                                    _autoSumStream,
                                                                builder: (context,
                                                                    snapshot) {
                                                                  _tinhAuto(
                                                                      data,
                                                                      '${data.field_set_value}');
                                                                  return WidgetTotalSum(
                                                                    label: data
                                                                        .field_label,
                                                                    value: AppValue
                                                                        .formatMoney(
                                                                      _getDataWithFieldName(
                                                                        data.field_name ??
                                                                            '',
                                                                        setValue:
                                                                            data.field_set_value,
                                                                      ),
                                                                    ),
                                                                    onChange:
                                                                        (String?
                                                                            v) {
                                                                      _addDataV(
                                                                          indexParent,
                                                                          indexChild,
                                                                          v);
                                                                    },
                                                                  );
                                                                })
                                                            : data.field_parent !=
                                                                    null // TH reload api
                                                                ? StreamBuilder<
                                                                        String>(
                                                                    stream:
                                                                        _reloadStream,
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      return FieldTextAPi(
                                                                        typeInput:
                                                                            TextInputType.number,
                                                                        addData:
                                                                            _addData,
                                                                        data:
                                                                            data,
                                                                        onChange:
                                                                            (v) {
                                                                          _addDataV(
                                                                              indexParent,
                                                                              indexChild,
                                                                              v);
                                                                          _addCheckSoTien(
                                                                              data: data);
                                                                        },
                                                                      );
                                                                    })
                                                                : FieldText(
                                                                    data: data,
                                                                    onChange: (v,
                                                                        mapV) {
                                                                      _tinhAuto(
                                                                          data,
                                                                          v);
                                                                      _addDataV(
                                                                          indexParent,
                                                                          indexChild,
                                                                          v);
                                                                      _addCheckSoTien(
                                                                          data:
                                                                              data);
                                                                      _setDataMapCheck(
                                                                          mapV);
                                                                    },
                                                                    init: _getDataV(
                                                                        indexParent,
                                                                        indexChild),
                                                                  )
                                                        : data.field_type ==
                                                                'images'
                                                            ? FieldImage(
                                                                init: (data.field_set_value
                                                                        is List<
                                                                            dynamic>)
                                                                    ? data
                                                                        .field_set_value
                                                                    : null,
                                                                data: data,
                                                                onChange: (v) {
                                                                  _addDataV(
                                                                      indexParent,
                                                                      indexChild,
                                                                      v);
                                                                },
                                                              )
                                                            : widgetHide(
                                                                indexParent,
                                                                indexChild)
        : widgetHide(indexParent, indexChild);
  }

  Widget widgetHide(int indexParent, int indexChild) {
    _addData[indexParent].data[indexChild].isHide = true;
    return SizedBox.shrink();
  }

  bool _isNull(data) {
    return (data == null || data == 'null' || data == '');
  }

  void _onClickSave() async {
    final Map<String, dynamic> data = {};
    final Map<String, dynamic> dataFile = {};

    bool isCheckValidate = false;
    String? txtValidate;

    for (int i = 0; i < _addData.length; i++) {
      for (int j = 0; j < _addData[i].data.length; j++) {
        final valueAdd = _addData[i].data[j].value;
        final labelAdd = _addData[i].data[j].label;
        final typeAdd = _addData[i].data[j].type;
        final txtValidateAdd = _addData[i].data[j].title.toString() + SPECIAL;
        final isRequiredAdd = _addData[i].data[j].required == 1;
        final isHide = _addData[i].data[j].isHide == true;

        if (_isNull(valueAdd) &&
            isRequiredAdd &&
            !(_isGetData && labelAdd == 'khach_hang_sp') &&
            !isHide) {
          isCheckValidate = true;
          txtValidate = txtValidateAdd;
          break;
        } else if (valueAdd != null && valueAdd != 'null') {
          if (labelAdd == 'hdsan_pham_kh' && valueAdd == ADD_NEW_CAR) {
            if (_contactBy.dataCarNew.isNotEmpty) {
              data['productscus'] = _contactBy.dataCarNew;
            }
          } else {
            if (typeAdd == 'images') {
              dataFile['$labelAdd'] = valueAdd;
            } else {
              data['$labelAdd'] = valueAdd;
            }
          }
        } else {
          if (typeAdd == 'images') {
            dataFile['$labelAdd'] = [];
          } else {
            data['$labelAdd'] = '';
          }
        }
      }
    }

    if (_isCheckIn) {
      if (_controllerTextNoteLocation.text.isNotEmpty) {
        data['longitude'] = _position?.longitude.toString();
        data['latitude'] = _position?.latitude.toString();
        data['note_location'] = _controllerTextNoteLocation.text;
        data['type'] = _typeCheckIn;
      } else {
        isCheckValidate = true;
      }
    }

    String mess = (getT(KeyT.please_enter_all_required_fields) +
        ((txtValidate != null && txtValidate != '') ? '\n($txtValidate' : ''));

    if (_daThanhToan < 0 && _type == ADD_CONTRACT && isCheckValidate == false) {
      isCheckValidate = true;
      mess = getT(KeyT.the_amount_paid_cannot_be_greater_than_the_total_amount);
    } else if (_giam_gia_tong > _tongChuaThanhToan &&
        isCheckValidate == false) {
      isCheckValidate = true;
      mess = getT(KeyT.giam_gia_tong_khong_duoc_lon_hon_CTT);
    }

    if (isCheckValidate == true) {
      ShowDialogCustom.showDialogBase(
        title: getT(KeyT.notification),
        content: mess,
      );
    } else {
      if (_listProduct.length > 0)
        data['products'] =
            jsonEncode(_listProduct.map((e) => e.toJsonPost()).toList());

      switch (_type) {
        case ADD_CUSTOMER_OR:
          _blocAdd.add(AddCustomerOrEvent(data, files: _attackBloc.listFile));
          break;
        case ADD_CUSTOMER:
          _blocAdd.add(AddCustomerEvent(data, files: _attackBloc.listFile));
          break;
        case ADD_CLUE_CUSTOMER:
          data['customer_id'] = _id;
          _blocAdd
              .add(AddContactCustomerEvent(data, files: _attackBloc.listFile));
          break;
        case ADD_CHANCE_CUSTOMER:
          data['customer_id'] = _id;
          _blocAdd.add(AddOpportunityEvent(data, files: _attackBloc.listFile));
          break;
        case ADD_CONTRACT_CUS:
          data['customer_id'] = _id;
          _blocAdd.add(AddContractEvent(data, files: _attackBloc.listFile));
          break;
        case ADD_JOB_CUSTOMER:
          data['customer_id'] = _id;
          _blocAdd.add(AddJobEvent(data, files: _attackBloc.listFile));
          break;
        case ADD_SUPPORT_CUSTOMER:
          data['customer_id'] = _id;
          data['nguoi_xu_lht'] = _idUserLocal;
          _blocAdd.add(AddSupportEvent(data, files: _attackBloc.listFile));
          break;
        case ADD_CLUE:
          _blocAdd
              .add(AddContactCustomerEvent(data, files: _attackBloc.listFile));
          break;
        case ADD_CHANCE:
          _blocAdd.add(AddOpportunityEvent(data, files: _attackBloc.listFile));
          break;
        case ADD_CONTRACT:
          data['col311'] = data['col311'] != ''
              ? (double.tryParse(data['col311']) ?? 0).toInt()
              : '';
          _blocAdd.add(AddContractEvent(data, files: _attackBloc.listFile));
          break;
        case ADD_JOB:
          _blocAdd.add(AddJobEvent(data, files: _attackBloc.listFile));
          break;
        case ADD_SUPPORT:
          data['nguoi_xu_lht'] = _idUserLocal;
          _blocAdd.add(AddSupportEvent(data, files: _attackBloc.listFile));
          break;
        case ADD_CLUE_JOB:
          data['daumoi_id'] = _id;
          _blocAdd.add(AddJobEvent(data, files: _attackBloc.listFile));
          break;
        case ADD_CHANCE_JOB:
          data['cohoi_id'] = _id;
          _blocAdd.add(AddJobEvent(data, files: _attackBloc.listFile));
          break;
        case ADD_SUPPORT_CONTRACT:
          data['hopdong_id'] = _id;
          data['nguoi_xu_lht'] = _idUserLocal;
          _blocAdd.add(AddSupportEvent(data, files: _attackBloc.listFile));
          break;
        case ADD_JOB_CONTRACT:
          data['hopdong_id'] = _id;
          _blocAdd.add(AddJobEvent(data, files: _attackBloc.listFile));
          break;
        case PRODUCT_TYPE:
          _blocAdd.add(
            AddProductEvent(
              FormDataCustom.formMap(
                data,
                dataFile,
              ),
              files: _attackBloc.listFile,
            ),
          );
          break;
        case PRODUCT_CUSTOMER_TYPE:
          if (_isGetData) {
            bool check = await _blocService.checkHasCar(data['bien_so']);
            if (check) {
              ShowDialogCustom.showDialogBase(
                title: getT(KeyT.notification),
                content: '${data['bien_so']} ${getT(KeyT.already_exist)}',
              );
            } else {
              _blocAdd.add(
                  AddProductCustomerEvent(data, files: _attackBloc.listFile));
            }
          } else {
            _blocAdd.add(
                AddProductCustomerEvent(data, files: _attackBloc.listFile));
          }
          break;
        case CV_PRODUCT_CUSTOMER_TYPE:
          // data['customer_id'] = _id;
          _blocAdd.add(AddJobEvent(data, files: _attackBloc.listFile));
          break;
        case HT_PRODUCT_CUSTOMER_TYPE:
          data['customer_id'] = _id;
          data['nguoi_xu_lht'] = _idUserLocal;
          _blocAdd.add(AddSupportEvent(data, files: _attackBloc.listFile));
          break;
        case HD_PRODUCT_CUSTOMER_TYPE:
          data['customer_id'] = _id;
          _blocAdd.add(AddContractEvent(data, files: _attackBloc.listFile));
          break;
        case CH_PRODUCT_CUSTOMER_TYPE:
          data['customer_id'] = _id;
          _blocAdd.add(AddOpportunityEvent(data, files: _attackBloc.listFile));
          break;
        case ADD_QUICK_CONTRACT:
          _blocAdd.add(QuickContractSaveEvent(data, _attackBloc.listFile));
          break;
        default:
          data['id'] = _id;
          if (_type == EDIT_CUSTOMER) {
            _blocAdd.add(EditCustomerEvent(data, files: _attackBloc.listFile));
          } else if (_type == EDIT_CLUE) {
            _blocAdd.add(AddContactCustomerEvent(
              data,
              files: _attackBloc.listFile,
              isEdit: true,
            ));
          } else if (_type == EDIT_CHANCE) {
            _blocAdd.add(AddOpportunityEvent(
              data,
              files: _attackBloc.listFile,
              isEdit: true,
            ));
          } else if (_type == EDIT_CONTRACT) {
            _blocAdd.add(AddContractEvent(
              data,
              files: _attackBloc.listFile,
              isEdit: true,
            ));
          } else if (_type == EDIT_JOB) {
            _blocAdd.add(EditJobEvent(data, files: _attackBloc.listFile));
          } else if (_type == EDIT_SUPPORT) {
            _blocAdd.add(AddSupportEvent(
              data,
              files: _attackBloc.listFile,
              isEdit: true,
            ));
          } else if (_type == PRODUCT_TYPE_EDIT) {
            _blocAdd.add(EditProductEvent(
                FormDataCustom.formMap(
                  data,
                  dataFile,
                ),
                int.tryParse(_id) ?? 0,
                files: _attackBloc.listFile));
          } else if (_type == PRODUCT_CUSTOMER_TYPE_EDIT) {
            _blocAdd.add(
                EditProductCustomerEvent(data, files: _attackBloc.listFile));
          } else if (_type == ADD_PAYMENT) {
            int soTienTT = int.tryParse(data['hd_sotien']) ?? 0;
            int soTienCL = int.tryParse(data['con_lai']) ?? 0;
            if (soTienTT <= soTienCL) {
              data['id_contract'] = _id;
              _blocAdd.add(AddPayment(data));
            } else {
              ShowDialogCustom.showDialogBase(
                title: getT(KeyT.notification),
                content: getT(KeyT.so_tien_tt_khong_duoc_lon_hon_so_tien_cl),
              );
            }
          } else if (_type == EDIT_PAYMENT) {
            data['id_contract'] = _id;
            data['id_chi_tiet_thanh_toan'] = _idDetail;
            data['id_payment'] = _idPay;
            _blocAdd.add(EditPayment(data));
          }
      }
    }
  }

  void _tinhAuto(
    CustomerIndividualItemData data,
    String v,
  ) {
    // tính chua thanh toan theo số tiền DATT
    if (data.field_name == 'datt' || data.field_name == 'dathanhtoan') {
      _daThanhToan = v.toDoubleTry();
      _tinhTheoProduct();
    } else if (data.field_name == 'giam_gia_tong') {
      _giam_gia_tong = v.toDoubleTry();
      _tinhTheoProduct();
    }
  }
}
