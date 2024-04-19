import 'package:flutter/material.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/src_index.dart';

class WidgetItemChance extends StatelessWidget {
  final ListChanceData data;

  const WidgetItemChance({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.navigateDetailChance(
          data.id ?? '',
        );
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
            itemTextIconStart(
              title: data.name ?? getT(KeyT.not_yet),
              icon: ICONS.IC_CHANCE_3X_PNG,
              colorDF: HexColor(data.color ?? '#FB4C2F'),
              isSVG: false,
              color: '',
            ),
            itemTextIcon(
              text: ('${data.customer?.danh_xung ?? ''}' +
                      ' ' +
                      '${data.customer?.name ?? ''}')
                  .trim(),
              icon: ICONS.IC_USER2_SVG,
            ),
            itemTextIcon(
                text: data.product_customer?.name ?? '',
                icon: ICONS.IC_CHANCE_3X_PNG,
                isSVG: false,
                colorText: COLORS.TEXT_BLUE_BOLD,
                onTap: () {
                  if (data.product_customer?.id != '' &&
                      data.product_customer?.id != null)
                    AppNavigator.navigateDetailProductCustomer(
                      data.product_customer?.id ?? '',
                    );
                }),
            itemTextIcon(
              text: data.status ?? '',
              icon: ICONS.IC_DANG_XU_LY_SVG,
              styleText: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                color: HexColor(data.color ?? '#FB4C2F'),
              ),
              colorIcon: HexColor(data.color ?? '#FB4C2F'),
            ),
            itemTextEnd(
              title: data.dateNextCare ?? getT(KeyT.not_yet),
              content: '',
              icon: ICONS.IC_DATE_PNG,
              isSvg: false,
            ),
          ],
        ),
      ),
    );
  }
}
