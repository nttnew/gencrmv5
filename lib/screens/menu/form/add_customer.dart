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
import '../../../widgets/widget_input_date.dart';
import '../../../src/models/model_generator/add_customer.dart';
import '../../../widgets/pick_file_image.dart';
import '../../../src/src_index.dart';
import '../../../widgets/appbar_base.dart';
import '../../../widgets/field_input_select_multi.dart';
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
              style: AppStyle.DEFAULT_14W600,
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
