import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/contract/contract_bloc.dart';
import 'package:gen_crm/bloc/contract/phone_bloc.dart';
import 'package:gen_crm/bloc/detail_product/detail_product_bloc.dart';
import 'package:gen_crm/bloc/detail_product_customer/detail_product_customer_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/add_data_bloc.dart';
import 'package:gen_crm/bloc/form_edit/form_edit_bloc.dart';
import 'package:gen_crm/models/model_data_add.dart';
import 'package:gen_crm/models/model_item_add.dart';
import 'package:gen_crm/screens/menu/form/widget/location_select.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import '../../../api_resfull/user_repository.dart';
import '../../../bloc/add_service_voucher/add_service_bloc.dart';
import '../../../bloc/clue/clue_bloc.dart';
import '../../../bloc/contact_by_customer/contact_by_customer_bloc.dart';
import '../../../bloc/contract/attack_bloc.dart';
import '../../../bloc/contract/detail_contract_bloc.dart';
import '../../../bloc/product_customer_module/product_customer_module_bloc.dart';
import '../../../bloc/product_module/product_module_bloc.dart';
import '../../../bloc/support/support_bloc.dart';
import '../../../bloc/work/work_bloc.dart';
import '../../../l10n/key_text.dart';
import '../../../widgets/widget_input_date.dart';
import '../../../src/models/model_generator/add_customer.dart';
import '../../../widgets/pick_file_image.dart';
import '../../../src/src_index.dart';
import '../../../widgets/appbar_base.dart';
import '../../../widgets/field_input_select_multi.dart';
import '../../../widgets/loading_api.dart';
import '../../../widgets/multiple_widget.dart';
import '../../../widgets/widget_field_input_percent.dart';
import '../../add_service_voucher/add_service_voucher_step2_screen.dart';
import '../home/customer/widget/input_dropDown.dart';

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

  @override
  void initState() {
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
    super.initState();
  }

  @override
  void deactivate() {
    ServiceVoucherBloc.of(context).loaiXe.add('');
    ServiceVoucherBloc.of(context).resetDataCarVerison();
    AttackBloc.of(context).add(RemoveAllAttackEvent());
    super.deactivate();
  }

  showLog(String mess) {
    ShowDialogCustom.showDialogBase(
      title: getT(KeyT.notification),
      content: mess,
      textButton1: getT(KeyT.come_back),
      onTap1: () {
        Get.back();
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS.WHITE,
      appBar: AppbarBaseNormal(getT(KeyT.edit_information)),
      body: BlocListener<AddDataBloc, AddDataState>(
        listener: (context, state) async {
          if (state is SuccessEditCustomerState) {
            LoadingApi().popLoading();
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: getT(KeyT.update_data_successfully),
              onTap1: () {
                Get.back();
                Get.back();

                if (type == EDIT_CUSTOMER)
                  GetListCustomerBloc.of(context)
                      .loadMoreController
                      .reloadData();
              },
            );
          } else if (state is ErrorEditCustomerState) {
            LoadingApi().popLoading();
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: state.msg,
            );
          } else if (state is SuccessAddContactCustomerState) {
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: getT(KeyT.update_data_successfully),
              onTap1: () {
                Get.back();
                Get.back();
                if (type == EDIT_CLUE) {
                  GetListClueBloc.of(context).loadMoreController.reloadData();
                }
                if (type == EDIT_CHANCE) {
                  GetListDetailChanceBloc.of(context)
                      .add(InitGetListDetailEvent(int.parse(id)));
                  GetListChanceBloc.of(context).loadMoreController.reloadData();
                }
                if (type == EDIT_JOB) {
                  WorkBloc.of(context).loadMoreController.reloadData();
                }
                if (type == 4) {
                  ContractBloc.of(context).add(InitGetContractEvent());
                  DetailContractBloc.of(context)
                      .add(InitGetDetailContractEvent(int.parse(id)));
                }
                if (type == EDIT_SUPPORT) {
                  SupportBloc.of(context).add(InitGetSupportEvent());
                }
                if (type == PRODUCT_TYPE) {
                  ProductModuleBloc.of(context).loadMoreController.reloadData();
                  DetailProductBloc.of(context)
                      .add(InitGetDetailProductEvent(id));
                }
                if (type == PRODUCT_CUSTOMER_TYPE) {
                  ProductCustomerModuleBloc.of(context)
                      .loadMoreController
                      .reloadData();
                  DetailProductCustomerBloc.of(context)
                      .add(InitGetDetailProductCustomerEvent(id));
                }
              },
            );
          } else if (state is ErrorAddContactCustomerState) {
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: state.msg,
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: BlocBuilder<FormEditBloc, FormEditState>(
              builder: (context, state) {
            if (state is LoadingFormEditState) {
              addData = [];
              data = [];
              return SizedBox.shrink();
            } else if (state is ErrorFormEditState) {
              return Text(
                state.msg,
                style: AppStyle.DEFAULT_16_T,
              );
            } else if (state is SuccessFormEditState) {
              if (addData.isNotEmpty) {
              } else {
                for (int i = 0; i < state.listEditData.length; i++) {
                  addData.add(ModelItemAdd(
                      group_name: state.listEditData[i].group_name ?? '',
                      data: []));
                  for (int j = 0; j < state.listEditData[i].data!.length; j++) {
                    addData[i].data.add(
                          ModelDataAdd(
                            label: state.listEditData[i].data![j].field_name,
                            value: state
                                .listEditData[i].data![j].field_set_value
                                .toString(),
                            required:
                                state.listEditData[i].data![j].field_require,
                          ),
                        );
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
                      (indexParent) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: AppValue.heights * 0.01,
                          ),
                          state.listEditData[indexParent].group_name != null
                              ? WidgetText(
                                  title: state.listEditData[indexParent]
                                          .group_name ??
                                      '',
                                  style: AppStyle.DEFAULT_18_BOLD)
                              : SizedBox.shrink(),
                          SizedBox(
                            height: AppValue.heights * 0.01,
                          ),
                          Column(
                            children: List.generate(
                              (state.listEditData[indexParent].data?.length ??
                                  0),
                              (indexChild) => _getBody(
                                state.listEditData[indexParent]
                                    .data![indexChild],
                                indexParent,
                                indexChild,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  FileDinhKemUiBase(
                      context: context, onTap: () {}, isSave: false),
                  SizedBox(
                    height: 25,
                  ),
                  FileLuuBase(context, () => onClickSave()),
                ],
              );
            } else if (state is ErrorFormEditState) {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => showLog(state.msg));
              return SizedBox.shrink();
            } else
              return SizedBox.shrink();
          }),
        ),
      ),
    );
  }

  Widget _getBody(
      CustomerIndividualItemData data, int indexParent, int indexChild) {
    if (data.field_name == "col131")
      customer_id = data.field_set_value.toString();
    return data.field_hidden != "1"
        ? data.field_special == "none-edit"
            ? (data.field_name == "so_dien_thoai"
                ? BlocBuilder<PhoneBloc, PhoneState>(builder: (context, stateA) {
                    if (stateA is SuccessPhoneState) {
                      return _fieldInputCustomer(
                        data,
                        indexParent,
                        indexChild,
                        noEdit: true,
                        value: stateA.phone,
                      );
                    } else if (stateA is LoadingPhoneState)
                      return SizedBox.shrink();
                    else {
                      return _fieldInputCustomer(
                        data,
                        indexParent,
                        indexChild,
                        noEdit: true,
                        value: data.field_value ?? '',
                      );
                    }
                  })
                : ServiceVoucherBloc.of(context).getInput(data.field_name ?? '')
                    ? StreamBuilder<String>(
                        stream: ServiceVoucherBloc.of(context)
                            .loaiXe, //getdata selectcar local
                        builder: (context, snapshot) {
                          return fieldCar(
                              data, indexParent, indexChild, context,
                              value: ServiceVoucherBloc.of(context)
                                  .getDataSelectCar(data.field_name ?? ''));
                        })
                    : _fieldInputCustomer(
                        data,
                        indexParent,
                        indexChild,
                        noEdit: true,
                      ))
            : data.field_type == "SELECT"
                ? ((data.field_name == 'cv_nguoiLienHe' ||
                        data.field_name == 'col131')
                    ? BlocBuilder<ContactByCustomerBloc, ContactByCustomerState>(
                        builder: (context, stateA) {
                        if (stateA is UpdateGetContacBytCustomerState)
                          return InputDropdown(
                            typeScreen: type,
                            dropdownItemList: stateA.listContactByCustomer,
                            data: data,
                            onSuccess: (value) {
                              addData[indexParent].data[indexChild].value =
                                  value;
                              if (data.field_name != "cv_kh")
                                PhoneBloc.of(context)
                                    .add(InitAgencyPhoneEvent(value));
                            },
                            value: (data.field_set_value_datasource != null &&
                                    data.field_set_value_datasource!.length > 0)
                                ? data.field_set_value_datasource![0][1]
                                    .toString()
                                : '',
                          );
                        else if (stateA is LoadingContactByCustomerState) {
                          return SizedBox.shrink();
                        } else
                          return InputDropdown(
                            typeScreen: type,
                            dropdownItemList: data.field_datasource ?? [],
                            data: data,
                            onSuccess: (value) {
                              addData[indexParent].data[indexChild].value =
                                  value;
                              if (data.field_name != "cv_kh")
                                PhoneBloc.of(context)
                                    .add(InitAgencyPhoneEvent(value));
                            },
                            value: (data.field_set_value_datasource != null &&
                                    data.field_set_value_datasource!.length > 0)
                                ? data.field_set_value_datasource![0][1]
                                    .toString()
                                : '',
                          );
                      })
                    : checkLocation(data)
                        ? LocationWidget(
                            data: data,
                            onSuccess: (data) {
                              addData[indexParent].data[indexChild].value =
                                  data;
                            },
                            initData: data.field_value,
                          )
                        : InputDropdown(
                            dropdownItemList: data.field_datasource ?? [],
                            data: data,
                            onSuccess: (value) {
                              addData[indexParent].data[indexChild].value =
                                  value;
                              if (data.field_name == "cv_kh" ||
                                  data.field_name == "col121") {
                                ContactByCustomerBloc.of(context)
                                    .add(InitGetContactByCustomerrEvent(value));
                                PhoneBloc.of(context)
                                    .add(InitPhoneEvent(value));
                              }
                            },
                            value: ((data.field_set_value_datasource != null &&
                                    data.field_set_value_datasource!.length > 0)
                                ? data.field_set_value_datasource![0][1]
                                    .toString()
                                : '')))
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
                        ? SizedBox.shrink()
                        : data.field_type == "TEXT_MULTI_NEW"
                            ? InputMultipleWidget(
                                data: data,
                                onSelect: (data) {
                                  addData[indexParent].data[indexChild].value =
                                      data.join(",");
                                },
                                value: (data.field_set_value != null &&
                                        data.field_set_value != "")
                                    ? data.field_set_value.split(",")
                                    : [],
                              )
                            : data.field_type == "DATE"
                                ? WidgetInputDate(
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
                                    : data.field_type == "CHECK"
                                        ? RenderCheckBox(
                                            onChange: (check) {
                                              addData[indexParent]
                                                  .data[indexChild]
                                                  .value = check ? 1 : 0;
                                            },
                                            data: data,
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
                                            : data.field_name == 'chi_tiet_xe' &&
                                                    data.field_type == 'TEXT'
                                                ? TypeCarBase(
                                                    data,
                                                    indexParent,
                                                    indexChild,
                                                    context,
                                                    ServiceVoucherBloc.of(
                                                        context),
                                                    (v) {
                                                      addData[indexParent]
                                                          .data[indexChild]
                                                          .value = v;
                                                    },
                                                  )
                                                : _fieldInputCustomer(
                                                    data, indexParent, indexChild,
                                                    value: data.field_set_value
                                                        .toString())
        : SizedBox();
  }

  Widget _fieldInputCustomer(
      CustomerIndividualItemData data, int indexParent, int indexChild,
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
                color: noEdit == true ? COLORS.LIGHT_GREY : COLORS.WHITE,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: COLORS.ffBEB4B4)),
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
                    addData[indexParent].data[indexChild].value = text;
                  },
                  readOnly: noEdit,
                  initialValue: value == "null" ? "" : value,
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
        title: getT(KeyT.notification),
        content: getT(KeyT.please_enter_all_required_fields),
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

  final Function? onChange;
  final CustomerIndividualItemData data;

  @override
  State<RenderCheckBox> createState() => _RenderCheckBoxState();
}

class _RenderCheckBoxState extends State<RenderCheckBox> {
  bool isCheck = false;

  @override
  void initState() {
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
                color: COLORS.BLACK,
              ),
              children: <TextSpan>[
                widget.data.field_require == 1
                    ? TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: COLORS.RED,
                        ),
                      )
                    : TextSpan(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
