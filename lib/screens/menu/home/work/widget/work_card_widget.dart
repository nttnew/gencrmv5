import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../src/models/model_generator/work.dart';

class WorkCardWidget extends StatefulWidget {
  WorkCardWidget(
      {Key? key,
      required this.data_list,
      required this.index,
      required this.length})
      : super(key: key);

  final WorkItemData? data_list;
  final int? index;
  final int? length;

  @override
  State<WorkCardWidget> createState() => _WorkCardWidgetState();
}

class _WorkCardWidgetState extends State<WorkCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 25, right: 25),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.data_list?.location != null) ...[
                Container(
                  height: 16,
                  width: 16,
                  child: SvgPicture.asset(
                    ICONS.IC_LOCATION_SVG,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
              ],
              Expanded(
                child: WidgetText(
                  title: widget.data_list?.name_job ?? '',
                  style: NameCustomerStyle(),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: widget.data_list!.status_color != null
                        ? HexColor(widget.data_list!.status_color!)
                        : COLORS.PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(99)),
                width: AppValue.widths * 0.1,
                height: AppValue.heights * 0.02,
              )
            ],
          ),
          itemTextIcon(
            text: widget.data_list?.user_work_name ?? '',
            icon: ICONS.IC_AVATAR_SVG,
          ),
          itemTextIcon(
            text: widget.data_list?.status_job ?? '',
            icon: ICONS.IC_ICON3_SVG,
            colorIcon: widget.data_list!.status_color != null
                ? HexColor(widget.data_list!.status_color!)
                : COLORS.PRIMARY_COLOR,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              children: [
                Expanded(
                  child: itemTextIcon(
                    paddingTop: 0,
                    text: widget.data_list?.start_date ?? '',
                    icon: ICONS.IC_ICON4_SVG,
                  ),
                ),   SizedBox(
                  width: 8,
                ),
                SvgPicture.asset(ICONS.IC_QUESTION_SVG),
                SizedBox(
                  width: 4,
                ),
                WidgetText(
                  title: widget.data_list!.total_comment.toString(),
                  style: TextStyle(
                    color: HexColor("#0052B4"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle OrtherInforCustomerStyle() => TextStyle(
      color: HexColor("#263238"),
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w400,
      fontSize: 14);

  TextStyle LocationCustomerStyle() => TextStyle(
      color: Colors.black,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w400,
      fontSize: 14);

  TextStyle NameCustomerStyle() => TextStyle(
      color: HexColor("#006CB1"),
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w700,
      fontSize: 18);
}
