import 'package:flutter/material.dart';
import 'package:gen_crm/screens/widget/box_item.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/models/model_generator/clue_customer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../l10n/key_text.dart';
import '../../../../../../src/src_index.dart';
import '../../../../widget/information.dart';

class ClueCardWidget extends StatelessWidget {
  ClueCardWidget({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  final ClueCustomerData data;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return BoxItem(
      onTap: () => onTap(),
      child: Column(
        children: [
          itemTextIcon(
            paddingTop: 0,
            text: '${data.danh_xung ?? ''}' + ' ' + '${data.name ?? ''}'.trim(),
            icon: ICONS.IC_AVATAR_SVG,
            styleText:
                AppStyle.DEFAULT_16_BOLD.copyWith(color: COLORS.TEXT_BLUE_BOLD),
          ),
          itemTextIcon(
            text: data.email?.val ?? getT(KeyT.not_yet),
            icon: ICONS.IC_MAIL_CUSTOMER_SVG,
            colorText: COLORS.TEXT_BLUE_BOLD,
            onTap: () {
              if (data.email?.action != null && data.email?.action == 1) {
                if (data.email?.val != null)
                  launchUrl(Uri(scheme: 'mailto', path: '${data.email?.val}'));
              }
            },
          ),
          itemTextEnd(
              title: data.phone?.val ?? getT(KeyT.not_yet),
              colorTitle: COLORS.TEXT_BLUE_BOLD,
              content: data.total_note ?? '',
              icon: ICONS.IC_PHONE_C_PNG,
              isSvg: false,
              colorIcon: COLORS.GREY,
              onTapTitle: () {
                if (data.phone?.action != null && data.phone?.action == 2) {
                  if (data.phone?.val != null)
                    dialogShowAllSDT(
                      context,
                      handelListSdt(data.phone?.val),
                      name: data.name ?? '',
                    );
                }
              }),
        ],
      ),
    );
  }
}
