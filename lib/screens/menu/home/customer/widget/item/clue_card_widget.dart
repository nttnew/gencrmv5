import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/src/models/model_generator/clue_customer.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../src/src_index.dart';

class ClueCardWidget extends StatefulWidget {
  ClueCardWidget({Key? key, required this.data}) : super(key: key);

  final ClueCustomerData? data;

  @override
  State<ClueCardWidget> createState() => _ClueCardWidgetState();
}

class _ClueCardWidgetState extends State<ClueCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(ICONS.IC_AVATAR_SVG),
              Padding(
                padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                child: WidgetText(
                  title: "${widget.data!.danh_xung ?? ''}" +
                      " " +
                      "${widget.data!.name ?? ''}",
                  style: AppStyle.DEFAULT_16_BOLD
                      .copyWith(color: COLORS.TEXT_BLUE_BOLD),
                ),
              ),
            ],
          ),
          SizedBox(height: AppValue.heights * 0.01),
          if (widget.data?.email?.val?.isNotEmpty ?? false) ...[
            GestureDetector(
              onTap: () {
                if (widget.data!.email!.action != null &&
                    widget.data!.email!.action == 1) {
                  if (widget.data!.email!.val != null)
                    launchUrl(Uri(
                        scheme: "mailto", path: "${widget.data!.email!.val}"));
                }
              },
              child: Row(
                children: [
                  SvgPicture.asset(ICONS.IC_MAIL_CUSTOMER_SVG),
                  Padding(
                    padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                    child: SizedBox(
                        width: AppValue.widths * 0.5,
                        child: WidgetText(
                          title: widget.data!.email!.val ?? 'Chưa có',
                          style: AppStyle.DEFAULT_14
                              .copyWith(color: COLORS.TEXT_BLUE_BOLD),
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppValue.heights * 0.01),
          ],
          if (widget.data?.phone?.val != '')
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.data!.phone!.action != null &&
                        widget.data!.phone!.action == 2) {
                      // launchUrl("tel://${widget.data!.phone!.val}");
                      if (widget.data!.phone!.val != null)
                        launchUrl(Uri(
                            scheme: "tel", path: "${widget.data!.phone!.val}"));
                    }
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(ICONS.IC_PHONE_CUSTOMER_SVG),
                      Padding(
                        padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                        child: SizedBox(
                            width: AppValue.widths * 0.5,
                            child: WidgetText(
                                title: widget.data!.phone!.val ?? '',
                                style: AppStyle.DEFAULT_14
                                    .copyWith(color: COLORS.TEXT_BLUE_BOLD))),
                      )
                    ],
                  ),
                ),
                Spacer(),
                SvgPicture.asset(ICONS.IC_QUESTION_SVG),
                SizedBox(
                  width: AppValue.widths * 0.01,
                ),
                WidgetText(
                  title: widget.data!.total_note ?? "",
                  style: AppStyle.DEFAULT_14
                      .copyWith(color: COLORS.TEXT_BLUE_BOLD),
                ),
              ],
            ),
        ],
      ),
      margin: EdgeInsets.only(
        top: AppValue.heights * 0.01,
        right: 5,
        left: 5,
      ),
      padding: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 20),
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
      color: HexColor("#0052B4"),
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
