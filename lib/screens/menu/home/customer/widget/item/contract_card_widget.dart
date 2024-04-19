import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../../l10n/key_text.dart';
import '../../../../../../src/app_const.dart';
import '../../../../../../src/models/model_generator/contract_customer.dart';
import '../../../../../../src/src_index.dart';
import '../../../../../../storages/share_local.dart';

class ContractCardWidget extends StatelessWidget {
  ContractCardWidget({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  final ContractCustomerData data;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 16,
          right: 16,
          left: 16,
        ),
        padding: EdgeInsets.all(16),
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
            itemTextIconStart(
              title: data.name ?? '',
              icon: ICONS.IC_CART_SVG,
              color: data.color,
            ),
            itemTextIcon(
              text: data.customer_name ?? '',
              icon: ICONS.IC_AVATAR_SVG,
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
              icon: ICONS.IC_ICON3_SVG,
              colorText: data.color != null
                  ? HexColor(data.color!)
                  : COLORS.PRIMARY_COLOR,
              colorIcon: data.color != null
                  ? HexColor(data.color!)
                  : COLORS.PRIMARY_COLOR,
            ),
            itemTextEnd(
              title: '${getT(KeyT.total_amount)}: ' +
                  '${data.total_value ?? ''}' +
                  shareLocal.getString(PreferencesKey.MONEY),
              content: data.total_note ?? '',
              icon: ICONS.IC_MAIL_CUSTOMER_SVG,
            ),
          ],
        ),
      ),
    );
  }
}
