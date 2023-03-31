import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hexcolor/hexcolor.dart';

import '../src/models/model_generator/add_customer.dart';
import '../src/src_index.dart';
import '../widgets/widget_text.dart';

class WidgetInputDate extends StatefulWidget {
  WidgetInputDate(
      {Key? key,
      required this.data,
      required this.onSelect,
      required this.onInit,
      this.dateText})
      : super(key: key);

  final CustomerIndividualItemData data;
  final Function onSelect, onInit;
  final String? dateText;

  @override
  State<WidgetInputDate> createState() => _WidgetInputDateState();
}

class _WidgetInputDateState extends State<WidgetInputDate> {
  String dateText = AppValue.formatDate(DateTime.now().toString());

  @override
  void initState() {
    widget.onInit();
    if (widget.dateText != null) {
      setState(() {
        dateText = widget.dateText!;
      });
    }
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
          GestureDetector(
            onTap: () {
              DatePicker.showDatePicker(context, showTitleActions: true,
                  // minTime: DateTime.now(),
                  onConfirm: (date) {
                setState(() {
                  dateText = AppValue.formatDate(date.toString());
                });
                widget.onSelect(date);
              }, currentTime: DateTime.now(), locale: LocaleType.vi);
            },
            child: Container(
              // width: Get.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: HexColor("#BEB4B4"))),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10, top: 15, bottom: 15),
                      child: WidgetText(
                        title: dateText,
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  WidgetContainerImage(
                    image: 'assets/icons/date.png',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  SizedBox(
                    width: 16,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
