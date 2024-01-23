import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/src/app_const.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/src_index.dart';

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
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.circular(
            10,
          ),
          border: Border.all(width: 1, color: COLORS.WHITE),
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
                Expanded(
                  child: itemTextIcon(
                    paddingTop: 0,
                    text: listChanceData.name ?? getT(KeyT.not_yet),
                    icon: ICONS.IC_CHANCE_3X_PNG,
                    isSVG: false,
                    styleText: AppStyle.DEFAULT_TITLE_PRODUCT
                        .copyWith(color: COLORS.TEXT_COLOR),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: COLORS.RED,
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
                  AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(color: COLORS.RED),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Expanded(
                    child: itemTextIcon(
                      isSVG: false,
                      paddingTop: 0,
                      text: listChanceData.dateNextCare ?? getT(KeyT.not_yet),
                      icon: ICONS.IC_DATE_PNG,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
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
