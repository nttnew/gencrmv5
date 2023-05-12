import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/contact_by_customer/contact_by_customer_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/add_data_bloc.dart';
import 'package:gen_crm/bloc/form_edit/form_edit_bloc.dart';
import 'package:gen_crm/models/model_data_add.dart';
import 'package:gen_crm/models/model_item_add.dart';
import 'package:gen_crm/screens/menu/home/contract/product_contract.dart';
import 'package:gen_crm/screens/menu/home/contract/widget_total_sum.dart';
import 'package:gen_crm/src/models/model_generator/product_response.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../../../src/models/model_generator/add_customer.dart';
import '../../../../../../../src/src_index.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../../../../../widgets/widget_dialog.dart';

import '../../../../bloc/contract/attack_bloc.dart';
import '../../../../bloc/contract/contract_bloc.dart';
import '../../../../bloc/contract/detail_contract_bloc.dart';
import '../../../../bloc/contract/phone_bloc.dart';
import '../../../../bloc/contract/total_bloc.dart';
import '../../../../models/product_model.dart';
import '../../../../models/widget_input_date.dart';

import '../../../../src/models/model_generator/login_response.dart';
import '../../../../src/pick_file_image.dart';
import '../../../../storages/share_local.dart';
import '../../../../widgets/widget_field_input_percent.dart';
import '../customer/add_customer.dart';
import '../customer/input_dropDown.dart';

class EditContract extends StatefulWidget {
  const EditContract({Key? key}) : super(key: key);

  @override
  State<EditContract> createState() => _EditContractState();
}

class _EditContractState extends State<EditContract> {
  List data = [];
  List<ModelItemAdd> addData = [];
  late String id_user;
  List<ProductModel> listProduct = [];
  List<List<dynamic>> dauMoi = [];
  String id = Get.arguments;
  double total = 0;

  @override
  void initState() {
    loadUser();
    AttackBloc.of(context).add(LoadingAttackEvent());
    FormEditBloc.of(context).add(InitFormEditContractEvent(id));
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
    if (check == false) listProduct.add(data);
  }

  reload() {
    total = 0;
    for (int i = 0; i < listProduct.length; i++) {
      if (listProduct[i].soLuong == 0) {
        listProduct.removeAt(i);
        i--;
      } else {
        if (listProduct[i].typeGiamGia == '%') {
          total += (double.parse(listProduct[i].item.sell_price!) *
                  listProduct[i].soLuong) *
              ((100 -
                      double.parse(listProduct[i].giamGia == ""
                          ? "0"
                          : listProduct[i].giamGia)) /
                  100);
        } else {
          total += (double.parse(listProduct[i].item.sell_price!) *
                  listProduct[i].soLuong) -
              double.parse(
                  listProduct[i].giamGia == "" ? "0" : listProduct[i].giamGia);
        }
      }
    }
    TotalBloc.of(context).add(InitTotalEvent(total));
  }

  @override
  void dispose() {
    data.clear();
    addData.clear();
    listProduct.clear();
    super.dispose();
  }

  @override
  void deactivate() {
    AttackBloc.of(context).add(RemoveAllAttackEvent());
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: AppValue.heights * 0.1,
          backgroundColor: HexColor("#D0F1EB"),
          title: WidgetText(
              title: "Sửa thông tin",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          leading: _buildBack(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
        ),
        body: BlocListener<AddDataBloc, AddDataState>(
          listener: (context, state) async {
            if (state is SuccessAddCustomerOrState) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return WidgetDialog(
                    title: MESSAGES.NOTIFICATION,
                    content: "Update dữ liệu thành công!",
                    textButton1: MESSAGES.OKE,
                    backgroundButton1: COLORS.PRIMARY_COLOR,
                    onTap1: () {
                      Get.back();
                      Get.back();

                      GetListCustomerBloc.of(context)
                          .add(InitGetListOrderEvent("", 1, ""));
                    },
                  );
                },
              );
            }
            if (state is ErrorAddCustomerOrState) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return WidgetDialog(
                    title: MESSAGES.NOTIFICATION,
                    content: state.msg,
                  );
                },
              );
            }
            if (state is SuccessAddContactCustomerState) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return WidgetDialog(
                    title: MESSAGES.NOTIFICATION,
                    content: "Update dữ liệu thành công!",
                    textButton1: MESSAGES.OKE,
                    backgroundButton1: COLORS.PRIMARY_COLOR,
                    onTap1: () {
                      Get.back();
                      Get.back();
                      DetailContractBloc.of(context)
                          .add(InitGetDetailContractEvent(int.parse(id)));
                      ContractBloc.of(context)
                          .add(InitGetContractEvent(1, "", ""));
                    },
                  );
                },
              );
            }
            if (state is ErrorAddContactCustomerState) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return WidgetDialog(
                    title: MESSAGES.NOTIFICATION,
                    content: state.msg,
                  );
                },
              );
            }
          },
          child: Container(
            padding: EdgeInsets.only(
                left: AppValue.widths * 0.05,
                right: AppValue.widths * 0.05,
                top: AppValue.heights * 0.02),
            color: Colors.white,
            child: SingleChildScrollView(
              child: BlocBuilder<FormEditBloc, FormEditState>(
                  builder: (context, state) {
                if (state is LoadingFormEditState) {
                  addData = [];
                  data = [];
                  listProduct = [];
                  return Container();
                } else if (state is SuccessFormEditState) {
                  for (int i = 0; i < state.listEditData.length; i++) {
                    addData.add(ModelItemAdd(
                        group_name: state.listEditData[i].group_name ?? '',
                        data: []));
                    for (int j = 0;
                        j < state.listEditData[i].data!.length;
                        j++) {
                      // if(state.listEditData[i].data![j].field_type!="HIDDEN")
                      if (state.listEditData[i].data![j].field_special ==
                          "url") {
                        if (state.listEditData[i].data![j].products != null)
                          for (int k = 0;
                              k <
                                  state.listEditData[i].data![j].products!
                                      .length;
                              k++) {
                            listProduct.add(ProductModel(
                                state.listEditData[i].data![j].products![k]
                                    .id_product
                                    .toString(),
                                double.parse(state.listEditData[i].data![j]
                                        .products![k].quantity!)
                                    .toInt(),
                                ProductItem(
                                    state.listEditData[i].data![j].products![k]
                                        .id_product
                                        .toString(),
                                    "",
                                    "",
                                    state.listEditData[i].data![j].products![k]
                                        .name_product,
                                    state.listEditData[i].data![j].products![k]
                                        .unit
                                        .toString(),
                                    state.listEditData[i].data![j].products![k]
                                        .vat,
                                    state.listEditData[i].data![j].products![k]
                                        .price),
                                state.listEditData[i].data![j].products![k]
                                    .sale_off.value!,
                                state.listEditData[i].data![j].products![k]
                                    .unit_name!,
                                state.listEditData[i].data![j].products![k]
                                    .vat_name!,
                                state.listEditData[i].data![j].products![k]
                                    .sale_off.type!));
                          }
                      } else
                        addData[i].data.add(ModelDataAdd(
                            label: state.listEditData[i].data![j].field_name,
                            value: state
                                .listEditData[i].data![j].field_set_value
                                .toString()));
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            state.listEditData.length,
                            (index) =>
                                (state.listEditData[index].data != null &&
                                        state.listEditData[index].data!.length >
                                            0)
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: AppValue.heights * 0.01,
                                          ),
                                          state.listEditData[index]
                                                      .group_name !=
                                                  null
                                              ? WidgetText(
                                                  title: state
                                                          .listEditData[index]
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
                                                state.listEditData[index].data!
                                                    .length,
                                                (index1) => state
                                                            .listEditData[index]
                                                            .data![index1]
                                                            .field_hidden !=
                                                        "1"
                                                    ? state.listEditData[index].data![index1].field_special ==
                                                            "none-edit"
                                                        ? (state.listEditData[index].data![index1].field_id ==
                                                                '774'
                                                            ? BlocBuilder<PhoneBloc, PhoneState>(
                                                                builder:
                                                                    (context,
                                                                        stateA) {
                                                                if (stateA
                                                                    is SuccessPhoneState) {
                                                                  addData[index]
                                                                          .data[
                                                                              index1]
                                                                          .value =
                                                                      stateA
                                                                          .phone;
                                                                  return _fieldInputCustomer(
                                                                      state.listEditData[index].data![
                                                                          index1],
                                                                      index,
                                                                      index1,
                                                                      noEdit:
                                                                          true,
                                                                      value: stateA
                                                                          .phone);
                                                                } else
                                                                  return Container();
                                                              })
                                                            : _fieldInputCustomer(
                                                                state
                                                                    .listEditData[index]
                                                                    .data![index1],
                                                                index,
                                                                index1,
                                                                noEdit: true,
                                                                value: state.listEditData[index].data![index1].field_set_value ?? ''))
                                                        : state.listEditData[index].data![index1].field_special == "url"
                                                            ? ProductContract(
                                                                data:
                                                                    listProduct,
                                                                addProduct:
                                                                    addProduct,
                                                                reload: reload,
                                                              )
                                                            : state.listEditData[index].data![index1].field_type == "SELECT"
                                                                ? (state.listEditData[index].data![index1].field_id == '256'
                                                                    ? BlocBuilder<ContactByCustomerBloc, ContactByCustomerState>(builder: (context, stateA) {
                                                                        if (stateA
                                                                            is UpdateGetContacBytCustomerState)
                                                                          return InputDropdown(
                                                                              dropdownItemList: stateA.listContactByCustomer,
                                                                              data: state.listEditData[index].data![index1],
                                                                              onSuccess: (data) {
                                                                                addData[index].data[index1].value = data;
                                                                                PhoneBloc.of(context).add(InitAgencyPhoneEvent(data));
                                                                              },
                                                                              value: state.listEditData[index].data![index1].field_value ?? '');
                                                                        else
                                                                          return Container();
                                                                      })
                                                                    : InputDropdown(
                                                                        dropdownItemList: state.listEditData[index].data![index1].field_datasource ?? [],
                                                                        data: state.listEditData[index].data![index1],
                                                                        onSuccess: (data) {
                                                                          addData[index]
                                                                              .data[index1]
                                                                              .value = data;
                                                                          if (state.listEditData[index].data![index1].field_id ==
                                                                              '246')
                                                                            ContactByCustomerBloc.of(context).add(InitGetContactByCustomerrEvent(data));
                                                                        },
                                                                        value: state.listEditData[index].data![index1].field_value ?? ''))
                                                                : state.listEditData[index].data![index1].field_type == "TEXT_MULTI"
                                                                    ? _fieldInputTextMulti(state.listEditData[index].data![index1].field_datasource!, state.listEditData[index].data![index1].field_label!, state.listEditData[index].data![index1].field_require!, index, index1, (state.listEditData[index].data![index1].field_set_value_datasource != "" && state.listEditData[index].data![index1].field_set_value_datasource != null) ? state.listEditData[index].data![index1].field_set_value_datasource![0][0].toString() : "", state.listEditData[index].data![index1].field_maxlength ?? '')
                                                                    : state.listEditData[index].data![index1].field_type == "HIDDEN"
                                                                        ? Container()
                                                                        : state.listEditData[index].data![index1].field_type == "TEXT_MULTI_NEW"
                                                                            ? WidgetInputMulti(
                                                                                data: state.listEditData[index].data![index1],
                                                                                onSelect: (data) {
                                                                                  addData[index].data[index1].value = data.join(",");
                                                                                },
                                                                              )
                                                                            : state.listEditData[index].data![index1].field_type == "DATE"
                                                                                ? WidgetInputDate(
                                                                                    data: state.listEditData[index].data![index1],
                                                                                    onSelect: (date) {
                                                                                      addData[index].data[index1].value = (date.microsecondsSinceEpoch / 1000000).floor();
                                                                                    },
                                                                                    dateText: (state.listEditData[index].data![index1].field_set_value != "" && state.listEditData[index].data![index1].field_set_value != null) ? AppValue.formatDate(DateTime.fromMillisecondsSinceEpoch(state.listEditData[index].data![index1].field_set_value * 1000).toString()) : "",
                                                                                    onInit: () {
                                                                                      if (state.listEditData[index].data![index1].field_set_value != "" && state.listEditData[index].data![index1].field_set_value != null) {
                                                                                        addData[index].data[index1].value = state.listEditData[index].data![index1].field_set_value;
                                                                                      } else {
                                                                                        DateTime date = DateTime.now();
                                                                                        addData[index].data[index1].value = (date.microsecondsSinceEpoch / 1000000).floor();
                                                                                      }
                                                                                    },
                                                                                  )
                                                                                : state.listEditData[index].data![index1].field_special == 'autosum'
                                                                                    ? BlocBuilder<TotalBloc, TotalState>(builder: (context, stateA) {
                                                                                        if (stateA is SuccessTotalState) {
                                                                                          addData[index].data[index1].value = stateA.total.toString();
                                                                                          return WidgetTotalSum(label: state.listEditData[index].data![index1].field_label, value: AppValue.APP_MONEY_FORMAT.format(stateA.total));
                                                                                        } else {
                                                                                          return WidgetTotalSum(label: state.listEditData[index].data![index1].field_label, value: state.listEditData[index].data![index1].field_value);
                                                                                        }
                                                                                      })
                                                                                    : state.listEditData[index].data![index1].field_type == "PERCENTAGE"
                                                                                        ? FieldInputPercent(
                                                                                            data: state.listEditData[index].data![index1],
                                                                                            onChanged: (text) {
                                                                                              addData[index].data[index1].value = text;
                                                                                            },
                                                                                          )
                                                                                        : _fieldInputCustomer(state.listEditData[index].data![index1], index, index1)
                                                    : SizedBox()),
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

  _buildBack() {
    return IconButton(
      onPressed: () {
        AppNavigator.navigateBack();
      },
      icon: Image.asset(
        ICONS.IC_BACK_PNG,
        height: 28,
        width: 28,
        color: COLORS.BLACK,
      ),
    );
  }

  Column fieldInputImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hình ảnh",
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
              border: Border.all(color: HexColor("#BEB4B4"))),
          child: Row(children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Tải hình ảnh",
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
              child: Center(child: Container(height: 50, width: 50, child: SvgPicture.asset(ICONS.IC_INPUT_SVG))),
            )
          ]),
        ),
      ],
    );
  }

  Widget _fieldInputCustomer(
      CustomerIndividualItemData data, int index, int index1,
      {bool noEdit = false, String value = ""}) {
    // if ((type == 21 && data.field_id == "12547")||(type == 31 && data.field_id == "12547")) {
    //   return Container();
    // } else
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
                            fontFamily: "Quicksand",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
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
                border: Border.all(color: HexColor("#BEB4B4"))),
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
              child: Container(
                child: TextFormField(
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
                    addData[index].data[index1].value = text;
                  },
                  readOnly: noEdit,
                  initialValue: value != ""
                      ? value
                      : noEdit == true
                          ? data.field_value
                          : (data.field_type == "MONEY" &&
                                  data.field_set_value != null)
                              ? data.field_set_value
                                  .replaceAll(",", "")
                                  .replaceAll(".", "")
                                  .toString()
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
      int index,
      int index1,
      String value,
      String maxLength) {
    List<ModelDataAdd> dropdow = [];
    int indexDefault = -1;
    for (int i = 0; i < dropdownItemList.length; i++) {
      dropdow.add(ModelDataAdd(
          label: dropdownItemList[i][1], value: dropdownItemList[i][0]));
      if (dropdownItemList[i][0].toString() == value) {
        indexDefault = i;
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
                  fontFamily: "Quicksand",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:COLORS.BLACK),
              children: <TextSpan>[
                required == 1
                    ? TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
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
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return WidgetDialog(
                        title: MESSAGES.NOTIFICATION,
                        content: "Bạn chỉ được chọn ${maxLength} giá trị",
                      );
                    },
                  );
                } else {
                  List<String> res = [];
                  for (int i = 0; i < values.length; i++) {
                    res.add(values[i].value!.toString());
                  }
                  addData[index].data[index1].value = res.join(",");
                }
              },
              onSelectionChanged: (values) {
                if (maxLength != "" && values.length > int.parse(maxLength)) {
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
                style: titlestyle(),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: HexColor("#BEB4B4"))),
              buttonIcon: Icon(
                Icons.arrow_drop_down,
                size: 25,
              ),
              initialValue: indexDefault != -1 ? [dropdow[indexDefault]] : [],
              selectedItemsTextStyle: AppStyle.DEFAULT_12,
              itemsTextStyle: AppStyle.DEFAULT_12),
        ],
      ),
    ));
  }

  TextStyle hintTextStyle() => TextStyle(
      fontFamily: "Quicksand",
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: COLORS.BLACK);

  TextStyle titlestyle() => TextStyle(
      fontFamily: "Quicksand",
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: COLORS.BLACK);

  void onClickSave() {
    final Map<String, dynamic> data = {};
    for (int i = 0; i < addData.length; i++) {
      for (int j = 0; j < addData[i].data.length; j++) {
        if (addData[i].data[j].value != null &&
            addData[i].data[j].value != "null")
          data["${addData[i].data[j].label}"] = addData[i].data[j].value;
        else {
          data["${addData[i].data[j].label}"] = "";
        }
      }
    }
    if (listProduct.length > 0) {
      List product = [];
      for (int i = 0; i < listProduct.length; i++) {
        product.add({
          "id": listProduct[i].id,
          "price": listProduct[i].item.sell_price,
          "quantity": listProduct[i].soLuong,
          "vat": listProduct[i].item.vat,
          "unit": listProduct[i].item.dvt,
          "sale_off": {
            "value": listProduct[i].giamGia,
            "type": listProduct[i].typeGiamGia
          }
        });
      }
      data['products'] = product;
      data['id'] = id;
    }
    AddDataBloc.of(context)
        .add(AddContractEvent(data, files: AttackBloc.of(context).listFile));
  }
}
