import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../../l10n/key_text.dart';
import '../../../../../../src/models/model_generator/contract_customer.dart';
import '../../../../../../src/src_index.dart';
import '../../../../../../storages/share_local.dart';

class ConstractCardWidget extends StatelessWidget {
  ConstractCardWidget({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  final ContractCustomerData data;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 16,
          right: 16,
          left: 16,
        ),
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
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(ICONS.IC_CART_SVG),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: WidgetText(
                    title: data.name ?? '',
                    style: NameCustomerStyle(),
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: data.color != null
                          ? HexColor(data.color!)
                          : COLORS.PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(99)),
                  width: AppValue.widths * 0.1,
                  height: AppValue.heights * 0.02,
                )
              ],
            ),
            if (data.customer_name?.isNotEmpty ?? false) ...[
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
                      title: data.customer_name ?? '',
                      style: NameCustomerStyle(),
                    ),
                  ),
                ],
              ),
            ],
            if (data.status?.isNotEmpty ?? false) ...[
              SizedBox(height: AppValue.heights * 0.01),
              Row(
                children: [
                  SvgPicture.asset(
                    ICONS.IC_ICON3_SVG,
                    color: data.color != null
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
                              color: data.color != null
                                  ? HexColor(data.color!)
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
                        title: '${getT(KeyT.total_amount)}: ' +
                            '${data.total_value ?? ''}' +
                            shareLocal.getString(PreferencesKey.MONEY),
                        style: OrtherInforCustomerStyle(),
                      )),
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
