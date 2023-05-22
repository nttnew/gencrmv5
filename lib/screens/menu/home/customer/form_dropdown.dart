import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../src/color.dart';
import '../contract/customer_contract.dart';

class FormDropDown extends StatefulWidget {
  FormDropDown(
      {Key? key,
      required this.dropdownItemList,
      required this.label,
      required this.onSuccess,
      required this.set_value,
      required this.value,
      required this.require,
      required this.field_id,
      this.customer_id = ""})
      : super(key: key);

  List<List<dynamic>> dropdownItemList;
  String label;
  Function onSuccess;
  String set_value;
  String value;
  int require;
  String field_id;
  String customer_id;

  @override
  State<FormDropDown> createState() => _FormDropDownState();
}

class _FormDropDownState extends State<FormDropDown> {
  int indexDefault = -1;
  List dropdow = [];
  String value = '';
  String customer_id = "";

  @override
  void initState() {
    setState(() {
      value = widget.value;
      customer_id = widget.customer_id;
    });
    super.initState();
  }

  loadValue(data) {
    setState(() {
      value = data;
    });
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
              text: widget.label,
              style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: COLORS.BLACK),
              children: <TextSpan>[
                widget.require == 1
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
                  enableDrag: false,
                  isScrollControlled: true,
                  context: context,
                  constraints: BoxConstraints(
                      maxHeight: Get.height * 0.65, minWidth: Get.width),
                  builder: (BuildContext context) {
                    return CustomerContractScreen(
                      contextFather: context,
                      onClickItem: (id, value) {
                        Get.back();
                        widget.onSuccess(id.toString());
                        loadValue(value);
                      },
                      type: widget.field_id == "246" ? 1 : 2,
                      id: customer_id,
                    );
                  });
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: HexColor("#BEB4B4"))),
              child: Padding(
                padding:
                    EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: WidgetText(
                          title: value,
                          maxLine: 1,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w500,
                              color: COLORS.BLACK),
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
            ),
          ),
        ],
      ),
    );
  }
}
