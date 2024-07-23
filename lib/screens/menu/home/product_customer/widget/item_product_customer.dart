import 'package:flutter/material.dart';
import 'package:gen_crm/screens/menu/widget/box_item.dart';
import 'package:gen_crm/src/models/model_generator/list_product_customer_response.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/src_index.dart';
import '../../../widget/information.dart';

class ItemProductCustomer extends StatelessWidget {
  const ItemProductCustomer({
    Key? key,
    required this.productModule,
    required this.onTap,
  }) : super(key: key);
  final ProductCustomerResponse productModule;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return BoxItem(
      onTap: () => onTap(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          itemTextIcon(
            paddingTop: 0,
            text: productModule.name ?? getT(KeyT.not_yet),
            icon: ICONS.IC_CHANCE_3X_PNG,
            isSVG: false,
            styleText: AppStyle.DEFAULT_18.copyWith(
                color: COLORS.ff006CB1, fontWeight: FontWeight.w700),
          ),
          GestureDetector(
            onTap: () {
              if (productModule.customer?.id != null &&
                  productModule.customer?.id != '')
                AppNavigator.navigateDetailCustomer(
                  productModule.customer?.id ?? '',
                );
            },
            child: itemTextIcon(
              text: productModule.customer?.name ?? getT(KeyT.not_yet),
              icon: ICONS.IC_USER2_SVG,
              styleText: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                color: COLORS.TEXT_BLUE_BOLD,
                fontSize: 14,
              ),
            ),
          ),
          itemTextIcon(
            onTap: () {
              if ((productModule.phone?.val != null &&
                      productModule.phone?.val != "") &&
                  productModule.phone?.action != null) {
                dialogShowAllSDT(
                  context,
                  handelListSdt(productModule.phone?.val),
                  name: productModule.name ?? '',
                );
              }
            },
            text: productModule.phone?.val ?? getT(KeyT.not_yet),
            styleText: AppStyle.DEFAULT_14.copyWith(
              fontWeight: FontWeight.w400,
              color: COLORS.TEXT_BLUE_BOLD,
            ),
            icon: ICONS.IC_PHONE_CUSTOMER_SVG,
          ),
          itemTextIcon(
            text: productModule.loai ?? getT(KeyT.not_yet),
            icon: Icon(
              Icons.insert_drive_file_outlined,
              color: COLORS.GREY,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
