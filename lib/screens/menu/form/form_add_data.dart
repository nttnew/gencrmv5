import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/contract/phone_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/add_data_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/form_add_data_bloc.dart';
import 'package:gen_crm/bloc/product_customer_module/product_customer_module_bloc.dart';
import 'package:gen_crm/bloc/product_module/product_module_bloc.dart';
import 'package:gen_crm/models/model_item_add.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/input_dropDown.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/widgets/appbar_base.dart';
import 'package:gen_crm/widgets/field_input_select_multi.dart';
import 'package:gen_crm/widgets/widget_field_input_percent.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../../src/models/model_generator/add_customer.dart';
import '../../../bloc/add_service_voucher/add_service_bloc.dart';
import '../../../bloc/clue/clue_bloc.dart';
import '../../../bloc/contact_by_customer/contact_by_customer_bloc.dart';
import '../../../bloc/contract/attack_bloc.dart';
import '../../../bloc/contract/contract_bloc.dart';
import '../../../bloc/contract/total_bloc.dart';
import '../../../bloc/detail_product_customer/detail_product_customer_bloc.dart';
import '../../../bloc/support/support_bloc.dart';
import '../../../bloc/work/work_bloc.dart';
import '../../../l10n/key_text.dart';
import '../../../models/model_data_add.dart';
import '../../../models/product_model.dart';
import '../../../widgets/widget_input_date.dart';
import '../../../src/models/model_generator/login_response.dart';
import '../../../widgets/pick_file_image.dart';
import '../../../src/src_index.dart';
import '../../../storages/share_local.dart';
import '../../../widgets/location_base.dart';
import 'package:geolocator/geolocator.dart' show Position;
import '../../../widgets/multiple_widget.dart';
import '../../add_service_voucher/add_service_voucher_step2_screen.dart';
import 'product_list/product_contract.dart';

class FormAddData extends StatefulWidget {
  const FormAddData({Key? key}) : super(key: key);

  @override
  State<FormAddData> createState() => _FormAddDataState();
}

class _FormAddDataState extends State<FormAddData> {
  String title = Get.arguments[0];
  int type = Get.arguments[1];
  String id = Get.arguments[2] != null ? Get.arguments[2].toString() : "";
  bool isCheckIn = Get.arguments[3];
  String typeCheckIn = Get.arguments[4];
  bool isResultData = Get.arguments[5];
  bool isGetData = Get.arguments[6];
  List data = [];
  double total = 0;
  List<ProductModel> listProduct = [];
  List<ModelItemAdd> addData = [];
  late String id_user;
  File? fileUpload;
  Position? position;
  late final ScrollController scrollController;
  late final BehaviorSubject<bool> isMaxScroll;
  late final BehaviorSubject<String> nameLocation;
  late final TextEditingController controllerNote;
  late final FormAddBloc _bloc;
  late final List<List<dynamic>> listCustomerForChance;

  @override
  void initState() {
    _bloc = FormAddBloc(userRepository: FormAddBloc.of(context).userRepository);
    String nameCustomerScreen =
        shareLocal.getString(PreferencesKey.NAME_CUSTOMER);
    listCustomerForChance = [
      [
        CA_NHAN,
        '${getT(KeyT.begin)}'
            ' ${nameCustomerScreen.toString().toLowerCase()} '
            '${getT(KeyT.individual)}'
      ],
      [
        TO_CHUC,
        '${getT(KeyT.begin)}'
            ' ${nameCustomerScreen.toString().toLowerCase()} '
            '${getT(KeyT.organization)}'
      ]
    ];
    controllerNote = TextEditingController();
    scrollController = ScrollController();
    nameLocation = BehaviorSubject.seeded('');
    nameLocation.listen((value) {
      if (value != '' && value != LOADING && controllerNote.text != value) {
        controllerNote.text = value;
      }
    });
    isMaxScroll = BehaviorSubject.seeded(false);
    loadUser();
    AttackBloc.of(context).add(LoadingAttackEvent());
    if (type == ADD_CUSTOMER) {
      _bloc.add(InitFormAddCusOrEvent());
    } else if (type == ADD_CLUE_CUSTOMER) {
      _bloc.add(InitFormAddContactCusEvent(id));
    } else if (type == ADD_CHANCE_CUSTOMER) {
      _bloc.add(InitFormAddOppCusEvent(id));
    } else if (type == 13) {
      _bloc.add(InitFormAddContractCusEvent(id));
    } else if (type == ADD_JOB_CUSTOMER) {
      _bloc.add(InitFormAddJobCusEvent(id));
    } else if (type == ADD_SUPPORT_CUSTOMER) {
      _bloc.add(InitFormAddSupportCusEvent(id));
    } else if (type == ADD_CLUE) {
      _bloc.add(InitFormAddAgencyEvent());
    } else if (type == ADD_CHANCE) {
      _bloc.add(InitFormAddChanceEvent());
    } else if (type == 4) {
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
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(Duration(seconds: 1));
      if (scrollController.position.maxScrollExtent > 7) {
        scrollHandle();
      } else {
        isMaxScroll.add(true);
      }
    });
    super.initState();
  }

  void scrollHandle() {
    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        if (!isMaxScroll.value) {
          isMaxScroll.add(true);
        }
      } else {
        if (isMaxScroll.value) {
          isMaxScroll.add(false);
        }
      }
    });
  }

  void loadUser() async {
    final response = await shareLocal.getString(PreferencesKey.USER);
    if (response != null) {
      id_user = LoginData.fromJson(jsonDecode(response)).info_user!.user_id!;
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    isMaxScroll.close();
    nameLocation.close();
    super.dispose();
  }

  @override
  void deactivate() {
    AttackBloc.of(context).add(RemoveAllAttackEvent());
    ServiceVoucherBloc.of(context).loaiXe.add('');
    ServiceVoucherBloc.of(context).resetDataCarVerison();
    super.deactivate();
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

  location() {
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
                            style: AppStyle.DEFAULT_18_BOLD),
                        WidgetText(
                            title: '*',
                            style: AppStyle.DEFAULT_18_BOLD
                                .copyWith(color: COLORS.RED)),
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
                                    style: TextStyle(
                                        fontFamily: "Quicksand",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: COLORS.BLACK)))
                            : SizedBox(
                                height: 12,
                                width: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.4,
                                )),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            color: COLORS.TEXT_COLOR,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            border: Border.all(
                              color: COLORS.TEXT_COLOR,
                            )),
                        child: WidgetText(
                            title: getT(KeyT.check_in),
                            style: TextStyle(
                                fontFamily: "Quicksand",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: COLORS.WHITE)),
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
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                border: Border.all(
                                  color: COLORS.TEXT_COLOR,
                                )),
                            child: WidgetText(
                                title: getT(KeyT.check_in_again),
                                style: TextStyle(
                                  fontFamily: "Quicksand",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: COLORS.TEXT_COLOR,
                                )),
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
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                border: Border.all(
                                  color: COLORS.RED,
                                )),
                            child: WidgetText(
                                title: getT(KeyT.delete),
                                style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: COLORS.RED)),
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
                                    fontFamily: "Quicksand",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: COLORS.RED))
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
                          border: Border.all(color: HexColor("#BEB4B4"))),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                        child: Container(
                          child: TextFormField(
                            controller: controllerNote,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                isDense: true),
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
    TotalBloc.of(context).getPaid();
    TotalBloc.of(context).add(InitTotalEvent(total));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar: AppbarBaseNormal(title.toUpperCase().capitalizeFirst ?? ''),
            body: BlocListener<AddDataBloc, AddDataState>(
              listener: (context, state) async {
                if (state is SuccessAddCustomerOrState) {
                  ShowDialogCustom.showDialogBase(
                    title: getT(KeyT.notification),
                    content: getT(KeyT.new_data_added_successfully),
                    onTap1: () {
                      Get.back();
                      Get.back();
                      if (isResultData)
                        Get.back(
                          result: state.result,
                        );
                      GetListCustomerBloc.of(context)
                          .loadMoreController
                          .reloadData();
                    },
                  );
                } else if (state is ErrorAddCustomerOrState) {
                  ShowDialogCustom.showDialogBase(
                      title: getT(KeyT.notification),
                      content: state.msg,
                      onTap1: () {
                        Get.back();
                        Get.back();
                      });
                } else if (state is SuccessAddContactCustomerState) {
                  ShowDialogCustom.showDialogBase(
                    title: getT(KeyT.notification),
                    content: getT(KeyT.new_data_added_successfully),
                    onTap1: () {
                      Get.back();
                      Get.back();
                      if (type == ADD_CLUE) {
                        GetListClueBloc.of(context)
                            .loadMoreController
                            .reloadData();
                      } else if (type == ADD_CHANCE) {
                        GetListChanceBloc.of(context)
                            .loadMoreController
                            .reloadData();
                      } else if (type == 4) {
                        ContractBloc.of(context).add(InitGetContractEvent());
                      } else if (type == ADD_JOB) {
                        WorkBloc.of(context).loadMoreController.reloadData();
                      } else if (type == ADD_SUPPORT) {
                        SupportBloc.of(context).add(InitGetSupportEvent());
                      } else if (type == PRODUCT_TYPE) {
                        ProductModuleBloc.of(context)
                            .loadMoreController
                            .reloadData();
                      } else if (type == PRODUCT_CUSTOMER_TYPE) {
                        ProductCustomerModuleBloc.of(context)
                            .loadMoreController
                            .reloadData();
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
                      }
                    },
                  );
                } else if (state is ErrorAddContactCustomerState) {
                  ShowDialogCustom.showDialogBase(
                    title: getT(KeyT.notification),
                    content: state.msg,
                  );
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(25),
                color: COLORS.WHITE,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      location(),
                      BlocBuilder<FormAddBloc, FormAddState>(
                          bloc: _bloc,
                          builder: (context, state) {
                            if (state is LoadingFormAddCustomerOrState) {
                              addData = [];
                              data = [];
                              return SizedBox.shrink();
                            } else if (state is SuccessFormAddCustomerOrState) {
                              if (addData.isEmpty) {
                                for (int i = 0;
                                    i < state.listAddData.length;
                                    i++) {
                                  addData.add(ModelItemAdd(
                                      group_name:
                                          state.listAddData[i].group_name ?? '',
                                      data: []));
                                  for (int j = 0;
                                      j < state.listAddData[i].data!.length;
                                      j++) {
                                    addData[i].data.add(ModelDataAdd(
                                        label: state
                                            .listAddData[i].data![j].field_name,
                                        value: state.listAddData[i].data![j]
                                            .field_set_value
                                            .toString(),
                                        required: state.listAddData[i].data![j]
                                            .field_require));
                                  }
                                }
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                        state.listAddData.length,
                                        (indexParent) => (state
                                                        .listAddData[
                                                            indexParent]
                                                        .data !=
                                                    null &&
                                                state.listAddData[indexParent]
                                                        .data!.length >
                                                    0)
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        AppValue.heights * 0.01,
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
                                                              .DEFAULT_18_BOLD)
                                                      : SizedBox.shrink(),
                                                  SizedBox(
                                                    height:
                                                        AppValue.heights * 0.01,
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
                                                          indexChild);
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
                                  )
                                ],
                              );
                            } else
                              return SizedBox.shrink();
                          }),
                    ],
                  ),
                ),
              ),
            )),
        Positioned(
          left: 0,
          bottom: 0,
          child: StreamBuilder<bool>(
              stream: isMaxScroll,
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.data ?? false,
                  child: Container(
                    color: COLORS.WHITE,
                    height: AppValue.widths * 0.1 + 10,
                    width: AppValue.widths,
                    padding: EdgeInsets.only(
                        left: AppValue.widths * 0.05,
                        right: AppValue.widths * 0.05,
                        bottom: 5),
                    child: FileLuuBase(context, () => onClickSave(),
                        isAttack: !isGetData),
                  ),
                );
              }),
        )
      ],
    );
  }

  Widget _fieldInputCustomer(
      CustomerIndividualItemData data, int indexParent, int indexChild,
      {bool noEdit = false, String value = ""}) {
    if ((type == ADD_CLUE_JOB && data.field_name == "so_dien_thoai") ||
        (type == ADD_CHANCE_JOB && data.field_name == "so_dien_thoai")) {
      return SizedBox.shrink();
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                text: data.field_label ?? '',
                style: AppStyle.DEFAULT_14W600,
                children: <TextSpan>[
                  data.field_require == 1
                      ? TextSpan(
                          text: '*',
                          style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: COLORS.RED))
                      : TextSpan(),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: noEdit == true ? COLORS.LIGHT_GREY : COLORS.WHITE,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: HexColor("#BEB4B4"))),
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                child: Container(
                  child: TextFormField(
                    minLines: data.field_type == 'TEXTAREA' ? 2 : 1,
                    maxLines: data.field_type == 'TEXTAREA' ? 6 : 1,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    keyboardType: data.field_type == "TEXT_NUMERIC"
                        ? TextInputType.number
                        : data.field_special == "default"
                            ? TextInputType.text
                            : (data.field_special == "numberic")
                                ? TextInputType.number
                                : data.field_special == "email-address"
                                    ? TextInputType.emailAddress
                                    : TextInputType.text,
                    onChanged: (text) {
                      addData[indexParent].data[indexChild].value = text;
                    },
                    readOnly: noEdit,
                    initialValue: value != ""
                        ? value
                        : noEdit == true
                            ? data.field_value
                            : data.field_set_value != null
                                ? data.field_set_value.toString()
                                : null,
                    decoration: InputDecoration(
                        hintStyle: AppStyle.DEFAULT_14W500,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        isDense: true),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _getBody(
      CustomerIndividualItemData data, int indexParent, int indexChild) {
    return data.field_hidden != "1"
        ? data.field_special == "none-edit"
            ? ((data.field_name == "so_dien_thoai")
                ? BlocBuilder<PhoneBloc, PhoneState>(
                    builder: (context, stateA) {
                    if (stateA is SuccessPhoneState) {
                      return _fieldInputCustomer(data, indexParent, indexChild,
                          noEdit: true, value: stateA.phone);
                    } else
                      return SizedBox.shrink();
                  })
                : ServiceVoucherBloc.of(context).getInput(data.field_name ?? '')
                    ? StreamBuilder<String>(
                        stream: ServiceVoucherBloc.of(context)
                            .loaiXe, // getdata selectcar local
                        builder: (context, snapshot) {
                          return fieldCar(
                              data, indexParent, indexChild, context,
                              value: ServiceVoucherBloc.of(context)
                                  .getDataSelectCar(data.field_name ?? ''));
                        })
                    : _fieldInputCustomer(data, indexParent, indexChild,
                        noEdit: true))
            : data.field_type == "SELECT"
                ? (data.field_name == 'khach_hang_sp' &&
                        isGetData) //getdata cho spkh
                    ? SizedBox()
                    : ((data.field_name == 'cv_nguoiLienHe' ||
                            data.field_name == 'col131')
                        ? BlocBuilder<ContactByCustomerBloc,
                            ContactByCustomerState>(builder: (context, stateA) {
                            if (stateA is UpdateGetContacBytCustomerState) {
                              return InputDropdown(
                                  typeScreen: type,
                                  dropdownItemList:
                                      stateA.listContactByCustomer,
                                  data: data,
                                  onSuccess: (data) {
                                    addData[indexParent]
                                        .data[indexChild]
                                        .value = data;
                                    if (data.field_name != "cv_kh")
                                      PhoneBloc.of(context)
                                          .add(InitAgencyPhoneEvent(data));
                                  },
                                  value: data.field_value ?? '');
                            } else if (stateA
                                is LoadingContactByCustomerState) {
                              return SizedBox.shrink();
                            } else {
                              return InputDropdown(
                                  typeScreen: type,
                                  dropdownItemList: data.field_datasource ?? [],
                                  data: data,
                                  onSuccess: (data) {
                                    addData[indexParent]
                                        .data[indexChild]
                                        .value = data;
                                    if (data.field_name != "cv_kh")
                                      PhoneBloc.of(context)
                                          .add(InitAgencyPhoneEvent(data));
                                  },
                                  value: data.field_value ?? '');
                            }
                          })
                        : (data.field_name == 'col121' && type == ADD_CHANCE)
                            ? StreamBuilder<List<dynamic>>(
                                stream: _bloc.customerNewStream,
                                builder: (context, snapshot) {
                                  final list = snapshot.data ?? [];
                                  return InputDropdown(
                                    isAddList: true,
                                    dropdownItemList: listCustomerForChance,
                                    data: data,
                                    onSuccess: (data) async {
                                      List<dynamic>? result = [];
                                      if (data == CA_NHAN) {
                                        result = await AppNavigator
                                            .navigateAddCustomer(
                                                listCustomerForChance.first[1],
                                                isResultData: true);
                                      } else if (data == TO_CHUC) {
                                        result = await AppNavigator
                                            .navigateFormAddCustomerGroup(
                                          listCustomerForChance.last[1],
                                          ADD_CUSTOMER,
                                          isResultData: true,
                                        );
                                      }
                                      if (result != null && result.isNotEmpty) {
                                        data = result.first;
                                        _bloc.customerNewStream.add(result);
                                      } else if (result == null) {
                                        data = '';
                                        _bloc.customerNewStream
                                            .add(['null', 'null']);
                                      }
                                      addData[indexParent]
                                          .data[indexChild]
                                          .value = data;
                                      ContactByCustomerBloc.of(context).add(
                                          InitGetContactByCustomerrEvent(data));
                                      PhoneBloc.of(context)
                                          .add(InitPhoneEvent(data));
                                    },
                                    value: list.isNotEmpty
                                        ? list.last
                                        : data.field_value ?? '',
                                  );
                                })
                            : InputDropdown(
                                dropdownItemList: data.field_datasource ?? [],
                                data: data,
                                onSuccess: (data) {
                                  addData[indexParent].data[indexChild].value =
                                      data;
                                  if (data.field_name == "cv_kh" ||
                                      data.field_name == "col121") {
                                    ContactByCustomerBloc.of(context).add(
                                        InitGetContactByCustomerrEvent(data));
                                    PhoneBloc.of(context)
                                        .add(InitPhoneEvent(data));
                                  }
                                },
                                value: data.field_value ?? ''))
                : data.field_type == "TEXT_MULTI"
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
                          addData[indexParent].data[indexChild].value = data;
                        },
                      )
                    : data.field_type == "HIDDEN"
                        ? SizedBox.shrink()
                        : data.field_special == 'url'
                            ? ProductContract(
                                listBtn: data.button,
                                data: listProduct,
                                addProduct: addProduct,
                                reload: reload,
                                neverHidden: true,
                                canDelete: true,
                              )
                            : data.field_type == "TEXT_MULTI_NEW"
                                ? InputMultipleWidget(
                                    data: data,
                                    onSelect: (data) {
                                      addData[indexParent]
                                          .data[indexChild]
                                          .value = data.join(",");
                                    },
                                  )
                                : data.field_type == "DATE"
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
                                    : data.field_type == "DATETIME"
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
                                        : data.field_type == "CHECK"
                                            ? RenderCheckBox(
                                                onChange: (check) {
                                                  addData[indexParent]
                                                      .data[indexChild]
                                                      .value = check ? 1 : 0;
                                                },
                                                data: data,
                                              )
                                            : data.field_type == "PERCENTAGE"
                                                ? FieldInputPercent(
                                                    data: data,
                                                    onChanged: (text) {
                                                      addData[indexParent]
                                                          .data[indexChild]
                                                          .value = text;
                                                    },
                                                  )
                                                : data.field_name ==
                                                            'chi_tiet_xe' &&
                                                        data.field_type ==
                                                            'TEXT'
                                                    ? TypeCarBase(
                                                        data,
                                                        indexParent,
                                                        indexChild,
                                                        context,
                                                        ServiceVoucherBloc.of(
                                                            context),
                                                        (v) {
                                                          addData[indexParent]
                                                              .data[indexChild]
                                                              .value = v;
                                                        },
                                                      )
                                                    : _fieldInputCustomer(data,
                                                        indexParent, indexChild)
        : SizedBox();
  }

  void onClickSave() async {
    final Map<String, dynamic> data = {};
    bool check = false;
    for (int i = 0; i < addData.length; i++) {
      for (int j = 0; j < addData[i].data.length; j++) {
        if ((addData[i].data[j].value == null ||
                addData[i].data[j].value == "null" ||
                addData[i].data[j].value == "") &&
            addData[i].data[j].required == 1 &&
            !(isGetData && addData[i].data[j].label == 'khach_hang_sp')) {
          check = true;
          break;
        } else if (addData[i].data[j].value != null &&
            addData[i].data[j].value != "null")
          data["${addData[i].data[j].label}"] = addData[i].data[j].value;
        else {
          data["${addData[i].data[j].label}"] = "";
        }
      }
    }
    //CHECKIN
    if (isCheckIn) {
      if (controllerNote.text != '') {
        data['longitude'] = position?.longitude.toString();
        data['latitude'] = position?.latitude.toString();
        data['note_location'] = controllerNote.text;
        data['type'] = typeCheckIn;
      } else {
        check = true;
      }
    }
    //
    if (check == true) {
      ShowDialogCustom.showDialogBase(
        title: getT(KeyT.notification),
        content: getT(KeyT.please_enter_all_required_fields),
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
      if (type == ADD_CUSTOMER) {
        AddDataBloc.of(context).add(
            AddCustomerOrEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == ADD_CLUE_CUSTOMER) {
        data["customer_id"] = id;
        AddDataBloc.of(context).add(AddContactCustomerEvent(data,
            files: AttackBloc.of(context).listFile));
      } else if (type == ADD_CHANCE_CUSTOMER) {
        data["customer_id"] = id;
        AddDataBloc.of(context).add(
            AddOpportunityEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == 13) {
        data["customer_id"] = id;
        AddDataBloc.of(context).add(
            AddContractEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == ADD_JOB_CUSTOMER) {
        data["customer_id"] = id;
        AddDataBloc.of(context)
            .add(AddJobEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == ADD_SUPPORT_CUSTOMER) {
        data["customer_id"] = id;
        data["nguoi_xu_lht"] = id_user;
        AddDataBloc.of(context)
            .add(AddSupportEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == ADD_CLUE) {
        AddDataBloc.of(context).add(AddContactCustomerEvent(data,
            files: AttackBloc.of(context).listFile));
      } else if (type == ADD_CHANCE) {
        AddDataBloc.of(context).add(
            AddOpportunityEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == 4) {
        data["customer_id"] = id;
        AddDataBloc.of(context).add(
            AddContractEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == ADD_JOB) {
        AddDataBloc.of(context)
            .add(AddJobEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == ADD_SUPPORT) {
        data["nguoi_xu_lht"] = id_user;
        AddDataBloc.of(context)
            .add(AddSupportEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == ADD_CLUE_JOB) {
        data["daumoi_id"] = id;
        AddDataBloc.of(context)
            .add(AddJobEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == ADD_CHANCE_JOB) {
        data["cohoi_id"] = id;
        AddDataBloc.of(context)
            .add(AddJobEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == ADD_SUPPORT_CONTRACT) {
        data["hopdong_id"] = id;
        data["nguoi_xu_lht"] = id_user;
        AddDataBloc.of(context)
            .add(AddSupportEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == ADD_JOB_CONTRACT) {
        data["hopdong_id"] = id;
        AddDataBloc.of(context)
            .add(AddJobEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == PRODUCT_TYPE) {
        AddDataBloc.of(context)
            .add(AddProductEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == PRODUCT_CUSTOMER_TYPE) {
        ////

        if (isGetData) {
          //validate biển số xe
          bool check =
              await ServiceVoucherBloc.of(context).checkHasCar(data['bien_so']);
          if (check) {
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: '${data['bien_so']} ${getT(KeyT.already_exist)}',
            );
          } else {
            Navigator.of(context).pop([
              data,
              AttackBloc.of(context).listFile,
            ]);
          }
          ////
        } else {
          AddDataBloc.of(context).add(AddProductCustomerEvent(data,
              files: AttackBloc.of(context).listFile));
        }
        ////
      } else if (type == CV_PRODUCT_CUSTOMER_TYPE) {
        data["customer_id"] = id;
        AddDataBloc.of(context)
            .add(AddJobEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == HT_PRODUCT_CUSTOMER_TYPE) {
        data["customer_id"] = id;
        data["nguoi_xu_lht"] = id_user;
        AddDataBloc.of(context)
            .add(AddSupportEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == HD_PRODUCT_CUSTOMER_TYPE) {
        data["customer_id"] = id;
        AddDataBloc.of(context).add(
            AddContractEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == CH_PRODUCT_CUSTOMER_TYPE) {
        data["customer_id"] = id;
        AddDataBloc.of(context).add(
            AddOpportunityEvent(data, files: AttackBloc.of(context).listFile));
      }
    }
  }
}

class RenderCheckBox extends StatefulWidget {
  RenderCheckBox({Key? key, required this.onChange, required this.data})
      : super(key: key);

  final Function? onChange;
  final CustomerIndividualItemData data;

  @override
  State<RenderCheckBox> createState() => _RenderCheckBoxState();
}

class _RenderCheckBoxState extends State<RenderCheckBox> {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            child: Checkbox(
              value: isCheck,
              onChanged: (bool? value) {
                widget.onChange!(value);
                setState(() {
                  isCheck = value!;
                });
              },
            ),
          ),
          RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              text: widget.data.field_label ?? '',
              style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: COLORS.BLACK),
              children: <TextSpan>[
                widget.data.field_require == 1
                    ? TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: COLORS.RED))
                    : TextSpan(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
