import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/models/model_generator/contract.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/widget_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class ItemContract extends StatelessWidget {
  const ItemContract({Key? key, required this.data}) : super(key: key);
  final ContractItemData data;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.navigateInfoContract(data.id ?? '',
            data.name ?? AppLocalizations.of(Get.context!)?.not_yet ?? '');
      },
      child: Container(
        margin: EdgeInsets.only(left: 25, right: 25, bottom: 20),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.circular(20),
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
                      text: data.name ??
                          AppLocalizations.of(Get.context!)?.not_yet ??
                          '',
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
              text: data.customer?.name?.trim() ??
                  AppLocalizations.of(Get.context!)?.not_yet ??
                  '',
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
                      text:
                          '${AppLocalizations.of(Get.context!)?.total_amount}: ' +
                              '${data.price.toString()}' +
                              'đ',
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
                      color: HexColor("#0052B4"),
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
