import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/models/model_generator/support.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/widget_text.dart';

class ItemSupport extends StatelessWidget {
  const ItemSupport({
    Key? key,
    required this.data,
  }) : super(key: key);
  final SupportItemData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNavigator.navigateDetailSupport(
        data.id.toString(),
        data.ten_ho_tro ?? '',
      ),
      child: Container(
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),
        padding: EdgeInsets.all(
          16,
        ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.location != null && data.location != '') ...[
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
                    title: data.ten_ho_tro ?? '',
                    style: TextStyle(
                        color: COLORS.ff006CB1,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: data.color != ""
                          ? HexColor(data.color!)
                          : COLORS.PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(99)),
                  width: AppValue.widths * 0.1,
                  height: AppValue.heights * 0.02,
                )
              ],
            ),
            itemTextIcon(
                text: data.customer?.name ?? '', icon: ICONS.IC_AVATAR_SVG),
            itemTextIcon(
                text: data.trang_thai ?? '',
                styleText: AppStyle.DEFAULT_14.copyWith(
                    color: data.color != ""
                        ? HexColor(data.color!)
                        : COLORS.PRIMARY_COLOR),
                colorIcon: data.color != ""
                    ? HexColor(data.color!)
                    : COLORS.PRIMARY_COLOR,
                icon: ICONS.IC_ICON3_SVG),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Expanded(
                    child: itemTextIcon(
                        paddingTop: 0,
                        text: data.created_date ?? '',
                        styleText: TextStyle(
                            color: HexColor("#263238"),
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                        icon: ICONS.IC_ICON4_SVG),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  SvgPicture.asset(ICONS.IC_QUESTION_SVG),
                  SizedBox(
                    width: 4,
                  ),
                  WidgetText(
                    title: data.total_note ?? '',
                    style: TextStyle(
                      color: COLORS.TEXT_BLUE_BOLD,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
