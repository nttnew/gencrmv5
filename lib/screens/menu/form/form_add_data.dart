import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/form_add_data/add_data_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/form_add_data_bloc.dart';
import 'package:gen_crm/bloc/product_customer_module/product_customer_module_bloc.dart';
import 'package:gen_crm/bloc/product_module/product_module_bloc.dart';
import 'package:gen_crm/models/model_item_add.dart';
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
  String title = Get.arguments[0];
  String type = Get.arguments[1] ?? '';
  String id = Get.arguments[2] != null ? Get.arguments[2].toString() : '';
  bool isCheckIn = Get.arguments[3] ?? false;
  String typeCheckIn = Get.arguments[4];
  bool isResultData = Get.arguments[5] ?? false;
  bool isGetData = Get.arguments[6] ?? false;
  ProductModel? product = Get.arguments[7];
  String sdt = Get.arguments[8] ?? '';
  String bienSo = Get.arguments[9] ?? '';
  double total = 0;
  List<ProductModel> listProduct = [];
  List<ModelItemAdd> addData = [];
  late String idUserLocal;
  File? fileUpload;
  Position? position;
  late final BehaviorSubject<String> nameLocation;
  late final BehaviorSubject<String>
      reloadStream; // dùng để reload con của field
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
    nameLocation = BehaviorSubject.seeded('');
    reloadStream = BehaviorSubject.seeded('');
    nameLocation.listen((value) {
      if (value != '' &&
          value != LOADING &&
          _controllerTextNoteLocation.text != value) {
        _controllerTextNoteLocation.text = value;
      }
    });
    loadUser();
    if (product != null) {
      addProduct(product!);
    }
    _attackBloc.add(LoadingAttackEvent());
    if (type == ADD_CUSTOMER_OR) {
      _bloc.add(InitFormAddCusOrEvent());
    } else if (type == ADD_CUSTOMER) {
      _bloc.add(InitFormAddCustomerEvent());
    } else if (type == ADD_CLUE_CUSTOMER) {
      _bloc.add(InitFormAddContactCusEvent(id));
    } else if (type == ADD_CHANCE_CUSTOMER) {
      _bloc.add(InitFormAddOppCusEvent(id));
    } else if (type == ADD_CONTRACT_CUS) {
      _bloc.add(InitFormAddContractCusEvent(id));
    } else if (type == ADD_JOB_CUSTOMER) {
      _bloc.add(InitFormAddJobCusEvent(id));
    } else if (type == ADD_SUPPORT_CUSTOMER) {
      _bloc.add(InitFormAddSupportCusEvent(id));
    } else if (type == ADD_CLUE) {
      _bloc.add(InitFormAddAgencyEvent());
    } else if (type == ADD_CHANCE) {
      _bloc.add(InitFormAddChanceEvent());
    } else if (type == ADD_CONTRACT) {
      _bloc.add(InitFormAddContractEvent(id: id));
    } else if (type == ADD_JOB) {
      _bloc.add(InitFormAddJobEvent());
    } else if (type == ADD_SUPPORT) {
      _bloc.add(InitFormAddSupportEvent());
    } else if (type == ADD_CLUE_JOB) {
      _bloc.add(InitFormAddJobOppEvent(id));
    } else if (type == ADD_CHANCE_JOB) {
      _bloc.add(InitFormAddJobChanceEvent(id));
    } else if (type == ADD_SUPPORT_CONTRACT) {
      _bloc.add(InitFormAddSupportContractEvent(id));
    } else if (type == ADD_JOB_CONTRACT) {
      _bloc.add(InitFormAddJobContractEvent(id));
    } else if (type == PRODUCT_TYPE) {
      _bloc.add(InitFormAddProductEvent());
    } else if (type == PRODUCT_CUSTOMER_TYPE) {
      _bloc.add(InitFormAddProductCustomerEvent());
    } else if (type == CH_PRODUCT_CUSTOMER_TYPE) {
      _bloc.add(InitFormAddCHProductCustomerEvent(int.parse(id)));
    } else if (type == CV_PRODUCT_CUSTOMER_TYPE) {
      _bloc.add(InitFormAddCVProductCustomerEvent(int.parse(id)));
    } else if (type == HT_PRODUCT_CUSTOMER_TYPE) {
      _bloc.add(InitFormAddHTProductCustomerEvent(int.parse(id)));
    } else if (type == HD_PRODUCT_CUSTOMER_TYPE) {
      _bloc.add(InitFormAddHDProductCustomerEvent(int.parse(id)));
    } else if (type == ADD_QUICK_CONTRACT) {
      _bloc.add(InitFormAddQuickContract(
        sdt,
        bienSo,
      ));
    } else if (type == EDIT_CUSTOMER)
      _bloc.add(InitFormEditCusEvent(id));
    else if (type == EDIT_CLUE) {
      _bloc.add(InitFormEditClueEvent(id));
    } else if (type == EDIT_CHANCE) {
      _bloc.add(InitFormEditChanceEvent(id));
    } else if (type == EDIT_CONTRACT) {
      _bloc.add(InitFormEditContractEvent(id));
    } else if (type == EDIT_JOB) {
      _bloc.add(InitFormEditJobEvent(id));
    } else if (type == EDIT_SUPPORT) {
      _bloc.add(InitFormEditSupportEvent(id));
    } else if (type == PRODUCT_TYPE) {
      _bloc.add(InitFormEditProductEvent(id));
    } else if (type == PRODUCT_CUSTOMER_TYPE) {
      _bloc.add(InitFormEditProductCustomerEvent(id));
    }
    super.initState();
  }

  void loadUser() async {
    final response = await shareLocal.getString(PreferencesKey.USER);
    if (response != null) {
      idUserLocal =
          LoginData.fromJson(jsonDecode(response)).info_user?.user_id ?? '';
    }
  }

  @override
  void deactivate() {
    _totalBloc.add(ReloadTotalEvent());
    _contactBy.chiTietXe.add('');
    _contactBy.listXe.add([]);
    // PhoneBloc.of(context).add(InitPhoneEvent(''));
    _attackBloc.add(RemoveAllAttackEvent());
    _blocService.loaiXe.add('');
    _blocService.resetDataCarVerison();
    super.deactivate();
  }

  @override
  void dispose() {
    nameLocation.close();
    _blocAdd.close();
    super.dispose();
  }

  getNameLocation() async {
    position = await determinePosition(context);
    if (position != null) {
      nameLocation.add(LOADING);
      final location = await getLocationName(
          position?.latitude ?? 0, position?.longitude ?? 0);
      nameLocation.add(location);
    }
  }

  _location() {
    return isCheckIn
        ? StreamBuilder<String>(
            stream: nameLocation,
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
                        await getNameLocation();
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
                            await getNameLocation();
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
                            nameLocation.add('');
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

  addProduct(ProductModel data) {
    bool check = false;
    for (int i = 0; i < listProduct.length; i++) {
      if (data.id == listProduct[i].id &&
          data.item.combo_id == listProduct[i].item.combo_id) {
        check = true;
        break;
      }
    }
    if (!check) {
      listProduct.add(data);
    }
  }

  reload() {
    total = 0;
    for (int i = 0; i < listProduct.length; i++) {
      total += listProduct[i].intoMoney ?? 0;
    }
    _totalBloc.getPaid();
    _totalBloc.add(InitTotalEvent(total));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppbarBaseNormal(title.toUpperCase().capitalizeFirst ?? ''),
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
                    if (!isGetData &&
                        type != ADD_CUSTOMER &&
                        type != ADD_CUSTOMER_OR) {
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    }
                    if (type == ADD_CLUE) {
                      GetListClueBloc.of(context)
                          .loadMoreController
                          .reloadData();
                    } else if (type == ADD_CHANCE) {
                      GetListChanceBloc.of(context)
                          .loadMoreController
                          .reloadData();
                    } else if (type == ADD_CONTRACT) {
                      ContractBloc.of(context).loadMoreController.reloadData();
                      if (product != null) AppNavigator.navigateContract();
                    } else if (type == ADD_JOB) {
                      WorkBloc.of(context).loadMoreController.reloadData();
                    } else if (type == ADD_SUPPORT) {
                      SupportBloc.of(context).loadMoreController.reloadData();
                    } else if (type == PRODUCT_TYPE) {
                      ProductModuleBloc.of(context)
                          .loadMoreController
                          .reloadData();
                    } else if (type == PRODUCT_CUSTOMER_TYPE) {
                      if (isGetData) {
                        Navigator.of(context)
                          ..pop()
                          ..pop([state.dataSPKH, state.idKH]);
                      } else {
                        ProductCustomerModuleBloc.of(context)
                            .loadMoreController
                            .reloadData();
                      }
                    } else if (type == CV_PRODUCT_CUSTOMER_TYPE) {
                      DetailProductCustomerBloc.of(context)
                          .controllerCv
                          .reloadData();
                    } else if (type == CH_PRODUCT_CUSTOMER_TYPE) {
                      DetailProductCustomerBloc.of(context)
                          .controllerCh
                          .reloadData();
                    } else if (type == HT_PRODUCT_CUSTOMER_TYPE) {
                      DetailProductCustomerBloc.of(context)
                          .controllerHt
                          .reloadData();
                    } else if (type == HD_PRODUCT_CUSTOMER_TYPE) {
                      DetailProductCustomerBloc.of(context)
                          .controllerHd
                          .reloadData();
                    } else if (type == ADD_QUICK_CONTRACT) {
                      //todo
                    } else if (type == EDIT_CLUE) {
                      GetListClueBloc.of(context)
                          .loadMoreController
                          .reloadData();
                    } else if (type == EDIT_CHANCE) {
                      GetListDetailChanceBloc.of(context)
                          .add(InitGetListDetailEvent(int.parse(id)));
                      GetListChanceBloc.of(context)
                          .loadMoreController
                          .reloadData();
                    } else if (type == EDIT_JOB) {
                      WorkBloc.of(context).loadMoreController.reloadData();
                    } else if (type == EDIT_CONTRACT) {
                      ContractBloc.of(context).add(InitGetContractEvent());
                      DetailContractBloc.of(context)
                          .add(InitGetDetailContractEvent(int.parse(id)));
                    } else if (type == EDIT_SUPPORT) {
                      SupportBloc.of(context).add(InitGetSupportEvent());
                    } else if (type == PRODUCT_TYPE) {
                      ProductModuleBloc.of(context)
                          .loadMoreController
                          .reloadData();
                      DetailProductBloc.of(context)
                          .add(InitGetDetailProductEvent(id));
                    } else if (type == PRODUCT_CUSTOMER_TYPE) {
                      ProductCustomerModuleBloc.of(context)
                          .loadMoreController
                          .reloadData();
                      DetailProductCustomerBloc.of(context)
                          .add(InitGetDetailProductCustomerEvent(id));
                    } else if (type == EDIT_CUSTOMER) {
                      GetListCustomerBloc.of(context)
                          .loadMoreController
                          .reloadData();
                    } else if (type == ADD_CUSTOMER ||
                        type == ADD_CUSTOMER_OR) {
                      Navigator.of(context)
                        ..pop()
                        ..pop(
                          state.result,
                        );
                      GetListCustomerBloc.of(context)
                          .loadMoreController
                          .reloadData();
                    }
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
                          addData = [];
                          return SizedBox.shrink();
                        } else if (state is ErrorForm) {
                          return Text(
                            state.msg,
                            style: AppStyle.DEFAULT_16_T,
                          );
                        } else if (state is SuccessForm) {
                          if (addData.isEmpty) {
                            for (int i = 0; i < state.listAddData.length; i++) {
                              addData.add(
                                ModelItemAdd(
                                  group_name:
                                      state.listAddData[i].group_name ?? '',
                                  data: [],
                                ),
                              );
                              for (int j = 0;
                                  j < state.listAddData[i].data!.length;
                                  j++) {
                                addData[i].data.add(
                                      ModelDataAdd(
                                        label: state
                                            .listAddData[i].data![j].field_name,
                                        value: state.listAddData[i].data![j]
                                            .field_set_value
                                            .toString(),
                                        required: state.listAddData[i].data![j]
                                            .field_require,
                                        txtValidate: state.listAddData[i]
                                            .data![j].field_validation_message,
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
                                children: List.generate(
                                    state.listAddData.length,
                                    (indexParent) => (state
                                                    .listAddData[indexParent]
                                                    .data !=
                                                null &&
                                            state.listAddData[indexParent].data!
                                                    .length >
                                                0)
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: AppValue.heights * 0.01,
                                              ),
                                              state.listAddData[indexParent]
                                                          .group_name !=
                                                      null
                                                  ? WidgetText(
                                                      title: state
                                                              .listAddData[
                                                                  indexParent]
                                                              .group_name ??
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
                                                    state
                                                            .listAddData[
                                                                indexParent]
                                                            .data
                                                            ?.length ??
                                                        0, (indexChild) {
                                                  return _getBody(
                                                    state
                                                        .listAddData[
                                                            indexParent]
                                                        .data![indexChild],
                                                    indexParent,
                                                    indexChild,
                                                  );
                                                }),
                                              )
                                            ],
                                          )
                                        : SizedBox.shrink()),
                              ),
                              if (!isGetData)
                                FileDinhKemUiBase(
                                  context: context,
                                  onTap: () {},
                                  isSave: false,
                                ),
                              SizedBox(
                                height: AppValue.widths * 0.1 + 10,
                              ),
                              FileLuuBase(
                                context,
                                () => onClickSave(),
                                isAttack: !isGetData,
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
                data: listProduct,
                addProduct: addProduct,
                reload: reload,
                neverHidden: true,
                canDelete: true,
              )
            : data.field_name == 'chi_tiet_xe' //chọn chi tiết xe
                ? data.field_parent != null
                    ? StreamBuilder<String>(
                        stream: reloadStream,
                        builder: (context, snapshot) {
                          return TypeCarBase(
                            data: data,
                            bloc: _blocService,
                            function: (v) {
                              addData[indexParent].data[indexChild].value = v;
                            },
                            addData: addData,
                          );
                        })
                    : TypeCarBase(
                        data: data,
                        bloc: _blocService,
                        function: (v) {
                          addData[indexParent].data[indexChild].value = v;
                        },
                        addData: addData,
                      )
                : data.field_type == 'TEXT' || data.field_type == 'TEXTAREA'
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
                                  addData[indexParent].data[indexChild].value =
                                      v;
                                },
                              );
                            })
                        : data.field_parent != null
                            ? StreamBuilder<String>(
                                stream: reloadStream,
                                builder: (context, snapshot) {
                                  return FieldTextAPi(
                                    addData: addData,
                                    data: data,
                                    onChange: (v) {
                                      addData[indexParent]
                                          .data[indexChild]
                                          .value = v;
                                    },
                                  );
                                })
                            : FieldText(
                                data: data,
                                onChange: (v) {
                                  addData[indexParent].data[indexChild].value =
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
                                      addData[indexParent]
                                          .data[indexChild]
                                          .value = v;
                                    },
                                  );
                                })
                            : checkLocation(data) // TH Select địa chỉ
                                ? LocationWidget(
                                    data: data,
                                    onSuccess: (v) {
                                      addData[indexParent]
                                          .data[indexChild]
                                          .value = v;
                                    },
                                    initData: data.field_value,
                                  )
                                : data.field_parent != null // TH reload api
                                    ? StreamBuilder<String>(
                                        stream: reloadStream,
                                        builder: (context, snapshot) {
                                          return InputDropdownBase(
                                            data: data,
                                            addData: addData,
                                            onChange: (v) {
                                              addData[indexParent]
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
                                                  addData: addData,
                                                  onChange: (v) {
                                                    addData[indexParent]
                                                        .data[indexChild]
                                                        .value = v;
                                                    if (data.is_load == true)
                                                      reloadStream.add(
                                                          '${data.field_name}$v');
                                                  },
                                                );
                                              }
                                            })
                                        : InputDropdownBase(
                                            data: data,
                                            addData: addData,
                                            onChange: (v) {
                                              addData[indexParent]
                                                  .data[indexChild]
                                                  .value = v;
                                              if (data.is_load == true)
                                                reloadStream.add(
                                                    '${data.field_name}$v');
                                            },
                                          )
                        : data.field_type == 'TEXT_MULTI'
                            ? SelectMulti(
                                dropdownItemList: data.field_datasource ?? [],
                                label: data.field_label ?? '',
                                required: data.field_require ?? 0,
                                maxLength: data.field_maxlength ?? '',
                                initValue: addData[indexParent]
                                    .data[indexChild]
                                    .value
                                    .toString()
                                    .split(','),
                                onChange: (data) {
                                  addData[indexParent].data[indexChild].value =
                                      data;
                                },
                              )
                            : data.field_type == 'TEXT_MULTI_NEW'
                                ? InputMultipleWidget(
                                    data: data,
                                    onSelect: (data) {
                                      addData[indexParent]
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
                                          addData[indexParent]
                                              .data[indexChild]
                                              .value = date;
                                        },
                                        onInit: (v) {
                                          addData[indexParent]
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
                                              addData[indexParent]
                                                  .data[indexChild]
                                                  .value = date;
                                            },
                                            onInit: (v) {
                                              addData[indexParent]
                                                  .data[indexChild]
                                                  .value = v;
                                            },
                                          )
                                        : data.field_type == 'CHECK'
                                            ? RenderCheckBox(
                                                onChange: (check) {
                                                  addData[indexParent]
                                                      .data[indexChild]
                                                      .value = check ? 1 : 0;
                                                },
                                                data: data,
                                              )
                                            : data.field_type == 'PERCENTAGE'
                                                ? FieldInputPercent(
                                                    data: data,
                                                    onChanged: (text) {
                                                      addData[indexParent]
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
                                                              addData[indexParent]
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
                                                                builder:
                                                                    (context,
                                                                        stateA) {
                                                                if (stateA
                                                                    is SuccessTotalState) {
                                                                  addData[indexParent]
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
                                                                        reloadStream,
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      return FieldTextAPi(
                                                                        typeInput:
                                                                            TextInputType.number,
                                                                        addData:
                                                                            addData,
                                                                        data:
                                                                            data,
                                                                        onChange:
                                                                            (v) {
                                                                          addData[indexParent]
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
                                                                      addData[indexParent]
                                                                          .data[
                                                                              indexChild]
                                                                          .value = v;
                                                                    },
                                                                  )
                                                    : SizedBox.shrink()
        : SizedBox.shrink();
  }

  void onClickSave() async {
    final Map<String, dynamic> data = {};
    bool isCheckValidate = false;
    String? txtValidate;
    for (int i = 0; i < addData.length; i++) {
      for (int j = 0; j < addData[i].data.length; j++) {
        if ((addData[i].data[j].value == null ||
                addData[i].data[j].value == 'null' ||
                addData[i].data[j].value == '') &&
            addData[i].data[j].required == 1 &&
            !(isGetData && addData[i].data[j].label == 'khach_hang_sp')) {
          isCheckValidate = true;
          txtValidate = addData[i].data[j].txtValidate;
          break;
        } else if (addData[i].data[j].value != null &&
            addData[i].data[j].value != 'null') {
          if (addData[i].data[j].label == 'hdsan_pham_kh' &&
              addData[i].data[j].value == ADD_NEW_CAR) {
            if (_contactBy.dataCarNew != {})
              data['productscus'] = _contactBy.dataCarNew;
          } else {
            data['${addData[i].data[j].label}'] = addData[i].data[j].value;
          }
        } else {
          data['${addData[i].data[j].label}'] = '';
        }
      }
    }
    //CHECKIN
    if (isCheckIn) {
      if (_controllerTextNoteLocation.text != '') {
        data['longitude'] = position?.longitude.toString();
        data['latitude'] = position?.latitude.toString();
        data['note_location'] = _controllerTextNoteLocation.text;
        data['type'] = typeCheckIn;
      } else {
        isCheckValidate = true;
      }
    }

    if (_totalBloc.unpaidStream.value < 0 && type == ADD_CONTRACT) {
      isCheckValidate = true;
    }

    //
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
      if (listProduct.length > 0) {
        List product = [];
        for (int i = 0; i < listProduct.length; i++) {
          product.add({
            'id': listProduct[i].id,
            'price': listProduct[i].item.sell_price,
            'quantity': listProduct[i].soLuong,
            'vat': listProduct[i].item.vat,
            'unit': listProduct[i].item.dvt,
            'ten_combo': listProduct[i].item.ten_combo,
            'combo_id': listProduct[i].item.combo_id,
            'sale_off': {
              'value': listProduct[i].giamGia,
              'type': listProduct[i].typeGiamGia
            }
          });
        }
        data['products'] = product;
      }
      if (type == ADD_CUSTOMER_OR) {
        _blocAdd.add(AddCustomerOrEvent(data, files: _attackBloc.listFile));
      } else if (type == ADD_CUSTOMER) {
        _blocAdd.add(AddCustomerEvent(data, files: _attackBloc.listFile));
      } else if (type == ADD_CLUE_CUSTOMER) {
        data['customer_id'] = id;
        _blocAdd
            .add(AddContactCustomerEvent(data, files: _attackBloc.listFile));
      } else if (type == ADD_CHANCE_CUSTOMER) {
        data['customer_id'] = id;
        _blocAdd.add(AddOpportunityEvent(data, files: _attackBloc.listFile));
      } else if (type == ADD_CONTRACT_CUS) {
        data['customer_id'] = id;
        _blocAdd.add(AddContractEvent(data, files: _attackBloc.listFile));
      } else if (type == ADD_JOB_CUSTOMER) {
        data['customer_id'] = id;
        _blocAdd.add(AddJobEvent(data, files: _attackBloc.listFile));
      } else if (type == ADD_SUPPORT_CUSTOMER) {
        data['customer_id'] = id;
        data['nguoi_xu_lht'] = idUserLocal;
        _blocAdd.add(AddSupportEvent(data, files: _attackBloc.listFile));
      } else if (type == ADD_CLUE) {
        _blocAdd
            .add(AddContactCustomerEvent(data, files: _attackBloc.listFile));
      } else if (type == ADD_CHANCE) {
        _blocAdd.add(AddOpportunityEvent(data, files: _attackBloc.listFile));
      } else if (type == ADD_CONTRACT) {
        data['col311'] =
            data['col311'] != '' ? double.parse(data['col311']).toInt() : '';
        _blocAdd.add(AddContractEvent(data, files: _attackBloc.listFile));
      } else if (type == ADD_JOB) {
        _blocAdd.add(AddJobEvent(data, files: _attackBloc.listFile));
      } else if (type == ADD_SUPPORT) {
        data['nguoi_xu_lht'] = idUserLocal;
        _blocAdd.add(AddSupportEvent(data, files: _attackBloc.listFile));
      } else if (type == ADD_CLUE_JOB) {
        data['daumoi_id'] = id;
        _blocAdd.add(AddJobEvent(data, files: _attackBloc.listFile));
      } else if (type == ADD_CHANCE_JOB) {
        data['cohoi_id'] = id;
        _blocAdd.add(AddJobEvent(data, files: _attackBloc.listFile));
      } else if (type == ADD_SUPPORT_CONTRACT) {
        data['hopdong_id'] = id;
        data['nguoi_xu_lht'] = idUserLocal;
        _blocAdd.add(AddSupportEvent(data, files: _attackBloc.listFile));
      } else if (type == ADD_JOB_CONTRACT) {
        data['hopdong_id'] = id;
        _blocAdd.add(AddJobEvent(data, files: _attackBloc.listFile));
      } else if (type == PRODUCT_TYPE) {
        _blocAdd.add(AddProductEvent(data, files: _attackBloc.listFile));
      } else if (type == PRODUCT_CUSTOMER_TYPE) {
        ////

        if (isGetData) {
          //validate biển số xe
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
          ////
        } else {
          _blocAdd
              .add(AddProductCustomerEvent(data, files: _attackBloc.listFile));
        }
        ////
      } else if (type == CV_PRODUCT_CUSTOMER_TYPE) {
        data['customer_id'] = id;
        _blocAdd.add(AddJobEvent(data, files: _attackBloc.listFile));
      } else if (type == HT_PRODUCT_CUSTOMER_TYPE) {
        data['customer_id'] = id;
        data['nguoi_xu_lht'] = idUserLocal;
        _blocAdd.add(AddSupportEvent(data, files: _attackBloc.listFile));
      } else if (type == HD_PRODUCT_CUSTOMER_TYPE) {
        data['customer_id'] = id;
        _blocAdd.add(AddContractEvent(data, files: _attackBloc.listFile));
      } else if (type == CH_PRODUCT_CUSTOMER_TYPE) {
        data['customer_id'] = id;
        _blocAdd.add(AddOpportunityEvent(data, files: _attackBloc.listFile));
      } else if (type == ADD_QUICK_CONTRACT) {
        _blocAdd.add(QuickContractSaveEvent(data, _attackBloc.listFile));
      } else {
        data['id'] = id; // save edit
        if (type == EDIT_CUSTOMER) {
          _blocAdd.add(EditCustomerEvent(data, files: _attackBloc.listFile));
        } else if (type == EDIT_CLUE) {
          _blocAdd.add(AddContactCustomerEvent(
            data,
            files: _attackBloc.listFile,
            isEdit: true,
          ));
        } else if (type == EDIT_CHANCE) {
          _blocAdd.add(AddOpportunityEvent(
            data,
            files: _attackBloc.listFile,
            isEdit: true,
          ));
        } else if (type == EDIT_CONTRACT) {
          _blocAdd.add(AddContractEvent(
            data,
            files: _attackBloc.listFile,
            isEdit: true,
          ));
        } else if (type == EDIT_JOB) {
          _blocAdd.add(EditJobEvent(data, files: _attackBloc.listFile));
        } else if (type == EDIT_SUPPORT) {
          _blocAdd.add(AddSupportEvent(
            data,
            files: _attackBloc.listFile,
            isEdit: true,
          ));
        } else if (type == PRODUCT_TYPE) {
          _blocAdd.add(EditProductEvent(data, int.parse(id),
              files: _attackBloc.listFile));
        } else if (type == PRODUCT_CUSTOMER_TYPE) {
          _blocAdd
              .add(EditProductCustomerEvent(data, files: _attackBloc.listFile));
        }
      }
    }
  }
}
