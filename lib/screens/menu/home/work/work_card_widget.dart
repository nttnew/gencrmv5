import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../src/models/model_generator/work.dart';

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
                    color: COLORS.GREY,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
              ],
              SizedBox(
                width: AppValue.widths * 0.5,
                child: WidgetText(
                  title: widget.data_list!.name_job ?? '',
                  style: NameCustomerStyle(),
                ),
              ),
              Spacer(),
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
          SizedBox(height: AppValue.heights * 0.01),
          if (widget.data_list!.user_work_name?.isNotEmpty ?? false) ...[
            Row(
              children: [
                SvgPicture.asset(ICONS.IC_AVATAR_SVG),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: WidgetText(
                    title: widget.data_list!.user_work_name ?? '',
                    style: NameCustomerStyle(),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppValue.heights * 0.01),
          ],
          if (widget.data_list!.status_job?.isNotEmpty ?? false) ...[
            Row(
              children: [
                SvgPicture.asset(
                  ICONS.IC_ICON3_SVG,
                  color: widget.data_list!.status_color != null
                      ? HexColor(widget.data_list!.status_color!)
                      : COLORS.PRIMARY_COLOR,
                ),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: SizedBox(
                      width: AppValue.widths * 0.5,
                      child: WidgetText(
                        title: widget.data_list!.status_job ?? '',
                        style: OrtherInforCustomerStyle(),
                      )),
                ),
              ],
            ),
            SizedBox(height: AppValue.heights * 0.01),
          ],
          Row(
            children: [
              SvgPicture.asset(ICONS.IC_ICON4_SVG),
              Padding(
                padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                child: SizedBox(
                    width: AppValue.widths * 0.5,
                    child: WidgetText(
                        title: widget.data_list!.start_date ?? '',
                        style: OrtherInforCustomerStyle())),
              ),
              Spacer(),
              SvgPicture.asset(ICONS.IC_QUESTION_SVG),
              SizedBox(
                width: AppValue.widths * 0.01,
              ),
              WidgetText(
                title: widget.data_list!.total_comment.toString(),
                style: TextStyle(
                  color: HexColor("#0052B4"),
                ),
              ),
            ],
          ),
        ],
      ),
      margin: EdgeInsets.only(
          left: AppValue.widths * 0.05,
          top: AppValue.heights * 0.01,
          right: AppValue.widths * 0.05,
          bottom: widget.index == (widget.length! - 1) ? 70 : 0),
      padding: EdgeInsets.only(
          left: AppValue.widths * 0.05,
          top: AppValue.heights * 0.02,
          right: AppValue.widths * 0.05,
          bottom: AppValue.widths * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
    );
  }

  TextStyle OrtherInforCustomerStyle() => TextStyle(
      color: HexColor("#263238"),
      fontFamily: "Roboto",
      fontWeight: FontWeight.w400,
      fontSize: 14);

  TextStyle LocationCustomerStyle() => TextStyle(
      color: Colors.black,
      fontFamily: "Roboto",
      fontWeight: FontWeight.w400,
      fontSize: 14);

  TextStyle NameCustomerStyle() => TextStyle(
      color: HexColor("#006CB1"),
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w700,
      fontSize: 18);
}
