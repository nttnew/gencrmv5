import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hexcolor/hexcolor.dart';

import '../src/models/model_generator/add_customer.dart';
import '../src/src_index.dart';
import '../widgets/widget_text.dart';

class WidgetInputDate extends StatefulWidget {
  WidgetInputDate({
    Key? key,
    required this.data,
    required this.onSelect,
    required this.onInit,
    this.dateText,
    this.isDate = true,
  }) : super(key: key);

  final CustomerIndividualItemData data;
  final Function(int dateTime) onSelect;
  final Function(int date) onInit;
  final dynamic dateText;
  final bool isDate;

  @override
  State<WidgetInputDate> createState() => _WidgetInputDateState();
}

class _WidgetInputDateState extends State<WidgetInputDate> {
  String dateText = '';

  @override
  void initState() {
    if (widget.dateText != null &&
        widget.dateText != '' &&
        widget.dateText != 0) {
      setState(() {
        dateText = widget.isDate
            ? AppValue.formatIntDate(widget.dateText)
            : AppValue.formatIntDateTime(widget.dateText);
      });
      widget.onInit(widget.dateText);
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
              widget.isDate
                  ? DatePicker.showDatePicker(
                      context,
                      showTitleActions: true,
                      onConfirm: (DateTime date) {
                        setState(() {
                          dateText = AppValue.formatDate(date.toString());
                        });
                        int time = date.millisecondsSinceEpoch ~/ 1000;
                        widget.onSelect(time);
                      },
                      currentTime: DateTime.now(),
                      locale: LocaleType.vi,
                    )
                  : DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      onConfirm: (DateTime date) {
                        setState(() {
                          dateText =
                              AppValue.formatStringDateTime(date.toString());
                        });
                        int time = date.millisecondsSinceEpoch ~/ 1000;
                        widget.onSelect(time);
                      },
                      currentTime: DateTime.now(),
                      locale: LocaleType.vi,
                    );
              ;
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
                        style: AppStyle.DEFAULT_14,
                      ),
                    ),
                  ),
                  WidgetContainerImage(
                    image: ICONS.IC_DATE_PNG,
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
