import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/add_service_voucher/add_service_bloc.dart';
import 'package:gen_crm/models/model_item_add.dart';
import 'package:gen_crm/screens/add_service_voucher/select_car.dart';
import 'package:gen_crm/src/models/request/voucher_service_request.dart';
import 'package:gen_crm/widgets/pick_file_image.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/contract/attack_bloc.dart';
import '../../bloc/contract/total_bloc.dart';
import '../../models/model_data_add.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../widgets/widget_input_date.dart';
import '../../src/models/model_generator/add_customer.dart';
import '../../src/src_index.dart';
import '../../widgets/appbar_base.dart';
import '../../widgets/field_input_select_multi.dart';
import '../../widgets/multiple_widget.dart';
import '../../widgets/widget_field_input_percent.dart';
import '../../widgets/widget_text.dart';
import '../menu/form/product_list/product_contract.dart';
import '../menu/home/customer/widget/input_dropDown.dart';

class AddServiceVoucherStepTwoScreen extends StatefulWidget {
  const AddServiceVoucherStepTwoScreen({Key? key}) : super(key: key);

  @override
  State<AddServiceVoucherStepTwoScreen> createState() =>
      _AddServiceVoucherStepTwoScreenState();
}

class _AddServiceVoucherStepTwoScreenState
    extends State<AddServiceVoucherStepTwoScreen> {
  late final ServiceVoucherBloc _bloc;
  String title = Get.arguments;

  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bloc = ServiceVoucherBloc.of(context);
    _bloc.idCar.listen((value) {
      _bloc.getCar(value);
    });
    _bloc.infoCar.listen((value) {
      if (value != null) {
        _bloc.loaiXe.add(value.chiTietXe ?? '');
        _bloc.listAddData.add(_bloc.listAddData.value);
      }
    });
    super.initState();
  }

  @override
  void deactivate() {
    TotalBloc.of(context).add(ReloadTotalEvent());
    super.deactivate();
  }

  void checkData() {
    final addData = _bloc.addData;
    final listAddData = _bloc.listAddData.value;
    if (addData.isNotEmpty) {
    } else {
      for (int i = 0; i < listAddData.length; i++) {
        addData.add(ModelItemAdd(
            group_name: listAddData[i].group_name ?? '', data: []));
        for (int j = 0; j < listAddData[i].data!.length; j++) {
          addData[i].data.add(ModelDataAdd(
              label: listAddData[i].data![j].field_name,
              value: listAddData[i].data![j].field_name == 'hdsan_pham_kh'
                  ? _bloc.getIdXe(
                      listAddData[i].data![j].field_datasource ?? [],
                      listAddData[i].data![j].field_value.toString(),
                      i,
                      j)
                  : _bloc.getTextInit(
                          name: listAddData[i].data![j].field_name) ??
                      listAddData[i].data![j].field_set_value_datasource?[0]
                          [1] ??
                      listAddData[i].data![j].field_set_value ??
                      '',
              required: listAddData[i].data![j].field_require));
        }
      }
    }
  }

  void reload() {
    for (int i = 0; i < _bloc.listProduct.length; i++) {
      if (_bloc.listProduct[i].soLuong == 0) {
        _bloc.listProduct.removeAt(i);
        i--;
      } else {
        if (_bloc.listProduct[i].typeGiamGia == '%') {
          _bloc.total +=
              (double.parse(_bloc.listProduct[i].item.sell_price ?? '0') *
                      _bloc.listProduct[i].soLuong) *
                  ((100 -
                          double.parse(_bloc.listProduct[i].giamGia == ""
                              ? "0"
                              : _bloc.listProduct[i].giamGia)) /
                      100);
        } else {
          _bloc.total +=
              (double.parse(_bloc.listProduct[i].item.sell_price ?? '0') *
                      _bloc.listProduct[i].soLuong) -
                  double.parse(_bloc.listProduct[i].giamGia == ""
                      ? "0"
                      : _bloc.listProduct[i].giamGia);
        }
      }
    }
    TotalBloc.of(context).add(InitTotalEvent(_bloc.total));
  }

  @override
  Widget build(BuildContext context) {
    final addData = _bloc.addData;
    return Scaffold(
        appBar: AppbarBaseNormal(title),
        body: BlocListener<ServiceVoucherBloc, ServiceVoucherState>(
          listener: (context, state) async {
            if (state is SaveServiceVoucherState) {
              ShowDialogCustom.showDialogBase(
                  title: AppLocalizations.of(Get.context!)?.notification,
                  content: AppLocalizations.of(Get.context!)?.add_success,
                  onTap1: () {
                    Navigator.of(context)
                      ..pop()
                      ..pop()
                      ..pop();
                  });
            }
            if (state is ErrorGetServiceVoucherState) {
              ShowDialogCustom.showDialogBase(
                title: AppLocalizations.of(Get.context!)?.notification,
                content: state.msg,
              );
            }
          },
          child: Container(
            margin: EdgeInsets.only(
                left: AppValue.widths * 0.05,
                right: AppValue.widths * 0.05,
                top: AppValue.heights * 0.02),
            child: SingleChildScrollView(
              child: BlocBuilder<ServiceVoucherBloc, ServiceVoucherState>(
                  builder: (context, state) {
                if (state is GetServiceVoucherState) {
                  _bloc.listAddData.add(state.listAddData);
                  checkData();
                  return StreamBuilder<List<AddCustomerIndividualData>>(
                      stream: _bloc.listAddData,
                      builder: (context, snapshot) {
                        final listAddData = snapshot.data ?? [];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(listAddData.length,
                                  (indexParent) {
                                final title =
                                    listAddData[indexParent].group_name ?? '';
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: AppValue.heights * 0.01,
                                    ),
                                    title != ''
                                        ? WidgetText(
                                            title: title,
                                            style: AppStyle.DEFAULT_18_BOLD)
                                        : SizedBox(),
                                    SizedBox(
                                      height: AppValue.heights * 0.01,
                                    ),
                                    Column(
                                      children: List.generate(
                                          listAddData[indexParent].data!.length,
                                          (indexChild) {
                                        final isHidden =
                                            listAddData[indexParent]
                                                    .data?[indexChild]
                                                    .field_hidden !=
                                                "1";
                                        final isURL = (state
                                                    .listAddData[indexParent]
                                                    .data?[indexChild]
                                                    .field_special ??
                                                '') ==
                                            "url";
                                        final fieldName =
                                            listAddData[indexParent]
                                                    .data?[indexChild]
                                                    .field_name ??
                                                '';
                                        final fieldType =
                                            listAddData[indexParent]
                                                .data?[indexChild]
                                                .field_type;
                                        final data = listAddData[indexParent]
                                            .data![indexChild];

                                        return isHidden
                                            ? isURL
                                                ? ProductContract(
                                                    listBtn: data.button,
                                                    data: _bloc.listProduct,
                                                    addProduct:
                                                        _bloc.addProduct,
                                                    reload: reload,
                                                    neverHidden: true,
                                                    canDelete: true,
                                                  )
                                                : fieldName == 'chi_tiet_xe'
                                                    ? TypeCarBase(
                                                        data,
                                                        indexParent,
                                                        indexChild,
                                                        context,
                                                        _bloc, (v) {
                                                        _bloc
                                                            .addData[
                                                                indexParent]
                                                            .data[indexChild]
                                                            .value = v;
                                                      })
                                                    : fieldName == 'col131' &&
                                                            data.field_set_value_datasource !=
                                                                []
                                                        ? fieldInputCustomer(
                                                            data: data,
                                                            indexParent:
                                                                indexParent,
                                                            indexChild:
                                                                indexChild)
                                                        : fieldType == "SELECT"
                                                            ? InputDropdown(
                                                                onUpdate:
                                                                    (data) {
                                                                  addData[indexParent]
                                                                      .data[
                                                                          indexChild]
                                                                      .value = data;
                                                                },
                                                                isUpdate: _bloc.getTextInit(name: fieldName, list: data.field_datasource) !=
                                                                        null &&
                                                                    fieldName !=
                                                                        'hdsan_pham_kh',
                                                                dropdownItemList:
                                                                    data.field_datasource ??
                                                                        [],
                                                                data: data,
                                                                onSuccess:
                                                                    (data) {
                                                                  addData[indexParent]
                                                                      .data[
                                                                          indexChild]
                                                                      .value = data;
                                                                  if (fieldName ==
                                                                      'hdsan_pham_kh') {
                                                                    if (data !=
                                                                        ServiceVoucherBloc
                                                                            .THEM_MOI_XE) {
                                                                      _bloc
                                                                          .idCar
                                                                          .add(
                                                                              data);
                                                                    }
                                                                  }
                                                                },
                                                                value: _bloc.infoCar.value != null &&
                                                                        fieldName !=
                                                                            'hdsan_pham_kh'
                                                                    ? _bloc.getTextInit(
                                                                            name: fieldName,
                                                                            list: data.field_datasource) ??
                                                                        ''
                                                                    : data.field_value ?? '')
                                                            : fieldType == "TEXT_MULTI"
                                                                ? SelectMulti(
                                                                    dropdownItemList:
                                                                        data.field_datasource ??
                                                                            [],
                                                                    label:
                                                                        data.field_label ??
                                                                            '',
                                                                    required:
                                                                        data.field_require ??
                                                                            0,
                                                                    maxLength:
                                                                        data.field_maxlength ??
                                                                            '',
                                                                    initValue: addData[
                                                                            indexParent]
                                                                        .data[
                                                                            indexChild]
                                                                        .value
                                                                        .toString()
                                                                        .split(
                                                                            ','),
                                                                    onChange:
                                                                        (data) {
                                                                      addData[indexParent]
                                                                          .data[
                                                                              indexChild]
                                                                          .value = data;
                                                                    },
                                                                  )
                                                                : fieldType == "HIDDEN"
                                                                    ? Container()
                                                                    : fieldType == "TEXT_MULTI_NEW"
                                                                        ? InputMultipleWidget(
                                                                            data: data,
                                                                            onSelect: (data) {
                                                                              addData[indexParent].data[indexChild].value = data.join(",");
                                                                            })
                                                                        : data.field_type == "DATE"
                                                                            ? WidgetInputDate(
                                                                                data: data,
                                                                                dateText: data.field_set_value,
                                                                                onSelect: (int date) {
                                                                                  addData[indexParent].data[indexChild].value = date;
                                                                                },
                                                                                onInit: (v) {
                                                                                  addData[indexParent].data[indexChild].value = v;
                                                                                },
                                                                              )
                                                                            : data.field_type == "DATETIME"
                                                                                ? WidgetInputDate(
                                                                                    isDate: false,
                                                                                    data: data,
                                                                                    dateText: data.field_set_value,
                                                                                    onSelect: (int date) {
                                                                                      addData[indexParent].data[indexChild].value = date;
                                                                                    },
                                                                                    onInit: (v) {
                                                                                      addData[indexParent].data[indexChild].value = v;
                                                                                    },
                                                                                  )
                                                                                : fieldType == "PERCENTAGE"
                                                                                    ? FieldInputPercent(
                                                                                        data: data,
                                                                                        onChanged: (text) {
                                                                                          addData[indexParent].data[indexChild].value = text;
                                                                                        },
                                                                                      )
                                                                                    : fieldType == "CHECK"
                                                                                        ? _check(data, indexParent, indexChild)
                                                                                        : fieldInputCustomer(data: data, indexParent: indexParent, indexChild: indexChild)
                                            : SizedBox();
                                      }),
                                    )
                                  ],
                                );
                              }),
                            ),
                            FileDinhKemUiBase(
                                context: context, onTap: onClickSave)
                          ],
                        );
                      });
                } else
                  return Container();
              }),
            ),
          ),
        ));
  }

  Widget _check(
      CustomerIndividualItemData data, int indexParent, int indexChild) {
    TextEditingController controller = TextEditingController();
    controller.text = (data.field_set_value ?? '').trim() ?? '';
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
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
          Align(
            alignment: Alignment.centerLeft,
            child: StreamBuilder<bool>(
                stream: _bloc.checkboxStream,
                builder: (context, snapshot) {
                  return Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2)),
                      checkColor: COLORS.WHITE,
                      value: snapshot.data ?? false,
                      onChanged: (bool? value) {
                        _bloc.addData[indexParent].data[indexChild].value =
                            value!;
                        _bloc.checkboxStream.sink.add(value);
                      },
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void onClickSave() {
    final addData = _bloc.addData;
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
          data["${addData[i].data[j].label}"] =
              addData[i].data[j].value.toString();
        else {
          data["${addData[i].data[j].label}"] = "";
        }
      }
    }
    if (check == true) {
      ShowDialogCustom.showDialogBase(
        title: AppLocalizations.of(Get.context!)?.notification,
        content:
            AppLocalizations.of(Get.context!)?.please_enter_all_required_fields,
      );
    } else {
      if (_bloc.listProduct.length > 0) {
        List product = [];
        for (int i = 0; i < _bloc.listProduct.length; i++) {
          product.add({
            "id": _bloc.listProduct[i].id,
            "price": _bloc.listProduct[i].item.sell_price,
            "quantity": _bloc.listProduct[i].soLuong,
            "vat": _bloc.listProduct[i].item.vat,
            "unit": _bloc.listProduct[i].item.dvt,
            "sale_off": {
              "value": _bloc.listProduct[i].giamGia,
              "type": _bloc.listProduct[i].typeGiamGia,
            }
          });
        }
        data['products'] = product;
      }
      VoucherServiceRequest voucherServiceRequest =
          VoucherServiceRequest.fromJson(data);
      _bloc.add(SaveVoucherServiceEvent(
          voucherServiceRequest, AttackBloc.of(context).listFile));
    }
  }
}

class fieldInputCustomer extends StatefulWidget {
  const fieldInputCustomer({
    Key? key,
    required this.data,
    required this.indexParent,
    required this.indexChild,
  }) : super(key: key);
  final CustomerIndividualItemData data;
  final int indexParent;
  final int indexChild;
  @override
  State<fieldInputCustomer> createState() => _fieldInputCustomerState();
}

class _fieldInputCustomerState extends State<fieldInputCustomer> {
  late final ServiceVoucherBloc _bloc;
  late final data;
  late final int indexChild;
  late final int indexParent;
  late final bool isEdit;
  late final TextEditingController _controller;

  @override
  void initState() {
    _bloc = ServiceVoucherBloc.of(context);
    indexParent = widget.indexParent;
    indexChild = widget.indexChild;
    data = widget.data;
    _controller = TextEditingController();
    _controller.text = _bloc.getTextInit(name: data.field_name) ??
        ((data.field_set_value ?? '').trim() != ''
            ? data.field_set_value
            : data.field_set_value_datasource?[0][1]) ??
        _bloc.addData[indexParent].data[indexChild].value ??
        '';
    _bloc.addData[indexParent].data[indexChild].value =
        _bloc.getTextInit(name: data.field_name) ??
            ((data.field_set_value ?? '').trim() != ''
                ? data.field_set_value
                : data.field_set_value_datasource?[0][1]) ??
            _bloc.addData[indexParent].data[indexChild].value ??
            '';
    isEdit = data.field_name == 'col131' || data.field_name == 'col121';
    _bloc.infoCar.listen((value) {
      _controller.text = _bloc.getTextInit(name: data.field_name) ??
          ((data.field_set_value ?? '').trim() != ''
              ? data.field_set_value
              : data.field_set_value_datasource?[0][1]) ??
          _bloc.addData[indexParent].data[indexChild].value ??
          '';
      _bloc.addData[indexParent].data[indexChild].value =
          _bloc.getTextInit(name: data.field_name) ??
              ((data.field_set_value ?? '').trim() != ''
                  ? data.field_set_value
                  : data.field_set_value_datasource?[0][1]) ??
              _bloc.addData[indexParent].data[indexChild].value ??
              '';
    });
    super.initState();
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
                color: isEdit && _controller.text != ''
                    ? COLORS.LIGHT_GREY
                    : COLORS.WHITE,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: HexColor("#BEB4B4"))),
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
              child: Container(
                child: TextField(
                  controller: _controller,
                  enabled: !isEdit,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  keyboardType: data.field_special == "default"
                      ? TextInputType.text
                      : data.field_special == "numberic"
                          ? TextInputType.number
                          : data.field_special == "email-address"
                              ? TextInputType.emailAddress
                              : TextInputType.text,
                  onChanged: (text) {
                    _bloc.addData[indexParent].data[indexChild].value = text;
                  },
                  decoration: InputDecoration(
                    hintStyle: AppStyle.DEFAULT_14W500,
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
}

Widget TypeCarBase(
  CustomerIndividualItemData data,
  int indexParent,
  int indexChild,
  BuildContext context,
  dynamic _bloc,
  Function(String v) function,
) {
  if (data.field_set_value != '' && data.field_set_value != null) {
    _bloc.loaiXe.add(data.field_set_value);
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
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                isDismissible: false,
                enableDrag: false,
                isScrollControlled: true,
                context: context,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                builder: (BuildContext context) {
                  return SelectCar();
                });
          },
          child: StreamBuilder<String>(
              stream: _bloc.loaiXe,
              builder: (context, snapshot) {
                if (_bloc.loaiXe.value.trim() != '') {
                  function(_bloc.loaiXe.value);
                }
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: COLORS.WHITE,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: HexColor("#BEB4B4"))),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 15, bottom: 15),
                    child: Container(
                      child: WidgetText(
                        title: (_bloc.loaiXe.value != ''
                            ? _bloc.loaiXe.value
                            : '---${AppLocalizations.of(Get.context!)?.select}---'),
                        style: AppStyle.DEFAULT_14,
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    ),
  );
}
