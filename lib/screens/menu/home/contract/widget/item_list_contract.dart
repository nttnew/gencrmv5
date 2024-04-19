import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/models/model_generator/contract.dart';
import '../../../../../src/src_index.dart';
import '../../../../../storages/share_local.dart';

class ItemContract extends StatelessWidget {
  const ItemContract({Key? key, required this.data}) : super(key: key);
  final ContractItemData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.navigateDetailContract(
            data.id ?? '', );
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
              icon: ICONS.IC_CONTRACT_3X_PNG,
              color: data.status_color,
              isSVG: false,
            ),
            itemTextIcon(
              text: data.customer?.name?.trim() ?? getT(KeyT.not_yet),
              icon: ICONS.IC_USER2_SVG,
              colorIcon: Color(0xffE75D18),
            ),
            itemTextIcon(
                text: data.product_customer?.name ?? '',
                icon: ICONS.IC_CHANCE_3X_PNG,
                isSVG: false,
                colorText: COLORS.TEXT_BLUE_BOLD,
                onTap: () {
                  if (data.product_customer?.id != '' &&
                      data.product_customer?.id != null)
                    AppNavigator.navigateDetailProductCustomer2(
                      data.product_customer,
                    );
                }),
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
            itemTextEnd(
              title: '${getT(KeyT.total_amount)}: ' +
                  '${data.price.toString()}' +
                  shareLocal.getString(PreferencesKey.MONEY),
              content: data.total_note ?? '0',
              icon: ICONS.IC_MAIL_SVG,
            ),
          ],
        ),
      ),
    );
  }
}
