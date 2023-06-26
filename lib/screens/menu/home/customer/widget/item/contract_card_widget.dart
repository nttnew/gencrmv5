import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../../src/models/model_generator/contract_customer.dart';
import '../../../../../../src/src_index.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class ConstractCardWidget extends StatefulWidget {
  ConstractCardWidget({Key? key, required this.data}) : super(key: key);

  final ContractCustomerData? data;

  @override
  State<ConstractCardWidget> createState() => _ConstractCardWidgetState();
}

class _ConstractCardWidgetState extends State<ConstractCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(ICONS.IC_CART_SVG),
              Padding(
                padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                child: WidgetText(
                  title: widget.data!.name ?? '',
                  style: NameCustomerStyle(),
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    color: widget.data!.color != null
                        ? HexColor(widget.data!.color!)
                        : COLORS.PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(99)),
                width: AppValue.widths * 0.1,
                height: AppValue.heights * 0.02,
              )
            ],
          ),
          if (widget.data!.customer_name?.isNotEmpty ?? false) ...[
            SizedBox(height: AppValue.heights * 0.01),
            Row(
              children: [
                SvgPicture.asset(
                  ICONS.IC_AVATAR_SVG,
                  color: COLORS.ORANGE_IMAGE,
                ),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: WidgetText(
                    title: widget.data!.customer_name ?? '',
                    style: NameCustomerStyle(),
                  ),
                ),
              ],
            ),
          ],
          if (widget.data!.status?.isNotEmpty ?? false) ...[
            SizedBox(height: AppValue.heights * 0.01),
            Row(
              children: [
                SvgPicture.asset(
                  ICONS.IC_ICON3_SVG,
                  color: widget.data!.color != null
                      ? HexColor(widget.data!.color!)
                      : COLORS.PRIMARY_COLOR,
                ),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: SizedBox(
                      width: AppValue.widths * 0.5,
                      child: WidgetText(
                        title: widget.data!.status ?? '',
                        style: AppStyle.DEFAULT_14.copyWith(
                            color: widget.data!.color != null
                                ? HexColor(widget.data!.color!)
                                : COLORS.PRIMARY_COLOR),
                      )),
                ),
              ],
            ),
          ],
          SizedBox(height: AppValue.heights * 0.01),
          Row(
            children: [
              SvgPicture.asset(ICONS.IC_MAIL_CUSTOMER_SVG),
              Padding(
                padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                child: SizedBox(
                    width: AppValue.widths * 0.5,
                    child: WidgetText(
                      title: "${AppLocalizations.of(Get.context!)?.total_amount}: " +
                          "${widget.data!.total_value ?? ''}" +
                          "đ",
                      style: OrtherInforCustomerStyle(),
                    )),
              ),
              Spacer(),
              SvgPicture.asset(ICONS.IC_QUESTION_SVG),
              SizedBox(
                width: AppValue.widths * 0.01,
              ),
              WidgetText(
                title: widget.data!.total_note ?? '',
                style: TextStyle(
                  color: HexColor("#0052B4"),
                ),
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
