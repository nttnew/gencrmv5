import 'package:flutter/material.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/models/model_generator/clue_customer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../l10n/key_text.dart';
import '../../../../../../src/src_index.dart';
import '../../../../../../widgets/dialog_call.dart';

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
        padding: EdgeInsets.only(
          bottom: 16,
          right: 16,
          left: 16,
        ),
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
            itemTextIcon(
              text:
                  "${data.danh_xung ?? ''}" + " " + "${data.name ?? ''}".trim(),
              icon: ICONS.IC_AVATAR_SVG,
              styleText: AppStyle.DEFAULT_16_BOLD
                  .copyWith(color: COLORS.TEXT_BLUE_BOLD),
            ),
            itemTextIcon(
              text: data.email?.val ?? getT(KeyT.not_yet),
              icon: ICONS.IC_MAIL_CUSTOMER_SVG,
              colorText: COLORS.TEXT_BLUE_BOLD,
              onTap: () {
                if (data.email?.action != null && data.email?.action == 1) {
                  if (data.email?.val != null)
                    launchUrl(
                        Uri(scheme: "mailto", path: "${data.email?.val}"));
                }
              },
            ),
            itemTextEnd(
                title: data.phone?.val ?? getT(KeyT.not_yet),
                colorTitle: COLORS.TEXT_BLUE_BOLD,
                content: data.total_note ?? '',
                icon: ICONS.IC_PHONE_CUSTOMER_SVG,
                onTapTitle: () {
                  if (data.phone?.action != null && data.phone?.action == 2) {
                    if (data.phone?.val != null)
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogCall(
                              phone: '${data.phone?.val}',
                              name: '${data.name}',
                            );
                          });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
