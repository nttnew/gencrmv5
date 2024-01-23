import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:hexcolor/hexcolor.dart';

class WorkCardWidget extends StatelessWidget {
  final String nameCustomer;
  final String nameJob;
  final String statusJob;
  final String startDate;
  final int totalComment;
  final String color;

  WorkCardWidget({
    required this.color,
    required this.nameCustomer,
    required this.nameJob,
    required this.statusJob,
    required this.startDate,
    required this.totalComment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        right: 16,
        left: 16,
      ),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: COLORS.WHITE,
        borderRadius: BorderRadius.all(
          Radius.circular(
            10,
          ),
        ),
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
            children: [
              SizedBox(
                width: AppValue.widths * 0.5,
                child: Text(
                  nameJob,
                  style: NameCustomerStyle(),
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    color:
                        (color == '') ? COLORS.PRIMARY_COLOR : HexColor(color),
                    borderRadius: BorderRadius.circular(99)),
                width: AppValue.widths * 0.1,
                height: AppValue.heights * 0.02,
              )
            ],
          ),
          SizedBox(height: AppValue.heights * 0.01),
          if (nameCustomer != '') ...[
            Row(
              children: [
                SvgPicture.asset(ICONS.IC_AVATAR_SVG),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: Text(
                    nameCustomer,
                    style: NameCustomerStyle(),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppValue.heights * 0.01),
          ],
          if (statusJob != '') ...[
            Row(
              children: [
                SvgPicture.asset(ICONS.IC_ICON3_SVG),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: SizedBox(
                      width: AppValue.widths * 0.5,
                      child: Text(
                        statusJob,
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
                  child: Text(
                    startDate,
                    style: OrtherInforCustomerStyle(),
                  ),
                ),
              ),
              Spacer(),
              SvgPicture.asset(ICONS.IC_QUESTION_SVG),
              SizedBox(
                width: AppValue.widths * 0.01,
              ),
              Text(
                totalComment.toString(),
                style: TextStyle(
                  color: HexColor("#0052B4"),
                ),
              ),
            ],
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
      color: COLORS.BLACK,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w400,
      fontSize: 14);

  TextStyle NameCustomerStyle() => TextStyle(
      color: COLORS.ff006CB1,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w700,
      fontSize: 18);
}
