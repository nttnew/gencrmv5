import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/bloc/add_customer/add_customer_bloc.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/contract/attack_bloc.dart';
import 'package:gen_crm/models/model_data_add.dart';
import 'package:gen_crm/models/model_item_add.dart';
import 'package:gen_crm/screens/menu/home/customer/data_dropdown_item.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../models/widget_input_date.dart';
import '../../../../src/models/model_generator/add_customer.dart';
import '../../../../src/src_index.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../../../widgets/widgetFieldInputPercent.dart';
import '../../../../widgets/widget_dialog.dart';
import 'input_dropDown.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({Key? key}) : super(key: key);

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  List data = [];
  List<ModelItemAdd> addData = [];
  late StreamSubscription<bool> keyboardSubscription;
  File? fileUpload;

  @override
  void initState() {
    AttackBloc.of(context).add(LoadingAttackEvent());
    AddCustomerBloc.of(context).add(InitGetAddCustomerEvent(1));
    // var keyboardVisibilityController = KeyboardVisibilityController();
    //
    // // Subscribe
    // keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
    //   if(visible==true)
    //
    // });
    super.initState();
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
        appBar: AppBar(
          toolbarHeight: AppValue.heights * 0.1,
          backgroundColor: HexColor("#D0F1EB"),
          title: Text("Th??m kh??ch h??ng c?? nh??n", style: TextStyle(color: Colors.black, fontFamily: "Montserrat", fontWeight: FontWeight.w700, fontSize: 16)),
          leading: _buildBack(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
        ),
        body: BlocListener<GetListCustomerBloc, CustomerState>(
          listener: (context, state) async {
            if (state is SuccessAddCustomerIndividualState) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return WidgetDialog(
                    title: MESSAGES.NOTIFICATION,
                    content: "Th??m m???i d??? li???u th??nh c??ng!",
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
            if (state is ErrorAddCustomerIndividualState) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return WidgetDialog(
                    title: MESSAGES.NOTIFICATION,
                    content: state.message,
                  );
                },
              );
            }
          },
          child: Container(
            margin: EdgeInsets.only(left: AppValue.widths * 0.05, right: AppValue.widths * 0.05, top: AppValue.heights * 0.02),
            child: SingleChildScrollView(
              child: BlocBuilder<AddCustomerBloc, AddCustomerState>(builder: (context, state) {
                if (state is LoadingAddCustomerState) {
                  data = [];
                  addData = [];
                  return Container();
                } else if (state is UpdateGetAddCustomerState) {
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
                            (index) => Column(
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
                                          (index1) => state.listAddData[index].data![index1].field_type == "SELECT"
                                              ? InputDropdown(
                                                  dropdownItemList: state.listAddData[index].data![index1].field_datasource ?? [],
                                                  data: state.listAddData[index].data![index1],
                                                  onSuccess: (data) {
                                                    addData[index].data[index1].value = data;
                                                  },
                                                  value: state.listAddData[index].data![index1].field_value ?? '')
                                              : state.listAddData[index].data![index1].field_type == "TEXT_MULTI"
                                                  ? _fieldInputTextMulti(state.listAddData[index].data![index1].field_datasource!, state.listAddData[index].data![index1].field_label!, state.listAddData[index].data![index1].field_require!, index, index1, (state.listAddData[index].data![index1].field_set_value_datasource != '' && state.listAddData[index].data![index1].field_set_value_datasource != null) ? state.listAddData[index].data![index1].field_set_value_datasource![0][0].toString() : "",
                                                      state.listAddData[index].data![index1].field_maxlength ?? '')
                                                  : state.listAddData[index].data![index1].field_type == "HIDDEN"
                                                      ? Container()
                                                      : state.listAddData[index].data![index1].field_type == "TEXT_MULTI_NEW"
                                                          ? WidgetInputMulti(
                                                              data: state.listAddData[index].data![index1],
                                                              onSelect: (data) {
                                                                addData[index].data[index1].value = data.join(",");
                                                              })
                                                          : state.listAddData[index].data![index1].field_type == "DATE"
                                                              ? WidgetInputDate(
                                                                  data: state.listAddData[index].data![index1],
                                                                  onSelect: (date) {
                                                                    addData[index].data[index1].value = (date.millisecondsSinceEpoch / 1000).floor();
                                                                  },
                                                                  onInit: () {
                                                                    DateTime date = DateTime.now();
                                                                    addData[index].data[index1].value = (date.millisecondsSinceEpoch / 1000).floor();
                                                                  },
                                                                )
                                                              : state.listAddData[index].data![index1].field_type == "PERCENTAGE"
                                                                  ? FieldInputPercent(
                                                                      data: state.listAddData[index].data![index1],
                                                                      onChanged: (text) {
                                                                        addData[index].data[index1].value = text;
                                                                      },
                                                                    )
                                                                  : _fieldInputCustomer(state.listAddData[index].data![index1], index, index1)),
                                    )
                                  ],
                                )),
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
                                "L??u",
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
          "H??nh ???nh",
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
                    hintText: "T???i h??nh ???nh",
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

  Widget _fieldInputCustomerType(List<List<dynamic>> dropdownItemList, String label, Function onSuccess, String value, int index1) {
    List dropdow = [];
    int indexDefault = -1;
    for (int i = 0; i < dropdownItemList.length; i++) {
      if (dropdownItemList[i][1] != null && dropdownItemList[i][0] != null) {
        dropdow.add({'label': dropdownItemList[i][1], 'value': dropdownItemList[i][0]});
        if (dropdownItemList[i][1] == value) {
          indexDefault = i;
        }
      }
    }

    return Container(
      // key: Key(index1.toString()),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetText(
            title: label,
            style: titlestyle(),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  enableDrag: false,
                  isScrollControlled: true,
                  context: context,
                  constraints: BoxConstraints(maxHeight: Get.height * 0.75, minWidth: Get.width),
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: DataDropDownItem(
                        data: dropdow,
                        onSuccess: onSuccess,
                      ),
                    );
                  });
            },
            child: Container(
                width: double.infinity,
                // height: AppValue.heights * 0.05,
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(5),
                //     border: Border.all(color: HexColor("#BEB4B4"))),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: HexColor("#BEB4B4"))),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: WidgetText(
                              title: value,
                              maxLine: 1,
                              style: TextStyle(fontSize: 11, fontFamily: "Roboto", fontWeight: FontWeight.w500, color: HexColor("#838A91")),
                            ),
                          ),
                          Container(
                            child: Icon(
                              Icons.arrow_drop_down,
                              size: 25,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _fieldInputCustomer(CustomerIndividualItemData data, int index, int index1) {
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: HexColor("#BEB4B4"))),
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
              child: Container(
                child: TextField(
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                  keyboardType: data.field_special == "default"
                      ? TextInputType.text
                      : data.field_special == "numberic"
                          ? TextInputType.number
                          : data.field_special == "email-address"
                              ? TextInputType.emailAddress
                              : TextInputType.text,
                  onChanged: (text) {
                    addData[index].data[index1].value = text;
                  },
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
    // List valueDefault=value.split(",");
    int indexDefault = -1;
    for (int i = 0; i < dropdownItemList.length; i++) {
      if (dropdownItemList[i][1] != null && dropdownItemList[i][0] != null) {
        print("value=${value} data=${dropdownItemList[i][0]}");
        dropdow.add(ModelDataAdd(label: dropdownItemList[i][1], value: dropdownItemList[i][0]));
        if (dropdownItemList[i][0].toString() == value) {
          indexDefault = i;
        }
      }
    }
    return (Container(
      key: Key(index1.toString()),
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
              if (maxLength != "" && values.length > int.parse(maxLength)) {
                values.removeRange(int.parse(maxLength) - 1, values.length - 1);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return WidgetDialog(
                      title: MESSAGES.NOTIFICATION,
                      content: "B???n ch??? ???????c ch???n ${maxLength} gi?? tr???",
                    );
                  },
                );
              } else {
                List<dynamic> res = [];
                for (int i = 0; i < values.length; i++) {
                  res.add(values[i].value!);
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
              style: titlestyle(),
            ),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: HexColor("#BEB4B4"))),
            buttonIcon: Icon(
              Icons.arrow_drop_down,
              size: 25,
            ),
            initialValue: indexDefault != -1 ? [dropdow[indexDefault]] : [],
            selectedItemsTextStyle: AppStyle.DEFAULT_12,
          )
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
            content: "H??y nh???p ????? c??c tr?????ng b???t bu???c (*)",
          );
        },
      );
    } else {
      GetListCustomerBloc.of(context).add(AddCustomerIndividualEvent(data, files: fileUpload));
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

class WidgetInputMulti extends StatefulWidget {
  WidgetInputMulti({Key? key, required this.data, required this.onSelect}) : super(key: key);

  final CustomerIndividualItemData data;
  Function onSelect;

  @override
  State<WidgetInputMulti> createState() => _WidgetInputMultiState();
}

class _WidgetInputMultiState extends State<WidgetInputMulti> {
  List<String> arr = [];
  TextEditingController _editingController = TextEditingController();
  bool check = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: widget.data.field_label ?? '',
              style: TextStyle(fontFamily: "Roboto", fontSize: 12, fontWeight: FontWeight.w500, color: HexColor("#697077")),
              children: <TextSpan>[
                widget.data.field_require == 1 ? TextSpan(text: '*', style: TextStyle(fontFamily: "Roboto", fontSize: 12, fontWeight: FontWeight.w500, color: Colors.red)) : TextSpan(),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: HexColor("#BEB4B4"))),
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
              child: Focus(
                onFocusChange: (status) {
                  if (status == false) {
                    if (_editingController.text != "") {
                      arr.add(_editingController.text);
                      widget.onSelect(arr);
                      setState(() {
                        check = !check;
                      });
                    }
                    _editingController.text = "";
                    _focusNode.unfocus();
                  }
                },
                child: TextField(
                  controller: _editingController,
                  onEditingComplete: () {
                    if (_editingController.text != "") {
                      arr.add(_editingController.text);
                      widget.onSelect(arr);
                      setState(() {
                        check = !check;
                      });
                    }
                    _editingController.text = "";
                    _focusNode.unfocus();
                  },
                  focusNode: _focusNode,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                  keyboardType: widget.data.field_special == "default"
                      ? TextInputType.text
                      : widget.data.field_special == "numberic"
                          ? TextInputType.number
                          : widget.data.field_special == "email-address"
                              ? TextInputType.emailAddress
                              : TextInputType.text,
                  // maxLength:widget.data.field_maxlength!=null? int.parse(widget.data.field_maxlength!):null,
                  // maxLengthEnforcement: MaxLengthEnforcement.none,123123
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(widget.data.field_maxlength != null ? int.parse(widget.data.field_maxlength!) : null),
                  ],
                  maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                  decoration: InputDecoration(focusedBorder: InputBorder.none, enabledBorder: InputBorder.none, disabledBorder: InputBorder.none, isDense: true),
                ),
              ),
            ),
          ),
          arr.length > 0
              ? Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: List.generate(
                        arr.length,
                        (index) => Container(
                              margin: EdgeInsets.only(right: 8),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
                                      // margin: EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: COLORS.BACKGROUND),
                                      child: WidgetText(
                                        title: arr[index],
                                        style: AppStyle.DEFAULT_12,
                                      )),
                                  Positioned(
                                    top: -8,
                                    right: -3,
                                    child: GestureDetector(
                                        onTap: () {
                                          arr.removeAt(index);
                                          setState(() {
                                            check = !check;
                                          });
                                        },
                                        child: WidgetText(
                                          title: "x",
                                          style: AppStyle.DEFAULT_16,
                                        )),
                                  )
                                ],
                              ),
                            )),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
