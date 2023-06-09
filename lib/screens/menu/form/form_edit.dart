import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/contract/contract_bloc.dart';
import 'package:gen_crm/bloc/contract/phone_bloc.dart';
import 'package:gen_crm/bloc/detail_product/detail_product_bloc.dart';
import 'package:gen_crm/bloc/detail_product_customer/detail_product_customer_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/add_data_bloc.dart';
import 'package:gen_crm/bloc/form_edit/form_edit_bloc.dart';
import 'package:gen_crm/models/model_data_add.dart';
import 'package:gen_crm/models/model_item_add.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rxdart/rxdart.dart';
import '../../../api_resfull/user_repository.dart';
import '../../../bloc/add_service_voucher/add_service_bloc.dart';
import '../../../bloc/clue/clue_bloc.dart';
import '../../../bloc/contact_by_customer/contact_by_customer_bloc.dart';
import '../../../bloc/contract/attack_bloc.dart';
import '../../../bloc/contract/detail_contract_bloc.dart';
import '../../../bloc/detail_clue/detail_clue_bloc.dart';
import '../../../bloc/product_customer_module/product_customer_module_bloc.dart';
import '../../../bloc/product_module/product_module_bloc.dart';
import '../../../bloc/support/detail_support_bloc.dart';
import '../../../bloc/support/support_bloc.dart';
import '../../../bloc/work/detail_work_bloc.dart';
import '../../../bloc/work/work_bloc.dart';
import '../../../models/widget_input_date.dart';
import '../../../src/models/model_generator/add_customer.dart';
import '../../../src/pick_file_image.dart';
import '../../../src/src_index.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../../widgets/appbar_base.dart';
import '../../../widgets/loading_api.dart';
import '../../../widgets/multiple_widget.dart';
import '../../../widgets/widget_field_input_percent.dart';
import '../../add_service_voucher/add_service_voucher_step2_screen.dart';
import '../home/customer/input_dropDown.dart';

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
    if (type == EDIT_CUSTOMER)
      FormEditBloc.of(context).add(InitFormEditCusEvent(id));
    else if (type == EDIT_CLUE) {
      FormEditBloc.of(context).add(InitFormEditClueEvent(id));
    } else if (type == EDIT_CHANCE) {
      FormEditBloc.of(context).add(InitFormEditChanceEvent(id));
    } else if (type == 4) {
      FormEditBloc.of(context).add(InitFormEditContractEvent(id));
    } else if (type == EDIT_JOB) {
      FormEditBloc.of(context).add(InitFormEditJobEvent(id));
    } else if (type == EDIT_SUPPORT) {
      FormEditBloc.of(context).add(InitFormEditSupportEvent(id));
    } else if (type == PRODUCT_TYPE) {
      FormEditBloc.of(context).add(InitFormEditProductEvent(id));
    } else if (type == PRODUCT_CUSTOMER_TYPE) {
      FormEditBloc.of(context).add(InitFormEditProductCustomerEvent(id));
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

  @override
  void deactivate() {
    ServiceVoucherBloc.of(context).loaiXe.add('');
    ServiceVoucherBloc.of(context).resetDataCarVerison();
    AttackBloc.of(context).add(RemoveAllAttackEvent());
    super.deactivate();
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
    ShowDialogCustom.showDialogBase(
      title: MESSAGES.NOTIFICATION,
      content: mess,
      textButton1: "Quay lại",
      onTap1: () {
        Get.back();
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            backgroundColor: Colors.white,
            appBar: AppbarBaseNormal('Sửa thông tin'),
            body: BlocListener<AddDataBloc, AddDataState>(
              listener: (context, state) async {
                if (state is SuccessEditCustomerState) {
                  LoadingApi().popLoading();
                  ShowDialogCustom.showDialogBase(
                    title: MESSAGES.NOTIFICATION,
                    content: "Update dữ liệu thành công!",
                    onTap1: () {
                      if (type == EDIT_CUSTOMER)
                        GetListCustomerBloc.of(context)
                            .add(InitGetListOrderEvent());
                      Get.back();
                      Get.back();
                      Get.back();
                    },
                  );
                }
                if (state is ErrorEditCustomerState) {
                  LoadingApi().popLoading();
                  ShowDialogCustom.showDialogBase(
                    title: MESSAGES.NOTIFICATION,
                    content: state.msg,
                  );
                }
                if (state is SuccessAddContactCustomerState) {
                  ShowDialogCustom.showDialogBase(
                    title: MESSAGES.NOTIFICATION,
                    content: "Update dữ liệu thành công!",
                    onTap1: () {
                      Get.back();
                      Get.back();
                      if (type == EDIT_CLUE) {
                        GetDetailClueBloc.of(context)
                            .add(InitGetDetailClueEvent(id));
                        GetListClueBloc.of(context).add(InitGetListClueEvent());
                      }
                      if (type == EDIT_CHANCE) {
                        GetListDetailChanceBloc.of(context)
                            .add(InitGetListDetailEvent(int.parse(id)));
                        GetListChanceBloc.of(context)
                            .add(InitGetListOrderEventChance());
                      }
                      if (type == EDIT_JOB) {
                        DetailWorkBloc.of(context)
                            .add(InitGetDetailWorkEvent(int.parse(id)));
                        WorkBloc.of(context).add(InitGetListWorkEvent());
                      }
                      if (type == 4) {
                        ContractBloc.of(context).add(InitGetContractEvent());
                        DetailContractBloc.of(context)
                            .add(InitGetDetailContractEvent(int.parse(id)));
                      }
                      if (type == EDIT_SUPPORT) {
                        DetailSupportBloc.of(context)
                            .add(InitGetDetailSupportEvent(id));
                        SupportBloc.of(context).add(InitGetSupportEvent());
                      }
                      if (type == PRODUCT_TYPE) {
                        ProductModuleBloc.of(context)
                            .add(InitGetListProductModuleEvent());
                        DetailProductBloc.of(context)
                            .add(InitGetDetailProductEvent(id));
                      }
                      if (type == PRODUCT_CUSTOMER_TYPE) {
                        ProductCustomerModuleBloc.of(context)
                            .add(GetProductCustomerModuleEvent());
                        DetailProductCustomerBloc.of(context)
                            .add(InitGetDetailProductCustomerEvent(id));
                      }
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
                      if (addData.isNotEmpty) {
                      } else {
                        for (int i = 0; i < state.listEditData.length; i++) {
                          addData.add(ModelItemAdd(
                              group_name:
                                  state.listEditData[i].group_name ?? '',
                              data: []));
                          for (int j = 0;
                              j < state.listEditData[i].data!.length;
                              j++) {
                            addData[i].data.add(ModelDataAdd(
                                label:
                                    state.listEditData[i].data![j].field_name,
                                value: state
                                    .listEditData[i].data![j].field_set_value
                                    .toString(),
                                required: state
                                    .listEditData[i].data![j].field_require));
                          }
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
                                                    .data![index1].field_name ==
                                                "col131")
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
                                                    ? (state.listEditData[index].data?[index1].field_name ==
                                                            "so_dien_thoai"
                                                        ? BlocBuilder<PhoneBloc, PhoneState>(builder:
                                                            (context, stateA) {
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
                                                    : state.listEditData[index].data![index1].field_type ==
                                                            "SELECT"
                                                        ? ((state.listEditData[index].data![index1].field_name ==
                                                                    'cv_nguoiLienHe' ||
                                                                state.listEditData[index].data![index1].field_name ==
                                                                    'col131')
                                                            ? BlocBuilder<ContactByCustomerBloc, ContactByCustomerState>(
                                                                builder: (context, stateA) {
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
                                                                        if (state.listEditData[index].data![index1].field_name !=
                                                                            "cv_kh")
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
                                                                        if (state.listEditData[index].data![index1].field_name !=
                                                                            "cv_kh")
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
                                                                  if (state.listEditData[index].data![index1].field_name ==
                                                                          "cv_kh" ||
                                                                      state.listEditData[index].data![index1]
                                                                              .field_name ==
                                                                          "col121") {
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
                                                                    ? InputMultipleWidget(
                                                                        data: state
                                                                            .listEditData[index]
                                                                            .data![index1],
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
                                                                            ? RenderCheckBox(
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
                                                                                : state.listEditData[index].data![index1].field_name == 'chi_tiet_xe' && state.listEditData[index].data![index1].field_type == 'TEXT'
                                                                                    ? TypeCarBase(
                                                                                        state.listEditData[index].data![index1],
                                                                                        index,
                                                                                        index1,
                                                                                        context,
                                                                                        ServiceVoucherBloc.of(context),
                                                                                        (v) {
                                                                                          addData[index].data[index1].value = v;
                                                                                        },
                                                                                      )
                                                                                    : _fieldInputCustomer(state.listEditData[index].data![index1], index, index1, value: state.listEditData[index].data![index1].field_set_value.toString())
                                                : SizedBox();
                                          }),
                                        )
                                      ],
                                    )),
                          ),
                          FileDinhKemUiBase(
                              context: context, onTap: () {}, isSave: false),
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
                      child: FileLuuBase(context, () => onClickSave()),
                    ),
                  );
                }))
      ],
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
                      child: SvgPicture.asset(ICONS.IC_INPUT_SVG))),
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
              items: dropdow
                  .map((e) => MultiSelectItem(e, e.label ?? ''))
                  .toList(),
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) {
                // _selectedAnimals = values;
                if (maxLength != "" && values.length > int.parse(maxLength)) {
                  values.removeRange(int.parse(maxLength), values.length);
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
      ShowDialogCustom.showDialogBase(
        title: MESSAGES.NOTIFICATION,
        content: "Hãy nhập đủ các trường bắt buộc (*)",
      );
    } else {
      data["id"] = id;
      if (type == EDIT_CUSTOMER) {
        AddDataBloc.of(context).add(
            EditCustomerEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == EDIT_CLUE) {
        AddDataBloc.of(context).add(AddContactCustomerEvent(data,
            files: AttackBloc.of(context).listFile));
      } else if (type == EDIT_CHANCE) {
        AddDataBloc.of(context).add(
            AddOpportunityEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == 4) {
        AddDataBloc.of(context).add(
            AddContractEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == EDIT_JOB) {
        AddDataBloc.of(context)
            .add(EditJobEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == EDIT_SUPPORT) {
        AddDataBloc.of(context)
            .add(AddSupportEvent(data, files: AttackBloc.of(context).listFile));
      } else if (type == PRODUCT_TYPE) {
        AddDataBloc.of(context).add(EditProductEvent(data, int.parse(id),
            files: AttackBloc.of(context).listFile));
      } else if (type == PRODUCT_CUSTOMER_TYPE) {
        AddDataBloc.of(context).add(EditProductCustomerEvent(data,
            files: AttackBloc.of(context).listFile));
      }
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
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              text: widget.data.field_label ?? '',
              style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: COLORS.BLACK),
              children: <TextSpan>[
                widget.data.field_require == 1
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
        ],
      ),
    );
  }
}
