import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/form_add_data/add_data_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/form_add_data_bloc.dart';
import 'package:gen_crm/models/model_item_add.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/input_dropDown.dart';
import 'package:gen_crm/widgets/appbar_base.dart';
import 'package:gen_crm/widgets/ky_nhan_widget.dart';
import 'package:gen_crm/widgets/widget_field_input_percent.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signature/signature.dart';
import '../../../../../../src/models/model_generator/add_customer.dart';
import '../../../../../../src/src_index.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../../models/model_data_add.dart';
import '../../../models/widget_input_date.dart';
import '../../../src/pick_file_image.dart';
import '../../../widgets/multiple_widget.dart';

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
  late final BehaviorSubject<int> starStream;
  late final FormAddBloc _bloc;
  bool daThuTien = false;
  bool ycXuatHoaDon = false;
  bool editStar = false;
  double soTien = 0;

  @override
  void initState() {
    _bloc = FormAddBloc(userRepository: FormAddBloc.of(context).userRepository);

    starStream = BehaviorSubject.seeded(-1);
    scrollController = ScrollController();
    isMaxScroll = BehaviorSubject.seeded(false);
    _bloc.add(InitFormAddSignEvent(id));
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
  void deactivate() {
    starStream.add(-1);
    _bloc.add(ResetDataEvent());
    super.deactivate();
  }

  @override
  void dispose() {
    scrollController.dispose();
    isMaxScroll.close();
    starStream.close();
    super.dispose();
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
                    title: MESSAGES.NOTIFICATION,
                    content: "Thêm mới dữ liệu thành công!",
                    onTap1: () {
                      Get.back();
                      Get.back();
                      GetListCustomerBloc.of(context)
                          .add(InitGetListOrderEvent());
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
                padding: EdgeInsets.all(25),
                color: Colors.white,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      BlocBuilder<FormAddBloc, FormAddState>(
                          bloc: _bloc,
                          builder: (context, state) {
                            if (state is LoadingFormAddCustomerOrState) {
                              addData = [];
                              data = [];
                              return Container();
                            } else if (state is SuccessFormAddCustomerOrState) {
                              soTien = state.soTien ?? 0;
                              if (addData.isEmpty) {
                                for (int i = 0;
                                    i < state.listAddData.length;
                                    i++) {
                                  addData.add(ModelItemAdd(
                                      group_name:
                                          state.listAddData[i].group_name ?? '',
                                      data: []));
                                  for (int j = 0;
                                      j <
                                          (state.listAddData[i].data?.length ??
                                              0);
                                      j++) {
                                    addData[i].data.add(ModelDataAdd(
                                          parent: state
                                              .listAddData[i].data?[j].parent,
                                          label: state.listAddData[i].data?[j]
                                              .field_name,
                                          value: state.listAddData[i].data?[j]
                                              .field_set_value
                                              .toString(),
                                          required: state.listAddData[i]
                                              .data?[j].field_require,
                                        ));
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
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: state.listAddData.length,
                                    itemBuilder: (context, indexParent) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 25,
                                          ),
                                          if (state.listAddData[indexParent]
                                                  .group_name !=
                                              null)
                                            WidgetText(
                                              title: state
                                                      .listAddData[indexParent]
                                                      .group_name ??
                                                  '',
                                              style: AppStyle.DEFAULT_18_BOLD,
                                            ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          _itemField(
                                            state.listAddData[indexParent]
                                                    .data ??
                                                [],
                                            indexParent,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  _signatureUi(state.chuKyResponse),
                                  SizedBox(
                                    height: 25,
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

  Widget _itemField(List<CustomerIndividualItemData> list, int indexParent) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: list.length,
        itemBuilder: (context, indexChild) {
          final dataFiled = list[indexChild];
          return dataFiled.field_hidden != "1"
              ? _checkHide(dataFiled.parent)
                  ? (dataFiled.field_special ?? '') == "none-edit"
                      ? _fieldInputCustomer(dataFiled, indexParent, indexChild,
                          noEdit: true)
                      : dataFiled.field_type == "SELECT"
                          ? InputDropdown(
                              dropdownItemList:
                                  dataFiled.field_datasource ?? [],
                              data: dataFiled,
                              onSuccess: (data) {
                                addData[indexParent].data[indexChild].value =
                                    data;
                              },
                              value: (dataFiled.field_set_value_datasource
                                          ?.isNotEmpty ??
                                      false)
                                  ? (dataFiled.field_set_value_datasource?[0]
                                          [1] ??
                                      '')
                                  : '',
                            )
                          : dataFiled.field_type == "TEXT_MULTI"
                              ? _fieldInputTextMulti(
                                  dataFiled.field_datasource ?? [],
                                  dataFiled.field_label ?? '',
                                  dataFiled.field_require ?? 0,
                                  indexParent,
                                  indexChild,
                                  dataFiled.field_set_value_datasource?[0][0].toString() ??
                                      '',
                                  dataFiled.field_maxlength ?? '')
                              : dataFiled.field_type == "HIDDEN"
                                  ? Container()
                                  : dataFiled.field_type == "TEXT_MULTI_NEW"
                                      ? InputMultipleWidget(
                                          data: dataFiled,
                                          onSelect: (data) {
                                            addData[indexParent]
                                                .data[indexChild]
                                                .value = data.join(",");
                                          },
                                        )
                                      : dataFiled.field_type == "DATE"
                                          ? WidgetInputDate(
                                              data: dataFiled,
                                              dateText:
                                                  dataFiled.field_set_value,
                                              onSelect: (DateTime date) {
                                                addData[indexParent]
                                                    .data[indexChild]
                                                    .value = date.millisecond;
                                              },
                                              onInit: () {
                                                if (dataFiled.field_set_value !=
                                                        null &&
                                                    dataFiled.field_set_value !=
                                                        '') {
                                                  final date = DateTime.parse(
                                                          dataFiled
                                                              .field_set_value)
                                                      .millisecond;
                                                  addData[indexParent]
                                                      .data[indexChild]
                                                      .value = date;
                                                }
                                              },
                                            )
                                          : dataFiled.field_type == "DATETIME"
                                              ? WidgetInputDate(
                                                  isDate: false,
                                                  data: dataFiled,
                                                  dateText:
                                                      dataFiled.field_set_value,
                                                  onSelect: (DateTime date) {
                                                    addData[indexParent]
                                                            .data[indexChild]
                                                            .value =
                                                        date.millisecond;
                                                  },
                                                  onInit: () {
                                                    if (dataFiled
                                                                .field_set_value !=
                                                            null &&
                                                        dataFiled
                                                                .field_set_value !=
                                                            '') {
                                                      final date = DateTime
                                                              .parse(dataFiled
                                                                  .field_set_value)
                                                          .millisecond;
                                                      addData[indexParent]
                                                          .data[indexChild]
                                                          .value = date;
                                                    }
                                                  },
                                                )
                                              : dataFiled.field_type == "CHECK"
                                                  ? RenderCheckBox(
                                                      onChange: (check) {
                                                        addData[indexParent]
                                                                .data[indexChild]
                                                                .value =
                                                            check ? 1 : 0;
                                                      },
                                                      data: dataFiled,
                                                    )
                                                  : dataFiled.field_type ==
                                                          "PERCENTAGE"
                                                      ? FieldInputPercent(
                                                          data: dataFiled,
                                                          onChanged: (text) {
                                                            addData[indexParent]
                                                                .data[
                                                                    indexChild]
                                                                .value = text;
                                                          },
                                                        )
                                                      : dataFiled.field_type ==
                                                              "SWITCH"
                                                          ? SwitchBase(
                                                              isHide: soTien ==
                                                                      0 &&
                                                                  dataFiled
                                                                          .field_name ==
                                                                      'da_thu_tien',
                                                              onChange:
                                                                  (check) {
                                                                if (dataFiled
                                                                        .field_name ==
                                                                    'da_thu_tien') {
                                                                  daThuTien =
                                                                      check;
                                                                } else if (dataFiled
                                                                        .field_name ==
                                                                    'hd_yeu_cau_xuat') {
                                                                  ycXuatHoaDon =
                                                                      check;
                                                                }
                                                                setState(() {});
                                                                addData[indexParent]
                                                                    .data[
                                                                        indexChild]
                                                                    .value = check;
                                                              },
                                                              data: dataFiled,
                                                            )
                                                          : dataFiled.field_type ==
                                                                  "RATE"
                                                              ? _rateWidget(
                                                                  dataFiled,
                                                                  indexParent,
                                                                  indexChild,
                                                                  value: int.parse(
                                                                      dataFiled
                                                                              .field_set_value ??
                                                                          '0'),
                                                                  noEdit: dataFiled
                                                                              .field_set_value !=
                                                                          null &&
                                                                      dataFiled
                                                                              .field_set_value !=
                                                                          "0",
                                                                )
                                                              : dataFiled.field_type ==
                                                                      "TEXTAREA"
                                                                  ? _fieldInputTextarea(
                                                                      dataFiled,
                                                                      indexParent,
                                                                      indexChild,
                                                                      noEdit: dataFiled.field_name == 'kh_danh_gia_nd'
                                                                          ? (((dataFiled.field_set_value ?? '') != '') ||
                                                                              editStar)
                                                                          : false,
                                                                      value: dataFiled.field_set_value ??
                                                                          '')
                                                                  : _fieldInputCustomer(
                                                                      dataFiled,
                                                                      indexParent,
                                                                      indexChild,
                                                                      value: dataFiled.field_name == 'hd_sotien'
                                                                          ? soTien.toInt().toString()
                                                                          : '')
                  : SizedBox()
              : SizedBox();
        });
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
                      height: AppValue.heights * 0.02,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: e.data?.length ?? 0,
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
                      // color: Colors.grey.withOpacity(0.2),
                      border: Border.all(color: HexColor("#BEB4B4")),
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
      CustomerIndividualItemData data, int indexParent, int indexChild,
      {bool noEdit = false, String value = ""}) {
    if (data.field_name == 'hd_sotien' &&
            addData[indexParent].data[indexChild].value == null ||
        addData[indexParent].data[indexChild].value == '' ||
        addData[indexParent].data[indexChild].value == 'null') {
      addData[indexParent].data[indexChild].value = value;
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
          if (data.field_name == 'hd_sotien') ...[
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

  Widget _fieldInputTextarea(
      CustomerIndividualItemData data, int indexParent, int indexChild,
      {bool noEdit = false, String value = ""}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // RichText(
          //   textScaleFactor: MediaQuery.of(context).textScaleFactor,
          //   text: TextSpan(
          //     text: data.field_label ?? '',
          //     style: titlestyle(),
          //     children: <TextSpan>[
          //       data.field_require == 1
          //           ? TextSpan(
          //               text: '*',
          //               style: TextStyle(
          //                   fontFamily: "Quicksand",
          //                   fontSize: 14,
          //                   fontWeight: FontWeight.w500,
          //                   color: Colors.red))
          //           : TextSpan(),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: 8,
          // ),
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
                  minLines: 2,
                  maxLines: 99,
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
                    hintText: // noEdit ? null :
                        data.field_label,
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
        ],
      ),
    );
  }

  Widget _rateWidget(
      CustomerIndividualItemData data, int indexParent, int indexChild,
      {bool noEdit = false, int value = 0}) {
    if (starStream.value == -1 || noEdit) {
      editStar = noEdit;
      starStream.add(value);
      addData[indexParent].data[indexChild].value = starStream.value;
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
          StreamBuilder<int>(
              stream: starStream,
              builder: (context, snapshot) {
                return Container(
                  height: MediaQuery.of(context).size.width / 10,
                  child: Center(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 15),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          if (!noEdit) {
                            starStream.add(index + 1);
                            addData[indexParent].data[indexChild].value =
                                index + 1;
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 13,
                          height: MediaQuery.of(context).size.width / 13,
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 26),
                          child: Image.asset(
                            (snapshot.data ?? 0) > index
                                ? ICONS.IC_STAR_BOLD_PNG
                                : ICONS.IC_STAR_PNG,
                            fit: BoxFit.contain,
                            color: (snapshot.data ?? 0) > index
                                ? null
                                : (!noEdit)
                                    ? COLORS.TEXT_COLOR
                                    : COLORS.GREY,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
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
                  addData[indexParent].data[indexChild].value = res.join(",");
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

    final isCheckRate =
        data["kh_danh_gia_nd"] != '' && data["kh_danh_gia_diem"] == '0';

    if (isCheckRate) {
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
          // check = true;
          // break;
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
            : isCheckRate
                ? "Vui lòng đánh giá số sao"
                : "Hãy nhập đủ các trường bắt buộc (*)",
      );
    } else {
      AddDataBloc.of(context).add(SignEvent(data));
    }
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
