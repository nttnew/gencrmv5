import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/contact_by_customer/contact_by_customer_bloc.dart';
import 'package:gen_crm/bloc/contract/phone_bloc.dart';
import 'package:gen_crm/bloc/contract/total_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/add_data_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/form_add_data_bloc.dart';
import 'package:gen_crm/models/model_data_add.dart';
import 'package:gen_crm/models/model_item_add.dart';
import 'package:gen_crm/screens/menu/form/product_list/product_contract.dart';
import 'package:gen_crm/screens/menu/home/contract/widget/widget_total_sum.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../../src/models/model_generator/add_customer.dart';
import '../../../bloc/contract/attack_bloc.dart';
import '../../../bloc/contract/contract_bloc.dart';
import '../../../models/product_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../widgets/widget_input_date.dart';
import '../../../src/app_const.dart';
import '../../../src/models/model_generator/login_response.dart';
import '../../../widgets/pick_file_image.dart';
import '../../../src/src_index.dart';
import '../../../storages/share_local.dart';
import '../../../widgets/appbar_base.dart';
import '../../../widgets/field_input_select_multi.dart';
import '../../../widgets/multiple_widget.dart';
import '../../../widgets/widget_field_input_percent.dart';
import '../home/customer/widget/input_dropDown.dart';

class FormAddContract extends StatefulWidget {
  const FormAddContract({Key? key}) : super(key: key);

  @override
  State<FormAddContract> createState() => _FormAddContractState();
}

class _FormAddContractState extends State<FormAddContract> {
  List data = [];
  List<ModelItemAdd> addData = [];
  late String id_user;
  List<ProductModel> listProduct = [];
  List<List<dynamic>> dauMoi = [];
  double total = 0;
  late final FormAddBloc _bloc;
  late final List<List<dynamic>> listCustomerForChance;
  String? id_first = Get.arguments[0];
  String? id_two = Get.arguments[1];
  String title = Get.arguments[2] ?? '';
  ProductModel? product = Get.arguments[3];

  @override
  void initState() {
    loadUser();
    _bloc = FormAddBloc(userRepository: FormAddBloc.of(context).userRepository);
    String nameCustomerScreen =
        shareLocal.getString(PreferencesKey.NAME_CUSTOMER);
    listCustomerForChance = [
      [
        CA_NHAN,
        '${AppLocalizations.of(Get.context!)?.begin}'
            ' ${nameCustomerScreen.toString().toLowerCase()} '
            '${AppLocalizations.of(Get.context!)?.individual}'
      ],
      [
        TO_CHUC,
        '${AppLocalizations.of(Get.context!)?.begin}'
            ' ${nameCustomerScreen.toString().toLowerCase()} '
            '${AppLocalizations.of(Get.context!)?.organization}'
      ]
    ];
    if (product != null) {
      addProduct(product!);
    }
    AttackBloc.of(context).add(LoadingAttackEvent());
    if (id_first != null)
      _bloc.add(InitFormAddContractEvent(id: id_first));
    else if (id_two != null) {
      _bloc.add(InitFormAddContractCusEvent(id_two));
    } else {
      _bloc.add(InitFormAddContractEvent());
    }
    super.initState();
  }

  loadUser() async {
    final response = await shareLocal.getString(PreferencesKey.USER);
    if (response != null) {
      id_user = LoginData.fromJson(jsonDecode(response)).info_user!.user_id!;
    }
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
  void deactivate() {
    TotalBloc.of(context).add(ReloadTotalEvent());
    AttackBloc.of(context).add(RemoveAllAttackEvent());
    ContactByCustomerBloc.of(context).chiTietXe.add('');
    ContactByCustomerBloc.of(context).listXe.add([]);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarBaseNormal(
          title,
        ),
        body: BlocListener<AddDataBloc, AddDataState>(
          listener: (context, state) async {
            if (state is SuccessAddCustomerOrState) {
              ShowDialogCustom.showDialogBase(
                title: AppLocalizations.of(Get.context!)?.notification,
                content: AppLocalizations.of(Get.context!)
                    ?.new_data_added_successfully,
                onTap1: () {
                  Get.back();
                  Get.back();
                  GetListCustomerBloc.of(context).add(InitGetListOrderEvent());
                },
              );
            }
            if (state is ErrorAddCustomerOrState) {
              ShowDialogCustom.showDialogBase(
                title: AppLocalizations.of(Get.context!)?.notification,
                content: state.msg,
              );
            }
            if (state is SuccessAddContactCustomerState) {
              ShowDialogCustom.showDialogBase(
                title: AppLocalizations.of(Get.context!)?.notification,
                content: AppLocalizations.of(Get.context!)
                    ?.new_data_added_successfully,
                onTap1: () {
                  Get.back();
                  Get.back();
                  ContractBloc.of(context).add(InitGetContractEvent());
                  if (product != null)
                    AppNavigator.navigateContract(
                        ModuleMy.getNameModuleMy(ModuleMy.HOP_DONG));
                },
              );
            }
            if (state is ErrorAddContactCustomerState) {
              ShowDialogCustom.showDialogBase(
                title: AppLocalizations.of(Get.context!)?.notification,
                content: state.msg,
              );
            }
          },
          child: Container(
            padding: EdgeInsets.all(25),
            color: COLORS.WHITE,
            child: SingleChildScrollView(
              child: BlocBuilder<FormAddBloc, FormAddState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    if (state is LoadingFormAddCustomerOrState) {
                      addData = [];
                      data = [];
                      return Container();
                    } else if (state is SuccessFormAddCustomerOrState) {
                      if (addData.isEmpty) {
                        for (int i = 0; i < state.listAddData.length; i++) {
                          addData.add(ModelItemAdd(
                              group_name: state.listAddData[i].group_name ?? '',
                              data: []));
                          for (int j = 0;
                              j < state.listAddData[i].data!.length;
                              j++) {
                            addData[i].data.add(ModelDataAdd(
                                  label:
                                      state.listAddData[i].data![j].field_name,
                                  value: state
                                      .listAddData[i].data![j].field_set_value
                                      .toString(),
                                  required: state
                                      .listAddData[i].data![j].field_require,
                                ));
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
                                (indexParent) => (state.listAddData[indexParent]
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
                                                  style:
                                                      AppStyle.DEFAULT_18_BOLD)
                                              : Container(),
                                          SizedBox(
                                            height: AppValue.heights * 0.01,
                                          ),
                                          Column(
                                            children: List.generate(
                                              state.listAddData[indexParent]
                                                      .data?.length ??
                                                  0,
                                              (indexChild) => _getBody(
                                                state.listAddData[indexParent]
                                                    .data![indexChild],
                                                indexParent,
                                                indexChild,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Container()),
                          ),
                          FileDinhKemUiBase(
                            context: context,
                            onTap: () => onClickSave(),
                          ),
                        ],
                      );
                    } else
                      return Container();
                  }),
            ),
          ),
        ));
  }

  Widget _getBody(
    CustomerIndividualItemData data,
    int indexParent,
    int indexChild,
  ) {
    return (data.field_special == 'none-edit' && data.field_name != 'col131')
        ? data.field_name == 'so_dien_thoai'
            ? BlocBuilder<PhoneBloc, PhoneState>(builder: (context, stateA) {
                if (stateA is SuccessPhoneState) {
                  addData[indexParent].data[indexChild].value = stateA.phone;
                  return _fieldInputCustomer(data, indexParent, indexChild,
                      noEdit: true, value: stateA.phone);
                } else
                  return Container();
              })
            : data.field_name == 'chi_tiet_xe'
                ? StreamBuilder<String>(
                    stream: ContactByCustomerBloc.of(context).chiTietXe,
                    builder: (context, snapshot) {
                      final chiTietXe = snapshot.data ?? '';
                      return _fieldChiTietXe(
                        data,
                        indexParent,
                        indexChild,
                        value: chiTietXe,
                      );
                    })
                : data.field_name == 'col1411'
                    ? //address
                    StreamBuilder<String>(
                        stream: _bloc.addressStream,
                        builder: (context, snapshot) {
                          final address = snapshot.data ?? '';
                          return _fieldChiTietXe(
                            data,
                            indexParent,
                            indexChild,
                            value: address,
                          );
                        })
                    : data.field_name == 'chuathanhtoan'
                        ? StreamBuilder<double>(
                            stream: TotalBloc.of(context).unpaidStream,
                            builder: (context, snapshot) {
                              final value = snapshot.data;
                              addData[indexParent].data[indexChild].value =
                                  value;
                              return WidgetTotalSum(
                                  label: data.field_label,
                                  value: AppValue.format_money(
                                      (value ?? 0).toStringAsFixed(0)));
                            })
                        : _fieldInputCustomer(data, indexParent, indexChild,
                            noEdit: true)
        : data.field_special == 'none-edit'
            ? _fieldInputCustomer(data, indexParent, indexChild, noEdit: true)
            : data.field_special == 'url'
                ? ProductContract(
                    listBtn: data.button,
                    data: listProduct,
                    addProduct: addProduct,
                    reload: reload,
                    neverHidden: true,
                    canDelete: true,
                  )
                : data.field_type == 'SELECT'
                    ? data.field_name == 'col131'
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
                                    result =
                                        await AppNavigator.navigateAddCustomer(
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
                                  addData[indexParent].data[indexChild].value =
                                      data;
                                  _bloc.getAddressCustomer(data);
                                  ContactByCustomerBloc.of(context)
                                      .chiTietXe
                                      .add('');
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
                        : data.field_name == 'col131'
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
                                      _bloc.getAddressCustomer(data);
                                      ContactByCustomerBloc.of(context)
                                          .chiTietXe
                                          .add('');
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
                            : (data.field_name == 'hinh_thuc_thanh_toan'
                                ? StreamBuilder<double>(
                                    stream: TotalBloc.of(context).paidStream,
                                    builder: (context, snapshot) {
                                      if ((snapshot.data ?? 0) == 0) {
                                        return SizedBox();
                                      } else {
                                        return InputDropdown(
                                            dropdownItemList:
                                                data.field_datasource ?? [],
                                            data: data,
                                            onSuccess: (data) {
                                              addData[indexParent]
                                                  .data[indexChild]
                                                  .value = data;
                                            },
                                            value: data.field_value ?? '');
                                      }
                                    })
                                : data.field_name == 'hdsan_pham_kh'
                                    ? StreamBuilder<List<List<dynamic>>>(
                                        stream:
                                            ContactByCustomerBloc.of(context)
                                                .listXe,
                                        builder: (context, snapshot) {
                                          final list = snapshot.data;
                                          return InputDropdown(
                                              isUpdate: true,
                                              isUpdateList: true,
                                              dropdownItemList: list ??
                                                  data.field_datasource ??
                                                  [],
                                              data: data,
                                              onSuccess: (dataRes) async {
                                                ///
                                                ///
                                                if (dataRes == ADD_NEW_CAR) {
                                                  final List<dynamic>? result =
                                                      await AppNavigator
                                                          .navigateFormAdd(
                                                    '${AppLocalizations.of(Get.context!)?.add} ${data.field_label}',
                                                    PRODUCT_CUSTOMER_TYPE,
                                                    isGetData: true,
                                                  );
                                                  if (result != null) {
                                                    final dataResult = result
                                                            .first
                                                        as Map<String, dynamic>;
                                                    //todo data
                                                    dataRes = [
                                                      '',
                                                      dataResult['bien_so'],
                                                      dataResult['bien_so'],
                                                      ADD_NEW_CAR,
                                                    ];

                                                    //remove data truoc đó
                                                    for (final value
                                                        in (list ?? [])) {
                                                      if (value.last ==
                                                          ADD_NEW_CAR) {
                                                        list?.remove(value);
                                                        break;
                                                      }
                                                    }
                                                    list?.add(dataRes);
                                                    ContactByCustomerBloc.of(
                                                            context)
                                                        .listXe
                                                        .add(list ?? []);
                                                    //
                                                    addData[indexParent]
                                                        .data[indexChild]
                                                        .value = ADD_NEW_CAR;

                                                    ContactByCustomerBloc.of(
                                                                context)
                                                            .dataCarNew =
                                                        dataResult;
                                                  }
                                                  /////////
                                                  ///// ///
                                                } else {
                                                  addData[indexParent]
                                                      .data[indexChild]
                                                      .value = dataRes;
                                                  ContactByCustomerBloc.of(
                                                          context)
                                                      .getCar(dataRes);
                                                }
                                                //// // /
                                                /// /// //
                                              },
                                              onUpdate: (dataRes) {
                                                if (ContactByCustomerBloc.of(
                                                            context)
                                                        .dataCarNew ==
                                                    [])
                                                  addData[indexParent]
                                                      .data[indexChild]
                                                      .value = dataRes;
                                                ContactByCustomerBloc.of(
                                                        context)
                                                    .getCar(dataRes);
                                              },
                                              value: (list ?? []).isNotEmpty
                                                  ? list![list.length - 1][1]
                                                  : data.field_value ?? '');
                                        })
                                    : InputDropdown(
                                        dropdownItemList:
                                            data.field_datasource ?? [],
                                        data: data,
                                        onSuccess: (data) {
                                          addData[indexParent]
                                              .data[indexChild]
                                              .value = data;
                                          if (data.field_name == 'col131') {
                                            _bloc.getAddressCustomer(data);
                                            ContactByCustomerBloc.of(context)
                                                .chiTietXe
                                                .add('');
                                            ContactByCustomerBloc.of(context).add(
                                                InitGetContactByCustomerrEvent(
                                                    data));
                                            PhoneBloc.of(context)
                                                .add(InitPhoneEvent(data));
                                          }
                                        },
                                        value: data.field_value ?? ''))
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
                        : data.field_type == 'HIDDEN'
                            ? Container()
                            : data.field_type == 'TEXT_MULTI_NEW'
                                ? InputMultipleWidget(
                                    data: data,
                                    onSelect: (data) {
                                      addData[indexParent]
                                          .data[indexChild]
                                          .value = data.join(',');
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
                                        : data.field_special == 'autosum'
                                            ? BlocBuilder<TotalBloc,
                                                    TotalState>(
                                                builder: (context, stateA) {
                                                if (stateA
                                                    is SuccessTotalState) {
                                                  addData[indexParent]
                                                          .data[indexChild]
                                                          .value =
                                                      stateA.total.toString();
                                                  return WidgetTotalSum(
                                                      label: data.field_label,
                                                      value: AppValue
                                                          .format_money(stateA
                                                              .total
                                                              .toStringAsFixed(
                                                                  0)));
                                                } else {
                                                  return WidgetTotalSum(
                                                      label: data.field_label,
                                                      value: '');
                                                }
                                              })
                                            : data.field_type == 'PERCENTAGE'
                                                ? FieldInputPercent(
                                                    data: data,
                                                    onChanged: (text) {
                                                      addData[indexParent]
                                                          .data[indexChild]
                                                          .value = text;
                                                    },
                                                  )
                                                : _fieldInputCustomer(data,
                                                    indexParent, indexChild,
                                                    value: data.field_special ==
                                                            'autosum'
                                                        ? total.toString()
                                                        : '');
  }

  Widget _fieldChiTietXe(
      CustomerIndividualItemData data, int indexParent, int indexChild,
      {String value = ''}) {
    addData[indexParent].data[indexChild].value = value;
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
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
                color: COLORS.LIGHT_GREY,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: HexColor('#BEB4B4'))),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                  child: WidgetText(
                title: '$value',
                style: AppStyle.DEFAULT_14,
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldInputCustomer(
    CustomerIndividualItemData data,
    int indexParent,
    int indexChild, {
    bool noEdit = false,
    String value = '',
  }) {
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
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
                border: Border.all(color: HexColor('#BEB4B4'))),
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
              child: Container(
                child: TextFormField(
                  minLines: data.field_type == 'TEXTAREA' ? 2 : 1,
                  maxLines: data.field_type == 'TEXTAREA' ? 6 : 1,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  keyboardType: data.field_type == 'TEXT_NUMERIC'
                      ? TextInputType.number
                      : data.field_special == 'default'
                          ? TextInputType.text
                          : (data.field_special == 'numberic')
                              ? TextInputType.number
                              : data.field_special == 'email-address'
                                  ? TextInputType.emailAddress
                                  : TextInputType.text,
                  onChanged: (text) {
                    if (data.field_name == 'datt') {
                      TotalBloc.of(context)
                          .paidStream
                          .add(double.parse(text.trim() == '' ? '0' : text));
                      TotalBloc.of(context).getPaid();
                    }
                    addData[indexParent].data[indexChild].value = text;
                  },
                  readOnly: noEdit,
                  initialValue: value != ''
                      ? value
                      : noEdit == true
                          ? data.field_value
                          : data.field_set_value != null
                              ? data.field_set_value.toString()
                              : null,
                  decoration: InputDecoration(
                      hintStyle: AppStyle.DEFAULT_14_BOLD,
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

  void onClickSave() {
    final Map<String, dynamic> data = {};
    bool check = false;
    for (int i = 0; i < addData.length; i++) {
      for (int j = 0; j < addData[i].data.length; j++) {
        if ((addData[i].data[j].value == null ||
                addData[i].data[j].value == 'null' ||
                addData[i].data[j].value == '') &&
            addData[i].data[j].required == 1) {
          check = true;
          break;
        } else if (addData[i].data[j].value != null &&
            addData[i].data[j].value != 'null') {
          if (addData[i].data[j].label == 'hdsan_pham_kh' &&
              addData[i].data[j].value == ADD_NEW_CAR) {
            if (ContactByCustomerBloc.of(context).dataCarNew != {})
              data['productscus'] =
                  ContactByCustomerBloc.of(context).dataCarNew;
          } else {
            data['${addData[i].data[j].label}'] = addData[i].data[j].value;
          }
        } else {
          data['${addData[i].data[j].label}'] = '';
        }
      }
    }

    if (TotalBloc.of(context).unpaidStream.value < 0) {
      check = true;
    }
    if (check == true) {
      ShowDialogCustom.showDialogBase(
        title: AppLocalizations.of(Get.context!)?.notification,
        content: TotalBloc.of(context).unpaidStream.value < 0
            ? AppLocalizations.of(Get.context!)
                ?.the_amount_paid_cannot_be_greater_than_the_total_amount
            : AppLocalizations.of(Get.context!)
                ?.please_enter_all_required_fields,
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
      data['col311'] =
          data['col311'] != '' ? double.parse(data['col311']).toInt() : '';
      AddDataBloc.of(context)
          .add(AddContractEvent(data, files: AttackBloc.of(context).listFile));
    }
  }
}
