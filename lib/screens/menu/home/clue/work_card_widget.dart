import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:hexcolor/hexcolor.dart';

class WorkCardWidget extends StatelessWidget {
  final String? nameCustomer;
  final String? nameJob;
  final String? statusJob;
  final String? startDate;
  final int? totalComment;
  final String? color;

  WorkCardWidget(
      {this.color,
      this.nameCustomer,
      this.nameJob,
      this.statusJob,
      this.startDate,
      this.totalComment});

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
                child: Text(
                  this.nameJob!,
                  style: NameCustomerStyle(),
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    color:
                        color == null ? COLORS.PRIMARY_COLOR : HexColor(color!),
                    borderRadius: BorderRadius.circular(99)),
                width: AppValue.widths * 0.1,
                height: AppValue.heights * 0.02,
              )
            ],
          ),
          SizedBox(height: AppValue.heights * 0.01),
          if (this.nameCustomer != '') ...[
            Row(
              children: [
                SvgPicture.asset(ICONS.IC_AVATAR_SVG),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: Text(
                    this.nameCustomer!,
                    style: NameCustomerStyle(),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppValue.heights * 0.01),
          ],
          if (this.statusJob != '') ...[
            Row(
              children: [
                SvgPicture.asset(ICONS.IC_ICON3_SVG),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: SizedBox(
                      width: AppValue.widths * 0.5,
                      child: Text(
                        this.statusJob!,
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
                    child: Text(this.startDate!,
                        style: OrtherInforCustomerStyle())),
              ),
              Spacer(),
              SvgPicture.asset(ICONS.IC_QUESTION_SVG),
              SizedBox(
                width: AppValue.widths * 0.01,
              ),
              Text(
                this.totalComment.toString(),
                style: TextStyle(
                  color: HexColor("#0052B4"),
                ),
              ),
            ],
          ),
        ],
      ),
      margin: EdgeInsets.only(
        top: 20,
      ),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
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
