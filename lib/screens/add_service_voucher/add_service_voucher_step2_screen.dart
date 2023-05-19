import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/add_service_voucher/add_service_bloc.dart';
import 'package:gen_crm/models/model_item_add.dart';
import 'package:gen_crm/screens/add_service_voucher/preview_image.dart';
import 'package:gen_crm/screens/add_service_voucher/select_car.dart';
import 'package:gen_crm/src/models/request/voucher_service_request.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../bloc/contract/total_bloc.dart';
import '../../models/model_data_add.dart';
import '../../models/widget_input_date.dart';
import '../../src/app_const.dart';
import '../../src/models/model_generator/add_customer.dart';
import '../../src/src_index.dart';
import '../../widgets/widget_field_input_percent.dart';
import '../../widgets/widget_text.dart';
import '../menu/home/contract/product_contract.dart';
import '../menu/home/customer/input_dropDown.dart';

class AddServiceVoucherStepTwoScreen extends StatefulWidget {
  const AddServiceVoucherStepTwoScreen({Key? key}) : super(key: key);

  @override
  State<AddServiceVoucherStepTwoScreen> createState() =>
      _AddServiceVoucherStepTwoScreenState();
}

class _AddServiceVoucherStepTwoScreenState
    extends State<AddServiceVoucherStepTwoScreen> {
  late final ServiceVoucherBloc _bloc;

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
              value: listAddData[i].data![j].field_id == '12708'
                  ? _bloc.getIdXe(
                      listAddData[i].data![j].field_datasource ?? [],
                      listAddData[i].data![j].field_value.toString(),
                      i,
                      j)
                  : _bloc.getTextInit(id: listAddData[i].data![j].field_id) ??
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
        appBar: AppBar(
          toolbarHeight: AppValue.heights * 0.1,
          backgroundColor: HexColor("#D0F1EB"),
          title: Text("${Get.arguments}",
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
        body: BlocListener<ServiceVoucherBloc, ServiceVoucherState>(
          listener: (context, state) async {
            if (state is SaveServiceVoucherState) {
              ShowDialogCustom.showDialogBase(
                  title: MESSAGES.NOTIFICATION,
                  content: "Thêm mới phiếu dịch vụ thành công!",
                  onTap1: () {
                    Navigator.of(context)
                      ..pop()
                      ..pop()
                      ..pop();
                  });
            }
            if (state is ErrorGetServiceVoucherState) {
              ShowDialogCustom.showDialogBase(
                title: MESSAGES.NOTIFICATION,
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
                              children:
                                  List.generate(listAddData.length, (index) {
                                final title =
                                    listAddData[index].group_name ?? '';
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
                                          listAddData[index].data!.length,
                                          (index1) {
                                        final isHidden = listAddData[index]
                                                .data?[index1]
                                                .field_hidden !=
                                            "1";
                                        final isURL = (state
                                                    .listAddData[index]
                                                    .data?[index1]
                                                    .field_special ??
                                                '') ==
                                            "url";
                                        final fieldId = listAddData[index]
                                                .data?[index1]
                                                .field_id ??
                                            '';
                                        final fieldType = listAddData[index]
                                            .data?[index1]
                                            .field_type;
                                        final fieldData =
                                            listAddData[index].data![index1];

                                        return isHidden
                                            ? isURL
                                                ? ProductContract(
                                                    data: _bloc.listProduct,
                                                    addProduct:
                                                        _bloc.addProduct,
                                                    reload: reload,
                                                    neverHidden: true,
                                                    canDelete: true,
                                                  )
                                                : fieldId == '13366'
                                                    ? _loaiCar(
                                                        fieldData, index, index1)
                                                    : fieldId == '246' &&
                                                            fieldData.field_set_value_datasource !=
                                                                []
                                                        ? fieldInputCustomer(
                                                            data: fieldData,
                                                            index: index,
                                                            index1: index1)
                                                        : fieldType == "SELECT"
                                                            ? InputDropdown(
                                                                onUpdate:
                                                                    (data) {
                                                                  addData[index]
                                                                      .data[
                                                                          index1]
                                                                      .value = data;
                                                                },
                                                                isUpdate: _bloc.getTextInit(id: fieldId, list: fieldData.field_datasource) !=
                                                                        null &&
                                                                    fieldId !=
                                                                        '12708',
                                                                dropdownItemList:
                                                                    fieldData.field_datasource ??
                                                                        [],
                                                                data: fieldData,
                                                                onSuccess:
                                                                    (data) {
                                                                  addData[index]
                                                                      .data[
                                                                          index1]
                                                                      .value = data;
                                                                  if (fieldId ==
                                                                      '12708') {
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
                                                                        fieldId !=
                                                                            '12708'
                                                                    ? _bloc.getTextInit(id: fieldId, list: fieldData.field_datasource) ??
                                                                        ''
                                                                    : fieldData.field_value ??
                                                                        '')
                                                            : fieldType ==
                                                                    "TEXT_MULTI"
                                                                ? _fieldInputTextMulti(
                                                                    fieldData.field_datasource!,
                                                                    fieldData.field_label!,
                                                                    fieldData.field_require!,
                                                                    index,
                                                                    index1,
                                                                    (fieldData.field_set_value_datasource != '' && fieldData.field_set_value_datasource != null) ? fieldData.field_set_value_datasource![0][0].toString() : "",
                                                                    fieldData.field_maxlength ?? '')
                                                                : fieldType == "HIDDEN"
                                                                    ? Container()
                                                                    : fieldType == "TEXT_MULTI_NEW"
                                                                        ? WidgetInputMulti(
                                                                            data: fieldData,
                                                                            onSelect: (data) {
                                                                              addData[index].data[index1].value = data.join(",");
                                                                            })
                                                                        : fieldType == "DATE"
                                                                            ? WidgetInputDate(
                                                                                data: fieldData,
                                                                                onSelect: (date) {
                                                                                  addData[index].data[index1].value = (date.millisecondsSinceEpoch / 1000).floor();
                                                                                },
                                                                                onInit: () {
                                                                                  DateTime date = DateTime.now();
                                                                                  addData[index].data[index1].value = (date.millisecondsSinceEpoch / 1000).floor();
                                                                                },
                                                                              )
                                                                            : fieldType == "PERCENTAGE"
                                                                                ? FieldInputPercent(
                                                                                    data: fieldData,
                                                                                    onChanged: (text) {
                                                                                      addData[index].data[index1].value = text;
                                                                                    },
                                                                                  )
                                                                                : fieldType == "CHECK"
                                                                                    ? _check(fieldData, index, index1)
                                                                                    : fieldInputCustomer(data: fieldData, index: index, index1: index1)
                                            : SizedBox();
                                      }),
                                    )
                                  ],
                                );
                              }),
                            ),
                            StreamBuilder(
                                stream: _bloc.listFileAllStream,
                                builder: (context, state) {
                                  return Container(
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      width: Get.width,
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _bloc.listFile.length,
                                            itemBuilder: (context, index) =>
                                                Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 4),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: WidgetText(
                                                      title: _bloc
                                                          .listFile[index].path
                                                          .split("/")
                                                          .last,
                                                      style:
                                                          AppStyle.DEFAULT_14,
                                                      maxLine: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      final List<File> list =
                                                          [];
                                                      _bloc.listFile
                                                          .removeAt(index);
                                                      list.addAll(
                                                          _bloc.listFile);
                                                      list.addAll(
                                                          _bloc.listImage);
                                                      _bloc.listFileAllStream
                                                          .add(list);
                                                    },
                                                    child: WidgetContainerImage(
                                                      image:
                                                          ICONS.IC_DELETE_PNG,
                                                      width: 20,
                                                      height: 20,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (_bloc.listImage.isNotEmpty)
                                            GridView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: _bloc.listImage.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 25,
                                                mainAxisSpacing: 25,
                                                mainAxisExtent: 90,
                                              ),
                                              itemBuilder: (context, index) =>
                                                  Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      PreviewImage(
                                                                        file: _bloc
                                                                            .listImage[index],
                                                                      )));
                                                    },
                                                    child: Container(
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                      child: Image.file(
                                                        _bloc.listImage[index],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        final List<File> list =
                                                            [];
                                                        _bloc.listImage
                                                            .removeAt(index);
                                                        list.addAll(
                                                            _bloc.listFile);
                                                        list.addAll(
                                                            _bloc.listImage);
                                                        _bloc.listFileAllStream
                                                            .add(list);
                                                      },
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.white,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 0.1),
                                                          ),
                                                          height: 16,
                                                          width: 16,
                                                          child: Icon(
                                                            Icons.close,
                                                            size: 9,
                                                          )),
                                                    ),
                                                    top: 0,
                                                    right: 0,
                                                  )
                                                ],
                                              ),
                                            )
                                        ],
                                      ));
                                }),
                            Row(
                              children: [
                                GestureDetector(
                                    onTap: this.onDinhKem,
                                    child: SvgPicture.asset(
                                      ICONS.IC_ATTACK_SVG,
                                    )),
                                Spacer(),
                                GestureDetector(
                                  onTap: this.onClickSave,
                                  child: Container(
                                    height: AppValue.widths * 0.1,
                                    width: AppValue.widths * 0.25,
                                    decoration: BoxDecoration(
                                        color: HexColor("#F1A400"),
                                        borderRadius:
                                            BorderRadius.circular(20.5)),
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
                      });
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

  Widget _loaiCar(
    CustomerIndividualItemData data,
    int index,
    int index1,
  ) {
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
                    _bloc.addData[index].data[index1].value =
                        _bloc.loaiXe.value;
                  }
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: HexColor("#BEB4B4"))),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, top: 15, bottom: 15),
                      child: Container(
                        child: WidgetText(
                          title: (_bloc.loaiXe.value != ''
                              ? _bloc.loaiXe.value
                              : '---Chọn---'),
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

  Widget _check(CustomerIndividualItemData data, int index, int index1) {
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
                      checkColor: Colors.white,
                      value: snapshot.data ?? false,
                      onChanged: (bool? value) {
                        _bloc.addData[index].data[index1].value = value!;
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

  Widget _fieldInputTextMulti(
    List<List<dynamic>> dropdownItemList,
    String label,
    int required,
    int index,
    int index1,
    String value,
    String maxLength,
  ) {
    List<ModelDataAdd> dropdow = [];
    int indexDefault = -1;
    for (int i = 0; i < dropdownItemList.length; i++) {
      if (dropdownItemList[i][1] != null && dropdownItemList[i][0] != null) {
        dropdow.add(ModelDataAdd(
            label: dropdownItemList[i][1], value: dropdownItemList[i][0]));
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
                            fontWeight: FontWeight.w600,
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
                _bloc.addData[index].data[index1].value = res.join(",");
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
            initialValue: indexDefault != -1 ? [dropdow[indexDefault]] : [],
            selectedItemsTextStyle: AppStyle.DEFAULT_14,
          )
        ],
      ),
    ));
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
        title: MESSAGES.NOTIFICATION,
        content: "Hãy nhập đủ các trường bắt buộc (*)",
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
      _bloc.add(SaveVoucherServiceEvent(voucherServiceRequest));
    }
  }

  Future<void> onDinhKem() async {
    if (await Permission.storage.request().isGranted) {
      openAppSettings();
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        final filePicked = result.files.first;
        final fileExt =
            result.files.first.path?.split("/").last.split('.').last;
        if (AppValue.checkTypeImage(fileExt.toString())) {
          _bloc.listImage.add(File(filePicked.path!));
        } else {
          _bloc.listFile.add(File(filePicked.path!));
        }
        final List<File> list = [];
        list.addAll(_bloc.listImage);
        list.addAll(_bloc.listFile);
        _bloc.listFileAllStream.add(list);
      }
    }
  }
}

class WidgetInputMulti extends StatefulWidget {
  WidgetInputMulti({Key? key, required this.data, required this.onSelect})
      : super(key: key);

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

class fieldInputCustomer extends StatefulWidget {
  const fieldInputCustomer({
    Key? key,
    required this.data,
    required this.index,
    required this.index1,
  }) : super(key: key);
  final CustomerIndividualItemData data;
  final int index;
  final int index1;
  @override
  State<fieldInputCustomer> createState() => _fieldInputCustomerState();
}

class _fieldInputCustomerState extends State<fieldInputCustomer> {
  late final ServiceVoucherBloc _bloc;
  late final data;
  late final int index1;
  late final int index;
  late final bool isEdit;
  late final TextEditingController _controller;

  @override
  void initState() {
    _bloc = ServiceVoucherBloc.of(context);
    index = widget.index;
    index1 = widget.index1;
    data = widget.data;
    _controller = TextEditingController();
    _controller.text = _bloc.getTextInit(id: data.field_id) ??
        ((data.field_set_value ?? '').trim() != ''
            ? data.field_set_value
            : data.field_set_value_datasource?[0][1]) ??
        _bloc.addData[index].data[index1].value ??
        '';
    _bloc.addData[index].data[index1].value =
        _bloc.getTextInit(id: data.field_id) ??
            ((data.field_set_value ?? '').trim() != ''
                ? data.field_set_value
                : data.field_set_value_datasource?[0][1]) ??
            _bloc.addData[index].data[index1].value ??
            '';
    isEdit = data.field_id == '246' || data.field_id == '264';
    _bloc.infoCar.listen((value) {
      _controller.text = _bloc.getTextInit(id: data.field_id) ??
          ((data.field_set_value ?? '').trim() != ''
              ? data.field_set_value
              : data.field_set_value_datasource?[0][1]) ??
          _bloc.addData[index].data[index1].value ??
          '';
      _bloc.addData[index].data[index1].value =
          _bloc.getTextInit(id: data.field_id) ??
              ((data.field_set_value ?? '').trim() != ''
                  ? data.field_set_value
                  : data.field_set_value_datasource?[0][1]) ??
              _bloc.addData[index].data[index1].value ??
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
                color: isEdit && _controller.text != ''
                    ? COLORS.LIGHT_GREY
                    : Colors.white,
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
                    _bloc.addData[index].data[index1].value = text;
                  },
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
        ],
      ),
    );
  }
}
