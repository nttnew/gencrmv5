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
  }) : super(key: key);
  final List<List<dynamic>> dropdownItemList;
  final CustomerIndividualItemData data;
  final Function onSuccess;
  final String value;
  final bool isUpdate;
  final bool isUpdateList;
  final Function? onUpdate;

  @override
  State<InputDropdown> createState() => _InputDropdownState();
}

class _InputDropdownState extends State<InputDropdown> {
  List dropdow = [];
  String textValue = "";

  @override
  void didUpdateWidget(covariant InputDropdown oldWidget) {
    if (widget.isUpdateList) {
      updateList();
    }
    if (mounted && widget.isUpdate) {
      textValue = widget.value;
      widget.onUpdate!(textValue);
    }
    super.didUpdateWidget(oldWidget);
  }

  void updateList() {
    dropdow=[];
    for (int i = 0; i < widget.dropdownItemList.length; i++) {
      if (widget.dropdownItemList[i][1] != null &&
          widget.dropdownItemList[i][0] != null) {
        dropdow.add({
          'label': widget.dropdownItemList[i][1],
          'value': widget.dropdownItemList[i][0]
        });
      }
    }
  }

  @override
  void initState() {
    if (widget.data.field_id == '246' ||
        widget.data.field_id == '128' ||
        widget.data.field_id == '107' ||
        widget.data.field_id == '438') {
      getCustomer(1);
      if (widget.data.field_set_value != null &&
          widget.data.field_set_value != "") {
        if (widget.data.field_id == '107') {
          PhoneBloc.of(context)
              .add(InitPhoneEvent(widget.data.field_set_value.toString()));
        } else if (widget.data.field_id == '246') {
          PhoneBloc.of(context)
              .add(InitPhoneEvent(widget.data.field_set_value.toString()));
          ContactByCustomerBloc.of(context).add(InitGetContactByCustomerrEvent(
              widget.data.field_set_value.toString()));
        } else
          ContactByCustomerBloc.of(context).add(InitGetContactByCustomerrEvent(
              widget.data.field_set_value.toString()));
      }
    } else {
      for (int i = 0; i < widget.dropdownItemList.length; i++) {
        if (widget.dropdownItemList[i][1] != null &&
            widget.dropdownItemList[i][0] != null) {
          dropdow.add({
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
    dropdow.clear();
    textValue = "";
    super.dispose();
  }

  getCustomer(int page,
      {Function? reload, String search = "", bool isLoadMore = false}) async {
    ContactByCustomerBloc.of(context)
        .add(InitGetCustomerContractEvent(page.toString(), search, (response) {
      if (isLoadMore == false) dropdow = [];
      for (int i = 0; i < response.data!.length; i++) {
        if (response.data![i][1] != null && response.data![i][0] != null) {
          dropdow.add(
              {'label': response.data![i][1], 'value': response.data![i][0]});
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
            text: TextSpan(
              text: widget.data.field_label ?? '',
              style: titlestyle(),
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
          GestureDetector(
            onTap: () {
              if (widget.data.field_special == "none-edit") {
              } else
                FocusManager.instance.primaryFocus?.unfocus();
              showModalBottomSheet(
                  enableDrag: false,
                  isScrollControlled: true,
                  context: context,
                  constraints: BoxConstraints(
                      maxHeight: Get.height * 0.65, minWidth: Get.width),
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setState1) {
                        return Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: DataDropDownItem(
                            data: dropdow,
                            isSearch: (widget.data.field_id == '246' ||
                                    widget.data.field_id == '128' ||
                                    widget.data.field_id == '107' ||
                                    widget.data.field_id == '184' ||
                                    widget.data.field_id == '438')
                                ? true
                                : false,
                            onSuccess: (data, label) {
                              if (mounted) {
                                setState(() {
                                  textValue = label;
                                });
                              }

                              widget.onSuccess(data);
                              Get.back();
                            },
                            onTabSearch: (search) {
                              getCustomer(1,
                                  reload: () => setState1(() {}),
                                  search: search);
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onLoadMore: (int pagee, String search) {
                              if (widget.data.field_id == '246' ||
                                  widget.data.field_id == '128' ||
                                  widget.data.field_id == '107' ||
                                  widget.data.field_id == '184' ||
                                  widget.data.field_id == '438')
                                getCustomer(pagee,
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
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w500,
                                  color: HexColor("#838A91")),
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
      fontFamily: "Roboto",
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: HexColor("#697077"));
}
