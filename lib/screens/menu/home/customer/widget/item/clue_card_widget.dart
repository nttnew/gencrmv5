import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/src/models/model_generator/clue_customer.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../l10n/key_text.dart';
import '../../../../../../src/src_index.dart';

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
            Row(
              children: [
                SvgPicture.asset(ICONS.IC_AVATAR_SVG),
                Padding(
                  padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                  child: WidgetText(
                    title:
                        "${data.danh_xung ?? ''}" + " " + "${data.name ?? ''}",
                    style: AppStyle.DEFAULT_16_BOLD
                        .copyWith(color: COLORS.TEXT_BLUE_BOLD),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppValue.heights * 0.01),
            if (data.email?.val?.isNotEmpty ?? false) ...[
              GestureDetector(
                onTap: () {
                  if (data.email?.action != null && data.email?.action == 1) {
                    if (data.email?.val != null)
                      launchUrl(
                          Uri(scheme: "mailto", path: "${data.email?.val}"));
                  }
                },
                child: Row(
                  children: [
                    SvgPicture.asset(ICONS.IC_MAIL_CUSTOMER_SVG),
                    Padding(
                      padding: EdgeInsets.only(left: AppValue.widths * 0.03),
                      child: SizedBox(
                          width: AppValue.widths * 0.5,
                          child: WidgetText(
                            title: data.email?.val ?? getT(KeyT.not_yet),
                            style: AppStyle.DEFAULT_14
                                .copyWith(color: COLORS.TEXT_BLUE_BOLD),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppValue.heights * 0.01),
            ],
            if (data.phone?.val != '')
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (data.phone?.action != null &&
                          data.phone?.action == 2) {
                        if (data.phone?.val != null)
                          launchUrl(
                              Uri(scheme: "tel", path: "${data.phone?.val}"));
                      }
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(ICONS.IC_PHONE_CUSTOMER_SVG),
                        Padding(
                          padding:
                              EdgeInsets.only(left: AppValue.widths * 0.03),
                          child: SizedBox(
                              width: AppValue.widths * 0.5,
                              child: WidgetText(
                                  title: data.phone?.val ?? '',
                                  style: AppStyle.DEFAULT_14
                                      .copyWith(color: COLORS.TEXT_BLUE_BOLD))),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  SvgPicture.asset(ICONS.IC_QUESTION_SVG),
                  SizedBox(
                    width: AppValue.widths * 0.01,
                  ),
                  WidgetText(
                    title: data.total_note ?? "",
                    style: AppStyle.DEFAULT_14
                        .copyWith(color: COLORS.TEXT_BLUE_BOLD),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
