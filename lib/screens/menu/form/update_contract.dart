// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gen_crm/bloc/contact_by_customer/contact_by_customer_bloc.dart';
// import 'package:gen_crm/bloc/form_add_data/add_data_bloc.dart';
// import 'package:gen_crm/bloc/form_edit/form_edit_bloc.dart';
// import 'package:gen_crm/models/model_data_add.dart';
// import 'package:gen_crm/models/model_item_add.dart';
// import 'package:gen_crm/screens/menu/form/product_list/product_contract.dart';
// import 'package:gen_crm/screens/menu/form/widget/location_select.dart';
// import 'package:gen_crm/screens/menu/home/contract/widget/widget_total_sum.dart';
// import 'package:gen_crm/src/app_const.dart';
// import 'package:gen_crm/src/models/model_generator/product_response.dart';
// import 'package:gen_crm/widgets/appbar_base.dart';
// import 'package:gen_crm/widgets/widget_text.dart';
// import 'package:get/get.dart';
// import '../../../../../../src/models/model_generator/add_customer.dart';
// import '../../../bloc/contract/attack_bloc.dart';
// import '../../../bloc/contract/contract_bloc.dart';
// import '../../../bloc/contract/detail_contract_bloc.dart';
// import '../../../bloc/contract/phone_bloc.dart';
// import '../../../bloc/contract/total_bloc.dart';
// import '../../../l10n/key_text.dart';
// import '../../../models/product_model.dart';
// import '../../../widgets/widget_input_date.dart';
// import '../../../src/models/model_generator/login_response.dart';
// import '../../../widgets/pick_file_image.dart';
// import '../../../src/src_index.dart';
// import '../../../storages/share_local.dart';
// import '../../../widgets/field_input_select_multi.dart';
// import '../../../widgets/multiple_widget.dart';
// import '../../../widgets/widget_field_input_percent.dart';
// import '../home/customer/widget/input_dropDown.dart';
//
// class EditContract extends StatefulWidget {
//   const EditContract({Key? key}) : super(key: key);
//
//   @override
//   State<EditContract> createState() => _EditContractState();
// }
//
// class _EditContractState extends State<EditContract> {
//   List data = [];
//   List<ModelItemAdd> addData = [];
//   late String id_user;
//   List<ProductModel> listProduct = [];
//   List<List<dynamic>> dauMoi = [];
//   String id = Get.arguments;
//   double total = 0;
//
//   @override
//   void initState() {
//     loadUser();
//     AttackBloc.of(context).add(LoadingAttackEvent());
//     FormEditBloc.of(context).add(InitFormEditContractEvent(id));
//     super.initState();
//   }
//
//   loadUser() async {
//     final response = await shareLocal.getString(PreferencesKey.USER);
//     if (response != null) {
//       id_user = LoginData.fromJson(jsonDecode(response)).info_user!.user_id!;
//     }
//   }
//
//   addProduct(ProductModel data) {
//     bool check = false;
//     for (int i = 0; i < listProduct.length; i++) {
//       if (data.id == listProduct[i].id &&
//           data.item.combo_id == listProduct[i].item.combo_id) {
//         check = true;
//         break;
//       }
//     }
//     if (check == false) {
//       listProduct.add(data);
//     }
//   }
//
//   reload() {
//     total = 0;
//     for (int i = 0; i < listProduct.length; i++) {
//       total += listProduct[i].intoMoney ?? 0;
//     }
//     TotalBloc.of(context).add(InitTotalEvent(total));
//   }
//
//   @override
//   void dispose() {
//     data.clear();
//     addData.clear();
//     listProduct.clear();
//     super.dispose();
//   }
//
//   @override
//   void deactivate() {
//     TotalBloc.of(context).add(ReloadTotalEvent());
//     ContactByCustomerBloc.of(context).chiTietXe.add('');
//     ContactByCustomerBloc.of(context).listXe.add([]);
//     AttackBloc.of(context).add(RemoveAllAttackEvent());
//     super.deactivate();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppbarBaseNormal(getT(KeyT.edit_information)),
//         body: BlocListener<AddDataBloc, AddDataState>(
//           listener: (context, state) async {
//             if (state is SuccessAddData) {
//               ShowDialogCustom.showDialogBase(
//                 title: getT(KeyT.notification),
//                 content: getT(KeyT.update_data_successfully),
//                 onTap1: () {
//                   Get.back();
//                   Get.back();
//                   DetailContractBloc.of(context)
//                       .add(InitGetDetailContractEvent(int.parse(id)));
//                   ContractBloc.of(context).add(InitGetContractEvent());
//                 },
//               );
//             } else if (state is ErrorAddData) {
//               ShowDialogCustom.showDialogBase(
//                 title: getT(KeyT.notification),
//                 content: state.msg,
//               );
//             }
//           },
//           child: SingleChildScrollView(
//             padding: EdgeInsets.all(
//               16,
//             ),
//             child: BlocBuilder<FormEditBloc, FormEditState>(
//                 builder: (context, state) {
//               if (state is LoadingFormEditState) {
//                 addData = [];
//                 data = [];
//                 listProduct = [];
//                 return SizedBox.shrink();
//               } else if (state is ErrorFormEditState) {
//                 return Text(
//                   state.msg,
//                   style: AppStyle.DEFAULT_16_T,
//                 );
//               } else if (state is SuccessFormEditState) {
//                 if (addData.isEmpty) {
//                   for (int i = 0; i < state.listEditData.length; i++) {
//                     addData.add(ModelItemAdd(
//                         group_name: state.listEditData[i].group_name ?? '',
//                         data: []));
//                     for (int j = 0;
//                         j < state.listEditData[i].data!.length;
//                         j++) {
//                       if (state.listEditData[i].data![j].field_special ==
//                           'url') {
//                         if (state.listEditData[i].data![j].products != null)
//                           for (int k = 0;
//                               k <
//                                   state.listEditData[i].data![j].products!
//                                       .length;
//                               k++) {
//                             listProduct.add(ProductModel(
//                                 state.listEditData[i].data![j].products![k]
//                                     .id_product
//                                     .toString(),
//                                 double.parse(state.listEditData[i].data![j]
//                                     .products![k].quantity!),
//                                 ProductItem(
//                                   state.listEditData[i].data![j].products![k]
//                                       .id_product
//                                       .toString(),
//                                   '',
//                                   '',
//                                   state.listEditData[i].data![j].products![k]
//                                       .name_product,
//                                   state.listEditData[i].data![j].products![k]
//                                       .unit
//                                       .toString(),
//                                   state.listEditData[i].data![j].products![k]
//                                       .vat,
//                                   state.listEditData[i].data![j].products![k]
//                                       .price,
//                                   ten_combo: state.listEditData[i].data![j]
//                                       .products![k].ten_combo,
//                                   combo_id: state.listEditData[i].data![j]
//                                       .products![k].combo_id,
//                                 ),
//                                 state.listEditData[i].data![j].products![k]
//                                     .sale_off.value!,
//                                 state.listEditData[i].data![j].products![k]
//                                     .unit_name!,
//                                 state.listEditData[i].data![j].products![k]
//                                     .vat_name!,
//                                 state.listEditData[i].data![j].products![k]
//                                     .sale_off.type!));
//                           }
//                       } else
//                         addData[i].data.add(
//                               ModelDataAdd(
//                                 label:
//                                     state.listEditData[i].data![j].field_name,
//                                 value: state
//                                     .listEditData[i].data![j].field_set_value
//                                     .toString(),
//                               ),
//                             );
//                     }
//                   }
//                 }
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: List.generate(
//                           state.listEditData.length,
//                           (indexParent) => (state
//                                           .listEditData[indexParent].data !=
//                                       null &&
//                                   state.listEditData[indexParent].data!.length >
//                                       0)
//                               ? Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     SizedBox(
//                                       height: AppValue.heights * 0.01,
//                                     ),
//                                     state.listEditData[indexParent]
//                                                 .group_name !=
//                                             null
//                                         ? WidgetText(
//                                             title: state
//                                                     .listEditData[indexParent]
//                                                     .group_name ??
//                                                 '',
//                                             style: AppStyle.DEFAULT_18_BOLD)
//                                         : SizedBox.shrink(),
//                                     SizedBox(
//                                       height: AppValue.heights * 0.01,
//                                     ),
//                                     Column(
//                                       children: List.generate(
//                                         state.listEditData[indexParent].data
//                                                 ?.length ??
//                                             0,
//                                         (indexChild) => _getBody(
//                                           state.listEditData[indexParent]
//                                               .data![indexChild],
//                                           indexParent,
//                                           indexChild,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               : SizedBox.shrink()),
//                     ),
//                     FileDinhKemUiBase(
//                       context: context,
//                       onTap: () => onClickSave(),
//                     ),
//                   ],
//                 );
//               } else
//                 return SizedBox.shrink();
//             }),
//           ),
//         ));
//   }
//
//   Widget _getBody(
//       CustomerIndividualItemData data, int indexParent, int indexChild) {
//     return data.field_hidden != '1'
//         ? data.field_special == 'none-edit'
//             ? (data.field_name == 'so_dien_thoai'
//                 ? BlocBuilder<PhoneBloc, PhoneState>(
//                     builder: (context, stateA) {
//                     if (stateA is SuccessPhoneState) {
//                       addData[indexParent].data[indexChild].value =
//                           stateA.phone;
//                       return _fieldNoEdit(data, indexParent, indexChild,
//                           value: stateA.phone);
//                     } else
//                       return SizedBox.shrink();
//                   })
//                 : data.field_name == 'chi_tiet_xe'
//                     ? StreamBuilder<String>(
//                         stream: ContactByCustomerBloc.of(context).chiTietXe,
//                         builder: (context, snapshot) {
//                           final chiTietXe = snapshot.data ?? '';
//                           return _fieldNoEdit(
//                             data,
//                             indexParent,
//                             indexChild,
//                             value: chiTietXe,
//                           );
//                         })
//                     : _fieldInputCustomer(data, indexParent, indexChild,
//                         noEdit: true, value: data.field_set_value ?? ''))
//             : data.field_special == 'url'
//                 ? ProductContract(
//                     listBtn: data.button,
//                     data: listProduct,
//                     addProduct: addProduct,
//                     reload: reload,
//                     neverHidden: true,
//                     canDelete: true,
//                   )
//                 : data.field_type == 'SELECT'
//                     ? checkLocation(data)
//                         ? LocationWidget(
//                             data: data,
//                             onSuccess: (data) {
//                               addData[indexParent].data[indexChild].value =
//                                   data;
//                             },
//                             initData: data.field_value,
//                           )
//                         : (data.field_name == 'col141'
//                             ? BlocBuilder<ContactByCustomerBloc,
//                                     ContactByCustomerState>(
//                                 builder: (context, stateA) {
//                                 if (stateA is UpdateGetContacBytCustomerState)
//                                   return InputDropdown(
//                                       dropdownItemList:
//                                           stateA.listContactByCustomer,
//                                       data: data,
//                                       onChange: (data) {
//                                         addData[indexParent]
//                                             .data[indexChild]
//                                             .value = data;
//                                         PhoneBloc.of(context)
//                                             .add(InitAgencyPhoneEvent(data));
//                                       },
//                                       value: data.field_value ?? '');
//                                 else
//                                   return SizedBox.shrink();
//                               })
//                             : data.field_name == 'hdsan_pham_kh'
//                                 ? StreamBuilder<List<List<dynamic>>>(
//                                     stream: ContactByCustomerBloc.of(context)
//                                         .listXe,
//                                     builder: (context, snapshot) {
//                                       final list = snapshot.data;
//                                       return InputDropdown(
//                                           isUpdate: true,
//                                           isUpdateList: true,
//                                           dropdownItemList: list ??
//                                               data.field_datasource ??
//                                               [],
//                                           data: data,
//                                           onChange: (data) {
//                                             addData[indexParent]
//                                                 .data[indexChild]
//                                                 .value = data;
//                                             // ContactByCustomerBloc.of(context)
//                                             //     .getCar(data);
//                                           },
//                                           onUpdate: (data) {
//                                             addData[indexParent]
//                                                 .data[indexChild]
//                                                 .value = data;
//                                             // ContactByCustomerBloc.of(context)
//                                             //     .getCar(data);
//                                           },
//                                           value:
//                                               ContactByCustomerBloc.of(context)
//                                                       .checkXeKhach(
//                                             addData[indexParent]
//                                                 .data[indexChild]
//                                                 .value,
//                                             list,
//                                           )
//                                                   ? ''
//                                                   : data.field_value ?? '');
//                                     })
//                                 : InputDropdown(
//                                     dropdownItemList:
//                                         data.field_datasource ?? [],
//                                     data: data,
//                                     onChange: (value) {
//                                       addData[indexParent]
//                                           .data[indexChild]
//                                           .value = value;
//                                       if (data.field_name == 'col131') {
//                                         PhoneBloc.of(context).add(
//                                             InitPhoneEvent(value.toString()));
//                                         ContactByCustomerBloc.of(context).add(
//                                             InitGetContactByCustomerrEvent(
//                                                 value.toString()));
//                                       }
//                                     },
//                                     value: data.field_value ?? ''))
//                     : data.field_type == 'TEXT_MULTI'
//                         ? SelectMulti(
//                             dropdownItemList: data.field_datasource ?? [],
//                             label: data.field_label ?? '',
//                             required: data.field_require ?? 0,
//                             maxLength: data.field_maxlength ?? '',
//                             initValue: addData[indexParent]
//                                 .data[indexChild]
//                                 .value
//                                 .toString()
//                                 .split(','),
//                             onChange: (data) {
//                               addData[indexParent].data[indexChild].value =
//                                   data;
//                             },
//                           )
//                         : data.field_type == 'HIDDEN'
//                             ? SizedBox.shrink()
//                             : data.field_type == 'TEXT_MULTI_NEW'
//                                 ? InputMultipleWidget(
//                                     data: data,
//                                     onSelect: (data) {
//                                       addData[indexParent]
//                                           .data[indexChild]
//                                           .value = data.join(',');
//                                     },
//                                   )
//                                 : data.field_type == 'DATE'
//                                     ? WidgetInputDate(
//                                         data: data,
//                                         dateText: data.field_set_value,
//                                         onSelect: (int date) {
//                                           addData[indexParent]
//                                               .data[indexChild]
//                                               .value = date;
//                                         },
//                                         onInit: (v) {
//                                           addData[indexParent]
//                                               .data[indexChild]
//                                               .value = v;
//                                         },
//                                       )
//                                     : data.field_type == 'DATETIME'
//                                         ? WidgetInputDate(
//                                             isDate: false,
//                                             data: data,
//                                             dateText: data.field_set_value,
//                                             onSelect: (int date) {
//                                               addData[indexParent]
//                                                   .data[indexChild]
//                                                   .value = date;
//                                             },
//                                             onInit: (v) {
//                                               addData[indexParent]
//                                                   .data[indexChild]
//                                                   .value = v;
//                                             },
//                                           )
//                                         : data.field_special == 'autosum'
//                                             ? BlocBuilder<TotalBloc,
//                                                     TotalState>(
//                                                 builder: (context, stateA) {
//                                                 if (stateA
//                                                     is SuccessTotalState) {
//                                                   addData[indexParent]
//                                                           .data[indexChild]
//                                                           .value =
//                                                       stateA.total
//                                                           .toStringAsFixed(0);
//                                                   return WidgetTotalSum(
//                                                       label: data.field_label,
//                                                       value: AppValue
//                                                           .format_money(stateA
//                                                               .total
//                                                               .toStringAsFixed(
//                                                                   0)));
//                                                 } else {
//                                                   return WidgetTotalSum(
//                                                       label: data.field_label,
//                                                       value: data.field_value);
//                                                 }
//                                               })
//                                             : data.field_type == 'PERCENTAGE'
//                                                 ? FieldInputPercent(
//                                                     data: data,
//                                                     onChanged: (text) {
//                                                       addData[indexParent]
//                                                           .data[indexChild]
//                                                           .value = text;
//                                                     },
//                                                   )
//                                                 : _fieldInputCustomer(data,
//                                                     indexParent, indexChild)
//         : SizedBox();
//   }
//
//   Widget _fieldNoEdit(
//       CustomerIndividualItemData data, int indexParent, int indexChild,
//       {String value = ''}) {
//     addData[indexParent].data[indexChild].value = value;
//     return Container(
//       margin: EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           RichText(
//             textScaleFactor: MediaQuery.of(context).textScaleFactor,
//             text: TextSpan(
//               text: data.field_label ?? '',
//               style: AppStyle.DEFAULT_14W600,
//               children: <TextSpan>[
//                 data.field_require == 1
//                     ? TextSpan(text: '*', style: AppStyle.DEFAULT_14W600_RED)
//                     : TextSpan(),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 8,
//           ),
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//                 color: COLORS.LIGHT_GREY,
//                 borderRadius: BorderRadius.circular(5),
//                 border: Border.all(color: COLORS.ffBEB4B4)),
//             child: Padding(
//               padding: EdgeInsets.all(15),
//               child: Container(
//                   child: WidgetText(
//                 title: '$value',
//                 style: AppStyle.DEFAULT_14,
//               )),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _fieldInputCustomer(
//       CustomerIndividualItemData data, int indexParent, int indexChild,
//       {bool noEdit = false, String value = ''}) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           RichText(
//             textScaleFactor: MediaQuery.of(context).textScaleFactor,
//             text: TextSpan(
//               text: data.field_label ?? '',
//               style: AppStyle.DEFAULT_14W600,
//               children: <TextSpan>[
//                 data.field_require == 1
//                     ? TextSpan(
//                         text: '*',
//                         style: TextStyle(
//                             fontFamily: 'Quicksand',
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: COLORS.RED))
//                     : TextSpan(),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 8,
//           ),
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: noEdit == true ? COLORS.LIGHT_GREY : COLORS.WHITE,
//               borderRadius: BorderRadius.circular(5),
//               border: Border.all(
//                 color: COLORS.ffBEB4B4,
//               ),
//             ),
//             child: Padding(
//               padding: EdgeInsets.only(
//                 left: 10,
//                 top: 5,
//                 bottom: 5,
//               ),
//               child: Container(
//                 child: TextFormField(
//                   textCapitalization: TextCapitalization.sentences,
//                   minLines: data.field_type == 'TEXTAREA' ? 2 : 1,
//                   maxLines: data.field_type == 'TEXTAREA' ? 6 : 1,
//                   style: AppStyle.DEFAULT_14W600,
//                   keyboardType: data.field_type == 'TEXT_NUMERIC'
//                       ? TextInputType.number
//                       : data.field_special == 'default'
//                           ? TextInputType.text
//                           : (data.field_special == 'numberic')
//                               ? TextInputType.number
//                               : data.field_special == 'email-address'
//                                   ? TextInputType.emailAddress
//                                   : TextInputType.text,
//                   onChanged: (text) {
//                     addData[indexParent].data[indexChild].value = text;
//                   },
//                   readOnly: noEdit,
//                   initialValue: value != ''
//                       ? value
//                       : noEdit == true
//                           ? data.field_value
//                           : (data.field_type == 'MONEY' &&
//                                   data.field_set_value != null)
//                               ? data.field_set_value
//                                   .replaceAll(',', '')
//                                   .replaceAll('.', '')
//                                   .toString()
//                               : data.field_set_value != null
//                                   ? data.field_set_value.toString()
//                                   : null,
//                   decoration: InputDecoration(
//                       hintStyle: AppStyle.DEFAULT_14W500,
//                       focusedBorder: InputBorder.none,
//                       enabledBorder: InputBorder.none,
//                       disabledBorder: InputBorder.none,
//                       isDense: true),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void onClickSave() {
//     final Map<String, dynamic> data = {};
//     for (int i = 0; i < addData.length; i++) {
//       for (int j = 0; j < addData[i].data.length; j++) {
//         if (addData[i].data[j].value != null &&
//             addData[i].data[j].value != 'null')
//           data['${addData[i].data[j].label}'] = addData[i].data[j].value;
//         else {
//           data['${addData[i].data[j].label}'] = '';
//         }
//       }
//     }
//     if (listProduct.length > 0) {
//       List product = [];
//       for (int i = 0; i < listProduct.length; i++) {
//         product.add({
//           'id': listProduct[i].id,
//           'price': listProduct[i].item.sell_price,
//           'quantity': listProduct[i].soLuong,
//           'vat': listProduct[i].item.vat,
//           'unit': listProduct[i].item.dvt,
//           'ten_combo': listProduct[i].item.ten_combo,
//           'combo_id': listProduct[i].item.combo_id,
//           'sale_off': {
//             'value': listProduct[i].giamGia,
//             'type': listProduct[i].typeGiamGia
//           }
//         });
//       }
//       data['products'] = product;
//     }
//     data['id'] = id;
//     AddDataBloc.of(context)
//         .add(AddContractEvent(data, files: AttackBloc.of(context).listFile));
//   }
// }
