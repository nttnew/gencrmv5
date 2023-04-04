import 'dart:convert';
import 'dart:io';

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
import 'package:gen_crm/screens/menu/home/contract/product_contract.dart';
import 'package:gen_crm/screens/menu/home/contract/widget_total_sum.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../src/models/model_generator/add_customer.dart';
import '../../../../../../../src/src_index.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../../../../../widgets/widget_dialog.dart';

import '../../../../bloc/contract/attack_bloc.dart';
import '../../../../bloc/contract/contract_bloc.dart';
import '../../../../models/product_model.dart';
import '../../../../models/widget_input_date.dart';

import '../../../../src/models/model_generator/login_response.dart';
import '../../../../storages/share_local.dart';
import '../../../../widgets/widgetFieldInputPercent.dart';
import '../customer/add_customer.dart';
import '../customer/input_dropDown.dart';

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
  File? fileUpload;
  double total = 0;
  TextEditingController value_contract_controller = TextEditingController();
  @override
  void initState() {
    loadUser();
    AttackBloc.of(context).add(LoadingAttackEvent());
    if (Get.arguments[0] != null)
      FormAddBloc.of(context).add(InitFormAddContractEvent(id: Get.arguments[0]));
    else if (Get.arguments[1] != null) {
      FormAddBloc.of(context).add(InitFormAddContractCusEvent(Get.arguments[1]));
    } else {
      FormAddBloc.of(context).add(InitFormAddContractEvent());
    }
    super.initState();
  }

  loadUser() async {
    final response = await shareLocal.getString(PreferencesKey.USER);
    if (response != null) {
      // setState(() {
      id_user = LoginData.fromJson(jsonDecode(response)).info_user!.user_id!;
      // });
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
    for (int i = 0; i < listProduct.length; i++) {
      if (listProduct[i].soLuong == 0) {
        listProduct.removeAt(i);
        i--;
      } else {
        if (listProduct[i].typeGiamGia == '%') {
          total += (double.parse(listProduct[i].item.sell_price ?? '0') * listProduct[i].soLuong) * ((100 - double.parse(listProduct[i].giamGia == "" ? "0" : listProduct[i].giamGia)) / 100);
        } else {
          total += (double.parse(listProduct[i].item.sell_price ?? '0') * listProduct[i].soLuong) - double.parse(listProduct[i].giamGia == "" ? "0" : listProduct[i].giamGia);
        }
      }
    }
    TotalBloc.of(context).add(InitTotalEvent(total));
  }

  @override
  void dispose() {
    data.clear();
    addData.clear();
    value_contract_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: AppValue.heights * 0.1,
          backgroundColor: HexColor("#D0F1EB"),
          title: WidgetText(title: "Thêm hợp đồng", style: TextStyle(color: Colors.black, fontFamily: "Montserrat", fontWeight: FontWeight.w700, fontSize: 16)),
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
                    content: "Thêm mới dữ liệu thành công!",
                    textButton1: "OK",
                    backgroundButton1: COLORS.PRIMARY_COLOR,
                    onTap1: () {
                      Get.back();
                      Get.back();
                      GetListCustomerBloc.of(context).add(InitGetListOrderEvent("", 1, ""));
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
                    content: "Thêm mới dữ liệu thành công!",
                    textButton1: "OK",
                    backgroundButton1: COLORS.PRIMARY_COLOR,
                    onTap1: () {
                      Get.back();
                      Get.back();
                      ContractBloc.of(context).add(InitGetContractEvent(1, "", ""));
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
            padding: EdgeInsets.only(left: AppValue.widths * 0.05, right: AppValue.widths * 0.05, top: AppValue.heights * 0.02),
            color: Colors.white,
            child: SingleChildScrollView(
              child: BlocBuilder<FormAddBloc, FormAddState>(builder: (context, state) {
                if (state is LoadingFormAddCustomerOrState) {
                  addData = [];
                  data = [];
                  return Container();
                } else if (state is SuccessFormAddCustomerOrState) {
                  for (int i = 0; i < state.listAddData.length; i++) {
                    addData.add(ModelItemAdd(group_name: state.listAddData[i].group_name ?? '', data: []));
                    for (int j = 0; j < state.listAddData[i].data!.length; j++) {
                      // if(state.listAddData[i].data![j].field_type!="HIDDEN")
                      addData[i].data.add(ModelDataAdd(label: state.listAddData[i].data![j].field_name, value: state.listAddData[i].data![j].field_set_value.toString(), required: state.listAddData[i].data![j].field_require));
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            state.listAddData.length,
                            (index) => (state.listAddData[index].data != null && state.listAddData[index].data!.length > 0)
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: AppValue.heights * 0.01,
                                      ),
                                      state.listAddData[index].group_name != null ? WidgetText(title: state.listAddData[index].group_name ?? '', style: AppStyle.DEFAULT_18_BOLD) : Container(),
                                      SizedBox(
                                        height: AppValue.heights * 0.01,
                                      ),
                                      Column(
                                        children: List.generate(
                                            state.listAddData[index].data!.length,
                                            (index1) => (state.listAddData[index].data![index1].field_special == "none-edit" && state.listAddData[index].data![index1].field_id != '246')
                                                ? (state.listAddData[index].data![index1].field_id == '774'
                                                    ? BlocBuilder<PhoneBloc, PhoneState>(builder: (context, stateA) {
                                                        if (stateA is SuccessPhoneState) {
                                                          addData[index].data[index1].value = stateA.phone;
                                                          return _fieldInputCustomer(state.listAddData[index].data![index1], index, index1, noEdit: true, value: stateA.phone);
                                                        } else
                                                          return Container();
                                                      })
                                                    : _fieldInputCustomer(state.listAddData[index].data![index1], index, index1, noEdit: true))
                                                : state.listAddData[index].data![index1].field_special == "url"
                                                    ? ProductContract(
                                                        data: listProduct,
                                                        addProduct: addProduct,
                                                        reload: reload,
                                                        neverHidden: true,
                                                        canDelete: true,
                                                      )
                                                    : state.listAddData[index].data![index1].field_type == "SELECT"
                                                || state.listAddData[index].data![index1].field_id == "12465"
                                                || state.listAddData[index].data![index1].field_id == "1391"
                                                        ? (state.listAddData[index].data![index1].field_id == '256'
                                                            ? BlocBuilder<ContactByCustomerBloc, ContactByCustomerState>(builder: (context, stateA) {
                                                                if (stateA is UpdateGetContacBytCustomerState)
                                                                  return InputDropdown(
                                                                      dropdownItemList: stateA.listContactByCustomer,
                                                                      data: state.listAddData[index].data![index1],
                                                                      onSuccess: (data) {
                                                                        addData[index].data[index1].value = data;
                                                                        PhoneBloc.of(context).add(InitAgencyPhoneEvent(data));
                                                                      },
                                                                      value: state.listAddData[index].data![index1].field_value ?? '');
                                                                else
                                                                  return Container();
                                                              })
                                                            : InputDropdown(
                                                                dropdownItemList: state.listAddData[index].data![index1].field_datasource ?? [],
                                                                data: state.listAddData[index].data![index1],
                                                                onSuccess: (data) {
                                                                  addData[index].data[index1].value = data;
                                                                  if (state.listAddData[index].data![index1].field_id == '246') {
                                                                    ContactByCustomerBloc.of(context).add(InitGetContactByCustomerrEvent(data));
                                                                    PhoneBloc.of(context).add(InitPhoneEvent(data));
                                                                  }
                                                                },
                                                                value: state.listAddData[index].data![index1].field_value ?? ''))
                                                        : state.listAddData[index].data![index1].field_type == "TEXT_MULTI"
                                                            ? _fieldInputTextMulti(state.listAddData[index].data![index1].field_datasource!, state.listAddData[index].data![index1].field_label!, state.listAddData[index].data![index1].field_require!, index, index1,
                                                                (state.listAddData[index].data![index1].field_set_value_datasource != "" && state.listAddData[index].data![index1].field_set_value_datasource != null) ? state.listAddData[index].data![index1].field_set_value_datasource![0][0].toString() : "", state.listAddData[index].data![index1].field_maxlength ?? '')
                                                            : state.listAddData[index].data![index1].field_type == "HIDDEN"
                                                                ? Container()
                                                                : state.listAddData[index].data![index1].field_type == "TEXT_MULTI_NEW"
                                                                    ? WidgetInputMulti(
                                                                        data: state.listAddData[index].data![index1],
                                                                        onSelect: (data) {
                                                                          addData[index].data[index1].value = data.join(",");
                                                                        },
                                                                      )
                                                                    : state.listAddData[index].data![index1].field_type == "DATE"
                                                                        ? WidgetInputDate(
                                                                            data: state.listAddData[index].data![index1],
                                                                            onSelect: (date) {
                                                                              addData[index].data[index1].value = (date.microsecondsSinceEpoch / 1000000).floor();
                                                                            },
                                                                            onInit: () {
                                                                              DateTime date = DateTime.now();
                                                                              addData[index].data[index1].value = (date.microsecondsSinceEpoch / 1000000).floor();
                                                                            },
                                                                          )
                                                                        : state.listAddData[index].data![index1].field_special == 'autosum'
                                                                            ? BlocBuilder<TotalBloc, TotalState>(builder: (context, stateA) {
                                                                                if (stateA is SuccessTotalState) {
                                                                                  addData[index].data[index1].value = stateA.total.toString();
                                                                                  return WidgetTotalSum(label: state.listAddData[index].data![index1].field_label, value: stateA.total.toStringAsFixed(0));
                                                                                } else {
                                                                                  return WidgetTotalSum(label: state.listAddData[index].data![index1].field_label, value: "");
                                                                                }
                                                                              })
                                                                            : state.listAddData[index].data![index1].field_type == "PERCENTAGE"
                                                                                ? FieldInputPercent(
                                                                                    data: state.listAddData[index].data![index1],
                                                                                    onChanged: (text) {
                                                                                      addData[index].data[index1].value = text;
                                                                                    },
                                                                                  )
                                                                                : _fieldInputCustomer(state.listAddData[index].data![index1], index, index1, value: state.listAddData[index].data![index1].field_special == 'autosum' ? total.toString() : "")),
                                      )
                                    ],
                                  )
                                : Container()),
                      ),
                      BlocBuilder<AttackBloc, AttackState>(builder: (context, state) {
                        if (state is SuccessAttackState) if (state.file != null)
                          return Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              width: Get.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: WidgetText(
                                      title: state.file!.path.split("/").last,
                                      style: AppStyle.DEFAULT_14,
                                      maxLine: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      fileUpload = null;
                                      AttackBloc.of(context).add(InitAttackEvent());
                                    },
                                    child: WidgetContainerImage(
                                      image: 'assets/icons/icon_delete.png',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                ],
                              ));
                        else
                          return Container();
                        else
                          return Container();
                      }),
                      Row(
                        children: [
                          GestureDetector(onTap: this.onDinhKem, child: SvgPicture.asset("assets/icons/attack.svg")),
                          Spacer(),
                          GestureDetector(
                            onTap: this.onClickSave,
                            child: Container(
                              height: AppValue.widths * 0.1,
                              width: AppValue.widths * 0.25,
                              decoration: BoxDecoration(color: HexColor("#F1A400"), borderRadius: BorderRadius.circular(20.5)),
                              child: Center(
                                  child: Text(
                                "Lưu",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                        ],
                      )
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
        ICONS.ICON_BACK,
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: HexColor("#BEB4B4"))),
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
              child: Center(child: Container(height: 50, width: 50, child: SvgPicture.asset("assets/icons/iconInputImg.svg"))),
            )
          ]),
        ),
      ],
    );
  }

  Widget _fieldInputCustomer(
    CustomerIndividualItemData data,
    int index,
    int index1, {
    bool noEdit = false,
    String value = "",
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: data.field_label ?? '',
              style: titlestyle(),
              children: <TextSpan>[
                data.field_require == 1 ? TextSpan(text: '*', style: TextStyle(fontFamily: "Roboto", fontSize: 12, fontWeight: FontWeight.w500, color: Colors.red)) : TextSpan(),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: noEdit == true ? COLORS.LIGHT_GREY : Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(color: HexColor("#BEB4B4"))),
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
                          : data.field_set_value != null
                              ? data.field_set_value.toString()
                              : null,
                  decoration: InputDecoration(hintStyle: hintTextStyle(), focusedBorder: InputBorder.none, enabledBorder: InputBorder.none, disabledBorder: InputBorder.none, isDense: true),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldInputTextMulti(List<List<dynamic>> dropdownItemList, String label, int required, int index, int index1, String value, String maxLength) {
    List<ModelDataAdd> dropdow = [];
    int indexDefault = -1;
    for (int i = 0; i < dropdownItemList.length; i++) {
      dropdow.add(ModelDataAdd(label: dropdownItemList[i][1], value: dropdownItemList[i][0]));
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
            text: TextSpan(
              text: label,
              style: TextStyle(fontFamily: "Roboto", fontSize: 12, fontWeight: FontWeight.w500, color: HexColor("#697077")),
              children: <TextSpan>[
                required == 1 ? TextSpan(text: '*', style: TextStyle(fontFamily: "Roboto", fontSize: 12, fontWeight: FontWeight.w500, color: Colors.red)) : TextSpan(),
              ],
            ),
          ),
          AppValue.vSpaceTiny,
          MultiSelectDialogField<ModelDataAdd>(
              items: dropdow.map((e) => MultiSelectItem(e, e.label ?? '')).toList(),
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) {
                if (maxLength != '' && values.length > int.parse(maxLength)) {
                  values.removeRange(int.parse(maxLength) - 1, values.length - 1);
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
                  values.removeRange(int.parse(maxLength) - 1, values.length - 1);
                }
              },
              title: WidgetText(
                title: label,
                style: AppStyle.DEFAULT_18_BOLD,
              ),
              buttonText: Text(
                label,
                style:  TextStyle(
                    fontSize: 14,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w500,
                    color: HexColor("#838A91")),
              ),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: HexColor("#BEB4B4"))),
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

  TextStyle hintTextStyle() => TextStyle(fontFamily: "Roboto", fontSize: 11, fontWeight: FontWeight.w500, color: HexColor("#838A91"));

  TextStyle titlestyle() => TextStyle(fontFamily: "Roboto", fontSize: 12, fontWeight: FontWeight.w500, color: HexColor("#697077"));

  void onClickSave() {
    final Map<String, dynamic> data = {};
    bool check = false;
    for (int i = 0; i < addData.length; i++) {
      for (int j = 0; j < addData[i].data.length; j++) {
        if ((addData[i].data[j].value == null || addData[i].data[j].value == "null" || addData[i].data[j].value == "") && addData[i].data[j].required == 1) {
          check = true;
          break;
        } else if (addData[i].data[j].value != null && addData[i].data[j].value != "null")
          data["${addData[i].data[j].label}"] = addData[i].data[j].value;
        else {
          data["${addData[i].data[j].label}"] = "";
        }
      }
    }
    if (check == true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WidgetDialog(
            title: MESSAGES.NOTIFICATION,
            content: "Hãy nhập đủ các trường bắt buộc (*)",
          );
        },
      );
    } else {
      if (listProduct.length > 0) {
        List product = [];
        for (int i = 0; i < listProduct.length; i++) {
          product.add({
            "id": listProduct[i].id,
            "price": listProduct[i].item.sell_price,
            "quantity": listProduct[i].soLuong,
            "vat": listProduct[i].item.vat,
            "unit": listProduct[i].item.dvt,
            "sale_off": {"value": listProduct[i].giamGia, "type": listProduct[i].typeGiamGia}
          });
        }
        data['products'] = product;
      }
      data['col311'] = data['col311']!=''?double.parse(data['col311']).toInt():'';
      AddDataBloc.of(context).add(AddContractEvent(data, files: fileUpload));
    }
  }

  Future<void> onDinhKem() async {
    ImagePicker picker = ImagePicker();
    XFile? result = await picker.pickImage(source: ImageSource.gallery, preferredCameraDevice: CameraDevice.rear);
    if (result != null) {
      fileUpload = File(result.path);
      AttackBloc.of(context).add(InitAttackEvent(file: File(result.path)));
    } else {
      // User canceled the picker
    }
  }
}
