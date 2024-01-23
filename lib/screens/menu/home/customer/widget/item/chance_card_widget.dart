import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../../l10n/key_text.dart';
import '../../../../../../src/models/model_generator/chance_customer.dart';
import '../../../../../../src/src_index.dart';

class ChanceCardWidget extends StatelessWidget {
  ChanceCardWidget({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  final ChanceCustomerData data;
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
        padding: EdgeInsets.all(
          16,
        ),
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
              children: [
                SvgPicture.asset(ICONS.IC_ICON1_SVG),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                    child: WidgetText(
                      title: data.name ?? getT(KeyT.not_yet),
                      style: AppStyle.DEFAULT_18_BOLD
                          .copyWith(color: COLORS.TEXT_COLOR),
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: data.color != null ? HexColor(data.color!) : null,
                      borderRadius: BorderRadius.circular(99)),
                  width: AppValue.widths * 0.1,
                  height: AppValue.heights * 0.02,
                )
              ],
            ),
            SizedBox(height: AppValue.heights * 0.01),
            Row(
              children: [
                SvgPicture.asset(
                  ICONS.IC_AVATAR_SVG,
                  color: COLORS.GRAY_IMAGE,
                ),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: WidgetText(
                    title:
                        (data.customer_name == "" || data.customer_name == null)
                            ? getT(KeyT.not_yet)
                            : data.customer_name,
                    style: AppStyle.DEFAULT_18_BOLD
                        .copyWith(color: COLORS.TEXT_COLOR),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppValue.heights * 0.01),
            Row(
              children: [
                SvgPicture.asset(ICONS.IC_ICON3_SVG),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: SizedBox(
                      width: AppValue.widths * 0.5,
                      child: WidgetText(
                        title: data.status ?? getT(KeyT.not_yet),
                        style: AppStyle.DEFAULT_14.copyWith(
                            fontWeight: FontWeight.w400,
                            color: COLORS.TEXT_RED),
                      )),
                ),
              ],
            ),
            SizedBox(height: AppValue.heights * 0.01),
            Row(
              children: [
                SvgPicture.asset(ICONS.IC_ICON4_SVG),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: SizedBox(
                      width: AppValue.widths * 0.5,
                      child: WidgetText(
                          title: data.date ?? getT(KeyT.not_yet),
                          style: AppStyle.DEFAULT_14.copyWith(
                              fontWeight: FontWeight.w400,
                              color: COLORS.TEXT_COLOR))),
                ),
                Spacer(),
                SvgPicture.asset(ICONS.IC_QUESTION_SVG),
                SizedBox(
                  width: AppValue.widths * 0.01,
                ),
                WidgetText(
                    title: data.total_note,
                    style:
                        AppStyle.DEFAULT_14.copyWith(color: COLORS.TEXT_COLOR)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
