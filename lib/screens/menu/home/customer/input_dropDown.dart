import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/contract/phone_bloc.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../bloc/contact_by_customer/contact_by_customer_bloc.dart';
import '../../../../src/models/model_generator/add_customer.dart';
import '../../../../widgets/widget_text.dart';
import 'data_dropdown_item.dart';

class InputDropdown extends StatefulWidget {
  InputDropdown({
    Key? key,
    required this.dropdownItemList,
    required this.data,
    required this.onSuccess,
    required this.value,
    this.isUpdate = false,
    this.onUpdate,
    this.isUpdateList = false,
    this.isAddList = false,
  }) : super(key: key);
  final List<List<dynamic>> dropdownItemList;
  final CustomerIndividualItemData data;
  final Function onSuccess;
  final String value;
  final bool isUpdate;
  final bool isUpdateList;
  final bool isAddList;
  final Function? onUpdate;

  @override
  State<InputDropdown> createState() => _InputDropdownState();
}

class _InputDropdownState extends State<InputDropdown> {
  List dropdown = [];
  String textValue = "";
  bool isUpdate = false;

  @override
  void didUpdateWidget(covariant InputDropdown oldWidget) {
    if (widget.isUpdateList) {
      updateList();
    }
    if (mounted && widget.isUpdate) {
      textValue = widget.value;
      String data = '';
      for (final value in widget.dropdownItemList) {
        if (value[1] == widget.value) {
          data = value[0];
        }
      }
      widget.onUpdate!(data);
    }
    if (mounted && widget.isAddList) {
      if (widget.value.isNotEmpty) {
        isUpdate = true;
        if (widget.value == 'null') {
          textValue = '';
        } else {
          textValue = widget.value;
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void updateList() {
    dropdown = [];
    for (int i = 0; i < widget.dropdownItemList.length; i++) {
      if (widget.dropdownItemList[i][1] != null &&
          widget.dropdownItemList[i][0] != null) {
        dropdown.add({
          'label': widget.dropdownItemList[i][1],
          'value': widget.dropdownItemList[i][0]
        });
      }
    }
  }

  @override
  void initState() {
    if (widget.data.field_name == 'col131' ||
        widget.data.field_name == 'col121' ||
        widget.data.field_name == 'khach_hang_id_dm' ||
        widget.data.field_name == 'cv_kh' ||
        widget.data.field_name == 'khach_hang') {
      getCustomer(1);
      if (widget.data.field_set_value != null &&
          widget.data.field_set_value != "") {
        if (widget.data.field_name == 'cv_kh') {
          PhoneBloc.of(context)
              .add(InitPhoneEvent(widget.data.field_set_value.toString()));
        }
        // else if (widget.data.field_name == 'col131') {
        //   PhoneBloc.of(context)
        //       .add(InitPhoneEvent(widget.data.field_set_value.toString()));
        //   ContactByCustomerBloc.of(context).add(InitGetContactByCustomerrEvent(
        //       widget.data.field_set_value.toString()));
        // }
        else
          ContactByCustomerBloc.of(context).add(InitGetContactByCustomerrEvent(
              widget.data.field_set_value.toString()));
      }
    } else {
      for (int i = 0; i < widget.dropdownItemList.length; i++) {
        if (widget.dropdownItemList[i][1] != null &&
            widget.dropdownItemList[i][0] != null) {
          dropdown.add({
            'label': widget.dropdownItemList[i][1],
            'value': widget.dropdownItemList[i][0]
          });
        }
      }
    }
    if (mounted) {
      setState(() {
        textValue = widget.value;
      });
    }

    super.initState();
  }

  dispose() {
    dropdown.clear();
    textValue = "";
    super.dispose();
  }

  getCustomer(int page,
      {Function? reload, String search = "", bool isLoadMore = false}) async {
    ContactByCustomerBloc.of(context)
        .add(InitGetCustomerContractEvent(page.toString(), search, (response) {
      if (isLoadMore == false) dropdown = [];
      // add
      if (widget.isAddList) {
        for (int i = 0; i < widget.dropdownItemList.length; i++) {
          if (widget.dropdownItemList[i][1] != null &&
              widget.dropdownItemList[i][0] != null) {
            dropdown.add({
              'label': widget.dropdownItemList[i][1],
              'value': widget.dropdownItemList[i][0]
            });
          }
        }
      }
      //
      for (int i = 0; i < response.list!.length; i++) {
        if (response.list![i][1] != null && response.list![i][0] != null) {
          dropdown.add(
              {'label': response.list![i][1], 'value': response.list![i][0]});
        }
      }
      if (mounted) {
        setState(() {});
      }

      if (reload != null) reload();
    }));
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
              style: titlestyle(),
              children: <TextSpan>[
                widget.data.field_require == 1
                    ? TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ))
                    : TextSpan(),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              if (widget.data.field_special != "none-edit") {
                FocusManager.instance.primaryFocus?.unfocus();
              }
              showModalBottomSheet(
                  enableDrag: false,
                  isScrollControlled: true,
                  context: context,
                  constraints: BoxConstraints(
                      maxHeight: Get.height * 0.65, minWidth: Get.width),
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setState1) {
                        if (isUpdate) {
                          getCustomer(1,
                              reload: () => setState1(() {}), search: '');
                          isUpdate = false;
                        }
                        return Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: DataDropDownItem(
                            data: dropdown,
                            isSearch: (widget.data.field_name == 'col131' ||
                                    widget.data.field_name == 'col121' ||
                                    widget.data.field_name == 'cv_kh' ||
                                    widget.data.field_name ==
                                        'khach_hang_id_dm' ||
                                    widget.data.field_name == 'khach_hang')
                                ? true
                                : false,
                            onSuccess: (data, label) {
                              if (mounted) {
                                setState(() {
                                  textValue = label;
                                });
                              }

                              Get.back();
                              widget.onSuccess(data);
                            },
                            onTabSearch: (search) {
                              getCustomer(1,
                                  reload: () => setState1(() {}),
                                  search: search);
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onLoadMore: (int page, String search) {
                              if (widget.data.field_name == 'col131' ||
                                  widget.data.field_name == 'col121' ||
                                  widget.data.field_name == 'cv_kh' ||
                                  widget.data.field_name ==
                                      'khach_hang_id_dm' ||
                                  widget.data.field_name == 'khach_hang')
                                getCustomer(page,
                                    reload: () => setState1(() {}),
                                    search: search,
                                    isLoadMore: true);
                            },
                          ),
                        );
                      },
                    );
                  });
            },
            child: Container(
                width: double.infinity,
                color: widget.data.field_special == "none-edit"
                    ? COLORS.GREY_400
                    : COLORS.WHITE,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: HexColor("#BEB4B4"))),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 10, top: 10, bottom: 10, right: 10),
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: WidgetText(
                              title: textValue,
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w600,
                                color: COLORS.BLACK,
                              ),
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

  TextStyle titlestyle() => TextStyle(
      fontFamily: "Quicksand",
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: COLORS.BLACK);
}
