import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/form_add_data/add_data_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/form_add_data_bloc.dart';
import 'package:gen_crm/models/model_item_add.dart';
import 'package:gen_crm/screens/menu/home/customer/input_dropDown.dart';
import 'package:gen_crm/widgets/ky_nhan_widget.dart';
import 'package:gen_crm/widgets/widget_field_input_percent.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signature/signature.dart';
import '../../../../../../../src/models/model_generator/add_customer.dart';
import '../../../../../../../src/src_index.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../../../models/model_data_add.dart';
import '../../../../models/widget_input_date.dart';
import '../../../../src/pick_file_image.dart';

class FormAddSign extends StatefulWidget {
  const FormAddSign({Key? key}) : super(key: key);

  @override
  State<FormAddSign> createState() => _FormAddSignState();
}

class _FormAddSignState extends State<FormAddSign> {
  String title = Get.arguments[0];
  String id = Get.arguments[1] != null ? Get.arguments[1].toString() : "";
  List<ChuKyModelResponse> chuKyModelResponse = [];
  List data = [];
  List<ModelItemAdd> addData = [];
  late final ScrollController scrollController;
  late final BehaviorSubject<bool> isMaxScroll;
  static const String HD_YEU_CAU_XUAT = 'hd_yeu_cau_xuat';
  static const String DA_THU_TIEN = 'da_thu_tien';
  bool daThuTien = false;
  bool ycXuatHoaDon = false;
  double soTien = 0;

  @override
  void initState() {
    scrollController = ScrollController();
    isMaxScroll = BehaviorSubject.seeded(false);
    FormAddBloc.of(context).add(InitFormAddSignEvent(id));
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

  @override
  void dispose() {
    scrollController.dispose();
    isMaxScroll.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              toolbarHeight: AppValue.heights * 0.1,
              backgroundColor: HexColor("#D0F1EB"),
              title: WidgetText(
                  title: title.toUpperCase().capitalizeFirst,
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
                  ShowDialogCustom.showDialogBase(
                    title: MESSAGES.NOTIFICATION,
                    content: "Thêm mới dữ liệu thành công!",
                    onTap1: () {
                      Get.back();
                      Get.back();
                      GetListCustomerBloc.of(context)
                          .add(InitGetListOrderEvent("", 1, ""));
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
                    content: "Thêm mới dữ liệu thành công!",
                    onTap1: () {
                      Get.back();
                      Get.back();
                      //todo get data
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
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                    left: AppValue.widths * 0.05,
                    right: AppValue.widths * 0.05,
                    top: AppValue.heights * 0.02),
                color: Colors.white,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      BlocBuilder<FormAddBloc, FormAddState>(
                          builder: (context, state) {
                        if (state is LoadingFormAddCustomerOrState) {
                          addData = [];
                          data = [];
                          return Container();
                        } else if (state is SuccessFormAddCustomerOrState) {
                          soTien = state.soTien ?? 0;
                          for (int i = 0; i < state.listAddData.length; i++) {
                            if (addData.isNotEmpty) {
                            } else {
                              addData.add(ModelItemAdd(
                                  group_name:
                                      state.listAddData[i].group_name ?? '',
                                  data: []));
                              for (int j = 0;
                                  j < (state.listAddData[i].data?.length ?? 0);
                                  j++) {
                                addData[i].data.add(ModelDataAdd(
                                    parent:
                                        state.listAddData[i].data?[j].parent,
                                    label: state
                                        .listAddData[i].data?[j].field_name,
                                    value: state
                                        .listAddData[i].data?[j].field_set_value
                                        .toString(),
                                    required: state.listAddData[i].data?[j]
                                        .field_require));
                              }

                              if (state.chuKyResponse != null &&
                                  chuKyModelResponse.isEmpty) {
                                for (final ChuKyModelResponse value
                                    in (state.chuKyResponse?.first.data ??
                                        [])) {
                                  chuKyModelResponse.add(value);
                                }
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
                                    (index) => (state.listAddData[index].data !=
                                                null &&
                                            (state.listAddData[index].data
                                                        ?.length ??
                                                    0) >
                                                0)
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: AppValue.heights * 0.01,
                                              ),
                                              state.listAddData[index]
                                                          .group_name !=
                                                      null
                                                  ? WidgetText(
                                                      title: state
                                                              .listAddData[
                                                                  index]
                                                              .group_name ??
                                                          '',
                                                      style: AppStyle
                                                          .DEFAULT_18_BOLD)
                                                  : Container(),
                                              SizedBox(
                                                height: AppValue.heights * 0.01,
                                              ),
                                              Column(
                                                children: List.generate(
                                                    state.listAddData[index]
                                                            .data?.length ??
                                                        0,
                                                    (index1) => state
                                                                .listAddData[
                                                                    index]
                                                                .data![index1]
                                                                .field_hidden !=
                                                            "1"
                                                        ? _checkHide(state
                                                                .listAddData[
                                                                    index]
                                                                .data?[index1]
                                                                .parent)
                                                            ? (state.listAddData[index].data?[index1].field_special ??
                                                                        '') ==
                                                                    "none-edit"
                                                                ? _fieldInputCustomer(
                                                                    state.listAddData[index].data![
                                                                        index1],
                                                                    index,
                                                                    index1,
                                                                    noEdit:
                                                                        true)
                                                                : state.listAddData[index].data![index1]
                                                                            .field_type ==
                                                                        "SELECT"
                                                                    ? InputDropdown(
                                                                        dropdownItemList: state.listAddData[index].data![index1].field_datasource ?? [],
                                                                        data: state.listAddData[index].data![index1],
                                                                        onSuccess: (data) {
                                                                          addData[index]
                                                                              .data[index1]
                                                                              .value = data;
                                                                        },
                                                                        value: state.listAddData[index].data![index1].field_set_value_datasource?[0][1] ?? '')
                                                                    : state.listAddData[index].data![index1].field_type == "TEXT_MULTI"
                                                                        ? _fieldInputTextMulti(state.listAddData[index].data![index1].field_datasource!, state.listAddData[index].data![index1].field_label!, state.listAddData[index].data![index1].field_require!, index, index1, (state.listAddData[index].data![index1].field_set_value_datasource != "" && state.listAddData[index].data![index1].field_set_value_datasource != null) ? state.listAddData[index].data![index1].field_set_value_datasource![0][0].toString() : "", state.listAddData[index].data![index1].field_maxlength ?? '')
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
                                                                                          addData[index].data[index1].value = (date.millisecondsSinceEpoch / 1000).floor();
                                                                                        },
                                                                                        onInit: () {
                                                                                          DateTime date = DateTime.now();
                                                                                          addData[index].data[index1].value = (date.millisecondsSinceEpoch / 1000).floor();
                                                                                        },
                                                                                      )
                                                                                    : state.listAddData[index].data![index1].field_type == "CHECK"
                                                                                        ? RenderCheckBox(
                                                                                            onChange: (check) {
                                                                                              addData[index].data[index1].value = check ? 1 : 0;
                                                                                            },
                                                                                            data: state.listAddData[index].data![index1],
                                                                                          )
                                                                                        : state.listAddData[index].data![index1].field_type == "PERCENTAGE"
                                                                                            ? FieldInputPercent(
                                                                                                data: state.listAddData[index].data![index1],
                                                                                                onChanged: (text) {
                                                                                                  addData[index].data[index1].value = text;
                                                                                                },
                                                                                              )
                                                                                            : state.listAddData[index].data![index1].field_type == "SWITCH"
                                                                                                ? SwitchBase(
                                                                                                    isHide: soTien == 0 && state.listAddData[index].data![index1].field_id == '13588',
                                                                                                    onChange: (check) {
                                                                                                      if (state.listAddData[index].data![index1].field_id == '13588') {
                                                                                                        daThuTien = check;
                                                                                                      } else if (state.listAddData[index].data![index1].field_id == '13590') {
                                                                                                        ycXuatHoaDon = check;
                                                                                                      }
                                                                                                      setState(() {});
                                                                                                      addData[index].data[index1].value = check;
                                                                                                    },
                                                                                                    data: state.listAddData[index].data![index1],
                                                                                                  )
                                                                                                : _fieldInputCustomer(state.listAddData[index].data![index1], index, index1, value: state.listAddData[index].data![index1].field_id == '13620' ? soTien.toInt().toString() : '')
                                                            : SizedBox()
                                                        : SizedBox()),
                                              )
                                            ],
                                          )
                                        : Container()),
                              ),
                              _signatureUi(state.chuKyResponse),
                              SizedBox(
                                height: AppValue.widths * 0.1 + 10,
                              )
                            ],
                          );
                        } else
                          return Container();
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
                    color: Colors.white,
                    height: AppValue.widths * 0.1 + 10,
                    width: AppValue.widths,
                    padding: EdgeInsets.only(
                        left: AppValue.widths * 0.05,
                        right: AppValue.widths * 0.05,
                        bottom: 5),
                    child: FileLuuBase(
                      context,
                      () => onClickSave(),
                      isAttack: false,
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }

  bool _checkHide(String? parent) {
    if (parent != null) {
      if (parent == DA_THU_TIEN && daThuTien) {
        if (soTien != 0) {
          return true;
        } else {
          return false;
        }
      } else if (parent == HD_YEU_CAU_XUAT && ycXuatHoaDon) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
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

  Widget _signatureUi(List<ChuKyResponse>? chuKyResponse) {
    if (chuKyResponse != null) {
      return Column(
        children: chuKyResponse
            .map(
              (e) => Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: AppValue.heights * 0.01,
                    ),
                    e.group_name != null
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: WidgetText(
                                title: e.group_name ?? '',
                                style: AppStyle.DEFAULT_18_BOLD),
                          )
                        : Container(),
                    SizedBox(
                      height: AppValue.heights * 0.01,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: e.data?.length,
                        itemBuilder: (context, index) =>
                            _signature(e.data?[index], (v) {
                              chuKyModelResponse[index] = v;
                            })),
                  ],
                ),
              ),
            )
            .toList(),
      );
    }

    return SizedBox();
  }

  Widget _signature(
    ChuKyModelResponse? dataSign,
    Function(ChuKyModelResponse) onData,
  ) {
    BehaviorSubject<String> dataStream = BehaviorSubject.seeded('');
    List<Point>? listPoint;
    return Column(
      children: [
        if (dataSign?.chuky == null)
          GestureDetector(
            onTap: () async {
              final data = await ShowDialogCustom.showDialogScreenBase(
                child: KyNhan(
                  data: dataSign,
                  listPoint: listPoint,
                ),
              );
              if (data != null) {
                dataStream.add(data[0].chuky);
                onData(data[0]);
                listPoint = data[1];
              }
            },
            child: StreamBuilder<String>(
              stream: dataStream,
              builder: (context, snapshot) {
                final data = snapshot.data ?? '';
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      border: Border.all(color: COLORS.TEXT_COLOR),
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  height: 300,
                  padding: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width,
                  child: Image.memory(
                    base64Decode(data),
                    errorBuilder: (_, __, ___) {
                      return Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: WidgetText(
                            title: 'Click để thực hiện ký',
                            style: AppStyle.DEFAULT_14.copyWith(
                              color: COLORS.TEXT_COLOR,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        if (dataSign?.chuky != null)
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: HexColor("#BEB4B4")),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            height: 300,
            // padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: Html(shrinkWrap: true, data: dataSign?.chuky, style: {
              "img": Style(),
            })),
          ),
        SizedBox(
          height: AppValue.heights * 0.005,
        ),
        WidgetText(
            title: dataSign?.nhanhienthi ?? '',
            style: AppStyle.DEFAULT_16_BOLD),
        SizedBox(
          height: AppValue.heights * 0.02,
        ),
      ],
    );
  }

  Widget _fieldInputCustomer(
      CustomerIndividualItemData data, int index, int index1,
      {bool noEdit = false, String value = ""}) {
    if (data.field_id == '13620' && addData[index].data[index1].value == null ||
        addData[index].data[index1].value == '' ||
        addData[index].data[index1].value == 'null') {
      addData[index].data[index1].value = value;
    }
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
                          : data.field_set_value != null
                              ? data.field_set_value.toString()
                              : null,
                  decoration: InputDecoration(
                    hintStyle: hintTextStyle(),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ),
          ),
          if (data.field_id == '13620') ...[
            SizedBox(
              height: 8,
            ),
            RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                text: 'Chưa thanh toán:',
                style: titlestyle(),
                children: <TextSpan>[
                  TextSpan(
                      text: " ${AppValue.format_money(soTien.toString())}",
                      style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: COLORS.TEXT_COLOR)),
                ],
              ),
            ),
          ]
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
                    content: "Bạn chỉ được chọn ${maxLength} giá trị",
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
              searchable: true,
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
              selectedItemsTextStyle: AppStyle.DEFAULT_14,
              itemsTextStyle: AppStyle.DEFAULT_14),
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
      fontSize: 14,
      fontFamily: "Quicksand",
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
            addData[i].data[j].value != "null") {
          if (_checkHide(addData[i].data[j].parent)) {
            data["${addData[i].data[j].label}"] = addData[i].data[j].value;
          }
        } else {
          data["${addData[i].data[j].label}"] = "";
        }
      }
    }
    final isCheckMoney = double.parse(
            data["hd_so_tien"] != '' && data["hd_so_tien"] != null
                ? data["hd_so_tien"]
                : '0') >
        soTien;
    if (isCheckMoney) {
      check = true;
    }

    if (chuKyModelResponse.isNotEmpty) {
      final chukys = [];
      for (final value in chuKyModelResponse) {
        if (value.chuky != null) {
          if (value.id == null) {
            final Map<String, dynamic> map = {};
            if (value.chuky.toString().contains('data:image/png;base64,')) {
              map['chuky'] = value.chuky.toString();
            } else {
              map['chuky'] = 'data:image/png;base64,' + value.chuky.toString();
            }
            map['doituong'] = value.doituongky;
            map['hop_dong'] = id;
            chukys.add(map);
          }
        } else {
          check = true;
          break;
        }
      }
      data['chuky'] = chukys;
    }

    data["id"] = id;

    //
    if (check == true) {
      ShowDialogCustom.showDialogBase(
        title: MESSAGES.NOTIFICATION,
        content: isCheckMoney
            ? "Số tiền không được lớn hơn số tiền chưa thanh toán"
            : "Hãy nhập đủ các trường bắt buộc (*)",
      );
    } else {
      AddDataBloc.of(context).add(SignEvent(data));
    }
  }
}

class WidgetInputMulti extends StatefulWidget {
  WidgetInputMulti({Key? key, required this.data, required this.onSelect})
      : super(key: key);

  final CustomerIndividualItemData data;
  final Function onSelect;

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
    if (widget.data.field_set_value != null)
      arr = widget.data.field_set_value.toString().split(',');
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  keyboardType: widget.data.field_special == "default"
                      ? TextInputType.text
                      : widget.data.field_special == "numberic"
                          ? TextInputType.number
                          : widget.data.field_special == "email-address"
                              ? TextInputType.emailAddress
                              : TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        widget.data.field_maxlength != null
                            ? int.parse(widget.data.field_maxlength!)
                            : null),
                  ],
                  maxLengthEnforcement:
                      MaxLengthEnforcement.truncateAfterCompositionEnds,
                  decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      isDense: true),
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
                                // overflow: Overflow.visible,
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(
                                          top: 3, bottom: 3, left: 8, right: 8),
                                      // margin: EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: COLORS.BACKGROUND),
                                      child: WidgetText(
                                        title: arr[index],
                                        style: AppStyle.DEFAULT_14,
                                      )),
                                  Positioned(
                                    top: -13,
                                    right: -8,
                                    child: InkWell(
                                        onTap: () {
                                          arr.removeAt(index);
                                          setState(() {
                                            check = !check;
                                          });
                                          widget.onSelect(arr);
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          padding: EdgeInsets.all(5),
                                          child: WidgetText(
                                            title: "x",
                                            style: AppStyle.DEFAULT_16,
                                          ),
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

class RenderCheckBox extends StatefulWidget {
  RenderCheckBox({Key? key, required this.onChange, required this.data})
      : super(key: key);

  Function? onChange;
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
                            color: Colors.red))
                    : TextSpan(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SwitchBase extends StatefulWidget {
  const SwitchBase({
    Key? key,
    required this.data,
    required this.onChange,
    required this.isHide,
  }) : super(key: key);
  final Function onChange;
  final CustomerIndividualItemData data;
  final bool isHide;

  @override
  State<SwitchBase> createState() => _SwitchBaseState();
}

class _SwitchBaseState extends State<SwitchBase> {
  late bool isCheck;
  @override
  void initState() {
    isCheck = (widget.data.field_set_value ?? 0) == 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: RichText(
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
                              color: Colors.red))
                      : TextSpan(),
                ],
              ),
            ),
          ),
          Switch(
            activeColor: (widget.isHide) ? COLORS.GREY : null,
            value: (widget.isHide) ? (widget.isHide) : isCheck,
            onChanged: (value) {
              if (!widget.isHide) {
                isCheck = value;
                widget.onChange(value);
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }
}
