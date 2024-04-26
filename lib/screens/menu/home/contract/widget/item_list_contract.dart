import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/models/model_generator/contract.dart';
import '../../../../../src/src_index.dart';
import '../../../../../storages/share_local.dart';
import '../../../../../widgets/line_horizontal_widget.dart';
import '../../../../../widgets/widget_text.dart';

class ItemContract extends StatelessWidget {
  const ItemContract({
    Key? key,
    required this.data,
    required this.onRefreshForm,
  }) : super(key: key);
  final ContractItemData data;
  final Function onRefreshForm;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.navigateDetailContract(
          data.id ?? '',
          onRefreshForm: () {
            onRefreshForm();
          },
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
            Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: Image.asset(
                    ICONS.IC_CONTRACT_3X_PNG,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: WidgetText(
                    title: data.name ?? getT(KeyT.not_yet),
                    style: AppStyle.DEFAULT_18.copyWith(
                      color: COLORS.ff006CB1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: data.status_color != ''
                        ? HexColor(data.status_color!)
                        : COLORS.RED,
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                  ),
                  child: Center(
                    child: WidgetText(
                      title: data.status ?? getT(KeyT.not_yet),
                      style: AppStyle.DEFAULT_14.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            itemTextIcon(
              onTap: () {
                if (data.customer?.id != '' && data.customer?.id != null)
                  AppNavigator.navigateDetailCustomer(
                    data.customer?.id ?? '',
                  );
              },
              text: data.customer?.name ?? '',
              icon: ICONS.IC_USER2_SVG,
              colorIcon: COLORS.GREY,
              styleText: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                color: (data.customer?.id != '' && data.customer?.id != null)
                    ? COLORS.TEXT_BLUE_BOLD
                    : null,
                fontSize: 14,
              ),
            ),
            itemTextIcon(
              onTap: () {
                if (data.product_customer?.id != '' &&
                    data.product_customer?.id != null)
                  AppNavigator.navigateDetailProductCustomer(
                    data.product_customer?.id ?? '',
                  );
              },
              text: data.product_customer?.name ?? '',
              styleText: AppStyle.DEFAULT_14.copyWith(
                fontWeight: FontWeight.w400,
                color: COLORS.TEXT_BLUE_BOLD,
              ),
              icon: ICONS.IC_CHANCE_3X_PNG,
              isSVG: false,
              colorIcon: COLORS.GREY,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: LineHorizontal(
                color: COLORS.LIGHT_GREY,
              ),
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
