import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/contact_by_customer/contact_by_customer_bloc.dart';
import 'package:gen_crm/bloc/contract/phone_bloc.dart';
import 'package:gen_crm/bloc/contract/total_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/add_data_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/form_add_data_bloc.dart';
import 'package:gen_crm/models/model_data_add.dart';
import 'package:gen_crm/models/model_item_add.dart';
import 'package:gen_crm/screens/menu/home/contract/widget/product_contract.dart';
import 'package:gen_crm/screens/menu/home/contract/widget/widget_total_sum.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../../../../../src/models/model_generator/add_customer.dart';
import '../../../bloc/contract/attack_bloc.dart';
import '../../../bloc/contract/contract_bloc.dart';
import '../../../models/product_model.dart';
import '../../../models/widget_input_date.dart';
import '../../../src/app_const.dart';
import '../../../src/models/model_generator/login_response.dart';
import '../../../src/pick_file_image.dart';
import '../../../src/src_index.dart';
import '../../../storages/share_local.dart';
import '../../../widgets/appbar_base.dart';
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
  String CA_NHAN = '0';
  String TO_CHUC = '1';
  String? id_first = Get.arguments[0];
  String? id_two = Get.arguments[1];
  String title = Get.arguments[2] ?? '';

  @override
  void initState() {
    loadUser();
    _bloc = FormAddBloc(userRepository: FormAddBloc.of(context).userRepository);
    String nameCustomerScreen =
        shareLocal.getString(PreferencesKey.NAME_CUSTOMER);
    listCustomerForChance = [
      [CA_NHAN, 'Thêm ${nameCustomerScreen.toString().toLowerCase()} cá nhân'],
      [TO_CHUC, 'Thêm ${nameCustomerScreen.toString().toLowerCase()} tổ chức']
    ];
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
      if (data.id == listProduct[i].id) {
        check = true;
        break;
      }
    }
    if (check == false) {
      listProduct.add(data);
    }
  }

  reload() {
    total = 0;
    for (int i = 0; i < listProduct.length; i++) {
      if (listProduct[i].soLuong == 0) {
        listProduct.removeAt(i);
        i--;
      } else {
        if (listProduct[i].typeGiamGia == '%') {
          total += (double.parse(listProduct[i].item.sell_price ?? '0') *
                  listProduct[i].soLuong) *
              ((100 -
                      double.parse(listProduct[i].giamGia == ''
                          ? '0'
                          : listProduct[i].giamGia)) /
                  100);
        } else {
          total += (double.parse(listProduct[i].item.sell_price ?? '0') *
                  listProduct[i].soLuong) -
              double.parse(
                  listProduct[i].giamGia == '' ? '0' : listProduct[i].giamGia);
        }
      }
    }
    TotalBloc.of(context).add(InitTotalEvent(total));
  }

  @override
  void deactivate() {
    AttackBloc.of(context).add(RemoveAllAttackEvent());
    ContactByCustomerBloc.of(context).chiTietXe.add('');
    ContactByCustomerBloc.of(context).listXe.add([]);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarBaseNormal(
          'Thêm ${title.toLowerCase()}',
        ),
        body: BlocListener<AddDataBloc, AddDataState>(
          listener: (context, state) async {
            if (state is SuccessAddCustomerOrState) {
              ShowDialogCustom.showDialogBase(
                title: MESSAGES.NOTIFICATION,
                content: 'Thêm mới dữ liệu thành công!',
                onTap1: () {
                  Get.back();
                  Get.back();
                  GetListCustomerBloc.of(context).add(InitGetListOrderEvent());
                },
              );
            }
            if (state is ErrorAddCustomerOrState) {
              ShowDialogCustom.showDialogBase(
                title: MESSAGES.NOTIFICATION,
                content: state.msg,
              );
            }
            if (state is SuccessAddContactCustomerState) {
              ShowDialogCustom.showDialogBase(
                title: MESSAGES.NOTIFICATION,
                content: 'Thêm mới dữ liệu thành công!',
                onTap1: () {
                  Get.back();
                  Get.back();
                  ContractBloc.of(context).add(InitGetContractEvent());
                },
              );
            }
            if (state is ErrorAddContactCustomerState) {
              ShowDialogCustom.showDialogBase(
                title: MESSAGES.NOTIFICATION,
                content: state.msg,
              );
            }
          },
          child: Container(
            padding: EdgeInsets.all(25),
            color: Colors.white,
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
        ? (data.field_name == 'so_dien_thoai'
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
                    : _fieldInputCustomer(data, indexParent, indexChild,
                        noEdit: true))
        : data.field_special == 'none-edit'
            ? _fieldInputCustomer(data, indexParent, indexChild, noEdit: true)
            : data.field_special == 'url'
                ? ProductContract(
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
                        : (data.field_name == 'col141'
                            ? BlocBuilder<ContactByCustomerBloc, ContactByCustomerState>(
                                builder: (context, stateA) {
                                if (stateA is UpdateGetContacBytCustomerState)
                                  return InputDropdown(
                                      dropdownItemList:
                                          stateA.listContactByCustomer,
                                      data: data,
                                      onSuccess: (data) {
                                        addData[indexParent]
                                            .data[indexChild]
                                            .value = data;
                                        PhoneBloc.of(context)
                                            .add(InitAgencyPhoneEvent(data));
                                      },
                                      value: data.field_value ?? '');
                                else
                                  return Container();
                              })
                            : data.field_name == 'hdsan_pham_kh'
                                ? StreamBuilder<List<List<dynamic>>>(
                                    stream: ContactByCustomerBloc.of(context)
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
                                          onSuccess: (data) {
                                            addData[indexParent]
                                                .data[indexChild]
                                                .value = data;
                                            ContactByCustomerBloc.of(context)
                                                .getCar(data);
                                          },
                                          onUpdate: (data) {
                                            addData[indexParent]
                                                .data[indexChild]
                                                .value = data;
                                            ContactByCustomerBloc.of(context)
                                                .getCar(data);
                                          },
                                          value: list?.isEmpty ?? false
                                              ? ''
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
                        ? _fieldInputTextMulti(
                            data.field_datasource!,
                            data.field_label!,
                            data.field_require!,
                            indexParent,
                            indexChild,
                            (data.field_set_value_datasource != '' &&
                                    data.field_set_value_datasource != null)
                                ? data.field_set_value_datasource![0][0]
                                    .toString()
                                : '',
                            data.field_maxlength ?? '')
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
                                : data.field_type == 'DATE'
                                    ? WidgetInputDate(
                                        data: data,
                                        onSelect: (date) {
                                          addData[indexParent]
                                                  .data[indexChild]
                                                  .value =
                                              (date.microsecondsSinceEpoch /
                                                      1000000)
                                                  .floor();
                                        },
                                        onInit: () {
                                          DateTime date = DateTime.now();
                                          addData[indexParent]
                                                  .data[indexChild]
                                                  .value =
                                              (date.microsecondsSinceEpoch /
                                                      1000000)
                                                  .floor();
                                        },
                                      )
                                    : data.field_type == 'DATETIME'
                                        ? WidgetInputDate(
                                            isDate: false,
                                            data: data,
                                            onSelect: (date) {
                                              addData[indexParent]
                                                      .data[indexChild]
                                                      .value =
                                                  (date.microsecondsSinceEpoch /
                                                          1000000)
                                                      .floor();
                                            },
                                            onInit: () {
                                              DateTime date = DateTime.now();
                                              addData[indexParent]
                                                      .data[indexChild]
                                                      .value =
                                                  (date.microsecondsSinceEpoch /
                                                          1000000)
                                                      .floor();
                                            },
                                          )
                                        : data.field_special == 'autosum'
                                            ? BlocBuilder<TotalBloc, TotalState>(
                                                builder: (context, stateA) {
                                                if (stateA
                                                    is SuccessTotalState) {
                                                  addData[indexParent]
                                                          .data[indexChild]
                                                          .value =
                                                      stateA.total.toString();
                                                  return WidgetTotalSum(
                                                      label: data.field_label,
                                                      value: stateA.total
                                                          .toStringAsFixed(0));
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
                                                : _fieldInputCustomer(
                                                    data, indexParent, indexChild,
                                                    value:
                                                        data.field_special == 'autosum'
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
              style: titlestyle(),
              children: <TextSpan>[
                data.field_require == 1
                    ? TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red))
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

  Column fieldInputImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hình ảnh',
          style: titlestyle(),
        ),
        SizedBox(
          height: AppValue.heights * 0.005,
        ),
        Container(
          width: double.infinity,
          height: AppValue.heights * 0.05,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: HexColor('#BEB4B4'))),
          child: Row(children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Tải hình ảnh',
                    enabled: false,
                    hintStyle: hintTextStyle(),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Center(
                  child: Container(
                      height: 50,
                      width: 50,
                      child: SvgPicture.asset(ICONS.IC_INPUT_SVG))),
            )
          ]),
        ),
      ],
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
              style: titlestyle(),
              children: <TextSpan>[
                data.field_require == 1
                    ? TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red))
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
                color: noEdit == true ? COLORS.LIGHT_GREY : Colors.white,
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
                      hintStyle: hintTextStyle(),
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

  Widget _fieldInputTextMulti(
      List<List<dynamic>> dropdownItemList,
      String label,
      int required,
      int indexParent,
      int indexChild,
      String value,
      String maxLength) {
    List<ModelDataAdd> dropdow = [];
    int indexParentDefault = -1;
    for (int i = 0; i < dropdownItemList.length; i++) {
      dropdow.add(ModelDataAdd(
          label: dropdownItemList[i][1], value: dropdownItemList[i][0]));
      if (dropdownItemList[i][0].toString() == value) {
        indexParentDefault = i;
      }
    }
    return (Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              text: label,
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: COLORS.BLACK),
              children: <TextSpan>[
                required == 1
                    ? TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red))
                    : TextSpan(),
              ],
            ),
          ),
          AppValue.vSpaceTiny,
          MultiSelectDialogField<ModelDataAdd>(
              items: dropdow
                  .map((e) => MultiSelectItem(e, e.label ?? ''))
                  .toList(),
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) {
                if (maxLength != '' && values.length > int.parse(maxLength)) {
                  values.removeRange(
                      int.parse(maxLength) - 1, values.length - 1);
                  ShowDialogCustom.showDialogBase(
                    title: MESSAGES.NOTIFICATION,
                    content: 'Bạn chỉ được chọn ${maxLength} giá trị',
                  );
                } else {
                  List<String> res = [];
                  for (int i = 0; i < values.length; i++) {
                    res.add(values[i].value!.toString());
                  }
                  addData[indexParent].data[indexChild].value = res.join(',');
                }
              },
              onSelectionChanged: (values) {
                if (maxLength != '' && values.length > int.parse(maxLength)) {
                  values.removeRange(
                      int.parse(maxLength) - 1, values.length - 1);
                }
              },
              title: WidgetText(
                title: label,
                style: AppStyle.DEFAULT_18_BOLD,
              ),
              buttonText: Text(
                label,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                    color: COLORS.BLACK),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: HexColor('#BEB4B4'))),
              buttonIcon: Icon(
                Icons.arrow_drop_down,
                size: 25,
              ),
              initialValue:
                  indexParentDefault != -1 ? [dropdow[indexParentDefault]] : [],
              selectedItemsTextStyle: AppStyle.DEFAULT_14,
              itemsTextStyle: AppStyle.DEFAULT_14),
        ],
      ),
    ));
  }

  TextStyle hintTextStyle() => TextStyle(
      fontFamily: 'Quicksand',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: COLORS.BLACK);

  TextStyle titlestyle() => TextStyle(
      fontFamily: 'Quicksand',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: COLORS.BLACK);

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
            addData[i].data[j].value != 'null')
          data['${addData[i].data[j].label}'] = addData[i].data[j].value;
        else {
          data['${addData[i].data[j].label}'] = '';
        }
      }
    }
    if (check == true) {
      ShowDialogCustom.showDialogBase(
        title: MESSAGES.NOTIFICATION,
        content: 'Hãy nhập đủ các trường bắt buộc (*)',
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
