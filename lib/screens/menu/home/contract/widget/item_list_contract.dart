import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/models/model_generator/contract.dart';
import '../../../../../src/src_index.dart';
import '../../../../../storages/share_local.dart';
import '../../../../../widgets/widget_text.dart';

class ItemContract extends StatelessWidget {
  const ItemContract({Key? key, required this.data}) : super(key: key);
  final ContractItemData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.navigateInfoContract(
            data.id ?? '', data.name ?? getT(KeyT.not_yet));
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
                      text: data.name ?? getT(KeyT.not_yet),
                      icon: ICONS.IC_CONTRACT_3X_PNG,
                      styleText: AppStyle.DEFAULT_TITLE_PRODUCT
                          .copyWith(color: COLORS.TEXT_COLOR),
                      isSVG: false),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: data.status_color != ""
                          ? HexColor(data.status_color!)
                          : COLORS.RED,
                      borderRadius: BorderRadius.circular(99)),
                  width: AppValue.widths * 0.08,
                  height: AppValue.heights * 0.02,
                )
              ],
            ),
            itemTextIcon(
              text: data.customer?.name?.trim() ?? getT(KeyT.not_yet),
              icon: ICONS.IC_USER2_SVG,
              colorIcon: Color(0xffE75D18),
            ),
            itemTextIcon(
              text: data.status ?? '',
              icon: ICONS.IC_DANG_XU_LY_SVG,
              colorText: data.status_color != ''
                  ? HexColor(data.status_color!)
                  : COLORS.RED,
              styleText: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                color: data.status_color != ""
                    ? HexColor(data.status_color!)
                    : COLORS.RED,
              ),
              colorIcon: data.status_color != ''
                  ? HexColor(data.status_color!)
                  : COLORS.RED,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Expanded(
                    child: itemTextIcon(
                      colorIcon: COLORS.GREY,
                      paddingTop: 0,
                      text: '${getT(KeyT.total_amount)}: ' +
                          '${data.price.toString()}' +
                          shareLocal.getString(PreferencesKey.MONEY),
                      icon: ICONS.IC_MAIL_SVG,
                      styleText: AppStyle.DEFAULT_LABEL_PRODUCT
                          .copyWith(color: COLORS.GREY),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  SvgPicture.asset(ICONS.IC_QUESTION_SVG),
                  SizedBox(
                    width: 4,
                  ),
                  WidgetText(
                    title: data.total_note ?? '0',
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
