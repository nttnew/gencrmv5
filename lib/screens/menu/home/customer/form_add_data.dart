import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/contract/phone_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/add_data_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/form_add_data_bloc.dart';
import 'package:gen_crm/models/model_data_add.dart';
import 'package:gen_crm/models/model_item_add.dart';
import 'package:gen_crm/screens/menu/home/customer/input_dropDown.dart';
import 'package:gen_crm/widgets/widgetFieldInputPercent.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../../../src/models/model_generator/add_customer.dart';
import '../../../../../../../src/src_index.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../../../../../widgets/widget_dialog.dart';

import '../../../../bloc/chance_customer/chance_customer_bloc.dart';
import '../../../../bloc/clue/clue_bloc.dart';
import '../../../../bloc/clue_customer/clue_customer_bloc.dart';
import '../../../../bloc/contact_by_customer/contact_by_customer_bloc.dart';
import '../../../../bloc/contract/attack_bloc.dart';
import '../../../../bloc/contract/contract_bloc.dart';
import '../../../../bloc/contract_customer/contract_customer_bloc.dart';
import '../../../../bloc/job_contract/job_contract_bloc.dart';
import '../../../../bloc/job_customer/job_customer_bloc.dart';
import '../../../../bloc/support/support_bloc.dart';
import '../../../../bloc/support_contract_bloc/support_contract_bloc.dart';
import '../../../../bloc/support_customer/support_customer_bloc.dart';
import '../../../../bloc/work/work_bloc.dart';
import '../../../../bloc/work_clue/work_clue_bloc.dart';
import '../../../../models/widget_input_date.dart';

import '../../../../src/models/model_generator/login_response.dart';
import '../../../../storages/share_local.dart';

class FormAddData extends StatefulWidget {
  const FormAddData({Key? key}) : super(key: key);

  @override
  State<FormAddData> createState() => _FormAddDataState();
}

class _FormAddDataState extends State<FormAddData> {
  String title = Get.arguments[0];
  int type = Get.arguments[1];
  String id = Get.arguments[2] != null ? Get.arguments[2].toString() : "";

  List data = [];
  List<ModelItemAdd> addData = [];
  late String id_user;
  File? fileUpload;

  late final ScrollController scrollController;
  late final BehaviorSubject<bool> isMaxScroll;

  @override
  void initState() {
    scrollController = ScrollController();
    isMaxScroll = BehaviorSubject.seeded(false);
    loadUser();
    AttackBloc.of(context).add(LoadingAttackEvent());
    if (type == 1) {
      FormAddBloc.of(context).add(InitFormAddCusOrEvent());
    } else if (type == 11) {
      FormAddBloc.of(context)
          .add(InitFormAddContactCusEvent(Get.arguments[2].toString()));
    } else if (type == 12) {
      FormAddBloc.of(context)
          .add(InitFormAddOppCusEvent(Get.arguments[2].toString()));
    } else if (type == 13) {
      FormAddBloc.of(context)
          .add(InitFormAddContractCusEvent(Get.arguments[2].toString()));
    } else if (type == 14) {
      FormAddBloc.of(context)
          .add(InitFormAddJobCusEvent(Get.arguments[2].toString()));
    } else if (type == 15) {
      FormAddBloc.of(context)
          .add(InitFormAddSupportCusEvent(Get.arguments[2].toString()));
    } else if (type == 2) {
      FormAddBloc.of(context).add(InitFormAddAgencyEvent());
    } else if (type == 3) {
      FormAddBloc.of(context).add(InitFormAddChanceEvent());
    } else if (type == 4) {
      FormAddBloc.of(context)
          .add(InitFormAddContractEvent(id: Get.arguments[2].toString()));
    } else if (type == 5) {
      FormAddBloc.of(context).add(InitFormAddJobEvent());
    } else if (type == 6) {
      FormAddBloc.of(context).add(InitFormAddSupportEvent());
    } else if (type == 21) {
      FormAddBloc.of(context)
          .add(InitFormAddJobOppEvent(Get.arguments[2].toString()));
    } else if (type == 31) {
      FormAddBloc.of(context)
          .add(InitFormAddJobChanceEvent(Get.arguments[2].toString()));
    } else if (type == 41) {
      FormAddBloc.of(context)
          .add(InitFormAddSupportContractEvent(Get.arguments[2].toString()));
    } else if (type == 42) {
      FormAddBloc.of(context)
          .add(InitFormAddJobContractEvent(Get.arguments[2].toString()));
    }
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

  void loadUser() async {
    final response = await shareLocal.getString(PreferencesKey.USER);
    if (response != null) {
      id_user = LoginData.fromJson(jsonDecode(response)).info_user!.user_id!;
    }
  }

  @override
  void dispose() {
    data.clear();
    addData.clear();
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
                        content: "Thêm mới dữ liệu thành công!",
                        textButton1: "OK",
                        backgroundButton1: COLORS.PRIMARY_COLOR,
                        onTap1: () {
                          Get.back();
                          Get.back();
                          if (type == 2)
                            GetListClueBloc.of(context)
                                .add(InitGetListClueEvent('', 1, ''));
                          else if (type == 3) {
                            GetListChanceBloc.of(context)
                                .add(InitGetListOrderEventChance('', 1, ''));
                          } else if (type == 4) {
                            ContractBloc.of(context)
                                .add(InitGetContractEvent(1, "", ""));
                          } else if (type == 5) {
                            WorkBloc.of(context)
                                .add(InitGetListWorkEvent("1", "", ""));
                          } else if (type == 6) {
                            SupportBloc.of(context)
                                .add(InitGetSupportEvent(1, '', ''));
                          } else if (type == 21) {
                            WorkClueBloc.of(context).add(GetWorkClue(id: id));
                          } else if (type == 31) {
                            GetJobChanceBloc.of(context)
                                .add(InitGetJobEventChance(int.parse(id)));
                          } else if (type == 41) {
                            SupportContractBloc.of(context).add(
                                InitGetSupportContractEvent(int.parse(id)));
                          } else if (type == 42) {
                            JobContractBloc.of(context)
                                .add(InitGetJobContractEvent(int.parse(id)));
                          } else if (type == 11) {
                            ClueCustomerBloc.of(context)
                                .add(InitGetClueCustomerEvent(int.parse(id)));
                          } else if (type == 12) {
                            ChanceCustomerBloc.of(context)
                                .add(InitGetChanceCustomerEvent(int.parse(id)));
                          } else if (type == 13) {
                            ContractCustomerBloc.of(context).add(
                                InitGetContractCustomerEvent(int.parse(id)));
                          } else if (type == 14) {
                            JobCustomerBloc.of(context)
                                .add(InitGetJobCustomerEvent(int.parse(id)));
                          } else if (type == 15) {
                            SupportCustomerBloc.of(context).add(
                                InitGetSupportCustomerEvent(int.parse(id)));
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
                  controller: scrollController,
                  child: BlocBuilder<FormAddBloc, FormAddState>(
                      builder: (context, state) {
                    if (state is LoadingFormAddCustomerOrState) {
                      addData = [];
                      data = [];
                      return Container();
                    } else if (state is SuccessFormAddCustomerOrState) {
                      for (int i = 0; i < state.listAddData.length; i++) {
                        addData.add(ModelItemAdd(
                            group_name: state.listAddData[i].group_name ?? '',
                            data: []));
                        for (int j = 0;
                            j < state.listAddData[i].data!.length;
                            j++) {
                          // if(state.listAddData[i].data![j].field_type!="HIDDEN")
                          addData[i].data.add(ModelDataAdd(
                              label: state.listAddData[i].data![j].field_name,
                              value: state
                                  .listAddData[i].data![j].field_set_value
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
                                (index) =>
                                    (state.listAddData[index].data != null &&
                                            state.listAddData[index].data!
                                                    .length >
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
                                                        .data!.length,
                                                    (index1) => state
                                                                .listAddData[
                                                                    index]
                                                                .data![index1]
                                                                .field_hidden !=
                                                            "1"
                                                        ? state.listAddData[index].data![index1].field_special ==
                                                                "none-edit"
                                                            ? ((state.listAddData[index].data![index1].field_id == "12547" ||
                                                                    state.listAddData[index].data![index1].field_id ==
                                                                        "1472")
                                                                ? BlocBuilder<PhoneBloc, PhoneState>(builder: (context, stateA) {
                                                                    if (stateA
                                                                        is SuccessPhoneState) {
                                                                      return _fieldInputCustomer(
                                                                          state.listAddData[index].data![
                                                                              index1],
                                                                          index,
                                                                          index1,
                                                                          noEdit:
                                                                              true,
                                                                          value:
                                                                              stateA.phone);
                                                                    } else
                                                                      return Container();
                                                                  })
                                                                : _fieldInputCustomer(
                                                                    state.listAddData[index].data![index1],
                                                                    index,
                                                                    index1,
                                                                    noEdit: true))
                                                            : state.listAddData[index].data![index1].field_type == "SELECT" || state.listAddData[index].data![index1].field_id == "12463" || state.listAddData[index].data![index1].field_id == "12464"
                                                                ? ((state.listAddData[index].data![index1].field_id == '115' || state.listAddData[index].data![index1].field_id == '135')
                                                                    ? BlocBuilder<ContactByCustomerBloc, ContactByCustomerState>(builder: (context, stateA) {
                                                                        if (stateA
                                                                            is UpdateGetContacBytCustomerState) {
                                                                          return InputDropdown(
                                                                              dropdownItemList: stateA.listContactByCustomer,
                                                                              data: state.listAddData[index].data![index1],
                                                                              onSuccess: (data) {
                                                                                addData[index].data[index1].value = data;
                                                                                if (state.listAddData[index].data![index1].field_id != "107") PhoneBloc.of(context).add(InitAgencyPhoneEvent(data));
                                                                              },
                                                                              value: state.listAddData[index].data![index1].field_value ?? '');
                                                                        } else if (stateA
                                                                            is LoadingContactByCustomerState) {
                                                                          return Container();
                                                                        } else {
                                                                          return InputDropdown(
                                                                              dropdownItemList: state.listAddData[index].data![index1].field_datasource ?? [],
                                                                              data: state.listAddData[index].data![index1],
                                                                              onSuccess: (data) {
                                                                                addData[index].data[index1].value = data;
                                                                                if (state.listAddData[index].data![index1].field_id != "107") PhoneBloc.of(context).add(InitAgencyPhoneEvent(data));
                                                                              },
                                                                              value: state.listAddData[index].data![index1].field_value ?? '');
                                                                        }
                                                                      })
                                                                    : InputDropdown(
                                                                        dropdownItemList: state.listAddData[index].data![index1].field_datasource ?? [],
                                                                        data: state.listAddData[index].data![index1],
                                                                        onSuccess: (data) {
                                                                          addData[index]
                                                                              .data[index1]
                                                                              .value = data;
                                                                          if (state.listAddData[index].data![index1].field_id == "107" ||
                                                                              state.listAddData[index].data![index1].field_id == "128") {
                                                                            ContactByCustomerBloc.of(context).add(InitGetContactByCustomerrEvent(data));
                                                                            PhoneBloc.of(context).add(InitPhoneEvent(data));
                                                                          }
                                                                        },
                                                                        value: state.listAddData[index].data![index1].field_value ?? ''))
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
                                                                                    ? renderCheckBox(
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
                                                                                        : _fieldInputCustomer(state.listAddData[index].data![index1], index, index1)
                                                        : SizedBox()),
                                              )
                                            ],
                                          )
                                        : Container()),
                          ),
                          BlocBuilder<AttackBloc, AttackState>(
                              builder: (context, state) {
                            if (state is SuccessAttackState) if (state.file !=
                                null) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                scrollController.jumpToBottom();
                              });

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
                            } else
                              return Container();
                            else
                              return Container();
                          }),
                          SizedBox(
                            height: AppValue.widths * 0.1 + 10,
                          )
                        ],
                      );
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
                            child: SvgPicture.asset("assets/icons/attack.svg")),
                        Spacer(),
                        GestureDetector(
                          onTap: this.onClickSave,
                          child: Material(
                            color: Colors.white,
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
              }),
        )
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
    if ((type == 21 && data.field_id == "12547") ||
        (type == 31 && data.field_id == "12547")) {
      return Container();
    } else {
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
                        isDense: true),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
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
      fontSize: 14,
      fontFamily: "Roboto",
      fontWeight: FontWeight.w500,
      color: HexColor("#838A91"));

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
      if (type == 1) {
        AddDataBloc.of(context)
            .add(AddCustomerOrEvent(data, files: fileUpload));
      } else if (type == 11) {
        data["customer_id"] = Get.arguments[2];
        AddDataBloc.of(context)
            .add(AddContactCustomerEvent(data, files: fileUpload));
      } else if (type == 12) {
        data["customer_id"] = Get.arguments[2];
        AddDataBloc.of(context)
            .add(AddOpportunityEvent(data, files: fileUpload));
      } else if (type == 13) {
        data["customer_id"] = Get.arguments[2];
        AddDataBloc.of(context).add(AddContractEvent(data, files: fileUpload));
      } else if (type == 14) {
        data["customer_id"] = Get.arguments[2];
        AddDataBloc.of(context).add(AddJobEvent(data, files: fileUpload));
      } else if (type == 15) {
        data["customer_id"] = Get.arguments[2];
        data["nguoi_xu_lht"] = id_user;
        AddDataBloc.of(context).add(AddSupportEvent(data, files: fileUpload));
      } else if (type == 2) {
        AddDataBloc.of(context)
            .add(AddContactCustomerEvent(data, files: fileUpload));
      } else if (type == 3) {
        AddDataBloc.of(context)
            .add(AddOpportunityEvent(data, files: fileUpload));
      } else if (type == 4) {
        data["customer_id"] = Get.arguments[2];
        AddDataBloc.of(context).add(AddContractEvent(data, files: fileUpload));
      } else if (type == 5) {
        AddDataBloc.of(context).add(AddJobEvent(data, files: fileUpload));
      } else if (type == 6) {
        data["nguoi_xu_lht"] = id_user;
        AddDataBloc.of(context).add(AddSupportEvent(data, files: fileUpload));
      } else if (type == 21) {
        data["daumoi_id"] = Get.arguments[2].toString();
        AddDataBloc.of(context).add(AddJobEvent(data, files: fileUpload));
      } else if (type == 31) {
        data["cohoi_id"] = Get.arguments[2].toString();
        AddDataBloc.of(context).add(AddJobEvent(data, files: fileUpload));
      } else if (type == 41) {
        data["hopdong_id"] = Get.arguments[2].toString();
        data["nguoi_xu_lht"] = id_user;
        AddDataBloc.of(context).add(AddSupportEvent(data, files: fileUpload));
      } else if (type == 42) {
        data["hopdong_id"] = Get.arguments[2].toString();
        AddDataBloc.of(context).add(AddJobEvent(data, files: fileUpload));
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
                  // maxLength:widget.data.field_maxlength!=null? int.parse(widget.data.field_maxlength!):null,
                  // maxLengthEnforcement: MaxLengthEnforcement.none,123123
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
                                        style: AppStyle.DEFAULT_12,
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
