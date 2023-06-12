import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/add_customer/add_customer_bloc.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/contract/attack_bloc.dart';
import 'package:gen_crm/models/model_data_add.dart';
import 'package:gen_crm/models/model_item_add.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../models/widget_input_date.dart';
import '../../../src/models/model_generator/add_customer.dart';
import '../../../src/pick_file_image.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../../src/src_index.dart';
import '../../../widgets/appbar_base.dart';
import '../../../widgets/multiple_widget.dart';
import '../../../widgets/widget_field_input_percent.dart';
import '../home/customer/widget/input_dropDown.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({Key? key}) : super(key: key);

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  List data = [];
  List<ModelItemAdd> addData = [];
  late StreamSubscription<bool> keyboardSubscription;
  String title = Get.arguments[0] ?? '';
  bool isResultData = Get.arguments[1];

  @override
  void initState() {
    AttackBloc.of(context).add(LoadingAttackEvent());
    AddCustomerBloc.of(context).add(InitGetAddCustomerEvent(1));
    super.initState();
  }

  @override
  void deactivate() {
    AttackBloc.of(context).add(RemoveAllAttackEvent());
    super.deactivate();
  }

  @override
  void dispose() {
    data = [];
    addData = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarBaseNormal(title),
        body: BlocListener<GetListCustomerBloc, CustomerState>(
          listener: (context, state) async {
            if (state is SuccessAddCustomerIndividualState) {
              ShowDialogCustom.showDialogBase(
                title: MESSAGES.NOTIFICATION,
                content: "Thêm mới dữ liệu thành công!",
                onTap1: () {
                  Get.back();
                  if (isResultData) {
                    Get.back(result: state.result);
                  } else {
                    Get.back();
                  }
                  GetListCustomerBloc.of(context).add(InitGetListOrderEvent());
                },
              );
            }
            if (state is ErrorAddCustomerIndividualState) {
              ShowDialogCustom.showDialogBase(
                title: MESSAGES.NOTIFICATION,
                content: state.message,
              );
            }
          },
          child: Container(
            margin: EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: BlocBuilder<AddCustomerBloc, AddCustomerState>(
                  builder: (context, state) {
                if (state is LoadingAddCustomerState) {
                  data = [];
                  addData = [];
                  return Container();
                } else if (state is UpdateGetAddCustomerState) {
                  if (addData.isEmpty)
                    for (int i = 0; i < state.listAddData.length; i++) {
                      addData.add(ModelItemAdd(
                          group_name: state.listAddData[i].group_name ?? '',
                          data: []));
                      for (int j = 0;
                          j < state.listAddData[i].data!.length;
                          j++) {
                        addData[i].data.add(ModelDataAdd(
                            label: state.listAddData[i].data![j].field_name,
                            value: state.listAddData[i].data![j].field_set_value
                                .toString(),
                            required:
                                state.listAddData[i].data![j].field_require));
                      }
                    }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            state.listAddData.length,
                            (indexParent) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: AppValue.heights * 0.01,
                                    ),
                                    state.listAddData[indexParent].group_name !=
                                            null
                                        ? WidgetText(
                                            title: state
                                                    .listAddData[indexParent]
                                                    .group_name ??
                                                '',
                                            style: AppStyle.DEFAULT_18_BOLD)
                                        : Container(),
                                    SizedBox(
                                      height: AppValue.heights * 0.01,
                                    ),
                                    Column(
                                      children: List.generate(
                                          state.listAddData[indexParent].data
                                                  ?.length ??
                                              0,
                                          (indexChild) => _getBody(
                                                state.listAddData[indexParent]
                                                    .data![indexChild],
                                                indexParent,
                                                indexChild,
                                              )),
                                    )
                                  ],
                                )),
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
      CustomerIndividualItemData data, int indexParent, int indexChild) {
    return data.field_hidden != "1"
        ? data.field_type == "SELECT"
            ? InputDropdown(
                dropdownItemList: data.field_datasource ?? [],
                data: data,
                onSuccess: (data) {
                  addData[indexParent].data[indexChild].value = data;
                },
                value: data.field_value ?? '')
            : data.field_type == "TEXT_MULTI"
                ? _fieldInputTextMulti(
                    data.field_datasource!,
                    data.field_label!,
                    data.field_require!,
                    indexParent,
                    indexChild,
                    (data.field_set_value_datasource != '' &&
                            data.field_set_value_datasource != null)
                        ? data.field_set_value_datasource![0][0].toString()
                        : "",
                    data.field_maxlength ?? '')
                : data.field_type == "HIDDEN"
                    ? Container()
                    : data.field_type == "TEXT_MULTI_NEW"
                        ? InputMultipleWidget(
                            data: data,
                            onSelect: (data) {
                              addData[indexParent].data[indexChild].value =
                                  data.join(",");
                            })
                        : data.field_type == "DATE"
                            ? WidgetInputDate(
                                data: data,
                                dateText: data.field_set_value,
                                onSelect: (int date) {
                                  addData[indexParent].data[indexChild].value =
                                      date;
                                },
                                onInit: (v) {
                                  addData[indexParent].data[indexChild].value =
                                      v;
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
                                : data.field_type == "PERCENTAGE"
                                    ? FieldInputPercent(
                                        data: data,
                                        onChanged: (text) {
                                          addData[indexParent]
                                              .data[indexChild]
                                              .value = text;
                                        },
                                      )
                                    : _fieldInputCustomer(
                                        data, indexParent, indexChild)
        : SizedBox();
  }

  Widget _fieldInputCustomer(
      CustomerIndividualItemData data, int indexParent, int indexChild) {
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
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: HexColor("#BEB4B4"))),
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
              child: Container(
                child: TextField(
                  minLines: data.field_type == 'TEXTAREA' ? 2 : 1,
                  maxLines: data.field_type == 'TEXTAREA' ? 6 : 1,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  keyboardType: data.field_special == "default"
                      ? TextInputType.text
                      : data.field_special == "numberic"
                          ? TextInputType.number
                          : data.field_special == "email-address"
                              ? TextInputType.emailAddress
                              : TextInputType.text,
                  onChanged: (text) {
                    addData[indexParent].data[indexChild].value = text;
                  },
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
      if (dropdownItemList[i][1] != null && dropdownItemList[i][0] != null) {
        dropdow.add(ModelDataAdd(
            label: dropdownItemList[i][1], value: dropdownItemList[i][0]));
        if (dropdownItemList[i][0].toString() == value) {
          indexParentDefault = i;
        }
      }
    }
    return (Container(
      key: Key(indexChild.toString()),
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
                  fontWeight: FontWeight.w600,
                  color: COLORS.BLACK),
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
            items:
                dropdow.map((e) => MultiSelectItem(e, e.label ?? '')).toList(),
            listType: MultiSelectListType.CHIP,
            onConfirm: (values) {
              if (maxLength != "" && values.length > int.parse(maxLength)) {
                values.removeRange(int.parse(maxLength) - 1, values.length - 1);
                ShowDialogCustom.showDialogBase(
                  title: MESSAGES.NOTIFICATION,
                  content: "Bạn chỉ được chọn ${maxLength} giá trị",
                );
              } else {
                List<dynamic> res = [];
                for (int i = 0; i < values.length; i++) {
                  res.add(values[i].value!);
                }
                addData[indexParent].data[indexChild].value = res.join(",");
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
              style: titlestyleNgTheoDoi(),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: HexColor("#BEB4B4"))),
            buttonIcon: Icon(
              Icons.arrow_drop_down,
              size: 25,
            ),
            initialValue:
                indexParentDefault != -1 ? [dropdow[indexParentDefault]] : [],
            selectedItemsTextStyle: AppStyle.DEFAULT_14,
          )
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
      fontWeight: FontWeight.w600,
      color: COLORS.BLACK);

  TextStyle titlestyleNgTheoDoi() => TextStyle(
      fontFamily: "Quicksand",
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: COLORS.BLACK);

  void onClickSave() {
    final Map<String, dynamic> data = {};
    bool check = false;
    for (int i = 0; i < addData.length; i++) {
      for (int j = 0; j < addData[i].data.length; j++) {
        if ((addData[i].data[j].value == null ||
                addData[i].data[j].value == "null" ||
                addData[i].data[j].value == "") &&
            addData[i].data[j].required == 1) {
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
    if (check == true) {
      ShowDialogCustom.showDialogBase(
        title: MESSAGES.NOTIFICATION,
        content: "Hãy nhập đủ các trường bắt buộc (*)",
      );
    } else {
      GetListCustomerBloc.of(context).add(AddCustomerIndividualEvent(data,
          files: AttackBloc.of(context).listFile));
    }
  }
}
