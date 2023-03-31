import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/contract/phone_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/add_data_bloc.dart';
import 'package:gen_crm/bloc/form_edit/form_edit_bloc.dart';
import 'package:gen_crm/models/model_data_add.dart';
import 'package:gen_crm/models/model_item_add.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../api_resfull/user_repository.dart';
import '../../../../bloc/clue/clue_bloc.dart';
import '../../../../bloc/contact_by_customer/contact_by_customer_bloc.dart';
import '../../../../bloc/contract/attack_bloc.dart';
import '../../../../bloc/contract/detail_contract_bloc.dart';
import '../../../../bloc/detail_clue/detail_clue_bloc.dart';
import '../../../../bloc/support/detail_support_bloc.dart';
import '../../../../bloc/support/support_bloc.dart';
import '../../../../bloc/work/detail_work_bloc.dart';
import '../../../../bloc/work/work_bloc.dart';
import '../../../../models/widget_input_date.dart';
import '../../../../src/models/model_generator/add_customer.dart';
import '../../../../src/src_index.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../../widgets/widgetFieldInputPercent.dart';
import '../../../../widgets/widget_dialog.dart';
import 'input_dropDown.dart';

class FormEdit extends StatefulWidget {
  const FormEdit({Key? key}) : super(key: key);

  @override
  State<FormEdit> createState() => _FormEditState();
}

class _FormEditState extends State<FormEdit> {
  String id = Get.arguments[0];
  int type = Get.arguments[1];
  List data = [];
  List<ModelItemAdd> addData = [];
  List<List<dynamic>> dataDauMoi = [];
  bool firstTime = true;
  String customer_id = "";
  File? fileUpload;
  final UserRepository userRepository = UserRepository();

  late final BehaviorSubject<bool> isMaxScroll;
  late final ScrollController scrollController;

  @override
  void initState() {
    isMaxScroll = BehaviorSubject.seeded(false);
    scrollController = ScrollController();
    AttackBloc.of(context).add(LoadingAttackEvent());
    if (type == 1)
      FormEditBloc.of(context).add(InitFormEditCusEvent(id));
    else if (type == 2) {
      FormEditBloc.of(context).add(InitFormEditClueEvent(id));
    } else if (type == 3) {
      FormEditBloc.of(context).add(InitFormEditChanceEvent(id));
    } else if (type == 4) {
      FormEditBloc.of(context).add(InitFormEditContractEvent(id));
    } else if (type == 5) {
      FormEditBloc.of(context).add(InitFormEditJobEvent(id));
    } else if (type == 6) {
      FormEditBloc.of(context).add(InitFormEditSupportEvent(id));
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(seconds: 1));
      if (scrollController.position.maxScrollExtent > 7) {
        scrollHandle();
      } else {
        isMaxScroll.add(true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    isMaxScroll.close();
    super.dispose();
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

  showLog(String mess) {
    Get.dialog(WidgetDialog(
      title: MESSAGES.NOTIFICATION,
      content: mess,
      textButton1: "Quay lại",
      onTap1: () {
        Get.back();
        Get.back();
      },
    ));
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
                if (state is SuccessEditCustomerState) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return WidgetDialog(
                        title: MESSAGES.NOTIFICATION,
                        content: "Update dữ liệu thành công!",
                        textButton1: "OK",
                        backgroundButton1: COLORS.PRIMARY_COLOR,
                        onTap1: () {
                          if (type == 1)
                            GetListCustomerBloc.of(context)
                                .add(InitGetListOrderEvent("", 1, ""));

                          Get.back();
                          Get.back();
                          Get.back();
                        },
                      );
                    },
                  );
                }
                if (state is ErrorEditCustomerState) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return WidgetDialog(
                        title: MESSAGES.NOTIFICATION,
                        content: state.msg,
                        onTap1: () {
                          Get.back();
                        },
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
                        textButton1: "OK",
                        backgroundButton1: COLORS.PRIMARY_COLOR,
                        onTap1: () {
                          Get.back();
                          Get.back();
                          if (type == 2) {
                            GetDetailClueBloc.of(context)
                                .add(InitGetDetailClueEvent(id));
                            GetListClueBloc.of(context)
                                .add(InitGetListClueEvent('', 1, ''));
                          }
                          if (type == 3) {
                            GetListDetailChanceBloc.of(context)
                                .add(InitGetListDetailEvent(int.parse(id)));
                            GetListChanceBloc.of(context)
                                .add(InitGetListOrderEventChance('', 1, ''));
                          }
                          if (type == 5) {
                            DetailWorkBloc.of(context)
                                .add(InitGetDetailWorkEvent(int.parse(id)));
                            WorkBloc.of(context)
                                .add(InitGetListWorkEvent("1", "", ""));
                          }
                          if (type == 4)
                            DetailContractBloc.of(context)
                                .add(InitGetDetailContractEvent(int.parse(id)));
                          if (type == 6) {
                            DetailSupportBloc.of(context)
                                .add(InitGetDetailSupportEvent(id));
                            SupportBloc.of(context)
                                .add(InitGetSupportEvent(1, '', ''));
                          }
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
                        onTap1: () {
                          Get.back();
                        },
                      );
                    },
                  );
                }
              },
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                    left: AppValue.widths * 0.05,
                    right: AppValue.widths * 0.05,
                    top: AppValue.heights * 0.02),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: BlocBuilder<FormEditBloc, FormEditState>(
                      builder: (context, state) {
                    if (state is LoadingFormEditState) {
                      addData = [];
                      data = [];
                      return Container();
                    } else if (state is SuccessFormEditState) {
                      for (int i = 0; i < state.listEditData.length; i++) {
                        addData.add(ModelItemAdd(
                            group_name: state.listEditData[i].group_name ?? '',
                            data: []));
                        for (int j = 0;
                            j < state.listEditData[i].data!.length;
                            j++) {
                          addData[i].data.add(ModelDataAdd(
                              label: state.listEditData[i].data![j].field_name,
                              value: state
                                  .listEditData[i].data![j].field_set_value
                                  .toString(),
                              required: state
                                  .listEditData[i].data![j].field_require));
                        }
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                state.listEditData.length,
                                (index) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: AppValue.heights * 0.01,
                                        ),
                                        state.listEditData[index].group_name !=
                                                null
                                            ? WidgetText(
                                                title: state.listEditData[index]
                                                        .group_name ??
                                                    '',
                                                style: AppStyle.DEFAULT_18_BOLD)
                                            : Container(),
                                        SizedBox(
                                          height: AppValue.heights * 0.01,
                                        ),
                                        Column(
                                          children: List.generate(
                                              state.listEditData[index].data!
                                                  .length, (index1) {
                                            if (state.listEditData[index]
                                                    .data![index1].field_id ==
                                                "246")
                                              customer_id = state
                                                  .listEditData[index]
                                                  .data![index1]
                                                  .field_set_value
                                                  .toString();
                                            return state
                                                        .listEditData[index]
                                                        .data![index1]
                                                        .field_hidden !=
                                                    "1"
                                                ? state
                                                            .listEditData[index]
                                                            .data![index1]
                                                            .field_special ==
                                                        "none-edit"
                                                    ? (state.listEditData[index].data![index1].field_id ==
                                                                "12547" ||
                                                            state.listEditData[index].data![index1].field_id ==
                                                                "1472"
                                                        ? BlocBuilder<PhoneBloc, PhoneState>(
                                                            builder: (context,
                                                                stateA) {
                                                            if (stateA
                                                                is SuccessPhoneState) {
                                                              return _fieldInputCustomer(
                                                                  state
                                                                          .listEditData[
                                                                              index]
                                                                          .data![
                                                                      index1],
                                                                  index,
                                                                  index1,
                                                                  noEdit: true,
                                                                  value: stateA
                                                                      .phone);
                                                            } else if (stateA
                                                                is LoadingPhoneState)
                                                              return Container();
                                                            else {
                                                              return _fieldInputCustomer(
                                                                  state
                                                                          .listEditData[
                                                                              index]
                                                                          .data![
                                                                      index1],
                                                                  index,
                                                                  index1,
                                                                  noEdit: true,
                                                                  value: state
                                                                      .listEditData[
                                                                          index]
                                                                      .data![
                                                                          index1]
                                                                      .field_value!);
                                                            }
                                                          })
                                                        : _fieldInputCustomer(
                                                            state.listEditData[index].data![index1], index, index1,
                                                            noEdit: true))
                                                    : state
                                                                .listEditData[index]
                                                                .data![index1]
                                                                .field_type ==
                                                            "SELECT"
                                                        ? ((state.listEditData[index].data![index1].field_id == '115' || state.listEditData[index].data![index1].field_id == '135')
                                                            ? BlocBuilder<ContactByCustomerBloc, ContactByCustomerState>(builder: (context, stateA) {
                                                                if (stateA
                                                                    is UpdateGetContacBytCustomerState)
                                                                  return InputDropdown(
                                                                      dropdownItemList:
                                                                          stateA
                                                                              .listContactByCustomer,
                                                                      data: state
                                                                              .listEditData[
                                                                                  index]
                                                                              .data![
                                                                          index1],
                                                                      onSuccess:
                                                                          (data) {
                                                                        addData[index]
                                                                            .data[index1]
                                                                            .value = data;
                                                                        if (state.listEditData[index].data![index1].field_id !=
                                                                            "107")
                                                                          PhoneBloc.of(context)
                                                                              .add(InitAgencyPhoneEvent(data));
                                                                      },
                                                                      value: (state.listEditData[index].data![index1].field_set_value_datasource != null &&
                                                                              state.listEditData[index].data![index1].field_set_value_datasource!.length >
                                                                                  0)
                                                                          ? state
                                                                              .listEditData[index]
                                                                              .data![index1]
                                                                              .field_set_value_datasource![0][1]
                                                                              .toString()
                                                                          : '');
                                                                else if (stateA
                                                                    is LoadingContactByCustomerState) {
                                                                  return Container();
                                                                } else
                                                                  return InputDropdown(
                                                                      dropdownItemList:
                                                                          state.listEditData[index].data![index1].field_datasource ??
                                                                              [],
                                                                      data: state
                                                                              .listEditData[index].data![
                                                                          index1],
                                                                      onSuccess:
                                                                          (data) {
                                                                        addData[index]
                                                                            .data[index1]
                                                                            .value = data;
                                                                        if (state.listEditData[index].data![index1].field_id !=
                                                                            "107")
                                                                          PhoneBloc.of(context)
                                                                              .add(InitAgencyPhoneEvent(data));
                                                                      },
                                                                      value: (state.listEditData[index].data![index1].field_set_value_datasource != null &&
                                                                              state.listEditData[index].data![index1].field_set_value_datasource!.length >
                                                                                  0)
                                                                          ? state
                                                                              .listEditData[index]
                                                                              .data![index1]
                                                                              .field_set_value_datasource![0][1]
                                                                              .toString()
                                                                          : '');
                                                              })
                                                            : InputDropdown(
                                                                dropdownItemList: state.listEditData[index].data![index1].field_datasource ?? [],
                                                                data: state.listEditData[index].data![index1],
                                                                onSuccess: (data) {
                                                                  addData[index]
                                                                      .data[
                                                                          index1]
                                                                      .value = data;
                                                                  if (state.listEditData[index].data![index1].field_id ==
                                                                          "107" ||
                                                                      state.listEditData[index].data![index1]
                                                                              .field_id ==
                                                                          "128") {
                                                                    ContactByCustomerBloc.of(
                                                                            context)
                                                                        .add(InitGetContactByCustomerrEvent(
                                                                            data));
                                                                    PhoneBloc.of(
                                                                            context)
                                                                        .add(InitPhoneEvent(
                                                                            data));
                                                                  }
                                                                },
                                                                value: ((state.listEditData[index].data![index1].field_set_value_datasource != null && state.listEditData[index].data![index1].field_set_value_datasource!.length > 0) ? state.listEditData[index].data![index1].field_set_value_datasource![0][1].toString() : '')))
                                                        : state.listEditData[index].data![index1].field_type == "TEXT_MULTI"
                                                            ? _fieldInputTextMulti(state.listEditData[index].data![index1].field_datasource!, state.listEditData[index].data![index1].field_label!, state.listEditData[index].data![index1].field_require!, index, index1, (state.listEditData[index].data![index1].field_set_value_datasource != "" && state.listEditData[index].data![index1].field_set_value_datasource != null && state.listEditData[index].data![index1].field_set_value_datasource!.length > 0) ? state.listEditData[index].data![index1].field_set_value_datasource![0][0].toString() : "", state.listEditData[index].data![index1].field_maxlength ?? '')
                                                            : state.listEditData[index].data![index1].field_type == "HIDDEN"
                                                                ? Container()
                                                                : state.listEditData[index].data![index1].field_type == "TEXT_MULTI_NEW"
                                                                    ? WidgetInputMulti(
                                                                        data: state
                                                                            .listEditData[index]
                                                                            .data![index1],
                                                                        onRemove:
                                                                            (data) {
                                                                          addData[index]
                                                                              .data[index1]
                                                                              .value = data.join(",");
                                                                        },
                                                                        onSelect:
                                                                            (data) {
                                                                          addData[index]
                                                                              .data[index1]
                                                                              .value = data.join(",");
                                                                        },
                                                                        value: (state.listEditData[index].data![index1].field_set_value != null &&
                                                                                state.listEditData[index].data![index1].field_set_value != "")
                                                                            ? state.listEditData[index].data![index1].field_set_value.split(",")
                                                                            : [],
                                                                      )
                                                                    : state.listEditData[index].data![index1].field_type == "DATE"
                                                                        ? WidgetInputDate(
                                                                            data:
                                                                                state.listEditData[index].data![index1],
                                                                            onSelect:
                                                                                (date) {
                                                                              addData[index].data[index1].value = (date.millisecondsSinceEpoch / 1000).floor();
                                                                            },
                                                                            dateText: (state.listEditData[index].data![index1].field_set_value != "" && state.listEditData[index].data![index1].field_set_value != null)
                                                                                ? AppValue.formatDate(DateTime.fromMillisecondsSinceEpoch(state.listEditData[index].data![index1].field_set_value * 1000).toString())
                                                                                : "",
                                                                            onInit:
                                                                                () {
                                                                              if (state.listEditData[index].data![index1].field_set_value != "" && state.listEditData[index].data![index1].field_set_value != null) {
                                                                                addData[index].data[index1].value = state.listEditData[index].data![index1].field_set_value;
                                                                              } else {
                                                                                DateTime date = DateTime.now();
                                                                                addData[index].data[index1].value = (date.microsecondsSinceEpoch / 1000000).floor();
                                                                              }
                                                                            },
                                                                          )
                                                                        : state.listEditData[index].data![index1].field_type == "CHECK"
                                                                            ? renderCheckBox(
                                                                                onChange: (check) {
                                                                                  addData[index].data[index1].value = check ? 1 : 0;
                                                                                },
                                                                                data: state.listEditData[index].data![index1],
                                                                              )
                                                                            : state.listEditData[index].data![index1].field_type == "PERCENTAGE"
                                                                                ? FieldInputPercent(
                                                                                    data: state.listEditData[index].data![index1],
                                                                                    onChanged: (text) {
                                                                                      addData[index].data[index1].value = text;
                                                                                    },
                                                                                  )
                                                                                : _fieldInputCustomer(state.listEditData[index].data![index1], index, index1, value: state.listEditData[index].data![index1].field_set_value.toString())
                                                : SizedBox();
                                          }),
                                        )
                                      ],
                                    )),
                          ),
                          BlocBuilder<AttackBloc, AttackState>(
                              builder: (context, state) {
                            if (state is SuccessAttackState) if (state.file !=
                                null)
                              return Container(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  width: Get.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: WidgetText(
                                          title:
                                              state.file!.path.split("/").last,
                                          style: AppStyle.DEFAULT_14,
                                          maxLine: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          fileUpload = null;
                                          AttackBloc.of(context)
                                              .add(InitAttackEvent());
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
                          SizedBox(
                            height: AppValue.widths * 0.1 + 10,
                          )
                        ],
                      );
                    } else if (state is ErrorFormEditState) {
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => showLog(state.msg));
                      return Container();
                    } else
                      return Container();
                  }),
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
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: this.onDinhKem,
                            child: SvgPicture.asset("assets/icons/attack.svg"),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: this.onClickSave,
                            child: Material(
                              child: Container(
                                height: AppValue.widths * 0.1,
                                width: AppValue.widths * 0.25,
                                decoration: BoxDecoration(
                                    color: HexColor("#F1A400"),
                                    borderRadius: BorderRadius.circular(20.5)),
                                child: Center(
                                    child: Text(
                                  "Lưu",
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }))
      ],
    );
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
              child: Center(
                  child: Container(
                      height: 50,
                      width: 50,
                      child:
                          SvgPicture.asset("assets/icons/iconInputImg.svg"))),
            )
          ]),
        ),
      ],
    );
  }

  Widget _fieldInputCustomer(
      CustomerIndividualItemData data, int index, int index1,
      {bool noEdit = false, String value = ""}) {
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
                data.field_require == 1
                    ? TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 12,
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
                  readOnly: noEdit,
                  initialValue: value == "null" ? "" : value,
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
      if (dropdownItemList[i][1] != null && dropdownItemList[i][0] != null) {
        dropdow.add(ModelDataAdd(
            label: dropdownItemList[i][1], value: dropdownItemList[i][0]));
        if (dropdownItemList[i][0].toString() == value.toString()) {
          indexDefault = i;
        } else {}
      }
    }
    return (Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: HexColor("#697077")),
              children: <TextSpan>[
                required == 1
                    ? TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 12,
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
                // _selectedAnimals = values;
                if (maxLength != "" && values.length > int.parse(maxLength)) {
                  values.removeRange(int.parse(maxLength), values.length);
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
              selectedItemsTextStyle: AppStyle.DEFAULT_12,
              itemsTextStyle: AppStyle.DEFAULT_12),
        ],
      ),
    ));
  }

  TextStyle hintTextStyle() => TextStyle(
      fontFamily: "Roboto",
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: HexColor("#838A91"));

  TextStyle titlestyle() => TextStyle(
      fontFamily: "Roboto",
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: HexColor("#697077"));

  void onClickSave() {
    final Map<String, dynamic> data = {};
    bool check = false;
    for (int i = 0; i < addData.length; i++) {
      for (int j = 0; j < addData[i].data.length; j++) {
        if ((addData[i].data[j].value == null ||
                addData[i].data[j].value == 'null' ||
                addData[i].data[j].value == "") &&
            addData[i].data[j].required == 1) {
          check = true;
          break;
        } else if (addData[i].data[j].value != null &&
            addData[i].data[j].value != 'null') {
          data["${addData[i].data[j].label}"] = addData[i].data[j].value;
        } else
          data["${addData[i].data[j].label}"] = "";
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
      data["id"] = id;
      if (type == 1) {
        AddDataBloc.of(context).add(EditCustomerEvent(data, files: fileUpload));
      } else if (type == 2) {
        AddDataBloc.of(context)
            .add(AddContactCustomerEvent(data, files: fileUpload));
      } else if (type == 3) {
        AddDataBloc.of(context)
            .add(AddOpportunityEvent(data, files: fileUpload));
      } else if (type == 4) {
        AddDataBloc.of(context).add(AddContractEvent(data, files: fileUpload));
      } else if (type == 5) {
        AddDataBloc.of(context).add(EditJobEvent(data, files: fileUpload));
      } else if (type == 6) {
        AddDataBloc.of(context).add(AddSupportEvent(data, files: fileUpload));
      }
    }
  }

  Future<void> onDinhKem() async {
    ImagePicker picker = ImagePicker();
    XFile? result = await picker.pickImage(
        source: ImageSource.gallery, preferredCameraDevice: CameraDevice.rear);
    if (result != null) {
      fileUpload = File(result.path);
      AttackBloc.of(context).add(InitAttackEvent(file: File(result.path)));
    } else {
      // User canceled the picker
    }
  }
}

class WidgetInputMulti extends StatefulWidget {
  WidgetInputMulti(
      {Key? key,
      required this.data,
      required this.onSelect,
      required this.value,
      required this.onRemove})
      : super(key: key);

  final CustomerIndividualItemData data;
  Function onSelect;
  Function onRemove;
  List<String> value;

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
    arr = widget.value;
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
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: HexColor("#697077")),
              children: <TextSpan>[
                widget.data.field_require == 1
                    ? TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 12,
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
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: COLORS.BACKGROUND),
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
                                          widget.onRemove(arr);
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

class renderCheckBox extends StatefulWidget {
  renderCheckBox({Key? key, required this.onChange, required this.data})
      : super(key: key);

  Function? onChange;
  final CustomerIndividualItemData data;

  @override
  State<renderCheckBox> createState() => _renderCheckBoxState();
}

class _renderCheckBoxState extends State<renderCheckBox> {
  bool isCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isCheck = widget.data.field_set_value == "1" ? true : false;
    });
  }

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
            text: TextSpan(
              text: widget.data.field_label ?? '',
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: HexColor("#697077")),
              children: <TextSpan>[
                widget.data.field_require == 1
                    ? TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
