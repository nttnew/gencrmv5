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
import 'package:gen_crm/screens/menu/form/widget/field_image.dart';
import 'package:gen_crm/screens/menu/form/widget/field_text.dart';
import 'package:gen_crm/screens/menu/form/widget/field_text_api.dart';
import 'package:gen_crm/screens/menu/form/widget/field_text_car_view.dart';
import 'package:gen_crm/screens/menu/form/widget/location_select.dart';
import 'package:gen_crm/screens/menu/form/widget/render_check_box.dart';
import 'package:gen_crm/screens/menu/form/widget/type_car.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/widgets/appbar_base.dart';
import 'package:gen_crm/widgets/field_input_select_multi.dart';
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
import '../../../bloc/contract/total_bloc.dart';
import '../../../bloc/detail_product/detail_product_bloc.dart';
import '../../../bloc/detail_product_customer/detail_product_customer_bloc.dart';
import '../../../bloc/support/support_bloc.dart';
import '../../../bloc/work/work_bloc.dart';
import '../../../l10n/key_text.dart';
import '../../../models/model_data_add.dart';
import '../../../models/product_model.dart';
import '../../../src/models/model_generator/product_response.dart';
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
import 'product_list/product_contract.dart';
import 'widget/input_drop_down_base.dart';

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
  ProductModel? _product = Get.arguments[6];
  String _sdt = Get.arguments[7] ?? '';
  String _bienSo = Get.arguments[8] ?? '';
  double _total = 0;
  List<ProductModel> _listProduct = [];
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
  late final TotalBloc _totalBloc;

  @override
  void initState() {
    _blocService = ServiceVoucherBloc.of(context);
    _totalBloc = TotalBloc.of(context);
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
    if (_product != null) {
      _addProduct(_product!);
    }
    _addBlocEvent(_type);
    super.initState();
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
    _totalBloc.add(ReloadTotalEvent());
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

  _addProduct(ProductModel data) {
    bool check = false;
    for (int i = 0; i < _listProduct.length; i++) {
      if (data.id == _listProduct[i].id &&
          data.item.combo_id == _listProduct[i].item.combo_id) {
        check = true;
        break;
      }
    }
    if (!check) {
      _listProduct.add(data);
    }
  }

  _reload() {
    _total = 0;
    for (int i = 0; i < _listProduct.length; i++) {
      _total += _listProduct[i].intoMoney ?? 0;
    }
    _totalBloc.getPaid();
    _totalBloc.add(InitTotalEvent(_total));
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
        SupportBloc.of(context).add(InitGetSupportEvent());
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppbarBaseNormal(_title.toUpperCase().capitalizeFirst ?? ''),
          body: BlocListener<AddDataBloc, AddDataState>(
            bloc: _blocAdd,
            listener: (context, state) {
              if (state is SuccessAddData) {
                LoadingApi().popLoading();
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
                LoadingApi().popLoading();
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
                          _listProduct = [];
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
                                _item.products?.forEach((_element) {
                                  _listProduct.add(
                                    ProductModel(
                                      _element.id_product.toString(),
                                      double.tryParse(
                                              _element.quantity ?? '') ??
                                          0,
                                      ProductItem(
                                        _element.id_product.toString(),
                                        '',
                                        '',
                                        _element.name_product,
                                        _element.unit.toString(),
                                        _element.vat,
                                        _element.price,
                                      ),
                                      _element.sale_off.value ?? '',
                                      _element.unit_name ?? '',
                                      _element.vat_name ?? '',
                                      _element.sale_off.type ?? '',
                                    ),
                                  );
                                });

                                //
                                _addData[i].data.add(
                                      ModelDataAdd(
                                        label: _item.field_name,
                                        value: _item.field_set_value.toString(),
                                        required: _item.field_require,
                                        txtValidate:
                                            _item.field_validation_message,
                                        type: _item.field_type,
                                      ),
                                    );
                              }
                            }
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(_listAddData.length,
                                    (indexParent) {
                                  final itemParent = _listAddData[indexParent];
                                  return (itemParent.data != null &&
                                          (itemParent.data?.length ?? 0) > 0)
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: AppValue.heights * 0.01,
                                            ),
                                            itemParent.group_name != null
                                                ? WidgetText(
                                                    title:
                                                        itemParent.group_name ??
                                                            '',
                                                    style: AppStyle
                                                        .DEFAULT_18_BOLD,
                                                  )
                                                : SizedBox.shrink(),
                                            SizedBox(
                                              height: AppValue.heights * 0.01,
                                            ),
                                            Column(
                                              children: List.generate(
                                                  itemParent.data?.length ?? 0,
                                                  (indexChild) {
                                                return _getBody(
                                                  itemParent.data![indexChild],
                                                  indexParent,
                                                  indexChild,
                                                );
                                              }),
                                            )
                                          ],
                                        )
                                      : SizedBox.shrink();
                                }),
                              ),
                              if (!_isGetData)
                                FileDinhKemUiBase(
                                  context: context,
                                ),
                              SizedBox(
                                height: AppValue.widths * 0.1 + 10,
                              ),
                              FileLuuBase(
                                context,
                                () => _onClickSave(),
                                isAttack: !_isGetData,
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
        ),
      ],
    );
  }

  Widget _getBody(
    CustomerIndividualItemData data,
    int indexParent,
    int indexChild,
  ) {
    return data.field_hidden != '1' || data.field_type != 'HIDDEN' // ==1 ẩn
        ? data.field_special == 'url'
            ? ProductContract(
                listBtn: data.button,
                data: _listProduct,
                addProduct: _addProduct,
                reload: _reload,
                isDelete: true,
              )
            : data.field_name == 'chi_tiet_xe' //chọn chi tiết xe
                ? data.field_parent != null
                    ? StreamBuilder<String>(
                        stream: _reloadStream,
                        builder: (context, snapshot) {
                          return TypeCarBase(
                            data: data,
                            bloc: _blocService,
                            function: (v) {
                              _addData[indexParent].data[indexChild].value = v;
                            },
                            addData: _addData,
                          );
                        })
                    : TypeCarBase(
                        data: data,
                        bloc: _blocService,
                        function: (v) {
                          _addData[indexParent].data[indexChild].value = v;
                        },
                        addData: _addData,
                      )
                : data.field_type == 'TEXT' ||
                        data.field_type == 'TEXTAREA' ||
                        data.field_type == 'MONEY'
                    ? _blocService.getInput(data.field_name ?? '')
                        ? StreamBuilder<String>(
                            stream:
                                _blocService.loaiXe, // getdata selectcar local
                            builder: (context, snapshot) {
                              return fieldTextCar(
                                data,
                                _blocService
                                    .getDataSelectCar(data.field_name ?? ''),
                                (v) {
                                  _addData[indexParent].data[indexChild].value =
                                      v;
                                },
                              );
                            })
                        : data.field_parent != null
                            ? StreamBuilder<String>(
                                stream: _reloadStream,
                                builder: (context, snapshot) {
                                  return FieldTextAPi(
                                    addData: _addData,
                                    data: data,
                                    onChange: (v) {
                                      _addData[indexParent]
                                          .data[indexChild]
                                          .value = v;
                                    },
                                  );
                                })
                            : FieldText(
                                data: data,
                                onChange: (v) {
                                  _addData[indexParent].data[indexChild].value =
                                      v;
                                },
                              )
                    : data.field_type == 'SELECT'
                        ? _blocService.getInput(data.field_name ?? '')
                            ? StreamBuilder<String>(
                                stream: _blocService
                                    .loaiXe, // getdata selectcar local
                                builder: (context, snapshot) {
                                  return fieldTextCar(
                                    data,
                                    _blocService.getDataSelectCar(
                                        data.field_name ?? ''),
                                    (v) {
                                      _addData[indexParent]
                                          .data[indexChild]
                                          .value = v;
                                    },
                                  );
                                })
                            : checkLocation(data) // TH Select địa chỉ
                                ? LocationWidget(
                                    data: data,
                                    onSuccess: (v) {
                                      _addData[indexParent]
                                          .data[indexChild]
                                          .value = v;
                                    },
                                    initData: data.field_value,
                                  )
                                : data.field_parent != null // TH reload api
                                    ? StreamBuilder<String>(
                                        stream: _reloadStream,
                                        builder: (context, snapshot) {
                                          return InputDropdownBase(
                                            data: data,
                                            addData: _addData,
                                            onChange: (v) {
                                              _addData[indexParent]
                                                  .data[indexChild]
                                                  .value = v;
                                            },
                                          );
                                        })
                                    : data.field_name == 'hinh_thuc_thanh_toan'
                                        ? StreamBuilder<double>(
                                            stream: _totalBloc.paidStream,
                                            builder: (context, snapshot) {
                                              if ((snapshot.data ?? 0) == 0) {
                                                return SizedBox();
                                              } else {
                                                return InputDropdownBase(
                                                  data: data,
                                                  addData: _addData,
                                                  onChange: (v) {
                                                    _addData[indexParent]
                                                        .data[indexChild]
                                                        .value = v;
                                                    if (data.is_load == true)
                                                      _reloadStream.add(
                                                          '${data.field_name}$v');
                                                  },
                                                );
                                              }
                                            })
                                        : InputDropdownBase(
                                            data: data,
                                            addData: _addData,
                                            onChange: (v) {
                                              _addData[indexParent]
                                                  .data[indexChild]
                                                  .value = v;
                                              if (data.is_load == true)
                                                _reloadStream.add(
                                                    '${data.field_name}$v');
                                            },
                                          )
                        : data.field_type == 'TEXT_MULTI'
                            ? SelectMulti(
                                dropdownItemList: data.field_datasource ?? [],
                                label: data.field_label ?? '',
                                required: data.field_require ?? 0,
                                maxLength: data.field_maxlength ?? '',
                                initValue: _addData[indexParent]
                                    .data[indexChild]
                                    .value
                                    .toString()
                                    .split(','),
                                onChange: (data) {
                                  _addData[indexParent].data[indexChild].value =
                                      data;
                                },
                              )
                            : data.field_type == 'TEXT_MULTI_NEW'
                                ? InputMultipleWidget(
                                    data: data,
                                    onSelect: (data) {
                                      _addData[indexParent]
                                          .data[indexChild]
                                          .value = data.join(',');
                                    },
                                    value: (data.field_set_value != null &&
                                            data.field_set_value != '')
                                        ? data.field_set_value.split(',')
                                        : [],
                                  )
                                : data.field_type == 'DATE'
                                    ? WidgetInputDate(
                                        data: data,
                                        dateText: data.field_set_value,
                                        onSelect: (int date) {
                                          _addData[indexParent]
                                              .data[indexChild]
                                              .value = date;
                                        },
                                        onInit: (v) {
                                          _addData[indexParent]
                                              .data[indexChild]
                                              .value = v;
                                        },
                                      )
                                    : data.field_type == 'DATETIME'
                                        ? WidgetInputDate(
                                            isDate: false,
                                            data: data,
                                            dateText: data.field_set_value,
                                            onSelect: (int date) {
                                              _addData[indexParent]
                                                  .data[indexChild]
                                                  .value = date;
                                            },
                                            onInit: (v) {
                                              _addData[indexParent]
                                                  .data[indexChild]
                                                  .value = v;
                                            },
                                          )
                                        : data.field_type == 'CHECK'
                                            ? RenderCheckBox(
                                                init: data.field_set_value
                                                        .toString() ==
                                                    '1',
                                                onChange: (check) {
                                                  _addData[indexParent]
                                                      .data[indexChild]
                                                      .value = check ? 1 : 0;
                                                },
                                                data: data,
                                              )
                                            : data.field_type == 'PERCENTAGE'
                                                ? FieldInputPercent(
                                                    data: data,
                                                    onChanged: (text) {
                                                      _addData[indexParent]
                                                          .data[indexChild]
                                                          .value = text;
                                                    },
                                                  )
                                                : data.field_type ==
                                                        'TEXT_NUMERIC'
                                                    ? data.field_name ==
                                                            'chuathanhtoan'
                                                        ? StreamBuilder<double>(
                                                            stream: _totalBloc
                                                                .unpaidStream,
                                                            builder: (context,
                                                                snapshot) {
                                                              final value =
                                                                  snapshot.data;
                                                              _addData[
                                                                      indexParent]
                                                                  .data[
                                                                      indexChild]
                                                                  .value = value;
                                                              return WidgetTotalSum(
                                                                label: data
                                                                    .field_label,
                                                                value: AppValue
                                                                    .format_money(
                                                                  (value ?? 0)
                                                                      .toStringAsFixed(
                                                                    0,
                                                                  ),
                                                                ),
                                                              );
                                                            })
                                                        : data.field_special ==
                                                                'autosum'
                                                            ? BlocBuilder<
                                                                    TotalBloc,
                                                                    TotalState>(
                                                                builder: (context,
                                                                    stateA) {
                                                                if (stateA
                                                                    is SuccessTotalState) {
                                                                  _addData[indexParent]
                                                                          .data[
                                                                              indexChild]
                                                                          .value =
                                                                      stateA
                                                                          .total
                                                                          .toString();
                                                                  TotalBloc.of(
                                                                          context)
                                                                      .getPaid();
                                                                  return WidgetTotalSum(
                                                                    label: data
                                                                        .field_label,
                                                                    value: AppValue
                                                                        .format_money(
                                                                      stateA
                                                                          .total
                                                                          .toStringAsFixed(
                                                                        0,
                                                                      ),
                                                                    ),
                                                                  );
                                                                } else {
                                                                  return WidgetTotalSum(
                                                                    label: data
                                                                        .field_label,
                                                                    value: '',
                                                                  );
                                                                }
                                                              })
                                                            : data.field_parent !=
                                                                    null // TH reload api
                                                                ? StreamBuilder<
                                                                        String>(
                                                                    stream:
                                                                        _reloadStream,
                                                                    builder: (context,
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
                                                                          _addData[indexParent]
                                                                              .data[indexChild]
                                                                              .value = v;
                                                                        },
                                                                      );
                                                                    })
                                                                : FieldText(
                                                                    data: data,
                                                                    onChange:
                                                                        (v) {
                                                                      if (data.field_name ==
                                                                          'datt') {
                                                                        _totalBloc
                                                                            .paidStream
                                                                            .add(double.tryParse(v) ??
                                                                                0);
                                                                        _totalBloc
                                                                            .getPaid();
                                                                      }
                                                                      _addData[
                                                                              indexParent]
                                                                          .data[
                                                                              indexChild]
                                                                          .value = v;
                                                                    },
                                                                  )
                                                    : data.field_type == 'images'
                                                        ? FieldImage(
                                                            init: (data.field_set_value
                                                                    is List<
                                                                        dynamic>)
                                                                ? data
                                                                    .field_set_value
                                                                : null,
                                                            data: data,
                                                            onChange: (v) {
                                                              _addData[
                                                                      indexParent]
                                                                  .data[
                                                                      indexChild]
                                                                  .value = v;
                                                            },
                                                          )
                                                        : SizedBox.shrink()
        : SizedBox.shrink();
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
        final txtValidateAdd = _addData[i].data[j].txtValidate;
        final isRequiredAdd = _addData[i].data[j].required == 1;

        if (_isNull(valueAdd) &&
            isRequiredAdd &&
            !(_isGetData && labelAdd == 'khach_hang_sp')) {
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

    if (_totalBloc.unpaidStream.value < 0 && _type == ADD_CONTRACT) {
      isCheckValidate = true;
    }

    if (isCheckValidate == true) {
      ShowDialogCustom.showDialogBase(
        title: getT(KeyT.notification),
        content: _totalBloc.unpaidStream.value < 0
            ? getT(KeyT.the_amount_paid_cannot_be_greater_than_the_total_amount)
            : (getT(KeyT.please_enter_all_required_fields) +
                ((txtValidate != null && txtValidate != '')
                    ? '\n($txtValidate)'
                    : '')),
      );
    } else {
      if (_listProduct.isNotEmpty) {
        List product = [];
        for (int i = 0; i < _listProduct.length; i++) {
          product.add({
            'id': _listProduct[i].id,
            'price': _listProduct[i].item.sell_price,
            'quantity': _listProduct[i].soLuong,
            'vat': _listProduct[i].item.vat,
            'unit': _listProduct[i].item.dvt,
            'ten_combo': _listProduct[i].item.ten_combo,
            'combo_id': _listProduct[i].item.combo_id,
            'sale_off': {
              'value': _listProduct[i].giamGia,
              'type': _listProduct[i].typeGiamGia
            }
          });
        }
        data['products'] = product;
      }

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
          data['customer_id'] = _id;
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
          }
      }
    }
  }
}
