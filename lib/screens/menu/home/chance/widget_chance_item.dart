import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/widgets/widgets.dart';

import '../../../../src/src_index.dart';
import '../../../../widgets/image_default.dart';

class WidgetItemChance extends StatelessWidget {
  final ListChanceData listChanceData;

  const WidgetItemChance({
    required this.listChanceData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.navigateInfoChance(
            listChanceData.id!, listChanceData.name!);
      },
      child: Container(
        margin: EdgeInsets.only(left: 25, right: 25, bottom: 20),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: COLORS.BLACK.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                itemTextIcon(
                  paddingTop: 0,
                  text: listChanceData.name ?? 'Chưa có',
                  icon: ICONS.IC_CHANCE_3X_PNG,
                  isSVG: false,
                  styleText: AppStyle.DEFAULT_TITLE_PRODUCT
                      .copyWith(color: COLORS.TEXT_COLOR),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(99)),
                  width: AppValue.widths * 0.1,
                  height: AppValue.heights * 0.02,
                )
              ],
            ),
            itemTextIcon(
              text: ('${listChanceData.customer!.danh_xung ?? ''}' +
                      ' ' +
                      '${listChanceData.customer!.name ?? ''}')
                  .trim(),
              icon: ICONS.IC_USER2_SVG,
            ),
            itemTextIcon(
              text: listChanceData.status ?? '',
              icon: ICONS.IC_DANG_XU_LY_SVG,
              styleText:
                  AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(color: Colors.red),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  itemTextIcon(
                    isSVG: false,
                    paddingTop: 0,
                    text: listChanceData.dateNextCare ?? 'Chưa có',
                    icon: ICONS.IC_DATE_PNG,
                  ),
                  Spacer(),
                  SvgPicture.asset(ICONS.IC_MESS),
                ],
              ),
            ),
            AppValue.hSpaceTiny,
          ],
        ),
      ),
    );
  }
}
