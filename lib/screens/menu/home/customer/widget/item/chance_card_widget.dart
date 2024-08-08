import 'package:flutter/material.dart';
import 'package:gen_crm/screens/menu/widget/box_item.dart';
import '../../../../../../l10n/key_text.dart';
import '../../../../../../src/app_const.dart';
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
    return BoxItem(
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          itemTextIconStart(
            title: data.name ?? getT(KeyT.not_yet),
            icon: ICONS.IC_ICON1_SVG,
            color: data.color,
          ),
          itemTextIcon(
            text: (data.customer_name == '' || data.customer_name == null)
                ? ''
                : data.customer_name ?? '',
            icon: ICONS.IC_AVATAR_SVG,
            colorIcon: COLORS.GRAY_IMAGE,
            styleText: AppStyle.DEFAULT_14.copyWith(
              color: COLORS.TEXT_COLOR,
            ),
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
              text: data.status ?? getT(KeyT.not_yet),
              icon: ICONS.IC_ICON3_SVG,
              colorText: COLORS.TEXT_RED,
              onTap: () {
                if (data.product_customer?.id != '' &&
                    data.product_customer?.id != null)
                  AppNavigator.navigateDetailProductCustomer(
                    data.product_customer?.id ?? '',
                  );
              }),
          itemTextEnd(
            title: data.date ?? getT(KeyT.not_yet),
            content: data.total_note ?? '',
            icon: ICONS.IC_ICON4_SVG,
          ),
        ],
      ),
    );
  }
}
