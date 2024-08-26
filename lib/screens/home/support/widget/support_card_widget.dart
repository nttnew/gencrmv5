import 'package:flutter/material.dart';
import 'package:gen_crm/screens/widget/box_item.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../src/src_index.dart';

class SupportCardWidget extends StatelessWidget {
  SupportCardWidget({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  final dynamic data;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final Color colorIcon = (data.color != '' && data.color != null)
        ? HexColor(data.color!)
        : COLORS.PRIMARY_COLOR;
    return BoxItem(
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          itemTextIconStart(
            title: data.name ?? '',
            icon: ICONS.IC_SUPPORT_3X_PNG,
            color: data.color,
            isSVG: false,
          ),
          itemTextIcon(
            text: data.user_handling ?? '',
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
            colorIcon: colorIcon,
            colorText: colorIcon,
          ),
          itemTextEnd(
            title: data.start_date,
            content: data.total_note ?? '',
            icon: ICONS.IC_ICON4_SVG,
          ),
        ],
      ),
    );
  }

  TextStyle OrtherInforCustomerStyle() => TextStyle(
      color: HexColor("#263238"),
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w400,
      fontSize: 14);

  TextStyle NameCustomerStyle() => TextStyle(
      color: COLORS.ff006CB1,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w700,
      fontSize: 18);
}
