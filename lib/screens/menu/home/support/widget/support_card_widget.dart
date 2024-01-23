import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../src/src_index.dart';

class SupportCardWidget extends StatelessWidget {
  SupportCardWidget({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  final dynamic data;
  final Function onTap;

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
                  title: data.name ?? '',
                  style: NameCustomerStyle(),
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    color: (data.color != "" && data.color != null)
                        ? HexColor(data.color!)
                        : COLORS.PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(99)),
                width: AppValue.widths * 0.1,
                height: AppValue.heights * 0.02,
              )
            ],
          ),
          SizedBox(height: AppValue.heights * 0.01),
          if (data.user_handling != '') ...[
            Row(
              children: [
                SvgPicture.asset(ICONS.IC_AVATAR_SVG),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: WidgetText(
                    title: data.user_handling ?? '',
                    style: NameCustomerStyle(),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppValue.heights * 0.01),
          ],
          if (data.status != '') ...[
            Row(
              children: [
                SvgPicture.asset(
                  ICONS.IC_ICON3_SVG,
                  color: (data.color != "" && data.color != null)
                      ? HexColor(data.color!)
                      : COLORS.PRIMARY_COLOR,
                ),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: SizedBox(
                      width: AppValue.widths * 0.5,
                      child: WidgetText(
                        title: data.status ?? '',
                        style: AppStyle.DEFAULT_14.copyWith(
                            color: (data.color != "" && data.color != null)
                                ? HexColor(data.color!)
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
                        title: data.start_date != "" ? data.start_date! : "",
                        style: OrtherInforCustomerStyle())),
              ),
              Spacer(),
              SvgPicture.asset(ICONS.IC_QUESTION_SVG),
              SizedBox(
                width: AppValue.widths * 0.01,
              ),
              WidgetText(
                title: data.total_note ?? '',
                style: TextStyle(
                  color: HexColor("#0052B4"),
                ),
              ),
            ],
          ),
        ],
      ),
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: COLORS.WHITE,
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
    );
  }

  TextStyle OrtherInforCustomerStyle() => TextStyle(
      color: HexColor("#263238"),
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w400,
      fontSize: 14);

  TextStyle NameCustomerStyle() => TextStyle(
      color: COLORS.ff006CB1,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w700,
      fontSize: 18);
}
