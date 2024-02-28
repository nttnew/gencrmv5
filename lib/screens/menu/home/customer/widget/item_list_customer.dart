import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/models/model_generator/customer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/dialog_call.dart';
import '../../../../../widgets/widget_text.dart';

class ItemCustomer extends StatelessWidget {
  const ItemCustomer(
      {Key? key, required this.data, required this.onTap, required this.title})
      : super(key: key);
  final CustomerData data;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: data.is_company == true
                      ? SvgPicture.asset(
                          ICONS.IC_BUILD_SVG,
                          color: data.tong_so_hop_dong! > 0
                              ? COLORS.ORANGE_IMAGE
                              : COLORS.GREY,
                          fit: BoxFit.contain,
                        )
                      : SvgPicture.asset(
                          ICONS.IC_AVATAR_SVG,
                          color: data.tong_so_hop_dong! > 0
                              ? COLORS.ORANGE_IMAGE
                              : COLORS.GREY,
                          fit: BoxFit.contain,
                        ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: WidgetText(
                    title: (('${data.danh_xung ?? ''}' +
                                    ' ' +
                                    '${data.name ?? ''}')
                                .trim() !=
                            '')
                        ? '${data.danh_xung ?? ''}' + ' ' + '${data.name ?? ''}'
                        : getT(KeyT.not_yet),
                    style: AppStyle.DEFAULT_18.copyWith(
                        color: COLORS.ff006CB1, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: data.color == null
                          ? COLORS.PRIMARY_COLOR
                          : HexColor(data.color!),
                      borderRadius: BorderRadius.circular(99)),
                  width: AppValue.widths * 0.1,
                  height: AppValue.heights * 0.02,
                )
              ],
            ),
            itemTextIcon(
              text: ((data.address == null || data.address == "")
                      ? getT(KeyT.not_yet)
                      : data.address)
                  .toString(),
              icon: ICONS.IC_LOCATION_PNG,
            ),//todo
            itemTextIcon(
              onTap: () {
                if ((data.email?.val != null && data.email?.val != '') &&
                    data.email?.action != null) {
                  launchUrl(Uri(scheme: "mailto", path: "${data.email?.val}"));
                }
              },
              text: data.email?.val ?? getT(KeyT.not_yet),
              icon: ICONS.IC_MAIL_CUSTOMER_SVG,
              colorIcon: COLORS.GREY,
            ),
            Row(
              children: [
                Expanded(
                  child: itemTextIcon(
                    onTap: () {
                      if ((data.phone?.val != null && data.phone?.val != "") &&
                          data.phone?.action != null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogCall(
                              phone: '${data.phone?.val}',
                              name: '${data.name}',
                            );
                          },
                        );
                      }
                    },
                    text: data.phone?.val ?? getT(KeyT.not_yet),
                    styleText: AppStyle.DEFAULT_14.copyWith(
                        fontWeight: FontWeight.w400,
                        color: HexColor("#0052B4")),
                    icon: ICONS.IC_PHONE_CUSTOMER_SVG,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                SvgPicture.asset(ICONS.IC_QUESTION_SVG),
                SizedBox(
                  width: 4,
                ),
                Text(
                  data.total_comment.toString(),
                  style: TextStyle(
                    color: HexColor("#0052B4"),
                  ),
                ),
              ],
            ),
          ],
        ),
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),
        padding: EdgeInsets.all(
          16,
        ),
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(
                0.3,
              ),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }
}
