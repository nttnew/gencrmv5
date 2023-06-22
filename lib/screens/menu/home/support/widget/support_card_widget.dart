import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../src/src_index.dart';

class SupportCardWidget extends StatefulWidget {
  SupportCardWidget({Key? key, required this.data}) : super(key: key);

  final dynamic data;

  @override
  State<SupportCardWidget> createState() => _SupportCardWidgetState();
}

class _SupportCardWidgetState extends State<SupportCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: AppValue.widths * 0.5,
                child: WidgetText(
                  title: widget.data.name ?? '',
                  style: NameCustomerStyle(),
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    color:
                        (widget.data.color != "" && widget.data.color != null)
                            ? HexColor(widget.data.color!)
                            : COLORS.PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(99)),
                width: AppValue.widths * 0.1,
                height: AppValue.heights * 0.02,
              )
            ],
          ),
          SizedBox(height: AppValue.heights * 0.01),
          if (widget.data.user_handling != '') ...[
            Row(
              children: [
                SvgPicture.asset(ICONS.IC_AVATAR_SVG),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: WidgetText(
                    title: widget.data.user_handling ?? '',
                    style: NameCustomerStyle(),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppValue.heights * 0.01),
          ],
          if (widget.data.status != '') ...[
            Row(
              children: [
                SvgPicture.asset(
                  ICONS.IC_ICON3_SVG,
                  color: (widget.data.color != "" && widget.data.color != null)
                      ? HexColor(widget.data.color!)
                      : COLORS.PRIMARY_COLOR,
                ),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: SizedBox(
                      width: AppValue.widths * 0.5,
                      child: WidgetText(
                        title: widget.data.status ?? '',
                        style: AppStyle.DEFAULT_14.copyWith(
                            color: (widget.data.color != "" &&
                                    widget.data.color != null)
                                ? HexColor(widget.data.color!)
                                : COLORS.PRIMARY_COLOR),
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
                        title: widget.data.start_date != ""
                            ? widget.data.start_date!
                            : "",
                        style: OrtherInforCustomerStyle())),
              ),
              Spacer(),
              SvgPicture.asset(ICONS.IC_QUESTION_SVG),
              SizedBox(
                width: AppValue.widths * 0.01,
              ),
              WidgetText(
                title: widget.data.total_note ?? '',
                style: TextStyle(
                  color: HexColor("#0052B4"),
                ),
              ),
            ],
          ),
        ],
      ),
      margin: EdgeInsets.only(
          left: 5, top: AppValue.heights * 0.01, right: 5, bottom: 5),
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
